Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37589 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab1CIDAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 22:00:54 -0500
Message-ID: <4D76ED41.3020504@candelatech.com>
Date: Tue, 08 Mar 2011 19:00:17 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Kyungwan Nam <Kyungwan.Nam@atheros.com>
Subject: Re: [PATCH 2.6.38] ath9k: remove support for the FIF_PROMISC_IN_BSS
 filter flag
References: <1299631692-69094-1-git-send-email-nbd@openwrt.org> <20110309025645.GA4975@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110309025645.GA4975@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2011 06:56 PM, Rajkumar Manoharan wrote:
> On Wed, Mar 09, 2011 at 06:18:12AM +0530, Felix Fietkau wrote:
>> The hardware rx filter flag triggered by FIF_PROMISC_IN_BSS is overly broad
>> and covers even frames with PHY errors. When this flag is enabled, this message
>> shows up frequently during scanning or hardware resets:
>>
>> ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
>>
>> Since promiscuous mode is usually not particularly useful, yet enabled by
>> default by bridging (either used normally in 4-addr mode, or with hacks
>> for various virtualization software), we should sacrifice it for better
>> reliability during normal operation.
>>
>> This patch leaves it enabled if there are active monitor mode interfaces, since
>> it's very useful for debugging.
>>
>> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>> Cc: stable@kernel.org
>> ---
>>   drivers/net/wireless/ath/ath9k/recv.c |    4 +---
>>   1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index cb559e3..a9c3f46 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -413,9 +413,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
>>   	 * mode interface or when in monitor mode. AP mode does not need this
>>   	 * since it receives all in-BSS frames anyway.
>>   	 */
>> -	if (((sc->sc_ah->opmode != NL80211_IFTYPE_AP)&&
>> -	     (sc->rx.rxfilter&  FIF_PROMISC_IN_BSS)) ||
>> -	    (sc->sc_ah->is_monitoring))
>> +	if (sc->sc_ah->is_monitoring)
>>   		rfilt |= ATH9K_RX_FILTER_PROM;
>
> Assume there are 2 vifs (STA + MON) and both running. Doing a scan on STA vif, dumps dma messages.

Sounds like you got a reproducible test case then!

This patch may be fine, but either way, it is at best making it harder to
hit the DMA issue, not actually fixing the underlying cause.

Thanks,
Ben

>
> --
> Rajkumar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
