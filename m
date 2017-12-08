Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58712 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753675AbdLHO3S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 09:29:18 -0500
Date: Fri, 8 Dec 2017 15:29:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kalle Valo <kvalo@codeaurora.org>, sgruszka@redhat.com
Cc: kernel list <linux-kernel@vger.kernel.org>,
        johannes.berg@intel.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org
Subject: iwl3945: regression at 4.15-rc1 was Re: 4.15.0-rc1-next-20171201:
 WARNING: .... at net/mac80211/agg-tx.c:315
Message-ID: <20171208142906.GF7793@amd> (sfid-20171208_152954_598799_1E9DA4D3)
References: <20171205102434.GA12780@amd>
 <874lp5jwge.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FeAIMMcddNRN4P4/"
In-Reply-To: <874lp5jwge.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--FeAIMMcddNRN4P4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is quite annoying: repeated
> >
> > [ 4169.591529] ---[ end trace e65d97cf1d20b84d ]---
> > [ 4169.591565] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315
> > ___ieee80211_stop_tx_\
> > ba_session+0x158/0x1f0
> >
> > Hardware is thinkpad x60. Git blame says cfcdbde35 introduced the
> > test.
>=20
> To save time for others, the driver is iwl3945:
>=20
> > [    0.970687] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connec=
tion driver for Linux, in-tree:ds
> > [    0.970690] iwl3945: Copyright(c) 2003-2011 Intel Corporation
> > [    0.970692] iwl3945: hw_scan is disabled
> > [    0.971082] iwl3945 0000:03:00.0: can't disable ASPM; OS doesn't hav=
e ASPM control
> > [    1.026281] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 =
802.11a channels
> > [    1.026287] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link =
3945ABG
> > [    1.027866] ieee80211 phy0: Selected rate control algorithm 'iwl-394=
5-rs'

And same problem is there in 4.15-rc1. It is regression from 4.14.

[  530.816390] WARNING: CPU: 1 PID: 3193 at net/mac80211/agg-tx.c:315
___ieee802
11_stop_tx_ba_session+0x158/0x1f0
[  530.816395] Modules linked in:
[  530.816405] CPU: 1 PID: 3193 Comm: wpa_supplicant Tainted: G
W
4.15.0-rc1+ #447
[  530.816410] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW
(2.19 ) 03/3
1/2011
[  530.816416] task: 17453748 task.stack: 79a41831
[  530.816422] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[  530.816427] EFLAGS: 00010246 CPU: 1
[  530.816433] EAX: 00000000 EBX: f5c19000 ECX: f5eff670 EDX: f5eff040
[  530.816438] ESI: 0000000f EDI: 00000003 EBP: ef32dbb4 ESP: ef32db8c
[  530.816444]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  530.816450] CR0: 80050033 CR2: 091a4008 CR3: 34d412c0 CR4: 000006b0
[  530.816455] Call Trace:
[  530.816463]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[  530.816470]  __sta_info_destroy_part1+0x3d/0x1f0


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--FeAIMMcddNRN4P4/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloqobIACgkQMOfwapXb+vLHwgCgqljnkfvdo7GFFbw8iJlqB0ny
FoUAnjqc4fnytnhfvOMRFY4Eoc1JdLH6
=uI8V
-----END PGP SIGNATURE-----

--FeAIMMcddNRN4P4/--
