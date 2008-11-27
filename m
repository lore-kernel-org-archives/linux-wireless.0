Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:54327 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYK0Rns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 12:43:48 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Stefanik =?utf-8?q?G=C3=A1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [RFC] rtl8187: Do not wait for an ACK when IEEE80211_TX_CTL_NO_ACK is set
Date: Thu, 27 Nov 2008 15:43:56 -0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
References: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com>
In-Reply-To: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200811271543.59126.herton@mandriva.com.br> (sfid-20081127_184352_432385_E63407C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Quarta 26 Novembro 2008, =C3=A0s 20:31:03, Stefanik G=C3=A1bor escre=
veu:
> (Patch also available as an attachment in case Gmail decides to linew=
rap
> it.)
>
> Currently we always wait for an ACK even if IEEE80211_TX_CTL_NO_ACK i=
s set.
> This is just the opposite of what other drivers do.

nack.

I've seen other drivers set just a flag when hardware has a bit field t=
o
signalize that there isn't need to ack the tx packet to be sent, but
don't saw anyone changing retry in tx hw header. Also setting to 0 in
no_ack case looks wrong, for example see ath5k where it even checks for
0 and returns an error if you try to do this.

> Change both RTL8187L and RTL8187B to skip waiting for an ACK when no
> ACK was requested.
>
> Signed-off-by: G=C3=A1bor Stefanik <netrolller.3d@gmail.com>
> ---
>  drivers/net/wireless/rtl818x/rtl8187_dev.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> index 9fd23b5..7f12d9f 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -230,7 +230,10 @@ static int rtl8187_tx(struct ieee80211_hw *dev,
> struct sk_buff *skb)
>  		hdr->flags =3D cpu_to_le32(flags);
>  		hdr->len =3D 0;
>  		hdr->rts_duration =3D rts_dur;
> -		hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
> +		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
> +			hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
> +		else
> +			hdr->retry =3D 0;
>  		buf =3D hdr;
>
>  		ep =3D 2;
> @@ -248,7 +251,10 @@ static int rtl8187_tx(struct ieee80211_hw *dev,
> struct sk_buff *skb)
>  		memset(hdr, 0, sizeof(*hdr));
>  		hdr->flags =3D cpu_to_le32(flags);
>  		hdr->rts_duration =3D rts_dur;
> -		hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
> +		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
> +			hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
> +		else
> +			hdr->retry =3D 0;
>  		hdr->tx_duration =3D
>  			ieee80211_generic_frame_duration(dev, priv->vif,
>  							 skb->len, txrate);

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
