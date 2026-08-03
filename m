Received: from MM0P280CU010.outbound.protection.outlook.com (mail-swedensouthazolkn19012051.outbound.protection.outlook.com [52.103.34.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DFB349CE2
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.34.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785778014; cv=fail; b=EqF51v2i2thTXtZ/WdqaxsOQzF71u3jyyVfBLkOQTfBqSrrvWbhf3DCIutcL1mQsxyyv781cXQX16HFa7pJYeLW5lVahtNFOMzn7VEoQjuhnJZ+WuUil8fj7ObLx8Jk1vi8m0ccAPzpahdP66gmIkCQhy/GHZr5s99q3DipzsdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785778014; c=relaxed/simple;
	bh=R1pR8v2p5BzKp6xkTKZS0naiJ18KEqBzKhpmlaOWFDo=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sNzy/LFSy531RTRaYEHex+WD/vn4co6ayOGfoyR8Lj5KHBCSwzx8MsltnrHNNn4hkxOHphwAY3rLcec8uMPrqUJGgukcNm4Wi+Qe0fb/RhYlQd4ahoCIxGJMb2dUkM4rxPidyYYSbMeXMOpyaG2XeOzqyoahNXnVcQ8TuYWx6Z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=VYyqIyUl; arc=fail smtp.client-ip=52.103.34.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="VYyqIyUl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L3hqWq68EYAu09iB+FnSdtZa+ROsEAwkv/MubMQHBuyBv2aOh5fqWKL5c3hNibPtZLNKNX9HwAJDEX8JX9oDoZ98YD+U7f2p0XskVBZ3IaR3qHZLMm4XVQE4F70uMYRKXmV0v5jKRZq/wj8H2q7Ja9vwJMWD3yStn7Knv3Twy64A1zMA20O6dIuKsus0LuS90tPhnE0Yp5S2jtVylLR3X1V0b+7PR867njId8fcC5DAASgkcD5m78v03PE7y9HEFqaiJGDFut45QwY7gcVbvQzG9hPX1bAgVKNCZOyMBlqohPdGH9MqtIUQuCGFVaQ6H+aSz9qj97I4dG5Q6d0wNzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93xp8Eca0niuq5MePSKV669f5Z9q9cXtW6aOnXl0/Zs=;
 b=mDnGXrN6SGQEmPc19eCbzNs+n4oUSNxg7TAZ38V/siqFvtgRTinK5Kt5z8b3lbTjPaQAowI1Lgc6Wk5gevgujh5p4FU7Ohnr4vg3jLzhIZV8JGeK5B5XyF643UTNWlvnuEz0xQficFG22AcQF5pbAlY1QZ774680qR/mGhD7Bz0XerbYQxsvO5N1N6lI6Po8jMZc2Ifko880JRptj/kKRBeEVs1mLTaLM/Y/xSzjaB0fkwW40Fl1HNaWjwM9lyMyaiI2sOSHbP/GOiDdqbj6lf/L2a3ygDxNQorON63QjuJtQzjt6R+zpZU6o8NaKaYCYrMsM4AqNswByTzzOif4Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93xp8Eca0niuq5MePSKV669f5Z9q9cXtW6aOnXl0/Zs=;
 b=VYyqIyUlQOG8dMBVCfYLzNi9GK971avCvx9dZU0gYB9iu1ECQ69RyQXY7Aiuy2TfmLKggxJS6fXkdWvKyV7aitUPvdwKOvfQRzpLnX7L0f4jHq0owj9yMigrmW0I86xpZ+EYJLfTXMBeCemDGYyedIstxkiMfDr3UxlSxyzWnBOqV+Y0l0JV03XIxAKwj65BJRrdO0tJeIAos5b0crZQpkcbrrWK+j8nmf8cd+evtNC4cc5bk721qXsJYMIcQzeZrxenfbrPgQZFa+G2eWSJQqtK3UUAWcJ2VHiEeuoPdiurIFFCtS7YmVqlxBVAcU/lPJRoWoieCxY9atq5tJLn6w==
Received: from GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:eb::13)
 by MM0P280MB0979.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.17; Mon, 3 Aug 2026 17:26:49 +0000
Received: from GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
 ([fe80::fd2d:3517:f39d:926a]) by GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
 ([fe80::fd2d:3517:f39d:926a%3]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 17:26:49 +0000
From: Stephen C Goodman <Stephen.C.Goodman2@outlook.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211@lists.linux.dev" <brcm80211@lists.linux.dev>,
	"brcm80211-dev-list.pdl@broadcom.com" <brcm80211-dev-list.pdl@broadcom.com>
Subject: brcmfmac: AP+STA on one PHY reassigns STA MAC to AP MAC and breaks
 concurrent operation
Thread-Topic: brcmfmac: AP+STA on one PHY reassigns STA MAC to AP MAC and
 breaks concurrent operation
Thread-Index: AQHdI2zP+JudjhTyVkW3bxnWqHaO7w==
Date: Mon, 3 Aug 2026 17:26:49 +0000
Message-ID:
 <GVYP280MB1056154BB4A4DE3D4555EA0C9DD52@GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVYP280MB1056:EE_|MM0P280MB0979:EE_
x-ms-office365-filtering-correlation-id: 927ecbcd-a32a-4e7c-2c7b-08def18466a5
x-microsoft-antispam:
 BCL:0;ARA:14566002|15030799006|31061999003|8060799015|19110799012|41001999006|8062599012|6012599012|15080799012|19101099003|4140399003|5040399003|40105399003|52005399003|2607281247196008|3430499035|102099032|3412199025|440099028|19061999003;
x-microsoft-antispam-message-info:
 =?Windows-1252?Q?DYhQY/l9l67WzGvRm3DsmJLkN5uujD9EMx5j370srJi+VAM03MbhvIqg?=
 =?Windows-1252?Q?6uPNZnyV7PSs7MGfyf9+CyjRWXCw9xjAkz0UKM7gmpIPqlB9ZZtH1tkr?=
 =?Windows-1252?Q?SxcIeA57EgmINMXdj4qh/e2OLrJFqAZ5lFs5W2f5uode/9QhGL24n8BS?=
 =?Windows-1252?Q?WNx9ed1FMcUmJnVz/rIEZ62Dfj6RAOb2FYIEjp3YtXLPRRYGnBH4CgCs?=
 =?Windows-1252?Q?+dDiVaukZZ+PD16kYeLirB5Ec2R0DGxkYVOJnHo+u60Ue0VePp4YfBS5?=
 =?Windows-1252?Q?O7Lj0omYA7n6g8xfOiw1DGCFmmvIUvzneJFl7r3sx4EFrwyFnnjB0H61?=
 =?Windows-1252?Q?eXT38cbns1n/8kXblRctgEKsZdv4jj6zpQcQ7DBPSIGqgVH3HMHp//mg?=
 =?Windows-1252?Q?go1pPvUAdSxcL5kQJyqMb4h3ng7fF3u5c4P/fMZcDNt7wVL/QHNrCZIf?=
 =?Windows-1252?Q?Oe2noDq4n09l1LfaLnI1D/bcbUVg9eLwsBp9LfvC8nV09N0LBq6iAHbg?=
 =?Windows-1252?Q?V3XPrBNt6hOLY4v3Qxi+cmffTBT2o5PmQMh/Ryi4v6T9VSPz8A+LxM0W?=
 =?Windows-1252?Q?wW6UXmog9sZh5Drdyo8HL5OircvXW0/+5RTWwMUFU1dPFPvSg2gDt2C8?=
 =?Windows-1252?Q?HYEZw7uzC1Tf5/y7BreXoHv3bRE7nujtfRy7gLnLg5s9tRMCLKEPHxV2?=
 =?Windows-1252?Q?SoeDtnPdFpYjnbwIzWEh6fRpRCs4NYoDlb56/zzcKyF0orKYC5pKdpot?=
 =?Windows-1252?Q?SiRmDws8H3sm57QN6rd3Lw+HH74gYZ3Qa5pyEsy34pWpcrrJMHPJc66h?=
 =?Windows-1252?Q?uIEAoPaYOEjTz20BlmKTbi22EJpe66d6F21dXbXvy88LdS5ilcmfygA9?=
 =?Windows-1252?Q?9P3kcuIQXOBCmUIWPDwzZqh69Ln4bzBBheeJkYTVR280hGWncXDsApBz?=
 =?Windows-1252?Q?4IRtiGoidwKwtdF5BzjbHjEH6+kHjWdlasvDBrMrZy1h0YMKgmzMySy2?=
 =?Windows-1252?Q?xXfvhmYnkY6yaMBC0369qY4horCyZhRgBxSS9vngDEQEvbK2xTnDvfA3?=
 =?Windows-1252?Q?GBjG0GZwN8WYPnXRlo5LStmUtkpY4bfhDeYkiAq9jbzkJNMYAM/1ZhyZ?=
 =?Windows-1252?Q?h+iYQ9hvcptvp2rnawV2wfVx?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?QlDTVagF7rTOSz4QYl5YJBhU5NEjAgZ0DwGwUqLWwbndO9QP36DJJfx1?=
 =?Windows-1252?Q?OvmiK0gzC3cVhi7GbFCFo6V91Ft5XGU6rSe1VYgq1zPix0VSbYlvLA3M?=
 =?Windows-1252?Q?317cLD+oet4eclRSsJmOYMRuA4oHAEdnA7une6HNi64rP2Ec+u6m1VPr?=
 =?Windows-1252?Q?/dMWEzb0h6GKRYPNfy/3Q2qTIwB8/dZ1slV4UEmZKEGRZ8zwdJT8eJd+?=
 =?Windows-1252?Q?To/FKpsWTiTGfdW0mnPneUWTJchakNv/fmasGKZkH8kPQWEu7rTbe0Nk?=
 =?Windows-1252?Q?h1M4f8qZp4InYI6SI0eaXxtKYAuTj+7d2gFw6VkwsZtS2Io6/lMVnZEE?=
 =?Windows-1252?Q?keKPLjafDu5xr0M099Y0ymEDuy41tVCZhu/I/3mAQe5DWawv5pN/+uS3?=
 =?Windows-1252?Q?KI1wCW9URhEV8SywOP0nTKxaR7Vg47vdHOz55t1dalneDpFY6+igV/zj?=
 =?Windows-1252?Q?SsamQMBKQgaO6cOWBaR7EUlD0T3+susn8Smyqz7ivW3pA+gop30p0gp1?=
 =?Windows-1252?Q?zg66g9nHStdJeeGxmlLu/0AQcFQI69H5rUxFVM64ff78Om6vq1J24FqC?=
 =?Windows-1252?Q?AEYfEQyvQCyxQQxQEqIf9CEgcROQljN8CB7o6Z5w8p06L4nBckpG5AfY?=
 =?Windows-1252?Q?1xk/1aMtFQaokvzXqhoRIWlBJhfmlJVG15U9BTlwmnl7IqTn29wsMDxa?=
 =?Windows-1252?Q?vq/7IJsFRSXUijkHeSxVWYDbMWFu9B13gdbvkEioh8lUrd5k25lOEnQk?=
 =?Windows-1252?Q?eAA+paQR5HyEBKHVofFR0gshGpwjH7N4ajeny9XVFqg0xJoUgshNUhzF?=
 =?Windows-1252?Q?dAhUPLcOyWnhDHS+353eF2gadEwoT9MpYdAwZl19ekGiRg30O15lbVTg?=
 =?Windows-1252?Q?WXQTwG4wREsXb3fLa/x4rueHnhZy2/hA8niRMPZ7At8iTKlTGo2cfsDR?=
 =?Windows-1252?Q?8aXujBdTGE+HQzGa9SAZRzdz6zmeyGV5swYLfzCDpSEECRq52gSqh32z?=
 =?Windows-1252?Q?RxzVIr5nwqDydjVQhUGuJFcoSwH0f0Y+tZ0u0R8KktumINbiKhXa+x12?=
 =?Windows-1252?Q?dhv5HgPhEECEpqhfD/rVhN8/t6qRTO7ZTHXR/Opt3tQO9+MqHBVPQgMg?=
 =?Windows-1252?Q?G1jLtirFpgUQyAAqzUrkLmKRpu8yNTBr+yhF6HFCd5yb/Stkw4WRSeRz?=
 =?Windows-1252?Q?cmmcl+acjreAB2i2mVHUle7tsXSsK016rG1GReM0TH+WtM6QHcIy8836?=
 =?Windows-1252?Q?4y+JqVkNCuIn8lLZQXJDIISG0Hg8Z/aR3z3GTIyvPFDFoeyLCH8Kxp0H?=
 =?Windows-1252?Q?E9pCy+Qn9c0VxXMI02lVfpltfuseKsxp2NLKqqeSorsmfd44cK/lokw7?=
 =?Windows-1252?Q?mzBMLqeGp94M8jyilP0Vr2UPCvIjt77BU4haKYdJtACykFV4MMER3/2c?=
 =?Windows-1252?Q?ETZY28nfZC44+wwg7Mh5exaE45XXVUSPhX9ciTCj+X7ky8MU1mLPHjCm?=
 =?Windows-1252?Q?TCqF72VocWD7Eyqld6nDPQ5L/S++KQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 927ecbcd-a32a-4e7c-2c7b-08def18466a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 17:26:49.3133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MM0P280MB0979

Hi,=0A=
=0A=
I am seeing a reproducible AP+STA concurrency failure with `brcmfmac` on a =
single PHY.=0A=
=0A=
The PHY advertises a valid interface combination containing both a managed =
interface and an AP interface, so one STA and one AP should be able to oper=
ate concurrently.=0A=
=0A=
The relevant `iw phy` interface-combination output is:=0A=
=0A=
```=0A=
[paste the exact =93valid interface combinations=94 block here]=0A=
```=0A=
=0A=
## Environment=0A=
=0A=
```=0A=
=0A=
Broadcom chipset:   BCM4366C0=0A=
=0A=
```=0A=
=0A=
## Summary=0A=
=0A=
STA-only and AP-only operation both work correctly.=0A=
=0A=
Concurrent AP+STA operation fails because the STA interface is reassigned t=
o the MAC address of the AP interface. The visible failure depends on which=
 interface is started first, but concurrent operation never works.=0A=
=0A=
The STA MAC also follows the most recently enabled AP interface. If another=
 AP is enabled, the STA changes again and takes that AP=92s MAC address.=0A=
=0A=
## Expected behavior=0A=
=0A=
One STA and one AP should operate concurrently on the same PHY, using disti=
nct interface MAC addresses.=0A=
=0A=
Starting or stopping another supported AP interface should not reassign the=
 STA MAC or corrupt the state of existing virtual interfaces.=0A=
=0A=
## Actual behavior=0A=
=0A=
### Test 1: STA only=0A=
=0A=
1. Enable the STA.=0A=
2. The STA associates with the upstream AP and works normally.=0A=
3. The STA initially uses the radio=92s normal/default MAC address.=0A=
=0A=
Result: works.=0A=
=0A=
### Test 2: AP only=0A=
=0A=
1. Enable one AP.=0A=
2. The AP starts and broadcasts normally.=0A=
=0A=
Result: works.=0A=
=0A=
### Test 3: STA first, AP second=0A=
=0A=
1. Enable the STA.=0A=
2. The STA associates and works.=0A=
3. Enable the AP.=0A=
4. The STA changes to the AP interface=92s MAC address.=0A=
5. The STA and AP now have the same MAC address.=0A=
6. Both interfaces fail.=0A=
=0A=
Result: both STA and AP fail.=0A=
=0A=
### Test 4: AP first, STA second=0A=
=0A=
1. Enable the AP.=0A=
2. The AP starts and broadcasts normally.=0A=
3. Enable the STA.=0A=
4. The STA changes to the AP interface=92s MAC address.=0A=
5. The STA successfully associates with the upstream AP.=0A=
6. The local AP then stops broadcasting/disappears.=0A=
=0A=
Result: the STA associates, but the AP fails.=0A=
=0A=
### Test 5: Explicit STA MAC=0A=
=0A=
Setting `option macaddr` on the STA does not resolve the problem.=0A=
=0A=
The STA does not retain the configured MAC during concurrent AP+STA operati=
on. It still changes to the AP interface=92s MAC address.=0A=
=0A=
### Test 6: Explicit AP MAC=0A=
=0A=
Changing the AP=92s configured `option macaddr` also does not resolve the p=
roblem.=0A=
=0A=
Whatever MAC address is assigned to the AP, the STA changes to that address=
 when AP+STA operation is attempted.=0A=
=0A=
### Test 7: Enable another AP=0A=
=0A=
This test makes the cross-interface reassignment especially visible:=0A=
=0A=
1. Enable AP0.=0A=
2. Enable the STA.=0A=
3. The STA takes AP0=92s MAC address.=0A=
4. Enable AP1, which has a different valid MAC address.=0A=
5. The STA changes again and takes AP1=92s MAC address.=0A=
=0A=
Therefore, the STA is not merely receiving one incorrect static address. It=
s MAC follows the most recently enabled AP interface.=0A=
=0A=
If AP1 is then disabled, AP0 and the STA once again show different MAC addr=
esses in Linux. However, concurrent operation does not recover correctly:=
=0A=
=0A=
* OpenWrt/hostapd may briefly report AP0 as enabled.=0A=
* The AP is not visible over the air.=0A=
* The STA repeatedly connects and disconnects.=0A=
* `phy0-ap0` repeatedly enters forwarding state and is then disabled.=0A=
* `brcmfmac` repeatedly reports `WLC_DISASSOC failed (-52)`.=0A=
=0A=
## Representative log=0A=
=0A=
The STA initially associates and completes WPA key negotiation:=0A=
=0A=
```=0A=
wpa_supplicant: phy0-sta0: Associated with aa:bb:cc:00:11:22=0A=
wpa_supplicant: phy0-sta0: CTRL-EVENT-SUBNET-STATUS-UPDATE status=3D0=0A=
wpa_supplicant: phy0-sta0: WPA: Key negotiation completed with aa:bb:cc:00:=
11:22 [PTK=3DCCMP GTK=3DCCMP]=0A=
wpa_supplicant: phy0-sta0: CTRL-EVENT-CONNECTED - Connection to aa:bb:cc:00=
:11:22 completed=0A=
```=0A=
=0A=
The local driver then fails to disconnect cleanly:=0A=
=0A=
```=0A=
ieee80211 phy0: brcmf_link_down: WLC_DISASSOC failed (-52)=0A=
```=0A=
=0A=
The STA is disconnected locally:=0A=
=0A=
```=0A=
wpa_supplicant: phy0-sta0: CTRL-EVENT-DISCONNECTED bssid=3Daa:bb:cc:00:11:2=
2 reason=3D0 locally_generated=3D1=0A=
```=0A=
=0A=
The AP bridge port then repeatedly transitions through forwarding and disab=
led states:=0A=
=0A=
```=0A=
br-lan: port 10(phy0-ap0) entered blocking state=0A=
br-lan: port 10(phy0-ap0) entered forwarding state=0A=
br-lan: port 10(phy0-ap0) entered disabled state=0A=
```=0A=
=0A=
This loop repeats:=0A=
=0A=
```=0A=
ieee80211 phy0: brcmf_link_down: WLC_DISASSOC failed (-52)=0A=
br-lan: port 10(phy0-ap0) entered blocking state=0A=
br-lan: port 10(phy0-ap0) entered forwarding state=0A=
br-lan: port 10(phy0-ap0) entered disabled state=0A=
```=0A=
=0A=
## Channel and security tests=0A=
=0A=
The AP+STA failure is reproducible with the channel set to automatic and wi=
th the AP explicitly configured to use the upstream AP=92s channel.=0A=
=0A=
The same MAC reassignment and concurrent-operation failure was observed wit=
h:=0A=
=0A=
* open authentication=0A=
* WEP=0A=
* WPA=0A=
* WPA2=0A=
=0A=
Therefore, the failure does not appear to be caused by WPA key negotiation =
or by a particular security mode.=0A=
=0A=
## Recovery=0A=
=0A=
On a fresh boot, disabling the STA allows the AP configuration to work agai=
n. A full reboot is not consistently required.=0A=
=0A=
During one earlier extended test session, a Wi-Fi restart was required befo=
re all APs returned, but I have not reproduced a consistent reboot requirem=
ent and am not treating that as part of the main bug.=0A=
=0A=
## Related observation=0A=
=0A=
The same hardware also has a separate multi-BSS MAC-assignment issue. Multi=
ple APs work only when explicit addresses are configured with the first fiv=
e octets identical and only the last octet different.=0A=
=0A=
I am treating that as a separate issue. However, it may indicate that virtu=
al-interface MAC allocation or firmware interface-address handling is relev=
ant to both failures.=0A=
=0A=
## Conclusion=0A=
=0A=
The main reproducible problem is:=0A=
=0A=
* AP-only works.=0A=
* STA-only works.=0A=
* Concurrent AP+STA is advertised as supported.=0A=
* The STA is reassigned to the AP interface=92s MAC.=0A=
* The STA MAC follows the most recently enabled AP.=0A=
* Bring-up order changes the visible outcome, but concurrent operation alwa=
ys fails.=0A=
* Removing the visible duplicate MAC afterwards does not immediately restor=
e valid AP+STA operation.=0A=
* The driver enters a repeated `WLC_DISASSOC failed (-52)` and interface-fl=
apping loop.=0A=
=0A=
This appears to be a `brcmfmac`/firmware virtual-interface MAC assignment o=
r interface-state handling bug.=0A=
=0A=
=0A=
Best regards,=0A=
Stephen=0A=
