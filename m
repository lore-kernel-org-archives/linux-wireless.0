Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60920 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaBSPr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 10:47:56 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so534150pde.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 07:47:56 -0800 (PST)
Date: Wed, 19 Feb 2014 07:47:51 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: Re: [PATCH v3 3/6] cfg80211: Enable GO operation on additional
 channels
Message-ID: <20140219154747.GG14296@garbanzo.do-not-panic.com> (sfid-20140219_164800_667348_091CE29B)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-4-git-send-email-ilan.peer@intel.com>
 <20140218233852.GC14296@garbanzo.do-not-panic.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A0333823B5@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A0333823B5@HASMSX106.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 02:52:13PM +0000, Peer, Ilan wrote:
> > Ilan, also extend the above with language similar to the one I provided=
 on the
> > cellular base station hints if you ended up adding a device feature cap=
ability.
> >=20
>=20
> You mean specify that this option is enabled, drivers can still use
> the device specific flags to disable this?

Yeap! In particular its important to make it clear that
enabling this option isn't enough to get enable this feature,
this option will only be usable on device drivers that have
support for this feature.

> > > +
> > > +		if (!other_chan)
> > > +			continue;
> > > +
> > > +		if (chan =3D=3D other_chan)
> > > +			return true;
> >=20
> > This seems to me to indicate that we have allowed here daisy chaining /=
 trust
> > on another GO who also trusted its AP. That is, we are leaving it up to=
 the
> > kernel for the above few lines of code to check if the STA was associat=
ed to
> > an AP that had DFS support. How do we know the AP the STA was associated
> > to was not another GO that ran through this permissive check? Is the FCC
> > happy with that?
> >=20
>=20
> This verification should be done by user space, i.e., if the station
> is a legacy client associated to a GO, then wpa_supplicant should not
> allow the GO_CONCURRENT relaxation. In addition, a GO instantiated on
> channel based on this relaxation should not allow connection from
> legacy clients ... again this should be enforced by user space. System
> wise this should adhere to the FCC expectations and prevent daisy
> chaining.

Wow this is a hugely important piece of information, please toss it into
the documentation both kconfig and wiki (once accepted upstream). As for
references to userspace you can mention supplicant (wpa_supplicant).

> > Also to be clear, you check for IEEE80211_CHAN_GO_CONCURRENT only on
> > the caller's channel, not the STA's device, is that OK ? Lets
> > consider the case case of two different types of interfaces on the
> > same system. I am aware of at least one 802.11 AP company selling
> > devices with one 802.11 vendor as the AP and another as the STA. I
> > don't consider this rare anymore now, as such please think about
> > this case as well.
>=20
> The property is of the channel so this should suffice. Overall, I
> think that the FCC definition rules are centered on the UNII bands, so
> the rules mandated for a given channel in a specific channel should
> also hold to other channels in the same UNII band. Ultimately, I would
> expect all channels in the same UNII band to share the same settings.

OK.

> The iteration in this case is over all the interfaces of the same
> registered device

This feature seems limited then. Can this be extended to relay on the
information from any other registered device? I suspect folks may soon
enter bug reports for this otherwise. That carefulness here seems to
be an implementation preference, but is it a hard requirement? If not
then please considering revising all registered devices.

  Luis

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTBNIjAAoJEKwtdpJg+MHGIi8P/1uAMXehEGIoD+BxJZCnX88o
xvB9MOm5fjViHyoLqDDoGd2XeGuj2/1Mp1RTagjGRNdKR63+fzPRsjxc2H/r7Ium
QwcZO2Es1yHRGKmaLDUD9QzW3syrGPbCoG+El2ASbRy4nwaxClwZfk4AShMCmZir
We9xD6DBIefXKsP6Dk3HsNarTUYk3eBSSl9clm4fe/9PwE0Ya/XF85cdFpJV9Q3N
B/JOEhWkIxlozvE+vjVxZIJu7aVoIz9Y0biCqNaQ+EjsDbYoGpcr60pUcVEUoTji
kOEjVTq6TLvz6lHY2QvF1efvriHFbRo0ooCBxwZCv4SIU5GoP0GE8Hbe9b6gYaNZ
vWjCHpq2afwaTGeCRV2ok6D9Uq/V2QjciEcAT5e8A/nPeZlWbzVYQ6plDki3cSh2
xCoTLh/GUnU7SfSa+40mmq5QkeZhwGe9mFdAOe91lKryrHsXQEG2vU4FVPhSSOB1
ESO5xwj3gpbsc/h4dVyUxZXwnrRlyXxclhL6L7DeS1xa0sMjgeuxgOW8sVwRck7X
7LP0DBh9rUEvMjXcCWn9r13FJiWzB0uNW6r76I129y4aDeBDtJAeKqIXMlQsOLZ6
Y9YC6pYAaSvcwwNR+aV6e80NdfObXmFdpEdgob5YMOELE8mH2tVl/m3c8E5ZELCq
o+jcxVZ+3/iUICs/90+d
=FE3R
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
