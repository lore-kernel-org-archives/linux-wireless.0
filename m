Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab0LGPUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 10:20:25 -0500
Received: from wpaz9.hot.corp.google.com (wpaz9.hot.corp.google.com [172.24.198.73])
	by smtp-out.google.com with ESMTP id oB7FKOVu004998
	for <linux-wireless@vger.kernel.org>; Tue, 7 Dec 2010 07:20:24 -0800
Received: from iwn9 (iwn9.prod.google.com [10.241.68.73])
	by wpaz9.hot.corp.google.com with ESMTP id oB7FKNON028847
	for <linux-wireless@vger.kernel.org>; Tue, 7 Dec 2010 07:20:23 -0800
Received: by iwn9 with SMTP id 9so10832iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 07:20:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291714709.3607.2.camel@jlt3.sipsolutions.net>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
	<1291690135-4535-6-git-send-email-lrodriguez@atheros.com>
	<1291714709.3607.2.camel@jlt3.sipsolutions.net>
Date: Tue, 7 Dec 2010 07:20:23 -0800
Message-ID: <AANLkTinZK_xMJUDaDWzOpW7FXUERUNS3Y0btx=WS9KR1@mail.gmail.com>
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

On Tue, Dec 7, 2010 at 1:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2010-12-06 at 18:48 -0800, Luis R. Rodriguez wrote:
>> --- a/net/mac80211/pm.c
>> +++ b/net/mac80211/pm.c
>> @@ -301,7 +301,7 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>>       }
>>
>>       mutex_lock(&local->mtx);
>> -     ieee80211_recalc_idle(local);
>> +     ieee80211_recalc_idle_force(local);
>
> Does this really occur afterwards closing interfaces?

It appears possible using wpa_supplicant with nl80211, at least using
the new DBus API.

--
Paul
