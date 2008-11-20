Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYKTR4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 12:56:19 -0500
Subject: Re: [ipw3945-devel] [PATCH 7/7] iwlwifi: prevent double key removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240811200046y67f18e48ubc8a2f4a586be627@mail.gmail.com> (sfid-20081120_094650_232097_C74A008C)
References: <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-3-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-4-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-5-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-6-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-7-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-8-git-send-email-reinette.chatre@intel.com>
	 <1227164164.17336.18.camel@johannes.berg>
	 <1ba2fa240811200046y67f18e48ubc8a2f4a586be627@mail.gmail.com>
	 (sfid-20081120_094650_232097_C74A008C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GN7csIcZ9yV5o919HpqV"
Date: Thu, 20 Nov 2008 18:56:11 +0100
Message-Id: <1227203771.3766.22.camel@johannes.berg> (sfid-20081120_185622_592642_A632F92D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GN7csIcZ9yV5o919HpqV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-20 at 10:46 +0200, Tomas Winkler wrote:
> On Thu, Nov 20, 2008 at 8:56 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2008-11-19 at 15:32 -0800, Reinette Chatre wrote:
> >
> >
> >> When the key is removed a second time the offset is set to 255 - this =
index
> >> is not valid for the ucode_key_table and corrupts the eeprom pointer (=
which
> >> is 255 bits from ucode_key_table).
> >
> >> +     if (WARN(priv->stations[sta_id].sta.key.key_offset =3D=3D WEP_IN=
VALID_OFFSET,
> >> +              "Removing wrong key %d 0x%x\n", keyconf->keyidx, key_fl=
ags)) {
> >> +             spin_unlock_irqrestore(&priv->sta_lock, flags);
> >> +             return 0;
> >> +     }
> >
> > So, since _this_ patch has been tested to fix the problem, the WARN_ON
> > must be triggering.
>=20
> It fix the immediate problem of crashing the kernel but not the
> problem why the key is removed twice.
> I'm analyzing the log I've got from Carlos to figure this out you can
> have a look as well.
> It should be probably considered as a test patch. The purpose is not
> to hide the bug buy fixing a symptom.
> I suspect there is some problem in mac80211 is that this is happening
> only on suspend/resumes not in regular flow

Hmm. Since we don't have suspend/resume that seems a bit odd. Maybe
because we don't have suspend/resume in mac80211? Maybe you've already
killed all the keys at suspend, but mac80211 doesn't know about that and
removes them after resume when we disassoc?

> > What are you doing to address the actual bug that causes it to trigger?
>=20
> If the flow of double removal of a key is okay from mac80211
> perspective we just catch it internally which is always good otherwise
> we need to fix also mac80211.

Do we really want the WARN() in this patch though? We already know the
information from Carlos's log, so do we need to bother users?

johannes

--=-GN7csIcZ9yV5o919HpqV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJaS3AAoJEKVg1VMiehFYPzIP/jMaIR9uEL1FLC4Cr1V1O3iB
5tzS60JUUV/oCS2UYgDseesCTWTOMOxAsGIqkSWHWbM3fFafRB47ngDahmNlAoh7
10pwJZAb1W3IZPwNeOwpCi/T5Sgh1zk9FBdpZXVej5gRiIQtkqFV2yesVD/PuxTi
gjrmL29EF5iSVzj5/HMWQRQB28v4FweRSw3rbg8ZeRp1HX+bVPYpaXSI7F0LSrdJ
k8O3/DAi4fb2qKal7/RIQtN1zMhbqpCoZmPF3zAaC2ARMQae3mUjIAWIGDoG9P6F
1o+QLlXMTyhPE0JcFWZ/uhk/Qw97MOc8t3B26MdCu0fSf7qclGJU1uQ2K9pozIwz
osGFpQUWy7JcPMvSVKWSDjcT4eJLX7oiWn1QZ3hKsH7TbbKjK4TLRkcXCl2CnH32
Icj/jc7WA4LyxufXh+jULLozEL6J+uFCe/XP9Px6pBfxxqXpFgSQNUc++O1zjm2H
OlQbe9361iWFchx4sq3z4icjMgsaHQ6G6nNiTffcJ381Md0BFUMNahh5HZk83e04
pZjpu+l9oO0x3c8AFdeuhLoMKTs6Wp8JuPo/laFruqB/CLSRXSXdDgWiArMcvNCK
EWIbNiCvt20i3kMwwaGwEBPbk6MeXFpwoByeW40uZ630kp6yc+gHh65qBlDlCHzD
td7HqVicrJn8EJX/NJ6P
=GdQm
-----END PGP SIGNATURE-----

--=-GN7csIcZ9yV5o919HpqV--

