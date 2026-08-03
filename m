Received: from GVZP280CU018.outbound.protection.outlook.com (mail-swedencentralazolkn19012048.outbound.protection.outlook.com [52.103.35.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A22732A3DA
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.35.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785778187; cv=fail; b=FQ5nWKtiPxMNlR2zyJ3jrByrd5FhyTXzATf1+JbAVV7HLGugXmepg+whZPsyur6XPCncoQEXYwrWrgnCV4myOtsWf9aQGbFuTW3R/XQflusQHNY28UaG5OMH5b0dqDPtqcHhIfuzIDP41tiaMiiW0NWx3OJbYh7ufBO7xB0lrXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785778187; c=relaxed/simple;
	bh=Yzl64Qm41S1vS187IWwoWE0SLgaR+9WZPrWkK6+7sDE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Ia6P0qrchFA3rWMLt1SfZjiUjACvNOoio75mD3tU6MQzJV+qVv1OxzASzXnoOSwLF7/OUh1iyTIFBizHgBPH9+8zTYaVtNoyjFBS9I2ivEInN4/pHnxfIOuptWdvU/FbI8WNbmzO33HfIpw2izXOiBXBTxJdd+LEy0mjmYsrfiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=LgjjFVX/; arc=fail smtp.client-ip=52.103.35.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="LgjjFVX/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sA0chPKY68rNGVKSkGhEIQmDBIEddmKq7OcX21adWAeLfp1+jhKLFQKUH5rEIRi0ycwvHkZWGr5pfC0sKnc9GSba+uGQoQ2h9khGAbTJUeIjq65Kz7SJX3nBcmPmcuIzuNcrnA43/31JI48tUiSq5Ji3Iu2Jg7zEz7G2g68LTLoKUfRhFlS9T4fu1ciczXl6g6oXAllqi7agbwNyTkuqgMgsW7GJb7hScGpxiN90GCzLfLVb+P2FMjQ0b8Ey+jPwgygWtzIDJo8p8BIykpaBwwwUlR2hq0qkTkIv2ig1xyHxgnRNNdIbn9h9QISbptW6snVI2Aim4bDogOloToceyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJSapGsHuSf3vvIEC5PPFGT+5wkcc6nsj+08f2j5e0I=;
 b=VTMIjE0Ol8QZIQc+VTqIP+NeHVTQdKiHo0nJ+v+HWGEKiQ41e4K9wNKScyFRi56QnJVzCkDtB2n5cUgZKxMWTJ8yFV5bymVG3fJ07+LRVF4jyCfEhn2zsCQuWt38W5vG7bkos5Xcwu3C7CoaiKG965p0Vqq8Y6QcwgitId4tqgCMtmqFzoumdIv7W9kJIMPGx+bgLEzUgLQPh+Ph2RHh/queARGir+ED0p1HgH965e0VJlEGgPRqHgV0a3V8ggWKELt3ijxfjy16mSN2qXBZhJwf9TJePEnbomKbs7mOzDz0VStNcRegCwqexV5NB9Hncrw8UrbEMohDlhebgz+efw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJSapGsHuSf3vvIEC5PPFGT+5wkcc6nsj+08f2j5e0I=;
 b=LgjjFVX/yUzmZzTp6YjAvKAB1ePHaJXcBrZbG+dJN12AYBgNLU0SmE/CQqcEazvXNtH86k1EdIGPJT/QLo5o06I+qphhdAyb0iZj3+5zu68aXrAGJ3m71fD9YDLTQHssI9SQ814UOzKwreGTYYD34Lx0YxMNVQxb+EaeIigrN1sBLTkj9gqoJ0IR84wk9WRwZI7F0Tw+haOwGrLFry40Ye71A0COMI/fXFlXwsKCDzQ84A1wuxwY045PIcP+5ouNqmLPb49MY0465tpcYnwh8IAgy8gAaFuspycIMmdnzb6cADLLEJzwyUJ++jCJXi9+ua4VsevaF0CNceDocSiXIw==
Received: from GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:eb::13)
 by GV3P280MB1743.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:23f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 17:29:41 +0000
Received: from GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
 ([fe80::fd2d:3517:f39d:926a]) by GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
 ([fe80::fd2d:3517:f39d:926a%3]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 17:29:41 +0000
From: Stephen C Goodman <Stephen.C.Goodman2@outlook.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211@lists.linux.dev" <brcm80211@lists.linux.dev>,
	"arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
	"brcm80211-dev-list.pdl@broadcom.com" <brcm80211-dev-list.pdl@broadcom.com>
Subject: brcmfmac: multi-BSS fails with arbitrary per-BSS MAC addresses
Thread-Topic: brcmfmac: multi-BSS fails with arbitrary per-BSS MAC addresses
Thread-Index: AQHdI21MToUzxZi3FUai5UCQnAbZJA==
Date: Mon, 3 Aug 2026 17:29:41 +0000
Message-ID:
 <GVYP280MB1056B22F060395735F23C20C9DD52@GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVYP280MB1056:EE_|GV3P280MB1743:EE_
x-ms-office365-filtering-correlation-id: 3d386184-ca1a-4d1f-e63c-08def184cd82
x-ms-exchange-slblob-mailprops:
 vuaKsetfIZn9IFDOZRHBr3PkJ6iE+FIkgn4s3vmXgSRBMK/NmYQWhuyE9wl+KXhis6DQQbyoG0Q09AZSbEakFrz7iM9YQylkUQsMa51Gte2L8ac73H9GcrWTAc9UW+ABuTBMHudaB1Z/tLqOShcGitpSsdlK9B/AWBxBYPmUnYiyGubO5j+OJGxL99yuOMDiSHrLer/u++0EDPzW78TxyhH3nPiHTnt7JUz9Oi2gbWxg5Z/p3F/7iM/FV8rQJWsWXLFRVIArPaIImp2D8eqNCs1H/f/0dOMhWir3rGpw7ck/nflKABVYp8XXufuSXFuGZYCb5Db4bz1qeqtCLokNwO1nI9TMBEPCgGc8ou1TaPLiwqtU0b1aVeMC03W1GNCj7Vm5WAGQf4Zx0wUUPylSZ+fgBjN8rOvpQoBCc/RXNmt5YZ3BKXTXlEmlhvdL5INwdUZgVlY+7mxHmZOEF/mz9ibLAYC573dQphDnJ80vSCzEz9GVQNYITTm1tTb8v7Ksc+CP6UXBFbdOoGynTQvWrnoqA56O90oVg/fl28DxtqB39ZuYDqj51bzzKnifxGgio1lm0Q2csxng5COYv2KpGMoxRtEGr9JHOrCDY1/tXSVmixzK0+evpc0043cdCKh+9UfqtcrCNbDuhlhMbMF80Bl/Ub+emdAISUYKkpvkM2rOsZtCxU/qgcQyLqKMh2NySjCei1+UWbM1UsT8ps02fd5+JUJvZRCuG+iR+ydwLxjdpOKI+Vq30wk0Tt8PySNzJh9mk1y6jnaRc3XcN0KDqwGBunH5HALWjKuTUTa5dsLoQvocmDsq3bwjhMOMswTs
x-microsoft-antispam:
 BCL:0;ARA:14566002|6012599012|15080799012|19101099003|15030799006|51005399006|19110799012|8060799015|31061999003|8062599012|41001999006|25010399006|40105399003|2607281247196008|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?Windows-1252?Q?Eu4mk4DF3L3Bl50B7iIKVGGGAZ4SqrVNQjl3rzF5xnfLY3i5Hsyq4sM7?=
 =?Windows-1252?Q?bA6eRmhlOTdyKCbuVdZuRBp+5rYzY8GPQxoc8nDnhwnA5ef0acQjKNua?=
 =?Windows-1252?Q?VtKmjieyfKRHPloJj52L3roPOKFMzS6eZhQQ+fZeNZ6Z/a49nMAEAe7C?=
 =?Windows-1252?Q?ngJO1qeYZxIOnu8JglcrBYCySnsI7Z9E7RMhYOX9MStybTQEn9xtxhkR?=
 =?Windows-1252?Q?pKiFwwTgHzjqCCks+AuSU5RdU1eh5SaOTJAlURufGuNY0hAH4RXg0ZTS?=
 =?Windows-1252?Q?UQYDv75jWaI95CdejRzWKwbvzEMzncts6GsIvBeZBG0aeITWkMlywAv4?=
 =?Windows-1252?Q?tL3v/6WDpoc39jwuLASvGM6HUvJ7w6gym6gDlCl6dYjJ4tHN2C/Xs16B?=
 =?Windows-1252?Q?LXk+vX3ry206TgGVLUj7u8vaY5vQiCIkvRaGswEfddazuu19ky2ZfKND?=
 =?Windows-1252?Q?MU+UI+9L5ZqCXcP2weUgaP2cc/kPRXSvATdQyjx85x50LsuCNQttvyyG?=
 =?Windows-1252?Q?BTcf8u7J5fP/bSbhypweGOWFp8ATuBvfn1l0NRqj1Zgkb5p9b+K+/I5L?=
 =?Windows-1252?Q?NHFsy8TpOURcV0AQ5bd4130xlUw3CoUlNz8Zm6YzUa9lJakj+xHfHhvI?=
 =?Windows-1252?Q?/GhZbCW/+5MVNastaoMnloaZ8R/b2UR6M8A9Lq3R4oZ5UAhm5NYrP+rY?=
 =?Windows-1252?Q?hFkELQZAEItUrValXQxuHVIDry27ypmcu8OcGsdbmZWC2cDqL+h8iXGf?=
 =?Windows-1252?Q?8u7n86Z6RPZQvNgbb1jIB7ERtwVf2X6Ua74XSUEuTNuLo5UsGdd42n4x?=
 =?Windows-1252?Q?Y8X1sFPvGTikGujxcP9SLNbjCW9OUiZPD3V5j3LPh32OMmkzLBMghfun?=
 =?Windows-1252?Q?/KDCeCvB0BT9yv3DTvwyLJPWc8p3lqkQMYIETDB9be+S3HD7xvNCa7Wr?=
 =?Windows-1252?Q?29QG2+2ovdAiNEvXDPZU/2HqOdBY4CAPs1jnwfpu40tr2C+xuO5RGQPJ?=
 =?Windows-1252?Q?KRUl0F8CyiEoD5CUw+a4yE9ITZKSPmAivDFmoG+bn9AgW3+5RKmbESCO?=
 =?Windows-1252?Q?sATlMr01EoBrsKhV72ZVpObdHkWqSBFZbXp/OHfXEZjMAWGUinCz11Cg?=
 =?Windows-1252?Q?VYY=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?jNpnTIb8/sIcol+py9PDRQshR0G7oqvmZv0wn6nPmvU9HxOARirvSXfV?=
 =?Windows-1252?Q?73TVjhOdclbD26JpaIM3m6CIpfVdi9pwbkUiO/awLuOFmD4YcJtjbaic?=
 =?Windows-1252?Q?+OHiuWsKUW+iazfgi6Jxo8pt8nH31uZVdSiOVG380FUOEyHF6nw/Vt3N?=
 =?Windows-1252?Q?2zTq5+5DDCa9J7u/ig9boomkAdiFmVrH11g67ICG1g3PV51CmeknoGCO?=
 =?Windows-1252?Q?ElE3zx2AKtnccjzpx+vLFw/oJnBZikutZHF9Qbqh49QVjmwGNToQkcZC?=
 =?Windows-1252?Q?acWBttGmCCMkl4MopD4RFuXy+jKtGzUOB6SIOnP54zyGG6ZXnKACf8bI?=
 =?Windows-1252?Q?xT8LrO0AYgYbJai6D8htUdEKfgDYi/IS+q2KFBiZC9WmGvUj6FqXiiDS?=
 =?Windows-1252?Q?hMQmHfkuK/idycwx467ZGX/EanJ1+NEj+S6uLRNQQSJwM6QWtCXRrYlh?=
 =?Windows-1252?Q?SVQxyf2Dj/42Rf2v9r9IrjYo13Iy1wLKE5UaIQqIoskzN0SKb6b+tgek?=
 =?Windows-1252?Q?cYIM8jNjb4xH6JNIKsGuEYSTQVD7K9zRmuYZKMgrMSpF0IIqnvPQEs5P?=
 =?Windows-1252?Q?HxZeBZAFj0f1jF5pStvr2PQeiX+4AdGl9Wt2dkEqB7aL482qKEaU42JV?=
 =?Windows-1252?Q?ftwb+oP47udlNav/vOoU4of+kPci41L2SqlFJl4UxMj0jAUo4PnKfpOt?=
 =?Windows-1252?Q?TkuQq7E3ScLgVZSOzotNezUeNePfLxvnPJPhqFwFmHn1KcMMPQsClKiQ?=
 =?Windows-1252?Q?PpSOm0U6LyUYx+QhC3VYeDhV48Xd9fKG9ZC8GU79XlAIvRe9J3w/zgsW?=
 =?Windows-1252?Q?lRpEeuHJi70SfDrYNObY1riFgooGOrKbc6fqvs91KJtb33eUuJ6sKKDm?=
 =?Windows-1252?Q?IxP4jDJ1RtMZdbxaI6NT6Xj85qvuXb383oefSLa26ll8it6Ts7ZlzG8e?=
 =?Windows-1252?Q?/Hm/oNG1PnsbUXkBBOU9N17V7zZYkC3dAtHuNTuIYwugT+gnzwwd5D/S?=
 =?Windows-1252?Q?tyWmp/EgfenCcA3dutix4YJdpHuS1iU3RGQEIU7a7X+aOVFVOprjxDaP?=
 =?Windows-1252?Q?KNK7vPUEP7DV62wkc6/Wy1vDzT1Urio+zCBjndn09tzWF2krqe7e9939?=
 =?Windows-1252?Q?YwRfpQ6f3qNqgeMdhwA7la1/W3TA4xKu2MBRQjAq4Cn0r1/o9GaH0+bC?=
 =?Windows-1252?Q?XF2UCtaw8OC0EVfmvf17TtqAM1xF43qMrZK9wu8AB01qagzV0sJjo0uC?=
 =?Windows-1252?Q?xaRjocL/undGAJobj4OhfJSwnD/6nv0cnIIt0b0qN1+tT8Efy+mLMRWW?=
 =?Windows-1252?Q?rAeWInG5MV69nGewV9zrCs4O+jKPdQAzFyyzJeu4g6ncg5nxtxpvLvnE?=
 =?Windows-1252?Q?d9WkkLtDHFkSDCZDLnPlw3SRgyJ7nXf6YYlaAtU2k7xXEXKznZq69XaO?=
 =?Windows-1252?Q?D5JfeXuBa4t9Zl2PhIUjYsyLMnbwyZ0POjelVj2uOCBY6QQd3GtJG6QJ?=
 =?Windows-1252?Q?e6sMb/BQZ9b41/NLueOuVjJbn3s3yg=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d386184-ca1a-4d1f-e63c-08def184cd82
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 17:29:41.8790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV3P280MB1743

Hi,=0A=
=0A=
I am seeing a reproducible multi-BSS MAC-address handling issue with `brcmf=
mac` when configuring multiple AP interfaces on the same PHY.=0A=
=0A=
## Environment=0A=
=0A=
```=0A=
=0A=
Broadcom chipset:   BCM4366C0=0A=
```=0A=
=0A=
## Summary=0A=
=0A=
A single AP works normally.=0A=
=0A=
Multiple APs also work when either:=0A=
=0A=
1. the default automatically assigned MAC addresses are used, or=0A=
2. explicit `option macaddr` values are configured using the same base addr=
ess, with the first five octets identical and only the last octet different=
.=0A=
=0A=
However, if I configure arbitrary unique MAC addresses for the AP interface=
s, only one AP can be enabled. As soon as a second AP is enabled, multi-BSS=
 operation fails and the AP interfaces disappear / fail to come up.=0A=
=0A=
## Expected behavior=0A=
=0A=
The PHY advertises support for multiple AP interfaces.=0A=
=0A=
Therefore, multiple AP interfaces should be able to operate concurrently as=
 long as each interface is assigned a valid, unique unicast MAC address.=0A=
=0A=
## Actual behavior=0A=
=0A=
### One AP=0A=
=0A=
A single AP works with:=0A=
=0A=
* the default MAC address=0A=
* an explicit same-base MAC address=0A=
* an arbitrary valid MAC address=0A=
=0A=
### Multiple APs using default MAC assignment=0A=
=0A=
Multiple APs work when the default automatically generated addresses are us=
ed.=0A=
=0A=
### Multiple APs using explicit same-base addresses=0A=
=0A=
Multiple APs work when I explicitly configure addresses where the first fiv=
e octets remain identical and only the last octet changes.=0A=
=0A=
Example of a working manually configured pattern:=0A=
=0A=
```=0A=
AP0: AA:BB:CC:DD:EE:01=0A=
AP1: AA:BB:CC:DD:EE:02=0A=
AP2: AA:BB:CC:DD:EE:03=0A=
AP3: AA:BB:CC:DD:EE:04=0A=
```=0A=
=0A=
The final values do not necessarily need to be consecutive, but the first f=
ive octets must remain identical in my tests.=0A=
=0A=
For example, addresses such as these also remain within the working pattern=
:=0A=
=0A=
```=0A=
AP0: AA:BB:CC:DD:EE:11=0A=
AP1: AA:BB:CC:DD:EE:27=0A=
AP2: AA:BB:CC:DD:EE:5A=0A=
AP3: AA:BB:CC:DD:EE:C3=0A=
```=0A=
=0A=
### Multiple APs using arbitrary unique addresses=0A=
=0A=
If the AP interfaces are assigned arbitrary unique MAC addresses, multi-BSS=
 fails.=0A=
=0A=
Keeping only the first three octets=97the vendor/OUI portion=97the same is =
not sufficient.=0A=
=0A=
Example of a failing pattern:=0A=
=0A=
```=0A=
AP0: AA:BB:CC:11:22:33=0A=
AP1: AA:BB:CC:44:55:66=0A=
AP2: AA:BB:CC:77:88:99=0A=
AP3: AA:BB:CC:12:34:56=0A=
```=0A=
=0A=
With one AP enabled, it works.=0A=
=0A=
When a second AP is enabled using this type of address layout, both APs fai=
l / disappear. With three or four configured, all APs fail as well.=0A=
=0A=
## Reproduction=0A=
=0A=
1. Configure one AP with an arbitrary valid MAC address.=0A=
=0A=
   * The AP comes up successfully.=0A=
=0A=
2. Add a second AP on the same PHY with another arbitrary unique MAC addres=
s.=0A=
=0A=
   * Both AP interfaces fail / disappear.=0A=
=0A=
3. Replace the addresses with explicit addresses sharing the same first fiv=
e octets.=0A=
=0A=
   * Both APs come up successfully.=0A=
=0A=
4. Add a third and fourth AP using the same first-five-octet pattern.=0A=
=0A=
   * All configured APs come up successfully.=0A=
=0A=
5. Change the last three octets independently while keeping only the same O=
UI.=0A=
=0A=
   * Multi-BSS fails again.=0A=
=0A=
## Observed address restriction=0A=
=0A=
In my testing, multiple AP interfaces work only when their MAC addresses be=
long to the same narrow address range:=0A=
=0A=
```=0A=
AA:BB:CC:DD:EE:xx=0A=
```=0A=
=0A=
Changing any of the first five octets between AP interfaces causes multi-BS=
S bring-up to fail.=0A=
=0A=
Keeping only the first three octets identical is not enough.=0A=
=0A=
This may indicate that the device or firmware supports only a restricted vi=
rtual-interface address mask or MAC-address pool, but that restriction does=
 not appear to be clearly exposed or enforced before interface creation.=0A=
=0A=
## Related issue=0A=
=0A=
I have also observed a separate AP+STA concurrency issue on the same hardwa=
re where the STA is reassigned to an AP interface=92s MAC address.=0A=
=0A=
I am reporting that separately because its reproduction and failure mode ar=
e different. However, both problems may involve virtual-interface MAC alloc=
ation or firmware interface-address handling.=0A=
=0A=
=0A=
Best regards,=0A=
Stephen=
