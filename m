Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51727 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbcDFPRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 11:17:48 -0400
Date: Wed, 6 Apr 2016 17:17:24 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160406171724.2b7b070b@wiggum> (sfid-20160406_171751_836877_A6B5C469)
In-Reply-To: <20160406133151.GA4976@localhost>
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
 <20160405194015.GC15353@localhost>
 <20160405214945.1214e13b@wiggum>
 <20160406133151.GA4976@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/0ALe0+3.7Zgklwdn0Cb3tFS"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/0ALe0+3.7Zgklwdn0Cb3tFS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Apr 2016 08:31:51 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> Even for interrupts, it's only a 90% solution because we do still get
> a few interrupts before the quirk runs.  There may not be enough to
> trigger the "IRQ nobody cared" check,

If no driver requested the shared interrupt yet, it should be disabled
in the interrupt controller. So the interrupts do not reach the CPU.
The interrupt storm (on the CPU) starts as soon as some driver
that shares the interrupt with b43 requests and thus enables the
interrupt. And that always happens after the PCI fixup. Thus this is
safe.

--=20
Michael

--Sig_/0ALe0+3.7Zgklwdn0Cb3tFS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXBSiEAAoJEPUyvh2QjYsODOYP/0OBtiN2bBd3I9EUofJ7zL0l
uAxQOreDCAfUPqmEN+mf2QPQrbVmrC/TxoZh2l2Qex8jj2UysIpiSJusKDZpcICx
n574mSHsik9peQScntG3zfhaHmkWizXkm2jGjRn2nUq33v4+RYaP1gS3mT3GPlnl
RUwZRoCCJH99GmuLkkKQKFFSxUCsfeKYDx+ScnUgUo16kaeGfIrhpsYuYh0RzI13
LAuh+rbKje5lPtqMI4f7ANEaU/It0os1PKzXA4QTkh5Zob5vRj22bbJw5KhKmCiq
EN52RIWufV7xHG+usECE6L79zHdXrpl/AQiziGxZqDNJ2hIac7vl28ac50Hu1VWm
/lsOcBPn80lIrXRNkd4dqZN1qbaGfpP06XQNkU55OCUwP9YJFkb5QWIuaKcOQjKL
5eeIrOc5NO++9OxBG174siHFEvcU1/igW1hZveRj17OuIPm+ig+GPWRIALC7Ih6f
ltHrytdDojviJ353qpHg4c8PUMnHrzwZ2T0zi/7HGW01XegH0gesDwtH/iQ5HBts
YQ29wY56bY7cQA4GHlg6OyYEWh8WoIUfBalG1PRWdJ1TDEBE2GKMGRdFHvqbCxtc
pYbUwvl8dv0jm5ky+vlsRyb0sThKxBcRuwbsZ1mFSlNe/RoVDrxskNYGrnT1XRB1
z31HsfQ4VC0pN2V5/Z7r
=Bcpp
-----END PGP SIGNATURE-----

--Sig_/0ALe0+3.7Zgklwdn0Cb3tFS--
