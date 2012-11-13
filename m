Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40380 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2KMSFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 13:05:16 -0500
Date: Tue, 13 Nov 2012 19:05:05 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Victor Goldenshtein <victorg@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20121113180505.GB19223@pandem0nium> (sfid-20121113_190522_515177_6DCAB9DD)
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
 <1350226137-13704-2-git-send-email-victorg@ti.com>
 <1350414099.10177.13.camel@jlt4.sipsolutions.net>
 <50842569.5000602@ti.com>
 <1350910543.10166.3.camel@jlt4.sipsolutions.net>
 <50922A9D.2060409@ti.com>
 <1352128887.9466.17.camel@jlt4.sipsolutions.net>
 <50A26163.10300@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
In-Reply-To: <50A26163.10300@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 05:04:03PM +0200, Victor Goldenshtein wrote:
> On 05/11/2012 17:21, Johannes Berg wrote:
> >On Thu, 2012-11-01 at 09:54 +0200, Victor Goldenshtein wrote:
> >>On 22/10/2012 14:55, Johannes Berg wrote:
> >>>>2. In __nl80211_set_channel() - to cover the case when the CAC was
> >>>>initiated on a "preset_chan" (during AP init phase) and the IF was
> >>>>removed before the AP was even started (local->oper_channel wasn't se=
t yet).
> >>>
> >>>Hmm, I'm not sure I get it. How is "local->oper_channel" (a mac80211
> >>>variable) related to this cfg80211 code?
> >>
> >>It's not, just saying that its not set at this point.
> >>
> >>>start_ap() isn't expected to be able to succeed until CAC passed
> >>>successfully, but OTOH the channel isn't configured until then?
> >>
> >>right, the initial CAC performed before start_ap(), only by setting the
> >>channel with __nl80211_set_channel() + radar detection command.
> >
> >Hmm. Maybe then the channel should be passed to the radar detection
> >command instead? That way, it can be passed through, you can allocate a
> >channel context, etc. Much easier?
>=20
> We already pass the frequency in the radar detection command, the
> set channel operation comes during hostapd init flow regardless DFS
> implementation.

Just for clarification for the API: Is the driver required to (re)set the c=
hannel
itself in the radar detection command, or do we expect that the channel was=
 already
set via __nl80211_set_channel() (or other means) before?

This would be important for other DFS modes like IBSS later.

Thanks,
	Simon

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlCii9EACgkQrzg/fFk7axZjewCgweRU0jFTYSth4w3Jh2BwT+Ue
QqYAn3LVXi/cv0ckAOm2g0kSfl4wIvS0
=3UXr
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
