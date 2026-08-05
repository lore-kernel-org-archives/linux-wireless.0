Received: from MM0P280CU010.outbound.protection.outlook.com (mail-swedensouthazolkn19012049.outbound.protection.outlook.com [52.103.34.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD643BBFA4
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 09:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.34.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785923267; cv=fail; b=WL/t3WWnDn3LkSqnDb6cQjv5vV9lVwwSTx3GkLTJU4fseOj0e8oIkmb5RFq/IRV/w5J6ZB35GDJWUjmTP2/34351Ku73RMl8bDwnddQwkGPbvmOa8g+0qgDhzgn/e6T5DoNoOliVyh9dGIHWzlqblrPgizUppdw5DQxGH6QHgqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785923267; c=relaxed/simple;
	bh=3tTcDKicXoNF70KxOafZRNon3785WKDWElhEv7tdO2g=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GhxyqeztNHpbMekgf7uZnFjINGWysX0rxUDwCbLk8ZZ+Vscsw2K0KlCg8feiCtN7mqDkzfrAOOg9rdZnyTx86CIhJ65Ol0hD++15vBIqN+ZevTuhELwWcP49XRBJP7LBhnwAs4NlDYEmVltpzIfcPTQuTUzcoqOx/cO4MJdjk48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Xll63+3d; arc=fail smtp.client-ip=52.103.34.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Xll63+3d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UOCrbWFwNb0ST5CD9N29ZUmrhFnifOG8TNzOKoVpm0O2lL5vf5fKw0TdK7qHb4wnZDq8FvUkVmvjBujDgrErGga51V4bK2cue1ubodwb8zIvWMF87vtf/tpUwMydkyEz4IqRFnFaYxO1/tMGzzcOK4YmizZIBv4BiPeCBKRme6Mk8Zi7mnp00gArqJ1xJt6ZATjQ+tJClvCK1d4LYGJn3m91J6Ay1L8Cmz+VWakfRbV7S36A2K/nUZIB1iFxT0InP2T1v6jvaWZ5KuPuyW3MXx328Ha9fSptuYLBp0th/K3kbtGv6GjSIZSCniT8YHmAAm+nHAihYCZcaC03LXRz9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNDzieRYzgImzk2JfcOwrAjPcwdFLt36ZEhK6B5bS78=;
 b=ZC+u/B4HJg5L4bYr1K4OOygaaGRKmb9cvF2AkU7Rbtz0PdgYq37YuF0JieSkiyYpep65JklCO7fsMKKvaH+l+wtOgROuP2O50ddXeuQs6V/v541YEqUvfd8gFakQ9YcS4hoPnE8ldzibXKXhjfHE/wlF7liKa8Q14hyO4/RQFWFN5mMnELgRBCO/ta02GKVw10nRaM53YuFZFz5wkMFVO4XqH0NTiumVf2lxq3ROiDilJDeYPmsoAg56zSuvODfSndhLFaE5gvPyMi9EavAyrw+P+g8jMaHSr7qJ0jvwRg6d6e97Sz6WbTtTZ1vTiHtNWHn0lbX/XhTE4WMVeaHt1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNDzieRYzgImzk2JfcOwrAjPcwdFLt36ZEhK6B5bS78=;
 b=Xll63+3djkNKF6S5IMZ2VTe0P1H62mXz3l2PrsO35clVIvwZAGTH/rbyvcDEPpaoMzH4ctrEWW5EI0AIgGzL3hwF6r+Geuy5+dP3BVX5AX3AFgyBeGlySP33unwSW01NCDXyveCWqL2vNZNJLNmjA7jBhoLaumKcP51T3u3OEbA5fVypkpxeeKWkd+yCe4myumig8DC5uJKQU1UIcIZNSyNAtXXoOePpi/NFfJoJxX71xM1CVy0ADNRQz1Iqnqz+SVtCf1dGolHtawSwGoMLy6M8JaUcVWqL0p38SKvzi4Rc7RndEbN+AfzYfcQZtM3rWYCoFKX/mtLvTRDzV7ZMRA==
Received: from GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:eb::13)
 by GV3P280MB0243.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.19; Wed, 5 Aug 2026 09:47:42 +0000
Received: from GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
 ([fe80::fd2d:3517:f39d:926a]) by GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
 ([fe80::fd2d:3517:f39d:926a%3]) with mapi id 15.21.0292.015; Wed, 5 Aug 2026
 09:47:42 +0000
From: Stephen C Goodman <Stephen.C.Goodman2@outlook.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211@lists.linux.dev" <brcm80211@lists.linux.dev>,
	"brcm80211-dev-list.pdl@broadcom.com" <brcm80211-dev-list.pdl@broadcom.com>
Subject: Re: brcmfmac: AP+STA on one PHY reassigns STA MAC to AP MAC and
 breaks concurrent operation
Thread-Topic: brcmfmac: AP+STA on one PHY reassigns STA MAC to AP MAC and
 breaks concurrent operation
Thread-Index: AQHdI2zP+JudjhTyVkW3bxnWqHaO77aPNo0F
Date: Wed, 5 Aug 2026 09:47:42 +0000
Message-ID:
 <GVYP280MB10566292972656C67802C7B79DD32@GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM>
References:
 <GVYP280MB1056154BB4A4DE3D4555EA0C9DD52@GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM>
In-Reply-To:
 <GVYP280MB1056154BB4A4DE3D4555EA0C9DD52@GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVYP280MB1056:EE_|GV3P280MB0243:EE_
x-ms-office365-filtering-correlation-id: d1cf54d2-cb88-47e9-70ee-08def2d69817
x-microsoft-antispam:
 BCL:0;ARA:14566002|19101099003|12121999013|6012599012|31061999003|8062599012|8060799015|19110799012|41001999006|15030799006|15080799012|51005399006|25010399006|40105399003|2607281247196008|102099032|3412199025|440099028|19061999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?eSHMD7HlB0Q5haoFwHuJZWs9MPOmcrHbdpuSeAfQGeA2dNZkqffrNBIb0k?=
 =?iso-8859-1?Q?ZrzLwjUK/o70TTfRNmlcQCwom7CTd1RCAYFknF1lk28N1JoZOMcp1cm8df?=
 =?iso-8859-1?Q?9AQCY2RDOCzmYsQu/JKnP0r4UydB2T/JDH8m1NKDVaV9YwjfycwKb06ha3?=
 =?iso-8859-1?Q?g2JfaRM/s05t1rq6rQZheCISVw1CAGoFm+nPGyF6j50ijHKRKRdnUgUBR3?=
 =?iso-8859-1?Q?3c2Dg9qfES0DjxKF4uw8DJApzM6Y8ioZyVrgLkF7kSC6M0ll75rNhZfbuY?=
 =?iso-8859-1?Q?v7s9nBaxj50RPFuc3+ReR5uppAw7pnGNXQ3kOEMhRFjKUPXgOc3ARIzSqt?=
 =?iso-8859-1?Q?SaWN7lra8LCuOAW9CVEuP1qkwUlhxQXzplo62iLWf7qmuq8QCu7l5n3REX?=
 =?iso-8859-1?Q?ru4ErPqtvBAx/KmC2X6kBmUP4fMKdrPOoKoB6lvgDMl7hbA8dCaukXhHCu?=
 =?iso-8859-1?Q?uTYnWTJc8VM4ps0ki+RuOEIdxcflKQEafKT/0iOD9Y05VzbVkr+MUJFMtU?=
 =?iso-8859-1?Q?zJGaSTdOELWwRgVEeWsbjKkl8GFTjBL/WH4uufm0gB5rylBzF6lf99KSNh?=
 =?iso-8859-1?Q?KSl+12c8Poueh6oom9zjy7zQCmKFjbaB7QC/hzryUZUFDe04XIEBTCeLB7?=
 =?iso-8859-1?Q?mDLV9Iey9FCQKMcaqZlvd/5a3owcoWQCtJ2fd3hCMVFOOPgq3l9lI+QCvo?=
 =?iso-8859-1?Q?MA93pS/LedVI1EyEYay309zE6d7BZtFbPiM9tIRqwZRETl1L+ygm1NJvfB?=
 =?iso-8859-1?Q?E5EHm6li6oITZELZk/Xcu0qfSuMrLd2h363MxYq+iLhwh7byuTTK4BSZ+l?=
 =?iso-8859-1?Q?ET/GH9KRVhbxVQ28J4ASWlwTpyIuiK+c+Qq41BgWWaUTLFzTZWARfJNYQD?=
 =?iso-8859-1?Q?jsG51Qe8gWii4KlUn4bJvnD+rzhQrYf+J5oANKP5TlDso+PYwLaMB+4eWc?=
 =?iso-8859-1?Q?XHnqNQlWkO1SG24GOl2ncgr57ifFw8QI+d4uAk3jILJDUMMEOeYUHyghzi?=
 =?iso-8859-1?Q?BTcTqq4RhJ1ppYEAA9GsrdFExNvBeyItX7K7+jOIKwgCgfvM+J/hxwg81c?=
 =?iso-8859-1?Q?b+xnjiDQ6TUMglN+0KpUxu1mRvTF8gfsybfc/LoxNRQMDgCLJmjfQz6Z7h?=
 =?iso-8859-1?Q?cDStRUqDrkbknIW7a0zgk9J7yUKaA=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?g+MmrEoGAr2Yatsq1uR+b8gG14Q0OKbrPOgK/ElYhaFfiI5oYnvlBr7yKi?=
 =?iso-8859-1?Q?/f18dTWf2BCrrmMU/xbvQ6apbxwd21R+mbjsRAO+8V6TOAAd91wGSe0970?=
 =?iso-8859-1?Q?YWz262OCk1XgMIEGhfGeopma63p3DX7f8S5tBGqjDEVeVz6ovcUod2L9x7?=
 =?iso-8859-1?Q?/HXVa4IXG8IgjUP8AM5LulvHWEa8KZuPTOXodo7jG/Tyo/CYswL0jz3f4O?=
 =?iso-8859-1?Q?m21Y8/cqBsN8CnDYfXoTqV1kKNyW2UM2wARgm8d+9R06ACXQEN2hMaSsgb?=
 =?iso-8859-1?Q?7LFCK3+47HegzCKkFyt0PxdULvhHzTtkv3/RMY1Qcfs/69T8GV6EGRxofm?=
 =?iso-8859-1?Q?8Rh6rjCzy+Xoj5/YPZ/uAqurPT2vnJctVqYNVR8RPGltAm4m953WwoqU5F?=
 =?iso-8859-1?Q?xS2a/862U4yiJ+NwmeUSwE3uN4+vOXomXQbCtZRqlMRMxBM/oWbWD+OPdI?=
 =?iso-8859-1?Q?XA/BpE9O+qevtYsvkU7c5PZmdplxVqWsDyYrEybizmNGSNv3EDrg1hPzfx?=
 =?iso-8859-1?Q?554IrsUCf/Iuo7bl8A1Z9aEiEaP+kINuJIotiDjRDexFBew9dPo5cFwrHq?=
 =?iso-8859-1?Q?WL99Q183jHU1+IX50XJdZnE3uF6xSUl1HnoyF5GP9UM29TavBpeZ1o/AHa?=
 =?iso-8859-1?Q?K1ADZy8HvTuVOyRrYe0CaE2y44BMfUCBv1mctQbQPj6zh2hANj2VjhoCiW?=
 =?iso-8859-1?Q?yWqjaOtGXH/ZLOvEkw77FWGDyZWSDDUToZy+gsD3aVaGy9suRvy6DT7hQ6?=
 =?iso-8859-1?Q?7e9bSSop0O/T5Kag3Afs/gJJrHkfoJa75zATM/8NF4rBs34wQdqDVoKxvv?=
 =?iso-8859-1?Q?lyrey4RCS3RVE3eigCzMub+arUwABJrKft+kLrKshA35a7QYlwQ15o2g5h?=
 =?iso-8859-1?Q?c1Q7XxI5vrmlFhIif6IgQENIS6v1LHlGL8hjYD3B9eobjvSBVZVOHUIzb/?=
 =?iso-8859-1?Q?kb+v3n83yiW5xTgcVmZSdAHsZoYGq8xe9eWV0GQL3Jwrr8tUBUbHknFYx7?=
 =?iso-8859-1?Q?z1wXJoYUn69WbrUa+Nq9BG3MbnpYohS+33aZc14NtO1XiKZGbGJy0y8EYz?=
 =?iso-8859-1?Q?NFrcb3jsvI/z8im6iing4QnNRRwTKp/EmtMzr8owNiz1NoWn4RrMs/RXuK?=
 =?iso-8859-1?Q?BCRSgb63/pR4i6uDJCQ9/OcQGoSUZq9egHhgtMoNue+waYJxlLwDAbZRRP?=
 =?iso-8859-1?Q?W9UN/oJBmDGDWA4fEqg9jiSA81DeQd33kvX5PRwRCn/wdzKlOpw1R2ned8?=
 =?iso-8859-1?Q?ryiAnv4ECHrPuNgoTEsM+L6WZ/5VmjFADADXgTjnB/8xkbCfQrY5USh4G4?=
 =?iso-8859-1?Q?1ee883B/avWrgRo+F8Xtm4ahlFw81U3NOAas/vySVIatTSmMdnWlzUOmpU?=
 =?iso-8859-1?Q?p1oppBNMQ1NhrOgas719QbX/oS9kt4Nw/ynx6pWK+yVgVc+gLavunWmV48?=
 =?iso-8859-1?Q?jbPc/qhVBwcnynJ3?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d1cf54d2-cb88-47e9-70ee-08def2d69817
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 09:47:42.1605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV3P280MB0243

I ran additional tests and found results that may help.=0A=
=0A=
## Summary=0A=
=0A=
There appear to be two related failures:=0A=
=0A=
1. A MAC address configured for the station using OpenWrt=0A=
   "option macaddr" is ignored. The station continues using the=0A=
   primary/default address.=0A=
=0A=
2. When the AP and station are enabled concurrently, the station can=0A=
   take the AP interface's MAC address. Both interfaces then have the=0A=
   same address, the AP fails to remain active, and the station either=0A=
   fails to connect or connects only momentarily.=0A=
=0A=
The only method that reliably changes the station MAC is:=0A=
=0A=
ip link set dev phy0-sta0 address <STA_MAC>=0A=
=0A=
This works even without bringing the interface down first.=0A=
=0A=
When I bring both interfaces down, assign different MAC addresses, and=0A=
bring them up again, the addresses shown by Linux become different.=0A=
However, the interfaces then enter a repeated failure cycle: the=0A=
station connects for approximately one second and disconnects, while=0A=
phy0-ap0 appears for approximately one second and disappears again.=0A=
=0A=
## Expected behavior=0A=
=0A=
The MAC address supplied for each interface should either:=0A=
=0A=
1. be applied to that interface, or=0A=
2. be rejected with a clear error if the firmware cannot support it.=0A=
=0A=
A supported one-STA plus one-AP combination should remain operational=0A=
with distinct, valid local-unicast addresses. The driver should not=0A=
silently assign the AP address to the station or repeatedly recreate=0A=
and remove interfaces.=0A=
=0A=
## Reproduction=0A=
=0A=
1. Configure only a station on radio0 and give it an explicit MAC:=0A=
=0A=
config wifi-iface 'sta'=0A=
option device 'radio0'=0A=
option mode 'sta'=0A=
option network 'wwan'=0A=
option ssid '<redacted>'=0A=
option encryption '<redacted>'=0A=
option key '<redacted>'=0A=
option macaddr '<STA_MAC>'=0A=
=0A=
2. Reload Wi-Fi.=0A=
=0A=
3. Check phy0-sta0:=0A=
=0A=
ip link show dev phy0-sta0=0A=
=0A=
The configured STA_MAC is not applied. The station uses the=0A=
primary/default radio address instead.=0A=
=0A=
4. Configure and enable an AP on the same PHY with another address:=0A=
=0A=
config wifi-iface 'ap'=0A=
option device 'radio0'=0A=
option mode 'ap'=0A=
option network 'lan'=0A=
option ssid '<redacted>'=0A=
option encryption '<redacted>'=0A=
option key '<redacted>'=0A=
option macaddr '<AP_MAC>'=0A=
=0A=
The radio is configured so the AP and station can use the same channel;=0A=
automatic channel selection was used during this test.=0A=
=0A=
5. Reload Wi-Fi and check both interfaces:=0A=
=0A=
ip link show dev phy0-sta0=0A=
ip link show dev phy0-ap0=0A=
iw dev=0A=
=0A=
The station takes AP_MAC, so phy0-sta0 and phy0-ap0 can show the same=0A=
MAC address. The AP then fails to remain operational.=0A=
=0A=
If another AP configuration is enabled with a different address, the=0A=
station can instead take that AP's address.=0A=
=0A=
## Manual MAC-address test=0A=
=0A=
The following changes the station MAC successfully:=0A=
=0A=
ip link set dev phy0-sta0 address <STA_MAC>=0A=
=0A=
I also tested forcing both interfaces to restart with distinct=0A=
addresses:=0A=
=0A=
ip link set dev phy0-sta0 down=0A=
ip link set dev phy0-sta0 address <STA_MAC>=0A=
ip link set dev phy0-sta0 up=0A=
=0A=
ip link set dev phy0-ap0 down=0A=
ip link set dev phy0-ap0 address <AP_MAC>=0A=
ip link set dev phy0-ap0 up=0A=
=0A=
Linux then shows two distinct addresses, but AP+STA operation becomes=0A=
unstable and enters a repeated add/remove cycle.=0A=
=0A=
No interface was manually created with "iw phy interface add", and no=0A=
separate manual hostapd instance was used for the log below.=0A=
=0A=
## Relevant log excerpt=0A=
=0A=
br-lan: port 6(phy0-ap0) entered forwarding state=0A=
ieee80211 phy0: brcmf_cfg80211_add_iface: iface validation failed: err=3D-1=
6=0A=
br-lan: port 6(phy0-ap0) entered disabled state=0A=
brcmfmac 0000:01:00.0 phy0-ap0: left allmulticast mode=0A=
brcmfmac 0000:01:00.0 phy0-ap0: left promiscuous mode=0A=
br-lan: port 6(phy0-ap0) entered disabled state=0A=
br-lan: port 6(phy0-ap0) entered blocking state=0A=
br-lan: port 6(phy0-ap0) entered disabled state=0A=
brcmfmac 0000:01:00.0 phy0-ap0: entered allmulticast mode=0A=
brcmfmac 0000:01:00.0 phy0-ap0: entered promiscuous mode=0A=
ieee80211 phy0: brcmf_link_down: WLC_DISASSOC failed (-52)=0A=
br-lan: port 6(phy0-ap0) entered forwarding state=0A=
ieee80211 phy0: brcmf_cfg80211_add_iface: iface validation failed: err=3D-1=
6=0A=
=0A=
This sequence repeats approximately once per second.=0A=
=0A=
## Code-path observations=0A=
=0A=
The observed difference between OpenWrt configuration and "ip link"=0A=
appears consistent with the current brcmfmac code paths.=0A=
=0A=
OpenWrt's wireless scripts place the configured address in the nl80211=0A=
request as "req.mac". When a pre-existing wireless device is reused,=0A=
this request is sent using NL80211_CMD_SET_INTERFACE.=0A=
=0A=
In brcmfmac, brcmf_cfg80211_change_iface() receives:=0A=
=0A=
struct vif_params *params=0A=
=0A=
but does not appear to use params->macaddr.=0A=
=0A=
This could explain why a configured address is ignored when the primary=0A=
or reusable interface becomes phy0-sta0.=0A=
=0A=
There is another asymmetry in brcmf_apsta_add_vif():=0A=
=0A=
* For NL80211_IFTYPE_STATION, params->macaddr is passed to=0A=
  brcmf_cfg80211_request_sta_if().=0A=
* For NL80211_IFTYPE_AP, brcmf_cfg80211_request_ap_if() is called=0A=
  without the requested address, and that function generates an=0A=
  address from the primary interface.=0A=
=0A=
In contrast, "ip link set ... address ..." reaches=0A=
brcmf_netdev_set_mac_address(), which calls=0A=
brcmf_c_set_cur_etheraddr(). That path sends the address to the=0A=
firmware and updates the netdev address after the operation succeeds.=0A=
=0A=
The "-16" message also appears to come from interface-combination=0A=
validation before a new interface-create request is sent to firmware.=0A=
Since a STA+AP combination should be valid, perhaps a previous or stale=0A=
VIF remains counted while userspace retries the operation.=0A=
=0A=
## Possible firmware address restriction=0A=
=0A=
On the same hardware, I separately observed that multiple AP interfaces=0A=
work when their first five MAC-address octets are identical and only=0A=
the last octet differs. Arbitrary unrelated AP addresses do not work=0A=
concurrently.=0A=
=0A=
I intend to report that multi-AP behavior separately. However, it may=0A=
be relevant because brcmfmac also constructs its advertised interface=0A=
address list from a common base address and varies the final octet.=0A=
=0A=
This could indicate a firmware address-mask or address-pool restriction.=0A=
Even if that restriction is required by the firmware, it does not=0A=
appear to explain why a requested station address is silently ignored,=0A=
why the station receives an AP address, or why the failure enters an=0A=
endless retry loop.=0A=
=0A=
## Questions=0A=
=0A=
1. Is ignoring params->macaddr in brcmf_cfg80211_change_iface()=0A=
   intentional?=0A=
=0A=
2. Should the driver call brcmf_c_set_cur_etheraddr() when a MAC is=0A=
   supplied while changing/reusing the primary interface?=0A=
=0A=
3. Should brcmf_cfg80211_request_ap_if() receive and validate=0A=
   params->macaddr instead of always generating the AP address?=0A=
=0A=
4. Does the firmware require concurrent VIF addresses to share a=0A=
   particular prefix or address mask?=0A=
=0A=
5. If such a firmware restriction exists, should brcmfmac expose it=0A=
   through wiphy->addr_mask or reject incompatible addresses before=0A=
   interface creation?=0A=
=0A=
=0A=
Best regards,=0A=
