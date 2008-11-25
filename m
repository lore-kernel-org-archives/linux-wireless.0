Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.km10614-05.keymachine.de ([87.118.102.170]:54354 "EHLO
	km10614-05.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947AbYKYWZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 17:25:16 -0500
Date: Tue, 25 Nov 2008 23:17:35 +0100
From: Harald Braumann <harry@unheit.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, ipw2100-devel@lists.sourceforge.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [Ipw2100-devel] [PATCH] ipw2200: increase scan timeout
Message-ID: <20081125231735.5c9f7a50@sbs173> (sfid-20081125_232521_037108_FAE8DE51)
In-Reply-To: <200811251809.55461.helmut.schaa@gmail.com>
References: <200811251809.55461.helmut.schaa@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jN55DY0WKCm8M0q6q_3UweJ";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/jN55DY0WKCm8M0q6q_3UweJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Nov 2008 18:09:54 +0100
Helmut Schaa <helmut.schaa@googlemail.com> wrote:

> The current scan timeout is set to 5 seconds. If the timeout is hit
> because the firmware did not respond yet, the adapter gets restarted,
> which results in a disassociation.

Could this be a workaround for my bug as well (disconnects caused by
scan while associated)? I get the following log entries:

I isr_status_change Scan detected while associated, with no scan
request.  Restarting firmware.=20
I schedule_reset wifi0: Scheduling firmware restart (0s).=20
I isr_status_change Status change: IPW_STATE_SCANNING=20
I isr_indicate_scanning Scanning...=20
U ipw2100_reset_adapter : wifi0: Restarting adapter.=20
U ipw2100_power_cycle_adapter Power cycling the hardware.

> However, in an environment with lots of access points the scan
> sometimes takes longer than 5 seconds. This patch simply increases
> the timeout to 10 seconds.

I only have 1 AP, though.

Cheer,
harry

--Sig_/jN55DY0WKCm8M0q6q_3UweJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkseX8ACgkQwMFqDB+mz24HIQCeP9XoncQOLY7eL2A+IIFNPzcc
EkYAoK0rDVTkWMCGZAtun1QpCAmMEnBD
=nmMX
-----END PGP SIGNATURE-----

--Sig_/jN55DY0WKCm8M0q6q_3UweJ--
