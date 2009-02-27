Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZB0VGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:06:50 -0500
Subject: Re: b43/mac80211: RX rate_idx warning triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200902241514.31289.mb@bu3sch.de>
References: <200902241514.31289.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pjnkJUV7khDJJw1QE5/V"
Date: Fri, 27 Feb 2009 18:19:42 +0100
Message-Id: <1235755182.7426.62.camel@johannes.local> (sfid-20090227_220653_475107_9F0F5152)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pjnkJUV7khDJJw1QE5/V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-24 at 15:14 +0100, Michael Buesch wrote:
> Any idea why this could happen?
>=20
> [ 2860.155778] Badness at net/mac80211/rx.c:2488
> [ 2860.155782] NIP: f2797fdc LR: f2784528 CTR: 00000000
> [ 2860.155787] REGS: eeaf3d60 TRAP: 0700   Not tainted  (2.6.29-rc5-wl-wl=
test)
> [ 2860.155791] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 22000446  XER: 2000000=
0
> [ 2860.155804] TASK =3D eea92d00[2771] 'Xorg' THREAD: eeaf2000
> [ 2860.155807] GPR00: 00000001 eeaf3e10 eea92d00 edde9220 edc1a9c0 eeaf3e=
48 eeaf3e6c 000000ff=20
> [ 2860.155818] GPR08: 00000002 000000ff 00000000 f2a30274 42000442 101f3d=
44 00000000 00000000=20
> [ 2860.155829] GPR16: 0000029e 00000199 00000240 5168a060 00000099 c07d47=
cc 00000000 c09458c0=20
> [ 2860.155839] GPR24: c09458c0 f27ade88 edde93d0 edde9220 eeaf3e48 edde93=
b4 edc1a9c0 edc1a9c0=20
> [ 2860.155909] NIP [f2797fdc] __ieee80211_rx+0x8c/0x690 [mac80211]
> [ 2860.155921] LR [f2784528] ieee80211_tasklet_handler+0x114/0x130 [mac80=
211]
> [ 2860.155925] Call Trace:
> [ 2860.155929] [eeaf3e10] [edde93c0] 0xedde93c0 (unreliable)
> [ 2860.155942] [eeaf3e40] [f2784528] ieee80211_tasklet_handler+0x114/0x13=
0 [mac80211]
> [ 2860.155954] [eeaf3ea0] [c003e85c] tasklet_action+0x80/0x100
> [ 2860.155961] [eeaf3ec0] [c003f240] __do_softirq+0x90/0x128
> [ 2860.155970] [eeaf3f00] [c0006f74] do_softirq+0x58/0x5c
> [ 2860.155975] [eeaf3f10] [c003f118] irq_exit+0x8c/0xb8
> [ 2860.155980] [eeaf3f20] [c0007028] do_IRQ+0xb0/0xec
> [ 2860.155988] [eeaf3f40] [c00171a8] ret_from_except+0x0/0x14
> [ 2860.155992] --- Exception: 501 at 0xff05c40
> [ 2860.155994]     LR =3D 0xf6838e8
> [ 2860.155996] Instruction dump:
> [ 2860.156001] 80050024 70090200 408200c8 81250020 38000001 2f890000 419c=
0018 800b0010=20
> [ 2860.156011] 7f890000 4fdce042 7c000026 5400fffe <0f000000> 2f800000 40=
beff98 55202036=20
>=20
> We have the following code in b43:
>=20
> 604         if (phystat0 & B43_RX_PHYST0_OFDM)
> 605                 status.rate_idx =3D b43_plcp_get_bitrate_idx_ofdm(plc=
p,
> 606                                                 phytype =3D=3D B43_PH=
YTYPE_A);
> 607         else
> 608                 status.rate_idx =3D b43_plcp_get_bitrate_idx_cck(plcp=
);
> 609         if (unlikely(status.rate_idx =3D=3D -1))
> 610                 goto drop;
>=20
> So IMO the only possible way for the WARN_ON to trigger is
> (status->rate_idx >=3D sband->n_bitrates)
>=20
> Why is rate_idx bigger than n_bitrates?

Did you ever see this again? It seems weird, since you never return any
value larger than the max afaict. Some form of corruption? Can you make
that warning should print out the entire skb->cb as a hex dump so we can
tell what's in there, and maybe the header of the 802.11 packet as well.
And please submit the patch, it'll be useful :)

johannes

--=-pjnkJUV7khDJJw1QE5/V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJqCCrAAoJEKVg1VMiehFYKAoP/2lv2Hr+E9EW9Z3/Y2bEYtmD
HQmT+6oNf2Ng9uAjU2M58Vhx7SHk62i+uMnNnvv18dlbtxWOTh3hTKWe6eWlrzNc
fAyoFulSy9RAMG0GD36LX+QQ8GLUSZFNQNNk58bi1omcyvMMMAumFGK5SyNu6rbG
d5dzkRS+F9ePUholNYoMwW80GwhBT4Mz36rWeE1TwpXng7KbUkDh5zXttoQcx0U9
1yRMEDKPFGtFc82sD+97sbxm6BIqkw80jzsvc+cNqbeloLu5LdiegT/Oe5CpGJNM
xu+hOtRjmIxIady5Ov0Fy6rk4LHrFGoWseuqKb6cmDH1nEXdKfnaaIf1alemPvLE
0SpNfTYcSsqZ+Mswa8jpwRJv4sQNQoJjQnBfrXB2huBOd5oLlP3ueD1Hs5vthQaV
ZK9oLQCCobVz81edxRtVOeIJc2Lu8blZjl3PTSbnvpMyDTuzJn844Em8wWAtJO+s
UXnWrV6vQ397eny5fGOLIXhAMcOrcfBDX1pKmpL0Uxy7rshhBM33+p1J9GsFyIG5
WkjzYJ/Z/i3OEJErexGxcrShNMKztrqlz/0Cts1+YINVedDOcqRh1XvcAcofM0sG
8YtGvtVm1XoWwgsc+6hFXf1wSakIxb0JuhP+5tKGiPzRogArk3RkpibPrWEx4+EE
wxTb4E1J47cW9hL7CIZM
=Sypp
-----END PGP SIGNATURE-----

--=-pjnkJUV7khDJJw1QE5/V--

