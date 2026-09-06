Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazolkn19010023.outbound.protection.outlook.com [52.103.2.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513ED1EB1AA
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.2.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788710908; cv=fail; b=KGleLOolb+s6p1CENoObtnjA3U9tck4FozABRuDe88u7wfDseRF5jowKU/BIVUMb80RG3SZ4FYFgCuma1R+WtSOLYktmQfY6bkUI8kSCQV9yGa0zzJSFkDomI7ydzNHCbtHIDoVWz7QssafAa6kBOjHpeZO/7HuFCd0OILkX4Sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788710908; c=relaxed/simple;
	bh=rgDXWF/Ld7dZzXvh/U7DnQFbPp3l0EyOlqy7NEpP0n0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W2A3DmR7oTgKf58Nhq1pDRqH+NrWAmcyxkM1mRqOnqug7zHN0C6rqx1aPDsQfw/UfEC2qyky/FZ4Z2ThnygXJLj+nPPJk1Gv4wa89GI0RksDo4F+xOCtS85Bqx6qlq35CvaD/5XybE6Ev2hCANNUylwiIf3xoM/8nTWAvbrShu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=opC0wEXj; arc=fail smtp.client-ip=52.103.2.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="opC0wEXj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pRhO+N+c1g5HYqwVdj8i8K6IZAdJFI0iBVPBIM6d31HcX5xcseXKHst4Fp3BdmOwbLudeFRGNqVsR5aPCbHqcm0vLcaL8nG9b8YxnwyzcWnwrKkDxT7j4iZYOSJS24elBMH2V1QS5pBlPcZOfRWvVOmFJafJ3HX8CMB93f63TWYL06hdV44gSb7X4NgF8SzFYb2gVMqnU1PEGUKerSF7Ob5Gyjx99WbOB+RNqLZZMEYM2NT99Lo2c6Jo40Uea0NcvZ9U2IAAoCPXtyoQhUJrjocTZsWpzh8mvCO74D6A6HPmSzqnRizHGSxO24cj6T7HhKXktDD0C0ohkFlzUe0oEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+eiSar9wtzaXQHscJfC8ld3WFE+qaMUBEyjHG9hhOTM=;
 b=isWSKOEpQQaiVWWPy7r+uo+TfJMU2h4u5G7XewIURGhLR1cYZ1CNsvn2zp5sqgcvHRMWO1jGX8JLzqA8NotdyKYIizIfkIm/eRetIGqmesMTC2Y3vyss0GyN+NRoxyKenQG204fKZO+waGCAqYadqUvdKS+5CiMiTwd7H0/jC2mso1WVwUov1cw6XzjuWqXGwsdyZAcLmO330ZQ88pev0+19bczeU1dhnZBjEsyZvSG2Qsc1Mvof9mdqEjfNimKipaay8q+oV5xsa/O1aMw/GTqbu9kTuouGBFUi+S0rh+w7CujxN3tXQJT4pc9bkMUKR2JfP9QxNy++8oNGAebJFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eiSar9wtzaXQHscJfC8ld3WFE+qaMUBEyjHG9hhOTM=;
 b=opC0wEXjvpPNRcQc3jRniy1PW5xsiEQXzzEnK+kn9b4NuJPBw2xoaqin2XON2u6D2zFvUbFv/lIKZYXHLymIHvQ/kXknMHDmuv62E7zpKK95sZUo/ZEbMDwK3vOCTWBSQqofveEv450o9k5gI6oVOtf+WzR8r/jGk5wklNLbDMUI+MzuSAqeoqzHcKrF0RVnupdPs7YH9Up0FyOHJ2h3eyOd6URditxsn7c0I+5K+15/4bDiIBQRUpeBQhbU07SBsDyq+yvyU+NCmil9Jc3NcJ6/cfe8Cg/f7ZZDqziCBIJKRhOit3YPBVA+e2eoWhcM5kGm0kHQRQffgTotp7SWdA==
Received: from PH7PR12MB7017.namprd12.prod.outlook.com (2603:10b6:510:1b7::15)
 by SJ5PPFA5F0E981D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 16:08:24 +0000
Received: from PH7PR12MB7017.namprd12.prod.outlook.com
 ([fe80::8c14:38f:301d:cf6]) by PH7PR12MB7017.namprd12.prod.outlook.com
 ([fe80::8c14:38f:301d:cf6%5]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 16:08:24 +0000
From: Aditya Srivastava <aditya1800@outlook.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "pkshih@realtek.com" <pkshih@realtek.com>, "rtl8821cerfe2@gmail.com"
	<rtl8821cerfe2@gmail.com>
Subject: rtw88: RTL8812BU does not re-enumerate after failed USB 3 mode switch
Thread-Topic: rtw88: RTL8812BU does not re-enumerate after failed USB 3 mode
 switch
Thread-Index: AQHdPhblzlcXQMfqP0ePrA4tIpkMJ7bBt0jb
Date: Sun, 6 Sep 2026 16:08:24 +0000
Message-ID:
 <PH7PR12MB701705472054EAF1303147B9D5B32@PH7PR12MB7017.namprd12.prod.outlook.com>
References:
 <PH7PR12MB7017F141EF4B1616C7ACC932D5B32@PH7PR12MB7017.namprd12.prod.outlook.com>
In-Reply-To:
 <PH7PR12MB7017F141EF4B1616C7ACC932D5B32@PH7PR12MB7017.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB7017:EE_|SJ5PPFA5F0E981D:EE_
x-ms-office365-filtering-correlation-id: 067133e1-0b20-4f4e-cf28-08df0c31144a
x-microsoft-antispam:
 BCL:0;ARA:14566002|51005399006|8060799015|8062599012|31061999003|19110799012|25010399006|15080799012|15030799006|25031999004|24021099003|2607281247196008|440099028|3412199025|102099032|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?keKqtWidB47pMrmirg2fUE+KV77tMtIWm4XnxmeKrMvceXxZ1H/1ejaWmi?=
 =?iso-8859-1?Q?GvdFsSlng+jrqu6qHWzCc8HgVJexNrAjTJi37WBGE88mKTeC3lZK7jDknr?=
 =?iso-8859-1?Q?18R3/zNPxIyi8ng6Y1kFTxpWXxED6ue4dNqh6Jvj/MIP1gQ3pM6vVZATuQ?=
 =?iso-8859-1?Q?GQWmRO2zbzClLXEsVHE8jXPqGWG+Fn90vne/Qvs2072E9N/CBJMVs4DACf?=
 =?iso-8859-1?Q?5Un60de/sRBgHjtXlBxVnBV46HvJhte2sRb58x/5ndP9oXAjJWxYj0dO+J?=
 =?iso-8859-1?Q?yld1WjnalsS76GDSIQToe2lWE3td8h5lszUpVj78guI40pTbKK9g7UXxc8?=
 =?iso-8859-1?Q?vwIdSZczRz7HSu0t5SZ5swlpxPQEnkTLJHLOUM8u9hCFSxBuWNebUbLreD?=
 =?iso-8859-1?Q?QHgihL83KYO05Rx3tcsXBDAKV3i8w18Fd0O8+fs861C9VVVqRS18lnFi7D?=
 =?iso-8859-1?Q?uESs248b1pnPX0MHnyN3jPDo5fdPOzy32a+2LMZhjOdX1piCxIdNdhvlo4?=
 =?iso-8859-1?Q?ZqJOGTm3j+1TTPMvEK86UXvlkaULQsrXPC8oW+OFiyn3ROA7p+Myp2/DQy?=
 =?iso-8859-1?Q?5WNirntXIlgpZVLLrCNoA204RcQ+nabPmGDCri9P+ihjANU/mWYNfxlRrM?=
 =?iso-8859-1?Q?yXFMZkfMXlTMtf7ePHIfOr76Rzan/LExFyC1gBZTnTPYcijfGUJwveiQ8t?=
 =?iso-8859-1?Q?3nXbjQXIn5auGo9VJRU1UZOe500dfN0JgNO3/Hgxa+ZV0R0eM16p3Trql4?=
 =?iso-8859-1?Q?MhLWQcu0hOzFsZNkrv6W42QfcL9d0fIlugBZI7O42dNL+A9rKHwW5S+xIM?=
 =?iso-8859-1?Q?L+6epY1rA4uFODtEvvdOtwbP29ierzBXIHle/VST1VwMLmya5CfC7b3u9+?=
 =?iso-8859-1?Q?H005pT5DwSD288RWrGpQehDb4fNfXiIVvNmhtHITbhzC+46hH5UuXKMHEV?=
 =?iso-8859-1?Q?hJoNdhmYFHZnNOn7XCSmvS6rq2bFFqLg7s7i+p1mz9yqijyYOOoH1ZFwoW?=
 =?iso-8859-1?Q?0aTWbmLmSquKAmu6VMv8qZEvZemo27rdu2u4xy?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?iGgHVJrg1C9ObUfPxUTqOt0dw7+aFRnf5GZDwp/2av33oW/d5mxkXzsiKt?=
 =?iso-8859-1?Q?PaCsf+B2SnhT7yTbfNWoUPRvDAc4+91L6sIqeiRmbe72u9BbMT49KzXXto?=
 =?iso-8859-1?Q?DuOvEdagud8hQ5LU1FVnKGa/Z/8S4WhFv4FEaM73vZOESFmUMvX91op3ez?=
 =?iso-8859-1?Q?QwTiDofSaELaqma7tncEfu7qtl3AiNpej2v6XInBONgtrKFB9J57ZHhtr5?=
 =?iso-8859-1?Q?vEK13JFp9QDGXL7Y/MbUXe3pBlGGraBejenj0Twno7IpKx0/3lxILXBToA?=
 =?iso-8859-1?Q?+YWDI2QCOvuXG+ydx2iaiLpgrHaXD9pxkBIz2UPfwRATaqjnUOxvDdvS5h?=
 =?iso-8859-1?Q?IdTxMdaw1/nmue2A7tTuVQlZrhu/NUffzFQBt4isjbMdnlTREr6AMKGgZj?=
 =?iso-8859-1?Q?7KSN/4OgAy943tiAWBjxuF7Xl8w0x0nkx/or4R3+YBf6y8Bfm9SB/HZRsc?=
 =?iso-8859-1?Q?tz9lZRtTP85hWXf/Ko1N5galBxTDWRdJKD7geRQtnruCf2u3o0bV8jqBS7?=
 =?iso-8859-1?Q?8Qx3bKEpS8DtNgzhXhM7lQbVQ+Ig9B8L+3Douip9eri25hILLgZicmjWKC?=
 =?iso-8859-1?Q?ewyx9HnX+mbkXD9z5VthybuDI2gpZHklPRR7sHvyaHlBRi30VwZnwIsu49?=
 =?iso-8859-1?Q?XhiX1PQ9qnsol2F+sX7HifOJC5d7O5hMxHhFmPXJiY+mXHbSPZ3B2bLx4X?=
 =?iso-8859-1?Q?zSlHI9FjqLMLxDKakQ5nWMKkqchkOGgjL+/1A7dj9S9GoujurXWmo81x1g?=
 =?iso-8859-1?Q?tPgHdp5bE/rygGztbf/0xYmi2I7fp4wtQ8SAXUj4Jmyjf2itnXmsiYQ9DC?=
 =?iso-8859-1?Q?XDdijwCj3iu7OKqT0y6LRQGm0LFPL48hYQPWFFdM2iApjSFAiC6cEmpOXg?=
 =?iso-8859-1?Q?7Ixy2eBzhnKvISXD95AMUDiWK3goGdHb99xuaOdh7sTGg7IPQfdYjQBEot?=
 =?iso-8859-1?Q?OLzL6Fr4as5LBhXQ99FPOZA3LcQA1Xm1dNEp84qdMu4EdYJs+GL0/jbqaU?=
 =?iso-8859-1?Q?BMyLPacPRVOAZMLUykZP35PeK85XxVMX8q814UobfnRbfKcbO9HWK+pFBJ?=
 =?iso-8859-1?Q?dKoK6Mp4sz1Ffk1T/96LSeF+9ukNMwzHlSzxlsuJSE6QDyZ+A2+3ZLroTf?=
 =?iso-8859-1?Q?/OkTOlp9sLrZJLwCjsa0E1V2Ah4hL8uFYf0JVjGn0j6pc6LGnvWqHjfvJg?=
 =?iso-8859-1?Q?vB3wbAVZHdHjrQJUOk5fPH6Z2j449Q7k/rboLB47mMjJpTohFx1aQk9PTG?=
 =?iso-8859-1?Q?BwjsyObpOesZ9kXRpRsz2/t8SEaUYa2wl5JShJYxs+qFyvaikMAsHbTU0e?=
 =?iso-8859-1?Q?Y0zUoT2CEJjzH3fMrL4R0AQGYQhb/fBpptjIqEKnUXgWSMYDNfGZVvwWMI?=
 =?iso-8859-1?Q?B9ypb2j8WpC++kq1abITHOkNyFyc0/7jyNcs72XPIoMb4r9aod+rw=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB7017.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 067133e1-0b20-4f4e-cf28-08df0c31144a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2026 16:08:24.3027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA5F0E981D

Hello,=0A=
=0A=
I am writing to you to report the issue that:=0A=
rtw88_8822bu leaves my adapter non-functional after the USB 3 mode=0A=
switch fails.=0A=
The device disconnects and does not come back until it is=0A=
pphysically unplugged and reinserted.=0A=
=0A=
Hardware:=0A=
  TP-Link Archer T4U Plus, USB ID 2357:0115 (RTL8812BU)=0A=
  ASUS TUF Gaming FX505GD=0A=
  Intel xHCI 8086:A36D (PCI 0000:00:14.0)=0A=
=0A=
Software:=0A=
  Fedora 44, kernel 6.19.10-300.fc44.x86_64=0A=
=0A=
With the default switch_usb_mode as 'Y', the driver loads firmware, writes=
=0A=
REG_PAD_CTRL2, and the device disconnects:=0A=
=0A=
  usb 1-2: new high-speed USB device number 27 using xhci_hcd=0A=
  usb 1-2: New USB device found, idVendor=3D2357, idProduct=3D0115, bcdDevi=
ce=3D 2.10=0A=
  usb 1-2: Product: 802.11ac NIC=0A=
  usb 1-2: Manufacturer: Realtek=0A=
  rtw88_8822bu 1-2:1.0: Firmware version 30.20.0, H2C version 14=0A=
  usb 1-2: USB disconnect, device number 27=0A=
  rtw88_8822bu 1-2:1.0: write register 0xc4 failed with -71=0A=
=0A=
It then does not re-enumerate. Waiting does not help, only a physical=0A=
replug brings it back, at which point the same cycle repeats.=0A=
=0A=
The commit 315c23a64e99 ("wifi: rtw88: usb: Support USB 3 with=0A=
RTL8822CU/RTL8822BU") states that when the switch cannot succeed, the=0A=
device "will disappear and come back still in USB 2 mode". That is not=0A=
what I observe at all, it does not come back.=0A=
=0A=
Setting switch_usb_mode=3DN avoids the transition entirely and the=0A=
adapter works normally at high speed:=0A=
=0A=
  rtw88_8822bu 1-2:1.0: Firmware version 30.20.0, H2C version 14=0A=
  rtw88_8822bu 1-2:1.0 wlp0s20f0u2: renamed from wlan0=0A=
  wlp0s20f0u2: authenticated=0A=
  wlp0s20f0u2: associated=0A=
=0A=
Additional information:=0A=
=0A=
- The connector supports SuperSpeed.=0A=
=0A=
- usb1-port2 peers with usb2-port3 per=0A=
  /sys/bus/usb/devices/usb1/1-0:1.0/usb1-port2/peer=0A=
=0A=
- Under Windows, Realtek's driver (RtlWlanu 1030.52.1216.2025) runs the=0A=
  adapter at high speed on this connector and does not appear to=0A=
  attempt the switch.=0A=
ACPI reports the device under=0A=
\_SB.PCI0.XHC.RHUB.HS02; the SuperSpeed node SS03 exists on the same=0A=
 connector.=0A=
=0A=
I am happy to test patches or gather more data.=0A=
=0A=
Best Regards,=0A=
Aditya Srivastava=0A=
