Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:55159 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbXE1Svw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2007 14:51:52 -0400
Message-ID: <465B24C5.6060401@lwfinger.net>
Date: Mon, 28 May 2007 13:51:49 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	mabbas@linux.intel.com
Subject: Re: [RFC/T #2] mac80211: Implementation of SIOCSIWRATE
References: <465a2d72.zG8j8542QjPLcafO%Larry.Finger@lwfinger.net> <200705280210.10893.flamingice@sourmilk.net>
In-Reply-To: <200705280210.10893.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Sunday 27 May 2007 18:16, Larry Finger wrote:
>> From: mabbas <mabbas@linux.intel.com>
>>
>> The WEXT ioctl SIOCSIWRATE is not implemented in mac80211. This patch
>> adds the missing routine. It supports the 'auto' keyword, fixed rates,
>> and the combination of 'auto' and a fixed rate to select an upper bound.
>>
>> Signed-off-by: mabbas <mabbas@linux.intel.com>
> Full name please.

I'm working on getting his name.

>> Index: wireless-dev/net/mac80211/ieee80211_i.h
>> ===================================================================
>> --- wireless-dev.orig/net/mac80211/ieee80211_i.h
>> +++ wireless-dev/net/mac80211/ieee80211_i.h
>> @@ -269,6 +269,7 @@ struct ieee80211_if_sta {
>>  	unsigned long ibss_join_req;
>>  	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
>>  	u32 supp_rates_bits;
>> +	u32 restricted_tx_rates; /* bitmap of user restricted tx rate */
>>
> No. max_ratectrl_rateidx and force_unicast_rateidx can do everything you need. 
> Look more carefully at how the rate control code works with those two fields. 
> The only file that needs to be patched to add support for this is 
> ieee80211_ioctl.c because this feature was always supported. (with 
> non-standard prism2/hostap ioctls)

I think I understand now. I could see how the two existing variables can be used for the maximum 
rate, but not for the range of rates implied when the 'auto' keyword of the iwconfig command is 
used. Now I see that sta->supp_rates and sdata->u.sta.supp_rates_bits can be used for the necessary 
bitmaps. I was reluctant to destroy them, but now I see that they will be rebuilt with later calls 
to iwconfig.

I am testing the new version and will be sending it along later.

Larry



