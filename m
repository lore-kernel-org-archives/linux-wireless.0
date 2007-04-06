Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32171 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767643AbXDFN2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 09:28:47 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Add radiotap support
Date: Fri, 6 Apr 2007 09:26:16 -0400
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Andy Green <andy@warmcat.com>
References: <200704060048.51524.flamingice@sourmilk.net> <1175847074.3489.56.camel@johannes.berg>
In-Reply-To: <1175847074.3489.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3253188.lQSRxGvsCa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704060926.21863.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3253188.lQSRxGvsCa
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 06 April 2007 04:11, Johannes Berg wrote:
> On Fri, 2007-04-06 at 00:48 -0400, Michael Wu wrote:
> > @@ -3756,6 +3802,12 @@ void __ieee80211_rx(struct ieee80211_hw *hw,
> > struct sk_buff *skb, struct ieee80211_txrx_data rx;
> >  	u16 type;
> >  	int multicast;
> > +	int radiotap_len =3D 0;
> > +
> > +	if (status->flag & RX_FLAG_RADIOTAP) {
> > +		radiotap_len =3D ieee80211_get_radiotap_len(skb);
> > +		skb_pull(skb, radiotap_len);
> > +	}
> >
> >  	hdr =3D (struct ieee80211_hdr *) skb->data;
> >  	memset(&rx, 0, sizeof(rx));
> > @@ -3792,6 +3844,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, stru=
ct
> > sk_buff *skb, goto end;
> >  	skb =3D rx.skb;
> >
> > +	skb_push(skb, radiotap_len);
>
> I don't like this trick. It's so non-obvious. And inbetween, the only
> thing we ever use is skb->data (once, to get hdr assigned) and skb->len
> (which we could also load into a local variable.
>
This is actually being done to avoid modifying rx_pre_handlers.

> > @@ -3800,7 +3853,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, stru=
ct
> > sk_buff *skb, } else {
> >  		struct ieee80211_sub_if_data *prev =3D NULL;
> >  		struct sk_buff *skb_new;
> > -		u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len);
> > +		u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len - radiotap_len);
>
> and here you still need to do the subtraction. If you had the local
> variable, then you could just write frame_len or something.
>
But calling the rx_pre_handlers still requires the skb_pull and skb_push so=
=20
this is the only point where we need to calculate the frame length ourselve=
s.

=2DMichael Wu

--nextPart3253188.lQSRxGvsCa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGFkp9T3Oqt9AH4aERApojAJ0etdSI/h6rfbLj5jWXAFSAD/lJ8QCeIw6y
8cfXrhjW1xYzcNBb+qkTxj4=
=D4cb
-----END PGP SIGNATURE-----

--nextPart3253188.lQSRxGvsCa--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
