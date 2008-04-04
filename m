Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbYDDVjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 17:39:55 -0400
Subject: Re: [PATCH] mac80211: notify mac from low level driver (iwlwifi)
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed salim abbas <mabbaswireless@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>
In-Reply-To: <b3153e950804041435p7233fe3bn23bc017967687e9a@mail.gmail.com> (sfid-20080404_223559_199978_E0FDDF61)
References: <1207264130-25437-1-git-send-email-reinette.chatre@intel.com>
	 <1207264130-25437-2-git-send-email-reinette.chatre@intel.com>
	 <1207320389.19189.30.camel@johannes.berg>
	 <b3153e950804041435p7233fe3bn23bc017967687e9a@mail.gmail.com>
	 (sfid-20080404_223559_199978_E0FDDF61)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9AVwxfb8BzX8Cfw8cmS7"
Date: Fri, 04 Apr 2008 23:39:43 +0200
Message-Id: <1207345183.3625.18.camel@johannes.berg> (sfid-20080404_223957_724284_A3960A58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9AVwxfb8BzX8Cfw8cmS7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-04-04 at 14:35 -0700, mohamed salim abbas wrote:
> On 4/4/08, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > > + * This function must be called by low level driver to inform mac802=
11 of
> > > + * low level driver status change or force mac80211 to re-assoc for =
low
> > > + * level driver internal error that require re-assoc. A good example=
 to use
> > > + * this notification to call mac80211 after suspend/resume, some NIC=
 require
> > > + * re-assoc.
> >
> > I think the suspend/resume text should be dropped since IMHO that
> > requires more work, reprogramming all the hardware crypto keys for
> > example.

> I can remove the suspend/resume text will be that good enough?

Sure. I hope at some point somebody will implement proper suspend/resume
(i.e. when the suspend callback is invoked all interfaces, stations,
keys etc. are removed from the driver) but that's a lot more work. That
you mention suspend/resume though makes me wonder: does iwlwifi store
all that information locally and restore it to the hardware so that it
can actually work with this across suspend/resume? For b43, I at least
need to reset all WEP keys.

Thanks,
johannes

--=-9AVwxfb8BzX8Cfw8cmS7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/agHqVg1VMiehFYAQKXWhAAlpZ/wzj54ocYfdF1sJOx07T1YgYnCOFj
dKbWdiQvh4bZXvQPPZlQwP5Kw117pUSXNVat5TR9arrDrMsZlqelZEWDP7c0kQtK
QgwRS8kgVRdNg/CmizRPWEvfd40fG0Ihxm3E5f482pJ+/Q7wLowJP7O24VGpOr1n
9bodFAa1hE5HNCo4tIJdOZBX/xOrnnQXC7kaFC1+bhAvOcNDUuXRb4A9npkLlPfb
sgABFV0GIxFhrdv6/+n+BHoZh+/pR2MYmD51nSAXvRECXVNAKQbA0a7KXm4X3Ldp
aNY2fCA24umJO0Ky2C4bHvcWpElONYDiWGu6yCOv3duTI54+RHQW04O2zsFzpmah
urQrLZm5xHh+1RRzjk+Fvbpr6ONJ9EVwz/0ZChwthasWEma3lnUjDycQdCIDaT+u
L5F6ieTVOS6pdFp+TMaI6Qqj6eFRbBUoBkavPaZJ2/aD9THnD1hnBO5rMBWq7tkg
iFLNsqsavK4pYOx1wElEANuVQ9SBwONBsVmBKIikYz397hqkX29JfaNWau48CiqE
QNL1UdgioTGecomkImcaFKVtHhCPdaRxc7PK9Y6FG3oYJ9qoUodpdc+Jw9ZK34i6
QfPEYUXeMlxJ/lFqT94Mn1Q+i+8ZRsV80MytDo16PBn4KhWPUCNXaRnmrsnQsJNy
z2CPG2FEGBU=
=Oka0
-----END PGP SIGNATURE-----

--=-9AVwxfb8BzX8Cfw8cmS7--

