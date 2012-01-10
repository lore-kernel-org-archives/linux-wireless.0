Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:39258 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab2AJBTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 20:19:11 -0500
Date: Mon, 9 Jan 2012 23:16:02 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Strange behavior with rtl8192se
Message-ID: <20120110011601.GA2445@nautilus.holoscopio.com> (sfid-20120110_021915_769263_CBAA31F2)
References: <20120108140753.GA2246@nautilus.holoscopio.com>
 <4F09C9B0.7080204@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
In-Reply-To: <4F09C9B0.7080204@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 08, 2012 at 10:52:00AM -0600, Larry Finger wrote:
> On 01/08/2012 08:07 AM, Thadeu Lima de Souza Cascardo wrote:
> >Hello, Larry.
> >
> >I have some problems with rtl819se that I couldn't find out what the
> >reason is. I would like some ideas as to what look after, what debugging
> >I can make or what changes I could try in the driver to fix it.
> >
> >The problem is that, sometimes, the adapter cannot receive probe
> >responses from my AP. Other devices in my network can reconnect to it,
> >so it's not a problem in the AP itself. There are other evidence that
> >point out to a problem with rtl8192se, as I will point out below.
> >
> >So, usually this happens when, for some reason, I can't receive any
> >packages from the network. After that, I try to reconnect, with no
> >success. The problem is that, even after a reboot, I keep trying without
> >no success to associate. I need to shutdown the machine to get the
> >adapter back to work. And that's another evidence that the AP is not to
> >blame. And it also happens with other AP I have around. Below is what I
> >get in dmesg when trying to associate.
> >
> >wlan0: direct probe to 36:d9:98:74:ff:42 (try 1/3)
> >wlan0: direct probe to 36:d9:98:74:ff:42 (try 2/3)
> >wlan0: direct probe to 36:d9:98:74:ff:42 (try 3/3)
> >wlan0: direct probe to 36:d9:98:74:ff:42 timed out
> >wlan0: direct probe to 36:d9:98:74:ff:42 (try 1/3)
> >wlan0: direct probe to 36:d9:98:74:ff:42 (try 2/3)
> >wlan0: direct probe to 36:d9:98:74:ff:42 (try 3/3)
> >wlan0: direct probe to 36:d9:98:74:ff:42 timed out
> >
> >Since a reboot didn't work and a shutdown did fix it, I have tried
> >shutting down only the adapter, putting it into D3_cold state and then
> >back into D0, but that didn't work. That may be a problem with my
> >notebook and its ACPI implementation. What I have managed to do is to
> >hibernate: after a resume from that, it works as if I have shutdown. So,
> >it's really a matter of shutting down the adapter or the system, instead
> >of rebooting.
> >
> >And that tells more: I have also tried to reload the driver and mac80211
> >stack, with no success. And since hibernate works, that is in their
> >favour to some extent. It indicates that's not a problem in a software
> >state. Well, there is the suspend and resume functions, but since
> >suspend didn't work and hibernate uses the same functions, they are not
> >fixing anything, neither breaking it.
> >
> >So, what I suspect is either there is some state in the hardware, like a
> >filter for the BSSID or anything like that, that is not being cleared by
> >the driver, or there is something wrong with the platform, perhaps ACPI
> >is doing something stupid. There is not much reason to suspect the
> >latter, however, since this bug does not require me to switch rfkill off
> >and on or to unplug the notebook from the wall. It just happens if I
> >have to reconnect for any reason.
> >
> >Since the adapter is not receiving probe responses from my AP, I decided
> >to run it on monitor too. And, well, it does not receive the probe
> >responses from my AP, but receives from some APs nearby. If I try to
> >associate with my other AP, however, it fails too. I have put another
> >device in monitor state too and have seen that the AP is sending the
> >responses, so the adapter is really sending the requests (which I also
> >saw in the monitor), but it's just not receivig the responses.
> >
> >Note that this was all done two meters from the AP, so this should not
> >be a matter of distance or power. The other AP, whose responses I see
> >should be further away, since it's not in my apartment.
> >
> >Any clues? I have run these monitor tests using 3.2-rc6. But I have also
> >run into this same problem running 3.2-03023-g02550d6, which is latest
> >rc, containing a merge from the last net-next.
>=20
> There are some changes in compat-wireless that are not in 3.2-git,
> but nothing that would cause this problem comes to mind. What is the
> PCI ID for your device? I have 3 with different stream
> configuration, and I want to test the one you are using.
>=20
> I have not received any other reports of needing to power off to
> restore operation. For me, rtl8192se has become quite stable.
>=20
> It certainly appears that your receiver is in some state that
> requires the power to be shut off. Rebooting without a power off
> should clear any filters, but I doubt that any are being set.
>=20
> The only other piece of info that might be useful would be the
> output of 'sudo lspci -vvv' for the adapter used by the rtl8192se
> when it is working and when it has failed.
>=20
> I am currently building the latest git pull from mainline to see if
> I can duplicate the problem.
>=20
> Larry
>=20

Hi, Larry.

Thanks for the quick reply. I have a 10ec:8171. I don't think you need
to build the latest git pull to try to duplicate the problem. As far as
I remember, this has been hapening since rtl8192se is in mainline, in
v3.0-rc1.

I did try lspci -vvv and the difference I saw was with ASPM. But it
seems ASPM is turned on every time the adapter is idle, which should
happen even while it is working, right?

After the adapter stopped working, I tried reloading the driver with
ips=3D0 (at first, thought this could solve the ASPM problem), with no luck.

What follows is the output of lspci -vvv when the adapter is working,
followed by when it stops working. Note that the only difference is
ASPM.

Thanks for the help.
Cascardo.

--
02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvA Wir=
eless LAN Controller (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RTL8191SEvA Wireless LAN Contro=
ller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at e000 [size=3D256]
	Region 1: Memory at fe500000 (32-bit, non-prefetchable) [size=3D16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns,=
 L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 88-55-22-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192se
--
02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvA Wir=
eless LAN Controller (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RTL8191SEvA Wireless LAN Contro=
ller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at e000 [size=3D256]
	Region 1: Memory at fe500000 (32-bit, non-prefetchable) [size=3D16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns,=
 L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 88-55-22-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192se
--

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPC5FOAAoJEEWxSg7udFZIhmwQAMr19KN2Erv8VmSSbjMLzxF/
Uw0fgnbjoeN5eM1X+JspLjV48TcKPm98M6+0X2pPoOOiE+u5xBwkSKgL9YPEX63L
GHjTPWP9QdlKZ2ZHzrB0WWw/9BX5LPSfE8T4BeUpNuAAg/d18LozA+hqKigIUHYH
ofgbtkhILmShHRsU/wWLYcJmvsc4Vq+ONs2Llz0JqxtINdBb1izeFoewebtKwmvN
ezs5szCqKeTThtHWh8aBqDvDQgZD+y9nBu47NWcBJBVL1hYhJjlcuJ3Y21QwJiNn
AhVQCsX0/Wf6Y06cVUjVJpHAiqoEHSdYIvUgNrGxOBb2kY3nKodZfeXqdivShHWS
bsZNTHA74Crm6WDbakVTVEJe/+bUQ8P9+e+JSVMWmlO/3Vra/3iXGLpWzkPAdnhQ
uELZc2spsvCXQDAg+O+IGGNFmQzpwvvXl/xCnIEZAQxU7N2HM0QixnSBxsspgh/I
e5A0zhov5kuqogs6MQhUClOH2GKq8Q88qx1w9Opg4blg1sHCUnjHGBrnaz52nq1+
5GfgbmFflewQtVmILpGCJdbqPIuklgr/qt1in4Y4ZsA2AUfNuuHmSOxhmy86xV6S
VVM3F31UuMwJiQoWs5lP3m/wMehUvBho20XrqqE6kt767wVeafAn43zyn+iFYtfA
27MRmwT5vsTNrX4TYo9E
=bEZl
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
