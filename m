Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34486 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0KBTQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 15:16:38 -0400
Received: by iwn10 with SMTP id 10so8714568iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 12:16:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD05E49.70701@openwrt.org>
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>
	<4CD046D2.4080703@openwrt.org>
	<4CD04C61.4070007@openwrt.org>
	<AANLkTikUUue=Nt0iFPcQC68kDCh=EeEpeBT9xnhW6bf+@mail.gmail.com>
	<4CD05E49.70701@openwrt.org>
Date: Tue, 2 Nov 2010 20:16:38 +0100
Message-ID: <AANLkTinBSeUSGR_9P-e5ZgKSeLfp36JfUbJOk73hpnQ2@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/2 Felix Fietkau <nbd@openwrt.org>:
> On 2010-11-02 7:20 PM, Björn Smedman wrote:
>> 2010/11/2 Felix Fietkau <nbd@openwrt.org>:
>>> +       q = ath_get_mac80211_qnum(txq->axq_class, sc);
>>>        r = ath_tx_setup_buffer(hw, bf, skb, txctl);
>>>        if (unlikely(r)) {
>>>                ath_print(common, ATH_DBG_FATAL, "TX mem alloc failure\n");
>>> @@ -1756,8 +1757,8 @@ int ath_tx_start(struct ieee80211_hw *hw
>>>                 * we will at least have to run TX completionon one buffer
>>>                 * on the queue */
>>>                spin_lock_bh(&txq->axq_lock);
>>> -               if (!txq->stopped && txq->axq_depth > 1) {
>>> -                       ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
>>> +               if (q >= 0 && !txq->stopped && txq->axq_depth > 1) {
>>> +                       ath_mac80211_stop_queue(sc, q);
>>>                        txq->stopped = 1;
>>>                }
>>
>> You cannot be sure that you are stopping the queue that the skb
>> actually came in on here since mac80211 queues are mapped to hw queues
>> by ath_get_hal_qnum() and that mapping is not reversible (due to the
>> default statement):
> How does the default statement matter here? The queue number always
> comes from an index of the ieee802_1d_to_ac[] array, which only contains
> numbers from 0 to 3. That should make the conversion reversible.

True, but then you have a functional dependency on that data/code
(with catastrophic consequences if it ever changes). I understand the
name of that array suggests that it will be fixed forever but I don't
think we can be sure that a queue mapping will always be an AC. I
think it may be very reasonable to expand it to be a TID (0-7) or even
a separate queue per RA and TID. Are you prepared to put a BUG_ON()
under that default? If so that's a start.

But it's not only the default statement that may make that mapping
non-reversible. It could also be that e.g. sc->tx.hwq_map[WME_AC_VI]
== sc->tx.hwq_map[WME_AC_VO]. You need some BUG_ONs there too and you
better not try to support a chipset with less than 4 hw queues.

/Björn
