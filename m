Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53828 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1BQMO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 07:14:27 -0500
Received: by qyk12 with SMTP id 12so2603190qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 04:14:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297894657.32237.2.camel@maggie>
References: <AANLkTimKE+WqChVf0XpeHsfHxT8=3vbnBh=Lo+1tLSwj@mail.gmail.com>
	<1297894657.32237.2.camel@maggie>
Date: Thu, 17 Feb 2011 13:14:21 +0100
Message-ID: <AANLkTi=sVaeizU3xJQQwwKXB5saPgdn9VxNQv0-aoiV7@mail.gmail.com>
Subject: Re: [RFC] How to rename SSB_TMSLOW_*, B43_TMSLOW_*?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: multipart/mixed; boundary=0016363b7e3ea3e5bb049c795615
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016363b7e3ea3e5bb049c795615
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

W dniu 16 lutego 2011 23:17 u=C5=BCytkownik Michael B=C3=BCsch <mb@bu3sch.d=
e> napisa=C5=82:
> On Wed, 2011-02-16 at 14:13 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>> Except for following 3 defines:
>> #define =C2=A0SSB_TMSLOW_RESET =C2=A0 =C2=A0 0x00000001 /* Reset */
>> #define =C2=A0SSB_TMSLOW_REJECT_22 0x00000002 /* Reject (Backplane rev 2=
.2) */
>> #define =C2=A0SSB_TMSLOW_REJECT_23 0x00000004 /* Reject (Backplane rev 2=
.3) */
>>
>> All our SSB_TMSLOW_* and B43_TMSLOW_* defines are some core control
>> bits. As we now know, core control bits are not SSB specific or TMSLOW
>> specific.
>>
>> Should we (and how) define that names in this situation?
>>
>> For b43 I propose (quite obvious?) B43_CORE_CTL_*.
>>
>> However what about SSB_TMSLOW_*? George proposed SSB_CORECTL_*, but it
>> contains "SSB", while that bits are not SSB specific. Same bits are
>> used on AI bus. Should we use some SSBAI_CORE_CTL_* then? Any other
>> ideas? Some better maybe?
>>
>> P.S.
>> Personally I prefer CORE_CTL over CORECTL (George). Which one should we =
use?
>
> Let's simply put those bits into the drivers and call them
> DRIVERNAME_TMSLOW_FOOBAR

That's what we already have...
B43_TMSLOW_GMODE
B43_TMSLOW_PLLREFSEL
B43_TMSLOW_MACPHYCLKEN
B43_TMSLOW_PHYRESET
B43_TMSLOW_PHYCLKEN
And it's fine for now, but not if we want to have AI support in b43.
See my next comment.


> The "TMSLOW" part seems rather important to me, because that makes it
> obvious what register these bits belong to. Note that's there's also
> TMSHIGH. It also follows current naming convention.

I skip TMSHIGH for now, to simplify discussion.

Your proposal is fine as long as we use that flags for TMSLOW only.
But we may need to use that for AI boards in future, which does not
contain TMSLOW. So that way we would finish with something so ugly:

#define B43_SSB_TMSLOW_GMODE			0x20000000	/* G Mode Enable */
#define B43_SSB_TMSLOW_PHY_BANDWIDTH		0x00C00000	/* PHY band width and
clock speed mask (N-PHY only) */
#define  B43_SSB_TMSLOW_PHY_BANDWIDTH_10MHZ	0x00000000	/* 10 MHz
bandwidth, 40 MHz PHY */
#define  B43_SSB_TMSLOW_PHY_BANDWIDTH_20MHZ	0x00400000	/* 20 MHz
bandwidth, 80 MHz PHY */
#define  B43_SSB_TMSLOW_PHY_BANDWIDTH_40MHZ	0x00800000	/* 40 MHz
bandwidth, 160 MHz PHY */
#define B43_SSB_TMSLOW_PLLREFSEL		0x00200000	/* PLL Frequency
Reference Select (rev >=3D 5) */
#define B43_SSB_TMSLOW_MACPHYCLKEN		0x00100000	/* MAC PHY Clock
Control Enable (rev >=3D 5) */
#define B43_SSB_TMSLOW_PHYRESET			0x00080000	/* PHY Reset */
#define B43_SSB_TMSLOW_PHYCLKEN			0x00040000	/* PHY Clock Enable */

#define B43_AI_REGNAME_GMODE			0x2000	/* G Mode Enable */
#define B43_AI_REGNAME_BANDWIDTH		0x00C0	/* PHY band width and clock
speed mask (N-PHY only) */
#define  B43_AI_REGNAME_BANDWIDTH_10MHZ		0x0000	/* 10 MHz bandwidth,
40 MHz PHY */
#define  B43_AI_REGNAME_BANDWIDTH_20MHZ		0x0040	/* 20 MHz bandwidth,
80 MHz PHY */
#define  B43_AI_REGNAME_BANDWIDTH_40MHZ		0x0080	/* 40 MHz bandwidth,
160 MHz PHY */
#define B43_AI_REGNAME_PLLREFSEL		0x0020	/* PLL Frequency Reference
Select (rev >=3D 5) */
#define B43_AI_REGNAME_MACPHYCLKEN		0x0010	/* MAC PHY Clock Control
Enable (rev >=3D 5) */
#define B43_AI_REGNAME_RESET			0x0008	/* PHY Reset */
#define B43_AI_REGNAME_CLKEN			0x0004	/* PHY Clock Enable */

if (boardtype =3D=3D SSB) {
	flags |=3D B43_SSB_TMSLOW_PHYCLKEN;
	flags |=3D B43_SSB_TMSLOW_PHYRESET;
	if (dev->phy.type =3D=3D B43_PHYTYPE_N)
		flags |=3D B43_SSB_TMSLOW_PHY_BANDWIDTH_20MHZ; /* Make 20 MHz def */
} else if (boardtype =3D=3D AI) {
	flags |=3D B43_AI_REGNAME_PHYCLKEN;
	flags |=3D B43_AI_REGNAME_PHYRESET;
	if (dev->phy.type =3D=3D B43_PHYTYPE_N)
		flags |=3D B43_AI_REGNAME_PHY_BANDWIDTH_20MHZ; /* Make 20 MHz def */
}

That's why I wanted to introduce some SSBAI_CORECTL_FOOBAR and make
b43 unaware it that flags are going to be written in register A or B.
I wanted b43 to just pass flags to correct function and do not care
about place where they are getting written.

--=20
Rafa=C5=82

--0016363b7e3ea3e5bb049c795615
Content-Type: text/plain; charset=US-ASCII; name="ugly.code.txt"
Content-Disposition: attachment; filename="ugly.code.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk9mtsha0

I2RlZmluZSBCNDNfU1NCX1RNU0xPV19HTU9ERQkJCTB4MjAwMDAwMDAJLyogRyBNb2RlIEVuYWJs
ZSAqLwojZGVmaW5lIEI0M19TU0JfVE1TTE9XX1BIWV9CQU5EV0lEVEgJCTB4MDBDMDAwMDAJLyog
UEhZIGJhbmQgd2lkdGggYW5kIGNsb2NrIHNwZWVkIG1hc2sgKE4tUEhZIG9ubHkpICovCiNkZWZp
bmUgIEI0M19TU0JfVE1TTE9XX1BIWV9CQU5EV0lEVEhfMTBNSFoJMHgwMDAwMDAwMAkvKiAxMCBN
SHogYmFuZHdpZHRoLCA0MCBNSHogUEhZICovCiNkZWZpbmUgIEI0M19TU0JfVE1TTE9XX1BIWV9C
QU5EV0lEVEhfMjBNSFoJMHgwMDQwMDAwMAkvKiAyMCBNSHogYmFuZHdpZHRoLCA4MCBNSHogUEhZ
ICovCiNkZWZpbmUgIEI0M19TU0JfVE1TTE9XX1BIWV9CQU5EV0lEVEhfNDBNSFoJMHgwMDgwMDAw
MAkvKiA0MCBNSHogYmFuZHdpZHRoLCAxNjAgTUh6IFBIWSAqLwojZGVmaW5lIEI0M19TU0JfVE1T
TE9XX1BMTFJFRlNFTAkJMHgwMDIwMDAwMAkvKiBQTEwgRnJlcXVlbmN5IFJlZmVyZW5jZSBTZWxl
Y3QgKHJldiA+PSA1KSAqLwojZGVmaW5lIEI0M19TU0JfVE1TTE9XX01BQ1BIWUNMS0VOCQkweDAw
MTAwMDAwCS8qIE1BQyBQSFkgQ2xvY2sgQ29udHJvbCBFbmFibGUgKHJldiA+PSA1KSAqLwojZGVm
aW5lIEI0M19TU0JfVE1TTE9XX1BIWVJFU0VUCQkJMHgwMDA4MDAwMAkvKiBQSFkgUmVzZXQgKi8K
I2RlZmluZSBCNDNfU1NCX1RNU0xPV19QSFlDTEtFTgkJCTB4MDAwNDAwMDAJLyogUEhZIENsb2Nr
IEVuYWJsZSAqLwoKI2RlZmluZSBCNDNfQUlfUkVHTkFNRV9HTU9ERQkJCTB4MjAwMAkvKiBHIE1v
ZGUgRW5hYmxlICovCiNkZWZpbmUgQjQzX0FJX1JFR05BTUVfQkFORFdJRFRICQkweDAwQzAJLyog
UEhZIGJhbmQgd2lkdGggYW5kIGNsb2NrIHNwZWVkIG1hc2sgKE4tUEhZIG9ubHkpICovCiNkZWZp
bmUgIEI0M19BSV9SRUdOQU1FX0JBTkRXSURUSF8xME1IWgkJMHgwMDAwCS8qIDEwIE1IeiBiYW5k
d2lkdGgsIDQwIE1IeiBQSFkgKi8KI2RlZmluZSAgQjQzX0FJX1JFR05BTUVfQkFORFdJRFRIXzIw
TUhaCQkweDAwNDAJLyogMjAgTUh6IGJhbmR3aWR0aCwgODAgTUh6IFBIWSAqLwojZGVmaW5lICBC
NDNfQUlfUkVHTkFNRV9CQU5EV0lEVEhfNDBNSFoJCTB4MDA4MAkvKiA0MCBNSHogYmFuZHdpZHRo
LCAxNjAgTUh6IFBIWSAqLwojZGVmaW5lIEI0M19BSV9SRUdOQU1FX1BMTFJFRlNFTAkJMHgwMDIw
CS8qIFBMTCBGcmVxdWVuY3kgUmVmZXJlbmNlIFNlbGVjdCAocmV2ID49IDUpICovCiNkZWZpbmUg
QjQzX0FJX1JFR05BTUVfTUFDUEhZQ0xLRU4JCTB4MDAxMAkvKiBNQUMgUEhZIENsb2NrIENvbnRy
b2wgRW5hYmxlIChyZXYgPj0gNSkgKi8KI2RlZmluZSBCNDNfQUlfUkVHTkFNRV9SRVNFVAkJCTB4
MDAwOAkvKiBQSFkgUmVzZXQgKi8KI2RlZmluZSBCNDNfQUlfUkVHTkFNRV9DTEtFTgkJCTB4MDAw
NAkvKiBQSFkgQ2xvY2sgRW5hYmxlICovCgppZiAoYm9hcmR0eXBlID09IFNTQikgewoJZmxhZ3Mg
fD0gQjQzX1NTQl9UTVNMT1dfUEhZQ0xLRU47CglmbGFncyB8PSBCNDNfU1NCX1RNU0xPV19QSFlS
RVNFVDsKCWlmIChkZXYtPnBoeS50eXBlID09IEI0M19QSFlUWVBFX04pCgkJZmxhZ3MgfD0gQjQz
X1NTQl9UTVNMT1dfUEhZX0JBTkRXSURUSF8yME1IWjsgLyogTWFrZSAyMCBNSHogZGVmICovCn0g
ZWxzZSBpZiAoYm9hcmR0eXBlID09IEFJKSB7CglmbGFncyB8PSBCNDNfQUlfUkVHTkFNRV9QSFlD
TEtFTjsKCWZsYWdzIHw9IEI0M19BSV9SRUdOQU1FX1BIWVJFU0VUOwoJaWYgKGRldi0+cGh5LnR5
cGUgPT0gQjQzX1BIWVRZUEVfTikKCQlmbGFncyB8PSBCNDNfQUlfUkVHTkFNRV9QSFlfQkFORFdJ
RFRIXzIwTUhaOyAvKiBNYWtlIDIwIE1IeiBkZWYgKi8KfQo=
--0016363b7e3ea3e5bb049c795615--
