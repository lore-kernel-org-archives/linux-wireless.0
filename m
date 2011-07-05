Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:39767 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab1GEMtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 08:49:15 -0400
Date: Tue, 5 Jul 2011 08:49:14 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless
 3.0-rc4-1
Message-ID: <20110705124914.GC26882@alittletooquiet.net> (sfid-20110705_144933_820915_2E67AED7)
References: <20110701133553.GA7125@alittletooquiet.net>
 <BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com>
 <BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
 <20110701173237.GC7125@alittletooquiet.net>
 <20110704052410.GA1364@vmraj-lnx.users.atheros.com>
 <20110704095341.GA1380@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
In-Reply-To: <20110704095341.GA1380@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rajkumar,

Thanks for your reply.

On Mon, Jul 04, 2011 at 03:23:42PM +0530, Rajkumar Manoharan wrote:
> On Mon, Jul 04, 2011 at 10:54:11AM +0530, Rajkumar Manoharan wrote:
> > On Fri, Jul 01, 2011 at 01:32:37PM -0400, Forest Bond wrote:
> > > Hi shafi,
> > >=20
> > > [Sorry for the duplicate, lost the Cc's the first time around.]
> > >=20
> > > On Fri, Jul 01, 2011 at 07:39:40PM +0530, Mohammed Shafi wrote:
> > > > On Fri, Jul 1, 2011 at 7:31 PM, Mohammed Shafi <shafi.wireless@gmai=
l.com> wrote:
> > > > > On Fri, Jul 1, 2011 at 7:05 PM, Forest Bond <forest@alittletooqui=
et.net> wrote:
> > > > >> Now the module loads fine and appears to load the firmware corre=
ctly, but the
> > > > >> interface never comes up. =A0Here's what happens when I insert t=
he device:
> > > > >>
> > > > >> [ =A0206.657723] Compat-wireless backport release: compat-wirele=
ss-v3.0-rc4-1
> > > > >> [ =A0206.657732] Backport based on linux-2.6-allstable.git v3.0-=
rc4
> > > > >> [ =A0206.864667] Calling CRDA to update world regulatory domain
> > > > >> [ =A0207.714633] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw=
, size: 51288
> > > > >> [ =A0207.861037] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized w=
ith 33 credits
> > > > >>
> > > > >> At this point the interface is not visible in the output of ifco=
nfig. =A0Something
> > > > >> has gone wrong with USB, because lsusb hangs until I unplug the =
device, at which
> > > > >> point I see the following in dmesg:
> > > > >>
> > > > >> [ =A0225.464212] usb 5-7: USB disconnect, address 5
> > > > >> [ =A0225.592282] ath: Reading Magic # failed
> > > > >> [ =A0225.592310] ath: no band has been marked as supported in EE=
PROM
> > > > >> [ =A0225.592315] ath: Unable to initialize hardware; initializat=
ion status: -22
> > > > >> [ =A0225.592321] ath: Unable to initialize hardware; initializat=
ion status: -22
> > > > >> [ =A0225.592336] Failed to initialize the device
> > > > >> [ =A0225.592400] ath9k_htc: probe of 5-7:1.0 failed with error -=
22
> > > > >> [ =A0225.712249] usbcore: registered new interface driver ath9k_=
htc
> > > > >
> > > > > something wrong in reading EEPROM, please post the kernel log for
> > > > > sudo modprobe ath9k_htc debug debug=3D0x404
> > > >=20
> > > > please do
> > > > sudo modprobe ath9k_htc debug=3D0xffffffff
> > > > this will give lots of information
> > >=20
> > > [   98.421395] Compat-wireless backport release: compat-wireless-v3.0=
-rc4-1
> > > [   98.421405] Backport based on linux-2.6-allstable.git v3.0-rc4
> > > [   98.638709] Calling CRDA to update world regulatory domain
> > > [   99.219353] usbcore: registered new interface driver ath9k_htc
> > > [  103.829197] usb 5-7: new high speed USB device using ehci_hcd and =
address 5
> > > [  103.985215] usb 5-7: configuration #1 chosen from 1 choice
> > > [  104.288053] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size:=
 51288
> > > [  104.448323] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 =
credits
> > > [  104.453395] ath: UNDEFINED -> AWAKE
> > > [  104.454654] ath: serialize_regmode is 0
> > > [  104.686218] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CM=
DID
> > > [  104.686240] ath: REGISTER WRITE FAILED, multi len: 9
> > > [  104.901237] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > > [  104.901259] ath: REGISTER READ FAILED: (0x9c00, -110)
> > > [  104.901276] ath: Reading from EEPROM, not flash
> > > [  105.911084] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > Please share your PID/VID.

0cf3:9271

> And also for compat-wireless-v3.0-rc4-1, FW version should be 1.3 and fw =
size
> should be 51272. But in your case size is 51288 which is 1.2. Please upgr=
ade fw
> to 1.3 and test again.
>=20
> http://wireless.kernel.org/download/htc_fw/1.3/htc_9271.fw

Okay.  I had tried both versions previously; neither seems to work any bett=
er
than the other.  Here is dmesg using firmware version 1.3:

[  102.984766] Compat-wireless backport release: compat-wireless-v3.0-rc4-1
[  102.984775] Backport based on linux-2.6-allstable.git v3.0-rc4
[  103.213468] Calling CRDA to update world regulatory domain
[  103.798281] usbcore: registered new interface driver ath9k_htc
[  108.482070] usb 5-7: new high speed USB device using ehci_hcd and addres=
s 5
[  108.643105] usb 5-7: configuration #1 chosen from 1 choice
[  108.996663] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
[  109.135499] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 credits
[  109.140526] ath: UNDEFINED -> AWAKE
[  109.141769] ath: serialize_regmode is 0
[  109.383151] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  109.383168] ath: REGISTER WRITE FAILED, multi len: 9
[  109.609805] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  109.609822] ath: REGISTER READ FAILED: (0x9c00, -110)
[  109.609835] ath: Reading from EEPROM, not flash
[  109.824058] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  109.824079] ath: Multiple REGISTER READ FAILED (count: 8)
[  110.042132] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  110.042148] ath: Multiple REGISTER READ FAILED (count: 8)
[  110.260786] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  110.260802] ath: Multiple REGISTER READ FAILED (count: 8)
[  110.482613] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  110.482629] ath: Multiple REGISTER READ FAILED (count: 8)
[  110.719736] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  110.719753] ath: Multiple REGISTER READ FAILED (count: 8)
[  110.953628] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  110.953645] ath: Multiple REGISTER READ FAILED (count: 8)
[  111.195035] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  111.195057] ath: Multiple REGISTER READ FAILED (count: 8)
[  111.432953] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  111.432975] ath: Multiple REGISTER READ FAILED (count: 8)
[  111.668211] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  111.668227] ath: Multiple REGISTER READ FAILED (count: 8)
[  111.903626] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  111.903642] ath: Multiple REGISTER READ FAILED (count: 8)
[  112.135695] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  112.135711] ath: Multiple REGISTER READ FAILED (count: 8)
[  112.370919] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  112.370936] ath: Multiple REGISTER READ FAILED (count: 8)
[  112.603491] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  112.603508] ath: Multiple REGISTER READ FAILED (count: 8)
[  112.841972] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  112.841988] ath: Multiple REGISTER READ FAILED (count: 8)
[  113.065412] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  113.065428] ath: Multiple REGISTER READ FAILED (count: 8)
[  113.300441] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  113.300458] ath: Multiple REGISTER READ FAILED (count: 8)
[  113.536889] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  113.536906] ath: Multiple REGISTER READ FAILED (count: 8)
[  113.774809] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  113.774826] ath: Multiple REGISTER READ FAILED (count: 8)
[  114.012001] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  114.012018] ath: Multiple REGISTER READ FAILED (count: 8)
[  114.245297] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  114.245314] ath: Multiple REGISTER READ FAILED (count: 8)
[  114.476929] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  114.476946] ath: Multiple REGISTER READ FAILED (count: 8)
[  114.753310] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  114.753327] ath: Multiple REGISTER READ FAILED (count: 8)
[  114.966595] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  114.966611] ath: Multiple REGISTER READ FAILED (count: 8)
[  115.193618] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  115.193634] ath: Multiple REGISTER READ FAILED (count: 4)
[  115.462402] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  115.462419] ath: REGISTER READ FAILED: (0x2000, -110)
[  115.685667] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  115.685684] ath: REGISTER READ FAILED: (0x407c, -110)
[  115.918681] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  115.918703] ath: REGISTER READ FAILED: (0x407c, -110)
[  116.152756] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  116.152773] ath: REGISTER READ FAILED: (0x407c, -110)
[  116.391881] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  116.391898] ath: REGISTER READ FAILED: (0x407c, -110)
[  116.629244] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  116.629265] ath: REGISTER READ FAILED: (0x407c, -110)
[  116.860197] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  116.860214] ath: REGISTER READ FAILED: (0x407c, -110)
[  117.094108] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  117.094124] ath: REGISTER READ FAILED: (0x407c, -110)
[  117.325535] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  117.325551] ath: REGISTER READ FAILED: (0x407c, -110)
[  117.578615] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  117.578632] ath: REGISTER READ FAILED: (0x407c, -110)
[  117.819951] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  117.819968] ath: REGISTER READ FAILED: (0x407c, -110)
[  118.055933] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  118.055950] ath: REGISTER READ FAILED: (0x407c, -110)
[  118.329876] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  118.329893] ath: REGISTER READ FAILED: (0x407c, -110)
[  118.563992] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  118.564009] ath: REGISTER READ FAILED: (0x407c, -110)
[  118.803279] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  118.803296] ath: REGISTER READ FAILED: (0x407c, -110)
[  119.045193] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  119.045209] ath: REGISTER READ FAILED: (0x407c, -110)
[  119.294820] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  119.294832] ath: REGISTER READ FAILED: (0x407c, -110)
[  119.536403] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  119.536421] ath: REGISTER READ FAILED: (0x407c, -110)
[  119.764358] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  119.764375] ath: REGISTER READ FAILED: (0x407c, -110)
[  120.002647] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  120.002664] ath: REGISTER READ FAILED: (0x407c, -110)
[  120.223089] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  120.223107] ath: REGISTER READ FAILED: (0x407c, -110)
[  120.450418] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  120.450435] ath: REGISTER READ FAILED: (0x407c, -110)
[  120.701625] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  120.701638] ath: REGISTER READ FAILED: (0x407c, -110)

I appreciate your help on this.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4TCEoACgkQRO4fQQdv5AzU1QCfTLes04IZ3F9Zrdo+WdMQ6Kg8
bV8AoI0CgOsrqwPnSxGA/NMPZFAXmsbP
=0xqn
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
