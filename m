Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:58666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0LGR3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 12:29:34 -0500
Received: from kpbe11.cbf.corp.google.com (kpbe11.cbf.corp.google.com [172.25.105.75])
	by smtp-out.google.com with ESMTP id oB7HTXXV020589
	for <linux-wireless@vger.kernel.org>; Tue, 7 Dec 2010 09:29:33 -0800
Received: from gyh4 (gyh4.prod.google.com [10.243.50.196])
	by kpbe11.cbf.corp.google.com with ESMTP id oB7HSW0K013202
	for <linux-wireless@vger.kernel.org>; Tue, 7 Dec 2010 09:29:27 -0800
Received: by gyh4 with SMTP id 4so130493gyh.23
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 09:28:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291735415.3607.46.camel@jlt3.sipsolutions.net>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
	<1291690135-4535-6-git-send-email-lrodriguez@atheros.com>
	<1291714709.3607.2.camel@jlt3.sipsolutions.net>
	<AANLkTinZK_xMJUDaDWzOpW7FXUERUNS3Y0btx=WS9KR1@mail.gmail.com>
	<1291735415.3607.46.camel@jlt3.sipsolutions.net>
Date: Tue, 7 Dec 2010 09:28:53 -0800
Message-ID: <AANLkTinXPOgOJB0ntHra4B_V0z9Qux2yrdiuqkyW7WuJ@mail.gmail.com>
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 7, 2010 at 7:23 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2010-12-07 at 07:20 -0800, Paul Stewart wrote:
>> On Tue, Dec 7, 2010 at 1:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Mon, 2010-12-06 at 18:48 -0800, Luis R. Rodriguez wrote:
>> >> --- a/net/mac80211/pm.c
>> >> +++ b/net/mac80211/pm.c
>> >> @@ -301,7 +301,7 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>> >>       }
>> >>
>> >>       mutex_lock(&local->mtx);
>> >> -     ieee80211_recalc_idle(local);
>> >> +     ieee80211_recalc_idle_force(local);
>> >
>> > Does this really occur afterwards closing interfaces?
>>
>> It appears possible using wpa_supplicant with nl80211, at least using
>> the new DBus API.
>
> Actually I believe it happens _during_ ifdown, but when the running bit
> is already cleared, so I guess this is about right -- although it
> shouldn't matter since the recalc_idle in do_stop should catch it later.

So the scenario is as follows.  If you down an interface
ieee80211_do_stop() first decrements local->open_count, then later
calls __ieee80211_recalc_idle, et al.  This means that later in this
call graph if ieee80211_hw_config() finally gets called, open_count is
already 0 and therefore drv_config is never called.  Luis' reference
to scan_completed() above is probable in reference to older versions
of compat where ieee80211_stop() called ieee80211_scan_cancel()
directly.  My admittedly casual look at wireless-testing seems to
imply that path may not exist in current compat, although my tests
seem to indicate the same class of problem still exists.

--
Paul
