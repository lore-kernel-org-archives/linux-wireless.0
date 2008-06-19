Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbYFSXgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 19:36:17 -0400
Subject: Re: [PATCH 2/3] mac80211: get rid of function pointers in TX path
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213918321.6591.4.camel@brick> (sfid-20080620_013221_708262_A91CCF6B)
References: <20080619232229.202159000@sipsolutions.net>
	 <20080619232434.586735000@sipsolutions.net> <1213918321.6591.4.camel@brick>
	 (sfid-20080620_013221_708262_A91CCF6B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MMNgcnOHXgJAtVKPFlH5"
Date: Fri, 20 Jun 2008 01:35:37 +0200
Message-Id: <1213918537.8967.121.camel@johannes.berg> (sfid-20080620_013620_243873_762058AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MMNgcnOHXgJAtVKPFlH5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 16:32 -0700, Harvey Harrison wrote:
> On Fri, 2008-06-20 at 01:22 +0200, Johannes Berg wrote:
> > +#define CALL_TXH(txh)		\
> > +	res =3D txh(tx);		\
> > +	if (res !=3D TX_CONTINUE)	\
> > +		goto txh_done;
> > +
> > +	CALL_TXH(ieee80211_tx_h_check_assoc)
> > +	CALL_TXH(ieee80211_tx_h_sequence);
> > +	CALL_TXH(ieee80211_tx_h_ps_buf);
> > +	CALL_TXH(ieee80211_tx_h_select_key);
> > +	CALL_TXH(ieee80211_tx_h_michael_mic_add);
> > +	CALL_TXH(ieee80211_tx_h_rate_ctrl);
> > +	CALL_TXH(ieee80211_tx_h_misc);
> > +	CALL_TXH(ieee80211_tx_h_fragment);
> > +	/* handlers after fragment must be aware of tx info fragmentation! */
> > +	CALL_TXH(ieee80211_tx_h_encrypt);
> > +	CALL_TXH(ieee80211_tx_h_calculate_duration);
> > +	CALL_TXH(ieee80211_tx_h_stats);
> > +#undef CALL_TXH
>=20
> Unnecessary ; after each CALL_TXH()...except the first.
>=20
> Same thing for 3/3 on the receive side.

Yeah, that's fair, it's not a function call in any way so it need not
look like one either. I'll resend tomorrow (just in case somebody else
finds something else).

johannes

--=-MMNgcnOHXgJAtVKPFlH5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWu1FAAoJEKVg1VMiehFYDVUP/jmnarvC4gyOBBsWrN4Er4LT
reaZu69DOp8+9ZVKBEnwCsC7kl5TGYY7a8jm+mwY4B97ybcMnn83xodJeTF4JhtE
2xCY0yjhI+wRnVamRW0ibLo3pffZ2zyH8qdZ4OiebMKFztzaCQbdeCgw9CoVlyV7
8Cb7OYI7w5cFHF7D9b2glmx4caSA1SKlvyk3PUIRuNXIxfoEbnDelUneEVBcDhRH
ZMuIso6xAHzZLCTCwe4sk2LdGEPFaEu7ZK/v1bsy4UBzfcLViAD2IS7O5ArDiTEC
8dCoSYOHCNde1N5Vn52K9OWTPz4KL3w2AvzgyNCthIi1CBqIwHB3oKleczNFxkkl
9s9SyJkC0UeEpisd/5doTnLn2DBjUAfvqghjkM95AR+tJ4hMiu9Nl8E5LnEdDuQI
E6dT5JcKWhRk8JTd+p/Kay1bbwbBKVdTxrpi4x+eaF4Y/jaMibn+5pMXebjJIDF1
/kL+bV7Ifk/Mk161HDHy78aX05hH3uFfE0z7uzLtXzxf7pEmCZ1VdIbf0dujFJjQ
NVf4kpydouEEUcO6tZkKhgJps+GuwcmOCSVX26HCRvzNzoqrspwiyAC7YgcjRDJo
2lV8dFQwjayi9D3Z9kISVPYKS2td8rxJEAvYNYZa7u3Vbdpt2WVWGY/ZwxG79OuF
eH6InSQxNPyztp5bRL6v
=a6FJ
-----END PGP SIGNATURE-----

--=-MMNgcnOHXgJAtVKPFlH5--

