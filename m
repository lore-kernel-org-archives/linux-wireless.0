Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:43070 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934065AbdKBTfA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 15:35:00 -0400
Received: by mail-wm0-f53.google.com with SMTP id m72so599506wmc.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Nov 2017 12:34:59 -0700 (PDT)
From: Christian Lamparter <chunkeey@gmail.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] ath10k: fix recent bandwidth conversion bug
Date: Thu, 02 Nov 2017 20:34:06 +0100
Message-ID: <1666282.PC3nhpCf9f@debian64> (sfid-20171102_203503_878606_B2B1FC2C)
In-Reply-To: <224e2890-3775-967b-d4ce-4297574c0642@dd-wrt.com>
References: <20171101200157.27096-1-chunkeey@gmail.com> <224e2890-3775-967b-d4ce-4297574c0642@dd-wrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, November 1, 2017 9:37:53 PM CET Sebastian Gottschall wrote:
> a additional array bounds check would be good

Ah, about that:

the bw variable in ath10k_htt_rx_h_rates() is extracted from info2
in the following way [0]:
|	bw = info2 & 3;

the txrate.bw variable in ath10k_update_per_peer_tx_stats() is set by [1]:
|	txrate.bw = ATH10K_HW_BW(peer_stats->flags);

ATH10K_HW_BW is a macro defined as [2]:
|	#define ATH10K_HW_BW(flags)		(((flags) >> 3) & 0x3)

In both cases the bandwidth values already are limited to 0-3 by
the "and 3" operation.

[0] <https://elixir.free-electrons.com/linux/v4.14-rc7/source/drivers/net/wireless/ath/ath10k/htt_rx.c#L646>

[1] <https://elixir.free-electrons.com/linux/v4.14-rc7/source/drivers/net/wireless/ath/ath10k/htt_rx.c#L2254>
[2] <https://elixir.free-electrons.com/linux/v4.14-rc7/source/drivers/net/wireless/ath/ath10k/wmi.h#L4810>


> > @@ -592,6 +592,9 @@ struct amsdu_subframe_hdr {
> >   
> >   #define GROUP_ID_IS_SU_MIMO(x) ((x) == 0 || (x) == 63)
> >   
> > +static const u8 ath10k_bw_to_mac80211[] = { RATE_INFO_BW_20, RATE_INFO_BW_40,
> > +	RATE_INFO_BW_80, RATE_INFO_BW_160 };
> > +
> >   static void ath10k_htt_rx_h_rates(struct ath10k *ar,
> >   				  struct ieee80211_rx_status *status,
> >   				  struct htt_rx_desc *rxd)
> > @@ -694,23 +697,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
> >   		if (sgi)
> >   			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
> >   
> > [...]
> > +		status->bw = ath10k_bw_to_mac80211[bw];
> >   		status->encoding = RX_ENC_VHT;
> >   		break;
> >   	default:
> > @@ -2297,7 +2284,7 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
> >   		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
> >   
> >   	arsta->txrate.nss = txrate.nss;
> > -	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
> > +	arsta->txrate.bw = ath10k_bw_to_mac80211[txrate.bw];
> >   }
> >   
> >   static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
