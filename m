Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55254 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1CJMrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 07:47:55 -0500
Message-ID: <4D78C871.2040901@openwrt.org>
Date: Thu, 10 Mar 2011 13:47:45 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 2/4] ath9k: fix stopping tx dma on reset
References: <1299717303-42430-1-git-send-email-nbd@openwrt.org> <1299717303-42430-2-git-send-email-nbd@openwrt.org> <20110310085847.GB28100@vasanth-laptop>
In-Reply-To: <20110310085847.GB28100@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-10 9:58 AM, Vasanthakumar Thiagarajan wrote:
> On Thu, Mar 10, 2011 at 06:05:01AM +0530, Felix Fietkau wrote:
>> +bool ath9k_hw_abort_tx_dma(struct ath_hw *ah)
>> +{
>> +	int i, q;
>> +
>> +	REG_WRITE(ah, AR_Q_TXD, AR_Q_TXD_M);
>> +
>> +	REG_SET_BIT(ah, AR_PCU_MISC, AR_PCU_FORCE_QUIET_COLL | AR_PCU_CLEAR_VMF);
>> +	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
>> +	REG_SET_BIT(ah, AR_D_GBL_IFS_MISC, AR_D_GBL_IFS_MISC_IGNORE_BACKOFF);
>> +
>> +	for (q = 0; q < AR_NUM_QCU; q++) {
>> +		for (i = 1000; i > 0; i--) {
>> +			if (!ath9k_hw_numtxpending(ah, q))
>> +				break;
>> +
>> +			udelay(5);
>> +		}
>> +	}
>> +	if (!i)
>> +		return false;
> 
> Here the assumption looks like a reset would follow to configure
> those registers back, may be some comment will be useful.
> 
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>> index e16136d..bb1d29e 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -1194,16 +1194,14 @@ bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>>  	if (sc->sc_flags & SC_OP_INVALID)
>>  		return true;
>>  
>> -	/* Stop beacon queue */
>> -	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
>> +	ath9k_hw_abort_tx_dma(ah);
>>  
>> -	/* Stop data queues */
>> +	/* Check if any queue remains active */
>>  	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
>> -		if (ATH_TXQ_SETUP(sc, i)) {
>> -			txq = &sc->tx.txq[i];
>> -			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
>> -			npend += ath9k_hw_numtxpending(ah, txq->axq_qnum);
>> -		}
>> +		if (!ATH_TXQ_SETUP(sc, i))
>> +			continue;
>> +
>> +		npend += ath9k_hw_numtxpending(ah, sc->tx.txq[i].axq_qnum);
> 
> This can be moved to ath9k_hw_abort_tx_dma() and make it return
> npend as the current return value is unused anyway.
I think I'll drop the return code of ath9k_hw_abort_tx_dma. Since it
checks the queues individually, queues that hit a timeout at first might
recover later, so it would be useful if the caller checks them properly
after the abort has been issued completely.

- Felix
