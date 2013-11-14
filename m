Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47185 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab3KNLJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 06:09:24 -0500
Message-ID: <5284AF55.2070704@openwrt.org> (sfid-20131114_120929_394192_957C0F0A)
Date: Thu, 14 Nov 2013 12:09:09 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/3] ath9k: optimize ath_drain_all_txq
References: <1384205015-68622-1-git-send-email-nbd@openwrt.org>	<1384205015-68622-2-git-send-email-nbd@openwrt.org> <21124.34726.610542.341502@gargle.gargle.HOWL>
In-Reply-To: <21124.34726.610542.341502@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-14 09:19, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> If the software has processed all packets, checking the hardware queue
>> is unnecessary.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/xmit.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>> index 09cdbcd..babb513 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -1786,6 +1786,9 @@ bool ath_drain_all_txq(struct ath_softc *sc)
>>  		if (!ATH_TXQ_SETUP(sc, i))
>>  			continue;
>>  
>> +		if (!sc->tx.txq[i].axq_depth)
>> +			continue;
>> +
> 
> Shouldn't the TX queue lock be taken here ?
I don't think so. Flushing the queues is only allowed if no frames are
expected to be pushed by mac80211, and callsites already take the pcu
lock (preventing the completion tasklet from running).

- Felix

