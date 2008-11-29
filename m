Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38730 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYK2HAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 02:00:15 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 4/4] mac80211: move dynamic_ps_timeout to hw.conf
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	<1227901784-5325-5-git-send-email-kalle.valo@nokia.com>
	<1227910693.3543.7.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 29 Nov 2008 09:00:03 +0200
In-Reply-To: <1227910693.3543.7.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 28 Nov 2008 23\:18\:13 +0100")
Message-ID: <87myfj10gc.fsf@nokia.com> (sfid-20081129_080026_811413_391D7FEA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Johannes Berg" <johannes@sipsolutions.net> writes:

> On Fri, 2008-11-28 at 21:49 +0200, Kalle Valo wrote:
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -560,6 +560,7 @@ struct ieee80211_conf {
>>  
>>  	u16 listen_interval;
>>  	bool radio_enabled;
>> +	int dynamic_ps_timeout;
>
> Same here, add documentation please;

I will.

> also, I think you need to call the hw_config call when this changes
> so drivers can upload the new value to the firmware or whatever?

Doh, I missed that. Yes, I think we need to do that.

> Which drivers actually will end up using it and how?

Currently I'm only aware of iwl3945 and iwlagn. I have some example
patches for them, but they aren't ready yet.

-- 
Kalle Valo
