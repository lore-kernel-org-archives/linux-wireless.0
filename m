Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 64.mail-out.ovh.net ([91.121.185.65]:55074 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932268Ab0BEOhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 09:37:33 -0500
Message-ID: <4B6C2D24.3020001@free.fr>
Date: Fri, 05 Feb 2010 15:37:24 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Improved IBSS merges
References: <1265319990-25583-1-git-send-email-benoit.papillault@free.fr> <1265365977.3613.2.camel@johannes.local>
In-Reply-To: <1265365977.3613.2.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a écrit :
> On Thu, 2010-02-04 at 22:46 +0100, Benoit Papillault wrote:
>
>   
>> Next, we merge even if the BSSID from the received beacon is the same as
>> our since merge can update more things that BSSID itself. This is
>> specifically true for ath9k where the merge updates TBTT timers as a
>> side effect and this is indeed needed if the TSF has been updated (if
>> TSF is updated, we need to update TBTT timers as well).
>>     
>
>   
>> @@ -373,10 +370,6 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>>  				sdata->u.ibss.ssid_len))
>>  		goto put_bss;
>>  
>> -	/* same BSSID */
>> -	if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
>> -		goto put_bss;
>> -
>>  	if (rx_status->flag & RX_FLAG_TSFT) {
>>  		/*
>>  		 * For correct IBSS merging we need mactime; since mactime is
>>     
>
> NACK. This will create merges and merges and merges and merges whenever
> you use hardware that doesn't have accurate timestamps all the time.
>
> johannes
>   
Humm... could you give an example? For hardware that don't have RX 
timestamp, we will use the drv_get_tsf() function, this function will 
only return a timestamp that is later than the real time at which the 
beacon is received, so we can only miss IBSS merges in fact. Did I miss 
something?

I can resubmit a patch with the remaining and leave this one open for 
discussion.

Regards,
Benoit

