Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXC2LUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:20:43 -0400
Subject: Re: [PATCH 4/4] mac80211: Monitor mode radiotap-based packet  injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <460B9F8C.3040701@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
	 <20070320104104.837354764@warmcat.com>
	 <1174501733.3944.28.camel@johannes.berg>  <460B9F8C.3040701@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zF96zO+QyjnttjoeVzK+"
Date: Thu, 29 Mar 2007 13:19:36 +0200
Message-Id: <1175167176.8807.53.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zF96zO+QyjnttjoeVzK+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-29 at 12:14 +0100, Andy Green wrote:

> >> +	static const u8 radiotap_entry_sizes[] =3D {
> >> +		8, /* IEEE80211_RADIOTAP_TSFT */
> >> +		1, /* IEEE80211_RADIOTAP_FLAGS */
> > [...]
> >=20
> > I'd prefer C99 style for this.
>=20
> Shocked that stuff from as late as 1999 is allowed.  I normally use //=20
> myself, I was making a special effort.

Oh, dang, that was ambiguous. I was thinking
static const u8 radiotap_entry_sizes[] =3D {
	[IEEE80211_RADIOTAP_TSFT] =3D 8,
	...

> Yes to cover more usage cases setting more things is needed.  The game=20
> seems to be to set the elements of the control struct from the radiotap=20
> header.  For clear discussion here is the list of things that can be set=20
> in control, first the ones we allow control of with this patch
>=20
> 	int tx_rate; /* Transmit rate, given as the hw specific value for the
> 		      * rate (from struct ieee80211_rate) */
> 	u8 power_level;		/* per-packet transmit power level, in dBm */
> 	u8 antenna_sel_tx; 	/* 0 =3D default/diversity, 1 =3D Ant0, 2 =3D Ant1 *=
/
>=20
>=20
> and the ones we might possibly want to fiddle with
>=20
> 	int rts_cts_rate; /* Transmit rate for RTS/CTS frame, given as the hw
> 			   * specific value for the rate (from
> 			   * struct ieee80211_rate) */
> 	u32 flags;			       /* tx control flags defined
> 						* above */
> 	u8 retry_limit;		/* 1 =3D only first attempt, 2 =3D one retry, .. */
> 	s8 key_idx;		/* -1 =3D do not encrypt, >=3D 0 keyidx from
> 				 * hw->set_key() */
> 	u8 icv_len;		/* length of the ICV/MIC field in octets */
> 	u8 iv_len;		/* length of the IV field in octets */
> 	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
> 	u8 queue;		/* hardware queue to use for this frame;
> 				 * 0 =3D highest, hw->queues-1 =3D lowest */
> 	u8 sw_retry_attempt;	/* number of times hw has tried to
> 				 * transmit frame (not incl. hw retries) */
> 	int alt_retry_rate; /* retry rate for the last retries, given as the
> 			     * hw specific value for the rate (from
> 			     * struct ieee80211_rate). To be used to limit
> 			     * packet dropping when probing higher rates, if hw
> 			     * supports multiple retry rates. -1 =3D not used */
>=20
> the flags are these
>=20
> #define IEEE80211_TXCTL_REQ_TX_STATUS	(1<<0)/* request TX status=20
> callback for
> 						* this frame */
> #define IEEE80211_TXCTL_DO_NOT_ENCRYPT	(1<<1) /* send this frame without
> 						* encryption; e.g., for EAPOL
> 						* frames */
> #define IEEE80211_TXCTL_USE_RTS_CTS	(1<<2) /* use RTS-CTS before sending
> 						* frame */
> #define IEEE80211_TXCTL_USE_CTS_PROTECT	(1<<3) /* use CTS protection for =
the
> 						* frame (e.g., for combined
> 						* 802.11g / 802.11b networks) */
> #define IEEE80211_TXCTL_NO_ACK		(1<<4) /* tell the low level not to
> 						* wait for an ack */
> #define IEEE80211_TXCTL_RATE_CTRL_PROBE	(1<<5)
> #define IEEE80211_TXCTL_CLEAR_DST_MASK	(1<<6)
> #define IEEE80211_TXCTL_REQUEUE		(1<<7)
> #define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment=
 of
> 						* the frame */
> #define IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY (1<<9)
>=20
> I guess the method is to work out what is useful to control and to=20
> define a minimal set of new radiotap arg indexes to cover them, and=20
> propose it to the radiotap folks.

Yeah, not really necessary right from the start anyway. It's doable
which is/was my biggest concern.

> The idea here is to synthesize an rx packet later after the tx has=20
> happened, reflecting the tx status back to userspace that way (if he=20
> elects to listen out for them)?

Yeah. Michael Wu says we don't need the magic cookie though.

johannes

--=-zF96zO+QyjnttjoeVzK+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGC6DI/ETPhpq3jKURArMEAKCN5hpi0hDvmgYAno0BUNBMS1chiQCaAsV3
150Jeq4LMvC8DZjZNzsILy0=
=8V7I
-----END PGP SIGNATURE-----

--=-zF96zO+QyjnttjoeVzK+--

