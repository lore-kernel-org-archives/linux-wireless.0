Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:48116 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbXDQAWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2007 20:22:11 -0400
Message-ID: <462413AE.9020200@lwfinger.net>
Date: Mon, 16 Apr 2007 19:24:14 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Andreas Schwab <schwab@suse.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] ieee80211-crypt: Make some TKIP and CCMP error logging  conditional on IEEE80211_DEBUG_DROP
References: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net>	<jeirbwfb55.fsf@sykes.suse.de> <4623C561.4030201@lwfinger.net> <200704162237.01280.mb@bu3sch.de>
In-Reply-To: <200704162237.01280.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Monday 16 April 2007 20:50, Larry Finger wrote:
>> Andreas Schwab wrote:
>>> This is causing an undefined refrence to ieee80211_debug_level with
>>> CONFIG_IEEE80211_DEBUG=y and CONFIG_IEEE80211_CRYPT_CCMP=m and/or
>>> CONFIG_IEEE80211_CRYPT_TKIP=m.
>>>
>>> WARNING: "ieee80211_debug_level" [net/ieee80211/ieee80211_crypt_tkip.ko] undefined!
>>> WARNING: "ieee80211_debug_level" [net/ieee80211/ieee80211_crypt_ccmp.ko] undefined!
>>>
>>> Andreas.
>> The missing symbol was not exported by ieee80211_module.c. Sorry for not testing enough. The fix is 
>> as follows:
>>
>> Index: wireless-2.6/net/ieee80211/ieee80211_module.c
>> ===================================================================
>> --- wireless-2.6.orig/net/ieee80211/ieee80211_module.c
>> +++ wireless-2.6/net/ieee80211/ieee80211_module.c
>> @@ -229,6 +229,7 @@ void free_ieee80211(struct net_device *d
>>
>>   static int debug = 0;
>>   u32 ieee80211_debug_level = 0;
>> +EXPORT_SYMBOL_GPL(ieee80211_debug_level);
> 
> We don't use the _GPL suffix in mac80211.
> 

Upon inspection, neither does most of ieee80211. It is now changed.

Larry
