Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F7014BF92
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 01:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787533940; cv=none; b=Xuea6RiY8QWck6hayjDEd5B7G2vIToAVDrpL6SEb3mDDkzwM9Tb7sqb1lD5i25dmw75k7rfgTVsVbCZ2J5Mg+GFGwUf4hzwvcuYoTg0hka3Ea/yNgZegLuW53jJFt6RLR6OKE9yVnd6Cx8tNZj8Cg4g6f9v2zcoqR7KforfvMSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787533940; c=relaxed/simple;
	bh=+socscwONWdaNhAFvTAER7ELx6vBc/tIelxpgPU+zH4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=plDxanDfZcbBacwk4gADrpgXa/Qg/5rfH0syEj9vgus8eaDptI1FT5UUEqNhgACiaKeLhHlgLTCoIttDkjIe+swYx3P5eOsjiptP+ldgGuGxhD7381aYuULYEVGZ9SZ4/UTHHV/yrKLA2rG5TwdlTccbYDHba9Y2sDQww0ALj6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Pmj1X5wc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Pmj1X5wc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67O1C43R02339534, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787533924; bh=y4vMp5BAXC7MHb97MSUYv0QKHv2/ua3cRuqRDWCbZDY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Pmj1X5wca/6p5LSuXpvDW0pJZl4Cgg3Kuzm2yc7pGrtzO8EjPF3cD2bq+VOabsAt3
	 Tcv0u5u6dr4Siy1ViY4y5S7rTAq/JwkcYGcuq1vu9rxgBDZSkiQDWcgOqPYdFUzMHn
	 F45DBasUW/N09NRKQnzGQk9RmRo2O2rm9B6MtbA9dEeJoDWH38bDgNoXWwObG5Shjc
	 4DZumNBGRSnMMt2b24OislcDO4Ik5gLMZbtcN0p3MzyeyPPGUg3VqJbVtnKYNfx+/1
	 fH0DTIJAi5Uj/IU8W3CClPbgpzN1v3NvXQYRVUhW3pX7c+P0BN7ZAd/3kzxO8CX4oa
	 P5qF5PATgEknw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67O1C43R02339534
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 24 Aug 2026 09:12:04 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 24 Aug 2026 09:12:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 24 Aug 2026 09:12:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 24 Aug 2026 09:12:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Branislav Klocok <branislav.klocok@orava.sk>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: add quirks to disable PCI ASPM and deep LPS
 for Dell Vostro 15 3530
Thread-Topic: [PATCH] wifi: rtw88: add quirks to disable PCI ASPM and deep LPS
 for Dell Vostro 15 3530
Thread-Index: AQHdMxZrvh3nCaxdtkaVx9BHev5th7asZN3w
Date: Mon, 24 Aug 2026 01:12:05 +0000
Message-ID: <6d7622a04f8049d4a3ec1f42ec1a03da@realtek.com>
References: <20260823154228.129848-1-branislav.klocok@orava.sk>
In-Reply-To: <20260823154228.129848-1-branislav.klocok@orava.sk>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Branislav Klocok <branislav.klocok@orava.sk> wrote:
> On a Dell Vostro 15 3530 with RTL8821CE [10ec:c821] the driver floods the
> kernel log with
>=20
>   rtw88_8821ce 0000:03:00.0: failed to send h2c command
>=20
> at roughly 220 messages per minute while the interface is associated. On
> this machine that amounted to 143704 of 167707 journal lines in a single
> day, or 86 percent of everything logged. The association also dropped
> its DHCP lease from time to time.
>=20
> Disabling PCI ASPM and deep LPS makes the messages disappear entirely.
> Measured over one continuous hour with the card as the only route out
> and 979 MB received / 341 MB transmitted: zero occurrences, against
> roughly 13000 per hour before the change. The only rtw88 lines left in
> the log for the whole boot are the interface rename, the firmware
> version and "enabling device".
>=20
> The measurement was taken with the rtw88_pci.disable_aspm=3D1 and
> rtw88_core.disable_lps_deep=3D1 module parameters, which set the same two
> variables that rtw_pci_disable_caps() sets for a quirk entry, so the
> result carries over unchanged.
>=20
> DMI on this machine:
>=20
>   sys_vendor:   Dell Inc.
>   product_name: Vostro 15 3530
>   product_sku:  0C32
>   board_name:   0RRJRM
>   BIOS:         1.3.0
>=20
> Signed-off-by: Branislav Klocok <branislav.klocok@orava.sk>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


