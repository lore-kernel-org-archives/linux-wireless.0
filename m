Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:17496 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbcAYJy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 04:54:57 -0500
Subject: Re: [PATCH] brcmfmac: fix setting primary channel for 80 MHz width
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>
References: <1453304764-11895-1-git-send-email-zajec5@gmail.com>
From: Arend van Spriel <arend@broadcom.com>
Message-ID: <56A5F0EE.7020409@broadcom.com> (sfid-20160125_105513_472965_E9371C43)
Date: Mon, 25 Jan 2016 10:54:54 +0100
MIME-Version: 1.0
In-Reply-To: <1453304764-11895-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-1-2016 16:46, Rafał Miłecki wrote:
> First of all it changes the way we calculate primary channel offset. If
> we use e.g. 80 MHz channel with primary frequency 5180 MHz (which means
> center frequency is 5210 MHz) it makes sense to calculate primary offset
> as -30 MHz.
> Then it fixes values we compare primary_offset with. We were comparing
> offset in MHz against -2 or 2 which was resulting in picking a wrong
> primary channel.

Not sure about comparing explicit values here, but it looks fine by me.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 23 ++++++++++------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 8d9cff4..2b335de 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -247,7 +247,7 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
>  	brcmf_dbg(TRACE, "chandef: control %d center %d width %d\n",
>  		  ch->chan->center_freq, ch->center_freq1, ch->width);
>  	ch_inf.chnum = ieee80211_frequency_to_channel(ch->center_freq1);
> -	primary_offset = ch->center_freq1 - ch->chan->center_freq;
> +	primary_offset = ch->chan->center_freq - ch->center_freq1;
>  	switch (ch->width) {
>  	case NL80211_CHAN_WIDTH_20:
>  	case NL80211_CHAN_WIDTH_20_NOHT:
> @@ -256,24 +256,21 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
>  		break;
>  	case NL80211_CHAN_WIDTH_40:
>  		ch_inf.bw = BRCMU_CHAN_BW_40;
> -		if (primary_offset < 0)
> +		if (primary_offset > 0)
>  			ch_inf.sb = BRCMU_CHAN_SB_U;
>  		else
>  			ch_inf.sb = BRCMU_CHAN_SB_L;
>  		break;
>  	case NL80211_CHAN_WIDTH_80:
>  		ch_inf.bw = BRCMU_CHAN_BW_80;
> -		if (primary_offset < 0) {
> -			if (primary_offset < -CH_10MHZ_APART)
> -				ch_inf.sb = BRCMU_CHAN_SB_UU;
> -			else
> -				ch_inf.sb = BRCMU_CHAN_SB_UL;
> -		} else {
> -			if (primary_offset > CH_10MHZ_APART)
> -				ch_inf.sb = BRCMU_CHAN_SB_LL;
> -			else
> -				ch_inf.sb = BRCMU_CHAN_SB_LU;
> -		}
> +		if (primary_offset == -30)
> +			ch_inf.sb = BRCMU_CHAN_SB_LL;
> +		else if (primary_offset == -10)
> +			ch_inf.sb = BRCMU_CHAN_SB_LU;
> +		else if (primary_offset == 10)
> +			ch_inf.sb = BRCMU_CHAN_SB_UL;
> +		else
> +			ch_inf.sb = BRCMU_CHAN_SB_UU;
>  		break;
>  	case NL80211_CHAN_WIDTH_80P80:
>  	case NL80211_CHAN_WIDTH_160:
> 
