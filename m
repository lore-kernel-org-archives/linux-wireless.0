Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50785 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYGWQ1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:27:44 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <48874F09.7060400@lwfinger.net>
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br> <4886AA3B.3000406@lwfinger.net>
		 <4886C50E.6040304@lwfinger.net> <1216824917.13587.9.camel@johannes.berg>
	  <48874F09.7060400@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5ct1DYzt4NHbAtsY17ip"
Date: Wed, 23 Jul 2008 18:27:29 +0200
Message-Id: <1216830449.13587.17.camel@johannes.berg> (sfid-20080723_182747_176435_40FD1D4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5ct1DYzt4NHbAtsY17ip
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-23 at 10:32 -0500, Larry Finger wrote:

> I tried something like that, but it didn't work. Maybe you can see what i=
s wrong=20
> here:
>=20
>=20
> Index: wireless-testing/drivers/net/wireless/rtl8187.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/rtl8187.h
> +++ wireless-testing/drivers/net/wireless/rtl8187.h
> @@ -100,6 +100,7 @@ struct rtl8187_priv {
>   	struct usb_device *udev;
>   	u32 rx_conf;
>   	u16 txpwr_base;
> +	u16 seqno;
>   	u8 asic_rev;
>   	u8 is_rtl8187b;
>   	enum {
> Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
> @@ -169,6 +169,7 @@ static int rtl8187_tx(struct ieee80211_h
>   {
>   	struct rtl8187_priv *priv =3D dev->priv;
>   	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> +	struct ieee80211_hdr *ieee80211hdr =3D (struct ieee80211_hdr *)skb->dat=
a;
>   	unsigned int ep;
>   	void *buf;
>   	struct urb *urb;
> @@ -198,6 +199,14 @@ static int rtl8187_tx(struct ieee80211_h
>   		flags |=3D ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
>   	}
>=20
> +	/* XXX: This sequence is an attempt to match what happens in r2x00. */
> +	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> +		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> +			priv->seqno +=3D 0x10;
> +		ieee80211hdr->seq_ctrl &=3D cpu_to_le16(IEEE80211_SCTL_FRAG);
> +		ieee80211hdr->seq_ctrl |=3D cpu_to_le16(priv->seqno);
> +	}
> +
>   	if (!priv->is_rtl8187b) {
>   		struct rtl8187_tx_hdr *hdr =3D
>   			(struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));

Odd, that looks like it should work. Can you try printing the seqno and
see if it does increase? Or maybe I messed up something with the
flags...

johannes

--=-5ct1DYzt4NHbAtsY17ip
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIh1vuAAoJEKVg1VMiehFY9R8QAKw99ZjttDwAISkS8iQIdMvo
I/s3NM+DKafj03Kuk3+9FJcNJhtyfeW5q4LE5oU6Yvy7GsWfSpAdLSllz+Jcddij
XoRW19uX9ssixnD0Q+J+DCbS/7n1fo1XtMElAAqOSOEQd4RTAvUPzA/SfhBWqxlk
Cy5igl3dW/IL9c80QJvhst/VgoJkFanlD1KENbwdnd1ZB3BmxyencORLkOeiXird
OYcC16FEubkd1laWJzYY1PMkoEDq1Q8sO5nrJzN60z3wE10XExBaHf+m+S5RkqNj
ioRvEUapKKXzmzlvI3H0zXjDMP7kOeKOMEYcF0iqRGAegFah9h1V+/7wK2+glqOi
ZgbjIRX300CXhcDBT3npKhwFiqgfa0VMdNgmx47VsPh6SGLSCReBbYdMhdnsBHH/
5Hf7+hUPHPYqQ5TfgnwUMA2q0geTeC8sm7EDjfjqjqqNNQHACW8NL2zz6VRQ7wWO
ir7XCjpCRLlkJiobFF3zhSMk92by9wb19+iYgKfVjz5xJOOd8SpPTPia41csPmS+
0d7+JhWTtl/ROIc2TTQqsYe5eKQNyuY4Lra9b/Gtg7UdABv5+90unb1KWB9qKkdo
Tl3cwVMrLFHjvWnJbOuJq3tMDR9xx90XiyCR8EUDlFEWud8ZAVGsk2VRrfNddW39
ZskLZQ24DtNwSHnnOX5f
=6Pm+
-----END PGP SIGNATURE-----

--=-5ct1DYzt4NHbAtsY17ip--

