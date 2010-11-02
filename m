Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45644 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab0KBSUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 14:20:17 -0400
Received: by ywc21 with SMTP id 21so1914092ywc.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 11:20:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD04C61.4070007@openwrt.org>
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>
	<4CD046D2.4080703@openwrt.org>
	<4CD04C61.4070007@openwrt.org>
Date: Tue, 2 Nov 2010 19:20:16 +0100
Message-ID: <AANLkTikUUue=Nt0iFPcQC68kDCh=EeEpeBT9xnhW6bf+@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/2 Felix Fietkau <nbd@openwrt.org>:
> +       q = ath_get_mac80211_qnum(txq->axq_class, sc);
>        r = ath_tx_setup_buffer(hw, bf, skb, txctl);
>        if (unlikely(r)) {
>                ath_print(common, ATH_DBG_FATAL, "TX mem alloc failure\n");
> @@ -1756,8 +1757,8 @@ int ath_tx_start(struct ieee80211_hw *hw
>                 * we will at least have to run TX completionon one buffer
>                 * on the queue */
>                spin_lock_bh(&txq->axq_lock);
> -               if (!txq->stopped && txq->axq_depth > 1) {
> -                       ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
> +               if (q >= 0 && !txq->stopped && txq->axq_depth > 1) {
> +                       ath_mac80211_stop_queue(sc, q);
>                        txq->stopped = 1;
>                }

You cannot be sure that you are stopping the queue that the skb
actually came in on here since mac80211 queues are mapped to hw queues
by ath_get_hal_qnum() and that mapping is not reversible (due to the
default statement):

static int ath_get_hal_qnum(u16 queue, struct ath_softc *sc)
{
        int qnum;

        switch (queue) {
        case 0:
                qnum = sc->tx.hwq_map[WME_AC_VO];
                break;
        case 1:
                qnum = sc->tx.hwq_map[WME_AC_VI];
                break;
        case 2:
                qnum = sc->tx.hwq_map[WME_AC_BE];
                break;
        case 3:
                qnum = sc->tx.hwq_map[WME_AC_BK];
                break;
        default:
                qnum = sc->tx.hwq_map[WME_AC_BE];
                break;
        }

        return qnum;
}

/Björn
