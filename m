Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:63981 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZGWXVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 19:21:43 -0400
Received: by gxk9 with SMTP id 9so2351894gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 16:21:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248389978.10342.1.camel@johannes.local>
References: <1248389377-30379-1-git-send-email-lrodriguez@atheros.com>
	<1248389904.10342.0.camel@johannes.local> <1248389978.10342.1.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 23 Jul 2009 16:21:21 -0700
Message-ID: <43e72e890907231621l35bc0f82n79b91bd5bda25dcc@mail.gmail.com>
Subject: Re: [PATCH] mac80211: do not trigger beacon loss work if scanning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rossi.f@inwind.it
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 3:59 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-07-24 at 00:58 +0200, Johannes Berg wrote:
>
>> > @@ -2187,7 +2187,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
>> >             (struct ieee80211_sub_if_data *) data;
>> >     struct ieee80211_local *local = sdata->local;
>> >
>> > -   if (local->quiescing)
>> > +   if (local->quiescing || local->sw_scanning || local->hw_scanning)
>>
>> I'd rather have  that check in ieee80211_mgd_probe_ap itself, so it's
>> much closer to the source of the problem.
>
> And, incidentally, not racy then.

And wouldn't it be even better to just disable the timers before
scanning and re-enabling after scanning?

  Luis
