Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54910 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751299AbYJ1Xfz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 19:35:55 -0400
Date: Wed, 29 Oct 2008 00:35:47 +0100
From: Mirco Tischler <mircotischler@gmx.net>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>,
	Arjan van de Ven <arjan@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W.Linville" <linville@tuxdriver.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
Message-ID: <20081029003547.773745ba@mtlp.12.dimension> (sfid-20081029_003600_099632_515DDD61)
In-Reply-To: <20081028235841.78942d67@mtlp.12.dimension>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	<1225157618.2917.215.camel@debian.sh.intel.com>
	<20081027213217.53558319@infradead.org>
	<1225171414.2917.229.camel@debian.sh.intel.com>
	<20081028172418.3c8e91f1@mtlp.12.dimension>
	<1225218994.3598.41.camel@johannes.berg>
	<20081028235841.78942d67@mtlp.12.dimension>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RLA2icrSvbyrMd=RJhoH=UC";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/RLA2icrSvbyrMd=RJhoH=UC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

In between I found out that suspend and hibernation are broken too. I would
open a new thread but in the "Suspend to RAM regression in 2.6.28-rc2
(bisected)" thread that handled a similar problem iwlwifi was blamed, at le=
ast
in the mails I read. So maybe this is related here too.

The machine suspends and hibernates fine, but doesn't wake up anymore corre=
ctly.
On hibernation I end up with a black screen and only the mouse which I can
still move. But anything else is locked up. I can't switch to virtual conso=
le
with ctrl+alt+f? nor can I restart the xserver. I can't even connect on
network. The only thing I can do is move the mouse on a black screen or push
the power button.

On suspend it is a little better. After wakeup I see the frames of the wind=
ows
but not the content, and the gnome panel. And again I can move the mouse bu=
t I
can't interact with anything. At least I can connect over network using ssh.
But processes like compiz don't respond to kill -9 PID and when I try to ki=
ll
Xorg the machine completely locks up.

Another thing that I just noticed is very slow boot. From startup of udev u=
ntil
short before X starts the boot lasts minutes. What I noticed is that there =
are
long phases of no hard disk activity. And I don't really  have the heart to
write this but I have the impression that keyboard activity (i.e. pressing
random keys) causes the harddisk to read again and the hole boot to go on.

Sorry for this long subjective description of symptoms only without any
kernel messages or anything but that's all I can deliver at the moment. May=
be
tomorrow I find more than only half an hour to dig into this.

Thanks again

Mirco

--Sig_/RLA2icrSvbyrMd=RJhoH=UC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkHodcACgkQz+diZ7c2xfhhYgCfTFHzHbvSfFDBa5Ft3Z0rDKix
kMAAn2A6QNjIFWRZlOgcp28Zj4ZCvKoB
=7sfz
-----END PGP SIGNATURE-----

--Sig_/RLA2icrSvbyrMd=RJhoH=UC--
