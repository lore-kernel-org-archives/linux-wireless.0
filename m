Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZAGP4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 10:56:21 -0500
Subject: Re: [RFC v2] mac80211: extend/document powersave API
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <878wpn5d64.fsf@nokia.com>
References: <1231264395.3654.10.camel@johannes>
	 <1231273502.3767.4.camel@johannes>  <878wpn5d64.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BE+d3jZ/cLtPjK5MB7zt"
Date: Wed, 07 Jan 2009 16:56:43 +0100
Message-Id: <1231343803.3545.50.camel@johannes> (sfid-20090107_165625_889727_3BF64EB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BE+d3jZ/cLtPjK5MB7zt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 17:49 +0200, Kalle Valo wrote:

> > + * First, it can support hardware that handles all powersaving by
> > + * itself, such hardware should simply set the %IEEE80211_HW_SUPPORTS_=
PS
> > + * hardware flag. In that case, it will be told about the desired
> > + * powersave mode regardless of association status, and the driver or
> > + * hardware must take care of enabling/disabling powersave depending o=
n
> > + * the association status and TIM bit and send nullfunc frames by
> > + itself.
>=20
> Actually I'm not aware of any hardware designs which enables and
> disables power save according to association status (modulo fullmac
> design, of course). Even iwlwifi, which I think has the most
> sophisticated power save support, requires the host to enable power
> save according to the association status. Hence I would like to have
> the power save enable/disable logic based on association status in
> mac80211.

Yeah, good point. But iwlwifi is confusing me ;) Since iwlwifi is the
only user, I'll clean that up along with cleaning up iwlwifi, would you
mind leaving it as-is, and I'll fix it in the short term?

> We already have this support in ieee80211_set_associated()=20
>=20
> [Reads the function again]=20
>=20
> Or, actually we had it. I think Vivek's patch changed the
> functionality. But anyway, it's very easy to add the support back.
>=20
> The reason why I would like to have this in mac80211 is to avoid
> having duplicate bugs in different drivers and make the driver
> implementation easier.

Makes sense.

> > + * Additionally, such hardware may set the %IEEE80211_HW_SUPPORTS_DYNA=
MIC_PS
> > + * flag to indicate that it can support dynamic PS mode (see below).
> > + *
> > + * Other hardware designs cannot send nullfunc frames by themselves an=
d
> > + * need to be told explicitly about powersave transitions depending on
> > + * association status, need software support for parsing the TIM bitma=
p
> > + * and can implement dynamic PS mode in software. This is also support=
ed
> > + * by mac80211 by combining the %IEEE80211_HW_SUPPORTS_PS and
> > + * %IEEE80211_HW_PS_NULLFUNC_STACK flags.
>=20
> stlc45xx (and p54spi) wakeup for multicast frames automatically, but
> ath5/9k need the host to do it. I think we will need a separate flag
> for that, but I can add it later.

Good point, we need to add that later.

> > @@ -858,8 +861,17 @@ static int ieee80211_ioctl_siwpower(stru
> >  	if (wrq->flags & ~(IW_POWER_MODE | IW_POWER_TIMEOUT))
> >  		return -EINVAL;
> > =20
> > -	if (wrq->flags & IW_POWER_TIMEOUT)
> > +	if (wrq->flags & IW_POWER_TIMEOUT) {
> > +		/*
> > +		 * dynamic PS only supported if nullfunc handling in stack
> > +		 * or hardware supports dynamic PS itself
> > +		 */
> > +		if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS) &&
> > +		    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
> > +			return -EOPNOTSUPP;
> > +
> >  		timeout =3D wrq->value / 1000;
> > +	}
>=20
> Actually there are hardware designs which don't have dynamic power
> save but have null frame creation in firmware (and hence don't need
> IEEE80211_HW_PS_NULLFUNC_STACK). So IEEE80211_HW_SUPPORTS_DYNAMIC_PS
> and IEEE80211_HW_PS_NULLFUNC_STACK are not related to each other in
> any way. I suspect at76_usb is such design, but I need to recheck
> that.

But if they don't have dynps but nullfunc in firmware then we can't
support dynamic ps at all, can we?

> So I would like to implement this so that if
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS is not set mac80211 will always use
> it's own timer, independent of IEEE80211_HW_PS_NULLFUNC_STACK. If you
> agree, I can create a separate patch for this.

Oh, I see now, so the firmware just creates the nullfunc whenever you
tell it to? bit strange, I guess.

johannes

--=-BE+d3jZ/cLtPjK5MB7zt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZNC4AAoJEKVg1VMiehFYhKwQALTbrmqHHXIAAt4NVOqoQEUb
1HWLkGLwGE/s5f3Y6+AT1inCv0KLViKuqzu324xFIqbPlh36hgtuHhQ65FZW69VC
Jb7nRmIoFhDxWty7ZD5BunngE/9+pm5MlmfcqyCC+PMYGxSG+N/XqinpPb3UWLU4
lrR5LQDRAgxqWm9g+7bcRlKsNk+I3Y9C/oLgBWbM5AhhIbZJNlRZLqZNW8ZBe334
nNnCDzutPDKgV3IWzNGUH8UD8K1SuHI8QRExcMM3v48LT78kkBc81GkUPSEkgEbo
R20hijCnwVtwA5pAduKae3t3MxwpF7CANhODsDa/ewBtNe1NXbixbG1ORmCdYuuY
pgeEGzCnZw3venW0Q5y/h1uLIR2IZRcVMV9HAwoqxbzvYSF1E3jjGC6S8iNndQim
JSvwkKHy5PWZcvnP1ljaiPSICwcAQIQvthIXf0wtdedQOQtIG1hjrZseb4RPCHS5
C/Iy7lbh1OiGfyECfNO0Vcp/lwO+IZA/Ssqm00FTorcZtCoDYzom6BXBOhqAaYvJ
1z7SMmauUgkgoeCtsarbPGffsIRDGT6eKaH4P/JZ1yYInX/h+iG3GUGyA9gQwiH7
KScRbhTnG2HbDwpPmsY8YvzZXknrcbxATIZP17iScMqHA5bRa1zqt8yhULfUYJvG
M53VH1j9dsozOMffdA+f
=yK4r
-----END PGP SIGNATURE-----

--=-BE+d3jZ/cLtPjK5MB7zt--

