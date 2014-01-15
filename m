Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64663 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaAOQQL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 11:16:11 -0500
Received: from [192.168.1.221] ([93.218.75.192]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0M6fXs-1V75CA1FRM-00wWue for
 <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 17:16:10 +0100
Message-ID: <52D6B448.6070309@rempel-privat.de> (sfid-20140115_171615_129423_56ABA329)
Date: Wed, 15 Jan 2014 17:16:08 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@meshcoding.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/5] ath: add common function ath_is_mybeacon
References: <1389802038-6688-1-git-send-email-linux@rempel-privat.de> <1389802038-6688-2-git-send-email-linux@rempel-privat.de> <52D6B2F5.4070404@meshcoding.com>
In-Reply-To: <52D6B2F5.4070404@meshcoding.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.01.2014 17:10, schrieb Antonio Quartulli:
> On 15/01/14 17:07, Oleksij Rempel wrote:
>> this function is used by most ath driver, so it can be moved here.
>>
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>> ---
>>  drivers/net/wireless/ath/ath.h  |  2 ++
>>  drivers/net/wireless/ath/main.c | 11 +++++++++++
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
>> index e0ba7cd..b59cfbe 100644
>> --- a/drivers/net/wireless/ath/ath.h
>> +++ b/drivers/net/wireless/ath/ath.h
>> @@ -17,6 +17,7 @@
>>  #ifndef ATH_H
>>  #define ATH_H
>>  
>> +#include <linux/etherdevice.h>
>>  #include <linux/skbuff.h>
>>  #include <linux/if_ether.h>
>>  #include <linux/spinlock.h>
>> @@ -165,6 +166,7 @@ struct ath_common {
>>  struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
>>  				u32 len,
>>  				gfp_t gfp_mask);
>> +bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr);
>>  
>>  void ath_hw_setbssidmask(struct ath_common *common);
>>  void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
>> diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
>> index 8e99540..9cb15d9 100644
>> --- a/drivers/net/wireless/ath/main.c
>> +++ b/drivers/net/wireless/ath/main.c
>> @@ -59,6 +59,17 @@ struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
>>  }
>>  EXPORT_SYMBOL(ath_rxbuf_alloc);
>>  
>> +bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr)
>> +{
>> +	if (ieee80211_is_beacon(hdr->frame_control) &&
>> +			!is_zero_ether_addr(common->curbssid) &&
>> +			ether_addr_equal_64bits(hdr->addr3, common->curbssid))
>> +		return true;
>> +
> 
> Apart from the fact that the expression in the if guard is badly
> indented, couldn't you just return the value of that expression and
> remove the if at all?

Good point, thank you!


-- 
Regards,
Oleksij
