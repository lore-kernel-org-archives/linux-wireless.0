Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49065 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab0KBSyF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 14:54:05 -0400
Message-ID: <4CD05E49.70701@openwrt.org>
Date: Tue, 02 Nov 2010 19:54:01 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>	<4CD046D2.4080703@openwrt.org>	<4CD04C61.4070007@openwrt.org> <AANLkTikUUue=Nt0iFPcQC68kDCh=EeEpeBT9xnhW6bf+@mail.gmail.com>
In-Reply-To: <AANLkTikUUue=Nt0iFPcQC68kDCh=EeEpeBT9xnhW6bf+@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-02 7:20 PM, Björn Smedman wrote:
> 2010/11/2 Felix Fietkau <nbd@openwrt.org>:
>> +       q = ath_get_mac80211_qnum(txq->axq_class, sc);
>>        r = ath_tx_setup_buffer(hw, bf, skb, txctl);
>>        if (unlikely(r)) {
>>                ath_print(common, ATH_DBG_FATAL, "TX mem alloc failure\n");
>> @@ -1756,8 +1757,8 @@ int ath_tx_start(struct ieee80211_hw *hw
>>                 * we will at least have to run TX completionon one buffer
>>                 * on the queue */
>>                spin_lock_bh(&txq->axq_lock);
>> -               if (!txq->stopped && txq->axq_depth > 1) {
>> -                       ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
>> +               if (q >= 0 && !txq->stopped && txq->axq_depth > 1) {
>> +                       ath_mac80211_stop_queue(sc, q);
>>                        txq->stopped = 1;
>>                }
> 
> You cannot be sure that you are stopping the queue that the skb
> actually came in on here since mac80211 queues are mapped to hw queues
> by ath_get_hal_qnum() and that mapping is not reversible (due to the
> default statement):
How does the default statement matter here? The queue number always
comes from an index of the ieee802_1d_to_ac[] array, which only contains
numbers from 0 to 3. That should make the conversion reversible.

- Felix
