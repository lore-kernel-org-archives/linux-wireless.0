Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49881 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbbFOLrF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 07:47:05 -0400
Message-ID: <557EBB2F.8000503@openwrt.org> (sfid-20150615_134708_568091_8756F4B9)
Date: Mon, 15 Jun 2015 13:46:55 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
CC: ath9k-devel@venema.h4ckr.net, c_manoha@qca.qualcomm.com
Subject: Re: [RFC] ath9k: allow to receive probe request when offchannel
References: <1433912583-15918-1-git-send-email-janusz.dziedzic@tieto.com>
In-Reply-To: <1433912583-15918-1-git-send-email-janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-06-10 07:03, Janusz Dziedzic wrote:
> This fix problem that p2p group negotiation didn't work
> correctly when chanctx used, because we didn't receive
> probe requests when offchannel and use_chanctx=1
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
> @Felix, Sujith could you review? I am not sure I put this in correct place.
> 
>  drivers/net/wireless/ath/ath9k/channel.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
> index 2066650..6301d44 100644
> --- a/drivers/net/wireless/ath/ath9k/channel.c
> +++ b/drivers/net/wireless/ath/ath9k/channel.c
> @@ -1157,6 +1157,7 @@ static bool ath_chanctx_defer_switch(struct ath_softc *sc)
>  static void ath_offchannel_channel_change(struct ath_softc *sc)
>  {
>  	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> +	u32 rfilt;
>  
>  	ath_dbg(common, CHAN_CTX, "%s: offchannel state: %s\n",
>  		__func__, offchannel_state_string(sc->offchannel.state));
> @@ -1179,6 +1180,11 @@ static void ath_offchannel_channel_change(struct ath_softc *sc)
>  		ath_scan_complete(sc, false);
>  		break;
>  	case ATH_OFFCHANNEL_ROC_START:
> +		/* Allow to receive probe requests */
> +		rfilt = ath_calcrxfilter(sc);
> +		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
I think ath_calcrxfilter should set this, otherwise it might be
overwritten, e.g. on BB watchdog reset.

- Felix
