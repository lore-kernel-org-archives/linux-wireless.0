Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:48477 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab2DWJMo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 05:12:44 -0400
Message-ID: <4F951D01.60509@neratec.com> (sfid-20120423_111247_844670_01AB963A)
Date: Mon, 23 Apr 2012 11:12:33 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Zefir Kurtisi <zefir.kurtisi@gmail.com>, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	chunkeey@googlemail.com
Subject: Re: [PATCH 2/4] ath9k: set PHYRADAR in RX filter when on DFS channel
References: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com> <1335124223-15439-3-git-send-email-zefir.kurtisi@gmail.com> <4F946340.3020700@openwrt.org>
In-Reply-To: <4F946340.3020700@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22.04.2012 22:00, Felix Fietkau wrote:
> On 2012-04-22 9:50 PM, Zefir Kurtisi wrote:
>> From: Zefir Kurtisi<zefir.kurtisi@neratec.com>
>>
>>
>> Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/recv.c |    6 ++++++
>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index f4ae3ba..ef45c0c 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -17,6 +17,7 @@
>>   #include<linux/dma-mapping.h>
>>   #include "ath9k.h"
>>   #include "ar9003_mac.h"
>> +#include "dfs.h"
>>
>>   #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
>>
>> @@ -467,6 +468,11 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
>>   		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
>>   	}
>>
>> +	if (sc->sc_ah->curchan->chan->flags&  IEEE80211_CHAN_RADAR)
>> +		rfilt |= ATH9K_RX_FILTER_PHYRADAR;
>> +	else
>> +		rfilt&= ~ATH9K_RX_FILTER_PHYRADAR;
> This should only be done in AP mode, maybe mac80211 should have a
> separate flag to tell the driver to enable this. Same comment also
> applies to patch 4/4.
>
> - Felix
>
Are you aware of any issues enabling DFS in client modes? My thinking 
was that it won't hurt to detect radars in any mode and let the DFS 
management component decide what to do with that events.

I'll be out of office for some time and update the patches then.

John, please ignore this series for now.


Thanks,
Zefir
