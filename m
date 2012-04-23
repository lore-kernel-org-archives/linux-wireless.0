Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41263 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2DWR1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 13:27:04 -0400
From: "Chadd, Adrian" <achadd@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: Zefir Kurtisi <zefir.kurtisi@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"chunkeey@googlemail.com" <chunkeey@googlemail.com>
Subject: RE: [PATCH 2/4] ath9k: set PHYRADAR in RX filter when on DFS channel
Date: Mon, 23 Apr 2012 17:27:02 +0000
Message-ID: <48EC4E8D43A28947B1AB2639FA97CDB90BE9B196@nasanexd02a.na.qualcomm.com> (sfid-20120423_192709_765341_1AF5C804)
References: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
 <1335124223-15439-3-git-send-email-zefir.kurtisi@gmail.com>
 <4F946340.3020700@openwrt.org> <4F951D01.60509@neratec.com>
 <4F95902E.7040806@openwrt.org>
In-Reply-To: <4F95902E.7040806@openwrt.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There may be a need later on (eg mesh, p2p mode, etc.)

2c,


Adrian

-----Original Message-----
From: Felix Fietkau [mailto:nbd@openwrt.org] 
Sent: Monday, April 23, 2012 10:24 AM
To: Zefir Kurtisi
Cc: Zefir Kurtisi; linville@tuxdriver.com; ath9k-devel@lists.ath9k.org; linux-wireless@vger.kernel.org; Rodriguez, Luis; Chadd, Adrian; chunkeey@googlemail.com
Subject: Re: [PATCH 2/4] ath9k: set PHYRADAR in RX filter when on DFS channel

On 2012-04-23 11:12 AM, Zefir Kurtisi wrote:
> On 22.04.2012 22:00, Felix Fietkau wrote:
>> On 2012-04-22 9:50 PM, Zefir Kurtisi wrote:
>>> From: Zefir Kurtisi<zefir.kurtisi@neratec.com>
>>>
>>>
>>> Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
>>> ---
>>>   drivers/net/wireless/ath/ath9k/recv.c |    6 ++++++
>>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c 
>>> b/drivers/net/wireless/ath/ath9k/recv.c
>>> index f4ae3ba..ef45c0c 100644
>>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>>> @@ -17,6 +17,7 @@
>>>   #include<linux/dma-mapping.h>
>>>   #include "ath9k.h"
>>>   #include "ar9003_mac.h"
>>> +#include "dfs.h"
>>>
>>>   #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
>>>
>>> @@ -467,6 +468,11 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
>>>   		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
>>>   	}
>>>
>>> +	if (sc->sc_ah->curchan->chan->flags&  IEEE80211_CHAN_RADAR)
>>> +		rfilt |= ATH9K_RX_FILTER_PHYRADAR;
>>> +	else
>>> +		rfilt&= ~ATH9K_RX_FILTER_PHYRADAR;
>> This should only be done in AP mode, maybe mac80211 should have a 
>> separate flag to tell the driver to enable this. Same comment also 
>> applies to patch 4/4.
>>
>> - Felix
>>
> Are you aware of any issues enabling DFS in client modes? My thinking 
> was that it won't hurt to detect radars in any mode and let the DFS 
> management component decide what to do with that events.
Power consumption (for laptops), performance issues (due to DMA descriptor use and interrupts triggered by pulse detection).

If the DFS management component decides what to do with the events, why not let it decide whether it actually wants events as well ;)

- Felix
