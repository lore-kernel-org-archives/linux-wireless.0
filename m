Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:40694 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbbANIb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 03:31:27 -0500
Received: by mail-la0-f41.google.com with SMTP id hv19so6858131lab.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 00:31:26 -0800 (PST)
Message-ID: <1421224274.2012.2.camel@gmail.com> (sfid-20150114_093134_357949_241203B4)
Subject: [REGRESSION] iwlfiwi with Intel Centrino N1000 won't work with
 power_save
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Wysocki, Rafael" <rafael@kernel.org>,
	Alex Nik <rage.iz.me@gmail.com>
Date: Wed, 14 Jan 2015 11:31:14 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-xgx9/UWtC7LqQyOAEWfc"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xgx9/UWtC7LqQyOAEWfc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I got report from people that on Intel Centrino N1000 wifi won't work=20
after
updating to 3.17.8. I see in that release Fedora maints enabled=20
POWERCAP and
INTEL RAPL. We got working wifi only after disabling powersave via `iw=20
dev wlp2s0 set power_save off`.

How we can debug this?

lspci above.

02:00.0 Network controller [0280]: Intel Corporation Centrino Wireless-
N 1000 [Condor Peak] [8086:0084]
        Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN=20
[8086:1315]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 28
        Region 0: Memory at d1500000 (64-bit, non-prefetchable)=20
[size=3D8K]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-
,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [d0] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee0800c  Data: 4122
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s=20
<512ns, L1 unlimited
                ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-=20
Unsupported-
                RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
                MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-=20
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,=20
Exit Latency L0s <128ns, L1 <32us
                ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-=20
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-=20
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-=20
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-=20
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-=20
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-=20
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn-=20
ChkCap- ChkEn-
        Capabilities: [140 v1] Device Serial Number 74-e5-0b-ff-ff-cc-
82-24
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi
--
-Igor Gnatenko
--=-xgx9/UWtC7LqQyOAEWfc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJUtilZAAoJEGmy9zExMnyPSroIAIUkQxua+p36iEyO/t9Qqhhy
1SFfLstUw+8GzzbxzTeLqLh3Kdl9pGYQsSD4MnN7RqHCpZAsZFvYSh+j3dG568Ee
i4nSplmmXot1xyDDFvEuBYhZGAkNPG46KLSot9I2pLsITVGMtK3oJqtEWqDGMABV
A/45UiOJar/5wBWmARXvQ/Ro1DM7HnJStvfzMQdd2VoVxOds4zNagR/YCZ+RREXA
Sz5PlahIrhFncSflBJO2tRD9G8d6K+TBF0+o7geR0mjD1IyEHPVmP5BIDPisaEFj
q5MAtA67brJX+14gUQsdwf2be0fVleoH6Hbr9I/JYEZxgVYm2tbmFZy1zgstuKs=
=ScnQ
-----END PGP SIGNATURE-----

--=-xgx9/UWtC7LqQyOAEWfc--

