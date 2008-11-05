Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbYKEL14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 06:27:56 -0500
Subject: Re: [PATCH 3/7] iwlwifi: fix priv->iw_mode setting when multiple
	vif are configured
From: Johannes Berg <johannes@sipsolutions.net>
To: yi.zhu@intel.com
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20081105000900.GA10671@mail.intel.com>
References: <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
	 <ae8368d03d2885c4942e2f9876dcaa60.squirrel@secure.sipsolutions.net>
	 <20081105000900.GA10671@mail.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qjbVEEa8YciLP7Gqcw1Z"
Date: Wed, 05 Nov 2008 12:27:52 +0100
Message-Id: <1225884472.3619.72.camel@johannes.berg> (sfid-20081105_122800_296784_5B6DF73A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qjbVEEa8YciLP7Gqcw1Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 08:09 +0800, Zhu Yi wrote:
> On Thu, Oct 30, 2008 at 05:18:03PM +0800, Johannes Berg wrote:
> > Reinette Chatre wrote:
> > > From: Zhu, Yi <yi.zhu@intel.com>
> > >
> > > mac80211 supports multiple virtual interfaces for a single device. Fo=
r
> > > example, a managed interface (wlan0) and a monitor interface (mon0) c=
an
> > > exist at the same time. Thus priv->iw_mode is not sufficient to track
> > > the wireless mode any more.
> >=20
> > This example is not correct, mac80211 will only support multiple virtua=
l
> > interfaces when the driver allows this via add_interface (which I don't
> > think yours does) and it will *never* tell you about monitor interfaces=
 at
> > all except by way of configuring the filter differently.
>=20
> We do support add_interface in iwlagn. But it works correctly only if
> the second one is a monitor interface.

But like I said, add_interface is _never_ called with _MONITOR.

> > Therefore, all the "is monitor" checks in iwlwifi are pretty pointless
> > unless you really want to have differing behaviour between "monitor +
> > something" and "just monitor"?
>=20
> In case of BSS + monitor, we need to tell firmware about the
> association status. This differs with pure montior mode.

You can only distinguish those by the filter flags, and should probably
base the firmware knowledge on that. We want to be able to pull up
"plain" monitor interfaces w/o any special flags that show things
exactly as they'd go to mac80211 if the monitor interface was not
present. I suspect you should look at the FIF_OTHER_BSS flag?

johannes

--=-qjbVEEa8YciLP7Gqcw1Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEYM0AAoJEKVg1VMiehFYCysQAK6D/nteArFqpxTZOvObXVIU
Glnw4B23STJoec3XO+cFqzoMOKxpapXqY8IGEZwmlJDOab+4dP/sulr6zV5+84S2
75ptAAH7bowjnC6pqCN1cMnb9m0UrAU796+B25O022+2qQYsghowoWldkMPh9v0A
LTIMTHznJNz6as6N0Ap8qR7+jOv7aTOLa4YUQ7Bby+JR5BYS3NAFNtgCrMNP7QLF
Rp/Hz9QwE+TNt3AoVtkJJZuNf9QvBKVTkmxsYuUCIwxSXjWXRfZKL3dZh5Gjl3hi
zTDgsxcS2OF6Gbk4Rd3HCzFZzqFTfttHhdzmFbaQjxypde+o9ImEDMtfAWcJvVKz
ZIjbSELb2HIudtkALvCy9E/JH9jRroVbj4N5CwdASuL7BX+UvxK3uXBX9S5lOaMU
MYK65GKkIPA06/o9HR23m20QBsMg/BRZ+mVHQ2/8nR5KQ29bmtSFp2jJVzIMd+YI
GoboTGyXlc0q1tt4lwZ1nAacnDnqulYS9NJHxC3j7bSEwWbulfPd5kDlQOfmpCJj
WaypR32cATWtTmwu/nJqePZ8++og/eYcszyVodbpW/g8b8dCtnCcT3+D5cpktiaU
AOZueLUNri2RJ8fJLoe8/O03rdRhFKdDIstYi99uS7vktuBsg/fnJdIYtzoVOJ1a
MEnR+NpyFCh+cHXxhpg6
=5uJz
-----END PGP SIGNATURE-----

--=-qjbVEEa8YciLP7Gqcw1Z--

