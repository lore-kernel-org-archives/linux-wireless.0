Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38553 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbbFOLj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 07:39:27 -0400
Received: by wibdq8 with SMTP id dq8so75027655wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 04:39:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433912583-15918-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1433912583-15918-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 15 Jun 2015 13:39:26 +0200
Message-ID: <CALhHN=r5FyRzG18KOmN7zFRhx2O4jjQ-MxUmRfcT9EKpmpbqig@mail.gmail.com> (sfid-20150615_133931_082683_2ABA309C)
Subject: Re: [RFC] ath9k: allow to receive probe request when offchannel
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Felix Fietkau <nbd@openwrt.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Sujith Manoharan <sujith@msujith.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding Sujith correct mail

On 10 June 2015 at 07:03, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
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
>         struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> +       u32 rfilt;
>
>         ath_dbg(common, CHAN_CTX, "%s: offchannel state: %s\n",
>                 __func__, offchannel_state_string(sc->offchannel.state));
> @@ -1179,6 +1180,11 @@ static void ath_offchannel_channel_change(struct ath_softc *sc)
>                 ath_scan_complete(sc, false);
>                 break;
>         case ATH_OFFCHANNEL_ROC_START:
> +               /* Allow to receive probe requests */
> +               rfilt = ath_calcrxfilter(sc);
> +               rfilt |= ATH9K_RX_FILTER_PROBEREQ;
> +               ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
> +
>                 if (sc->cur_chan != &sc->offchannel.chan)
>                         break;
>
> --
> 1.9.1
>
