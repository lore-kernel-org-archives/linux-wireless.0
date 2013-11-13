Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:58433 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab3KMNsa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 08:48:30 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	wzyboy <wzyboy@wzyboy.org>,
	"ilw\@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
	<CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
	<527A8166.6000701@gmail.com>
	<CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
	<CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
	<CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
	<CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
	<20131111224439.GA30638@google.com>
	<CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com>
	<CALkVjQaXEBpbwu9Qy3+17Eg-nSg-k7iin8G3f1RsTLkCOB-2XQ@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com>
	<CAErSpo5iU15AoSVL9WmLp4gNCiNmt6pFZuTsd-Vui4SCrSc_Hw@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DF0865@HASMSX103.ger.corp.intel.com>
	<CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
	<52828364.6080103@gmail.com>
	<CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301E00262@HASMSX103.ger.corp.intel.com>
Date: Wed, 13 Nov 2013 14:48:12 +0100
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301E00262@HASMSX103.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Wed, 13 Nov 2013 12:13:31 +0000")
Message-ID: <87k3gco1k3.fsf@nemi.mork.no> (sfid-20131113_144835_251297_DECA51B1)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> Ok - so I have now the complete picture.

> This device was designed before PCI-SIG gave an ID to L1 PM Substates,
> so Intel had to use the L1 PM Substate as a Vendor Define whose ID is
> 0xCAFE. Layout is the same as defined now in PCI-SIG (page 21 in
> http://www.pcisig.com/specifications/pciexpress/specifications/ECN_L1_PM_=
Substates_with_CLKREQ_31_May_2013_Rev10a.pdf).
>
> So:
> 150: 03 10 03 10 0b 00 01 00 fe ca 41 01 1f 1e f0 00
> 160: 0f 00 a0 40 f0 00 00 00 00 00 00 00 00 00 00 00
>
> We can see that L1 PM Substate *is* enabled:
> 004h =3D 41 01 1f 1e
> 008h =3D 0f 00 f0 00
> 00Ch =3D a0 40 f0 00

Wow!  That's extremely useful.

But I do have some problems placing the individiual bits right in these
LE registers.  And so have you, I believe...  You are 2 bytes off.
"41 01" is part of the vendor specific header (12 bits length =3D=3D 0x014
and 4 bits version =3D=3D 0x1.

So I made a simple patch for lspci based on your info.  Seems to work
for me:


03:00.0 Network controller [0280]: Intel Corporation Wireless 7260 [8086:08=
b1] (rev 63)
	Subsystem: Intel Corporation Dual Band Wireless-AC 7260 [8086:4070]
	Physical Slot: 1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at f0500000 (64-bit, non-prefetchable) [size=3D8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [d0] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 4152
	Capabilities: [40] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimit=
ed
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <=
4us, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
		DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR+, OBFF Via WAKE#
		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-, LTR-, OBFF Disabl=
ed
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, Equali=
zationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP+ BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 0c-8b-fd-ff-ff-08-09-71
	Capabilities: [14c v1] Latency Tolerance Reporting
		Max snoop latency: 0ns
		Max no snoop latency: 0ns
	Capabilities: [154 v1] Vendor Specific Information: ID=3Dcafe Rev=3D1 Len=
=3D014 L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
			  PortCommonModeRestoreTime=3D30us PortTPowerOnTime=3D60us
	Kernel driver in use: iwlwifi
00: 86 80 b1 08 06 05 10 00 63 00 80 02 10 00 00 00
10: 04 00 50 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 70 40
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0b 01 00 00
40: 10 00 02 00 c0 8e 00 10 10 0c 11 00 11 ec 06 00
50: 42 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 12 08 08 00 05 00 00 00 00 00 00 00
70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 01 d0 23 c8 00 00 00 0d
d0: 05 40 81 00 0c 10 e0 fe 00 00 00 00 52 41 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
100: 01 00 01 14 00 00 00 00 00 00 00 00 31 20 46 00
110: 40 20 00 00 00 20 00 00 00 00 00 00 00 00 00 00
120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
140: 03 00 c1 14 71 09 08 ff ff fd 8b 0c 18 00 41 15
150: 00 00 00 00 0b 00 01 00 fe ca 41 01 1f 1e f0 00
160: 00 00 00 00 28 00 00 00 00 00 00 00 00 00 00 00
170: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
190: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
210: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
220: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
230: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[snipped the remaing 00 bytes]


> I may have messed up things here...
>
> According to System / HW, it is unsafe to disable L1 PM Substate using se=
tpci, even if we disable it from both sides (device and bridge). This kind =
of settings should be done by BIOS only.
> So we have 2 options here (assuming that we can't disable that in BIOS):
> * either we try to disable L1 PM Substate even my colleagues think it is =
not safe
> * either we just disable L1 altogether

How about forcing ASPM even if the BIOS says it's unsupported?  Has that
been tested?


Bj=C3=B8rn


--=-=-=
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: inline;
 filename=0001-lspci-decode-Intel-vendor-specific-L1-PM-Substates.patch
Content-Transfer-Encoding: quoted-printable

>From de4befe40cb12a57a6edc4dd22271fa8a000d8f1 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Bj=3DC3=3DB8rn=3D20Mork?=3D <bjorn@mork.no>
Date: Wed, 13 Nov 2013 14:24:06 +0100
Subject: [PATCH] lspci: decode Intel vendor specific L1 PM Substates
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
---
 ls-ecaps.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/ls-ecaps.c b/ls-ecaps.c
index c6f217e..144bf77 100644
--- a/ls-ecaps.c
+++ b/ls-ecaps.c
@@ -429,10 +429,13 @@ cap_rclink(struct device *d, int where)
     }
 }
=20
+static void cap_l1pm(struct device *d, int where);
+
 static void
 cap_evendor(struct device *d, int where)
 {
   u32 hdr;
+  u16 id;
=20
   printf("Vendor Specific Information: ");
   if (!config_fetch(d, where + PCI_EVNDR_HEADER, 4))
@@ -442,10 +445,17 @@ cap_evendor(struct device *d, int where)
     }
=20
   hdr =3D get_conf_long(d, where + PCI_EVNDR_HEADER);
-  printf("ID=3D%04x Rev=3D%d Len=3D%03x <?>\n",
-    BITS(hdr, 0, 16),
+  id =3D BITS(hdr, 0, 16);
+  printf("ID=3D%04x Rev=3D%d Len=3D%03x ",
+    id,
     BITS(hdr, 16, 4),
     BITS(hdr, 20, 12));
+
+  /* Intel used this vendor specific ID prior to PCI-SIG allocating 0x001e=
 */
+  if (d->dev->vendor_id =3D=3D cpu_to_le16(0x8086) && id =3D=3D cpu_to_le1=
6(0xcafe))
+	  cap_l1pm(d, where + PCI_EVNDR_HEADER);
+  else
+	  printf("<?>\n");
 }
=20
 static void
--=20
1.7.10.4


--=-=-=--
