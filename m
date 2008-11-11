Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19404 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYKKHOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 02:14:35 -0500
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/2] mac80211: implement dynamic power save
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	<1226245439-30329-3-git-send-email-kalle.valo@nokia.com>
	<20081110201444.GI6918@tesla>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 11 Nov 2008 09:14:23 +0200
In-Reply-To: <20081110201444.GI6918@tesla> (ext Luis R. Rodriguez's message of "Mon\, 10 Nov 2008 12\:14\:44 -0800")
Message-ID: <87zlk6vink.fsf@nokia.com> (sfid-20081111_081440_027791_A7348607)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <lrodriguez@atheros.com> writes:

> On Sun, Nov 09, 2008 at 07:43:59AM -0800, Kalle Valo wrote:
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -973,6 +978,10 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
>>  u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
>>                               enum ieee80211_band band);
>> 
>> +void ieee80211_ps_enable_work(struct work_struct *work);
>> +void ieee80211_ps_disable_work(struct work_struct *work);
>
> Should these also be prefixed with _dynamic ? May confuse other people
> working on regular ps mode I think.

I think we should. Actually there are three types of power save now:
AP mode buffering for clients in power save, the normal ("static")
power save for client mode and the dynamic version. So this will get
very confusing.

> Also can you elaborate a bit in the patch/log as to what dynamic power save
> concept is, what drivers who implement it are expected to do as well?

I will do that in the next round.

While talking about power save, can you give me any hints how power
save in client mode works in ath5k/ath9k? I haven't looked at the
drivers yet, but any hints (even how small) always help and save time.
I'm trying to understand how power save is implemented in different
hardware so that I can take that into account in my patches.

-- 
Kalle Valo
