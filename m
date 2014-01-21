Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24355 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031AbaAUK3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 05:29:39 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: "'Andreas Fenkart'" <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 21 Jan 2014 02:29:32 -0800
Subject: RE: mwifiex wowlan not working
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF59510D9F010FC@SC-VEXCH1.marvell.com> (sfid-20140121_112942_957004_DA2E5AD2)
References: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com>
 <CALtMJEBuMfTi=nqjC_T8GcJCkfM3M1Q1g6PMH2k+7=XOFkdabA@mail.gmail.com>
In-Reply-To: <CALtMJEBuMfTi=nqjC_T8GcJCkfM3M1Q1g6PMH2k+7=XOFkdabA@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_5FF020A1CFFEEC49BD1E09530C4FF59510D9F010FCSCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_5FF020A1CFFEEC49BD1E09530C4FF59510D9F010FCSCVEXCH1marve_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi Andreas,

>=20
> One thing I noticed, these triggers don't work unless you also
> enable a trigger with iw. Any ideas why I need to setup wowlan
> via both tools iw and ethtool even if only want ethtool functions?
>=20

"ethwool wol" configuration should work independently. This command just co=
nfigures sleep condition (adapter->hs_cfg.conditions) which is used later w=
hen system suspends.

Can you please enable dynamic debug and collect logs with attached change?
1. CONFIG_DYNAMIC_DEBUG=3Dy in kernel .config and rebuild the kernel
2. Load the driver.
3. echo "module mwifiex +p" > /sys/kernel/debug/dynamic_debug/control
4. echo "module mwifiex_usb +p" > /sys/kernel/debug/dynamic_debug/control
5. save the logs in dmesg after the test.

> e.g.
>=20
> <fresh booted system, wifi connected>
> ethttool -s wlan0 wol u
> echo mem > /sys/power/state
>=20
> -> no wakeup on ping request, I see ICMP packets with tcpdump
>=20
> iw phy0 wowlan enable patterns de:ad:be:ef
> ethttool -s wlan0 wol u
> echo mem > /sys/power/state
>=20
> -> wakeup on ping request works
>=20

I think, ethtool command is not taking an effect. Device waked up due to "i=
w wowlan" configuration.

Thanks,
Amitkumar Karwar

--_002_5FF020A1CFFEEC49BD1E09530C4FF59510D9F010FCSCVEXCH1marve_
Content-Type: application/octet-stream; name="ethtool_dbg.diff"
Content-Description: ethtool_dbg.diff
Content-Disposition: attachment; filename="ethtool_dbg.diff"; size=773;
	creation-date="Tue, 21 Jan 2014 04:10:17 GMT";
	modification-date="Tue, 21 Jan 2014 04:10:17 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2V0aHRvb2wuYyBiL2V0aHRvb2wuYwppbmRleCBiZmIzOTkwLi43ODkyMzZk
IDEwMDY0NAotLS0gYS9ldGh0b29sLmMKKysrIGIvZXRodG9vbC5jCkBAIC0yNSw2ICsyNSw4IEBA
IHN0YXRpYyB2b2lkIG13aWZpZXhfZXRodG9vbF9nZXRfd29sKHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYsCiAJc3RydWN0IG13aWZpZXhfcHJpdmF0ZSAqcHJpdiA9IG13aWZpZXhfbmV0ZGV2X2dldF9w
cml2KGRldik7CiAJdTMyIGNvbmRpdGlvbnMgPSBsZTMyX3RvX2NwdShwcml2LT5hZGFwdGVyLT5o
c19jZmcuY29uZGl0aW9ucyk7CiAKKwlwcl9pbmZvKCJFdGh0b29sIGdldCBoc19jZmcuY29uZGl0
aW9ucz0weCV4XG4iLCBwcml2LT5hZGFwdGVyLT5oc19jZmcuY29uZGl0aW9ucyk7CisKIAl3b2wt
PnN1cHBvcnRlZCA9IFdBS0VfVUNBU1R8V0FLRV9NQ0FTVHxXQUtFX0JDQVNUfFdBS0VfUEhZOwog
CiAJaWYgKGNvbmRpdGlvbnMgPT0gSFNfQ0ZHX0NPTkRfREVGKQpAQCAtNjEsNiArNjMsOCBAQCBz
dGF0aWMgaW50IG13aWZpZXhfZXRodG9vbF9zZXRfd29sKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYs
CiAJCWNvbmRpdGlvbnMgfD0gSFNfQ0ZHX0NPTkRfREVGOwogCXByaXYtPmFkYXB0ZXItPmhzX2Nm
Zy5jb25kaXRpb25zID0gY3B1X3RvX2xlMzIoY29uZGl0aW9ucyk7CiAKKwlwcl9pbmZvKCJFdGh0
b29sIHNldCBoc19jZmcuY29uZGl0aW9ucz0weCV4XG4iLCBwcml2LT5hZGFwdGVyLT5oc19jZmcu
Y29uZGl0aW9ucyk7CisKIAlyZXR1cm4gMDsKIH0KIAo=

--_002_5FF020A1CFFEEC49BD1E09530C4FF59510D9F010FCSCVEXCH1marve_--
