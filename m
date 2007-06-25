Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbXFYIo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 04:44:28 -0400
Subject: Re: [Radiotap] radiotap for TX
From: Johannes Berg <johannes@sipsolutions.net>
To: David Young <dyoung@pobox.com>
Cc: radiotap@ojctech.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <20070621175541.GQ19613@che.ojctech.com>
References: <1182375853.3714.103.camel@johannes.berg>
	 <20070621175541.GQ19613@che.ojctech.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JRbk5TE1C9pJrNLHDG5O"
Date: Mon, 25 Jun 2007 08:39:40 +0200
Message-Id: <1182753581.21939.147.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JRbk5TE1C9pJrNLHDG5O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-21 at 12:55 -0500, David Young wrote:

> >  * IEEE80211_RADIOTAP_SEND_AC		u8		access category
>=20
> The MAC access parameters are an important parameter to control, but
> I think that if the control is self-contained, then people will use it
> in a predictable and consistent way.  As is, you have to interpret the
> access category by reference to the current MAC settings for the AC
> (AIFS, CWmin, CWmax, et cetera), which can change.

Good point. However, not all hardware allows setting these with each
frame, the Broadcom hardware I work with most allows only setting up the
parameters for four access categories and then using them by putting the
frame into different DMA rings.

> I propose that we add a field such as this,
>=20
> 	IEEE80211_RADIOTAP_TX_WMEPARAM	u32	WME access parameters
>=20
> with three 8-bit fields for AIFS, log(CWmin), and log(CWmax), and the
> remaining 8 bits reserved and set to 0.

That makes sense.

> This gives us the flexibility to use more MACs to the extent of their
> capabilities.  IIRC, one Realtek MAC lets us set the access parameters
> packet by packet, instead of category by category or queue by queue.

Oh ok, that'd be perfect for those then.

> Some 802.11 MACs have different transmit priority queues, but the queues'
> access parameters are not adjustable.  For those MACs, we should provide
> for selecting the queue by number:
>=20
> 	IEEE80211_RADIOTAP_TX_QNUM		u8		queue number

That would work, although I think I'd still prefer being able to select
an AC as well because in most cases the queues would be set up according
to the four ACs. However, we can standardise that within the QNUM field
as well.

> I think it's reasonable to say in the _TX_QNUM definition that the queue
> numbers do not necessarily have any relationship to queue priority level
> or access parameters.

Definitely.

> >  *	Indicates which access category to send the frame in, 0-3.
> >  *
> >  * IEEE80211_RADIOTAP_SEND_FLAGS	u8		flags
> ...
> >    IEEE80211_RADIOTAP_SEND_FLAG_SEQNR (1<<3)
> >    /* set if the sequence number in the packet shouldn't be changed,
> >     * if not set then the packet is sequence numbered properly */
>=20
> Let's re-use and augment IEEE80211_RADIOTAP_TX_FLAGS for transmission
> control.  For example, let the bits _F_TX_CTS/_F_TX_RTS indicate "use CTS=
"
> and "use RTS" when we transmit.  But see below.  Also, add _F_TX_SEQNR.

Sounds good to me as well.

> >    IEEE80211_RADIOTAP_SEND_FLAG_ENCRYPT (1<<0)
> >    /* encrypt with key for the station named in addr1 or default key */
>=20
> Let's re-use IEEE80211_RADIOTAP_FLAGS[IEEE80211_RADIOTAP_F_WEP] for this.

Sure

> >    IEEE80211_RADIOTAP_SEND_FLAG_AUTO_RTSCTS (1<<1)
> >    /* automatically decide whether rts/cts are used, if unset then
> >     * rts/cts are used depending on IEEE80211_RADIOTAP_F_TX_{CTS,RTS} *=
/
>=20
> I believe implementors will have an easier time if you invert this:
> NOAUTO or (errr...) MANUAL.

Heh, probably.

> 16-bit fields IEEE80211_RADIOTAP_RTS_THRESHOLD and
> IEEE80211_RADIOTAP_CTS_THRESHOLD may be better: if absent, autoselect.
> If present and equal to 0, always use RTS(CTS).  If present and greater
> than or equal to the maximum packet length, never use RTS(CTS).  We can
> likewise control fragmentation.

Good point. However, in some cases where we may end up wanting to use
this feature, this means querying the kernel for the current
fragmentation threshold only to send it back into the kernel in the
radiotap header. That's perfectly acceptable of course.

> >    IEEE80211_RADIOTAP_SEND_FLAG_RATE_CONTROL (1<<2)
> >    /* should rate control be applied to this algorithm? if not, take
> >     * the value of IEEE80211_RADIOTAP_RATE or lowest rate */
>=20
> Control this by the presence of the _RATE parameter.  If _RATE is absent,
> let the driver or NIC autoselect.

Yeah, good enough.

Thanks for your comments! Do you want me to send a patch against the
authoritative version of the radiotap header?

johannes

--=-JRbk5TE1C9pJrNLHDG5O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGf2Ms/ETPhpq3jKURAsYNAKCVCQGgMeGFPKZbAyuUJlNnfHLIXQCffF+t
79OpbTJONUPTytrraWyDdsw=
=G5fZ
-----END PGP SIGNATURE-----

--=-JRbk5TE1C9pJrNLHDG5O--

