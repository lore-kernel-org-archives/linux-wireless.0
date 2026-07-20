Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF32257827
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 01:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784512520; cv=none; b=DFc0AQtJO8ik2aZrrKJsrPpp0sw7LXBJ4mh3gH/2YtBuRAh2xqR1bBZhJHk7E+Z70zfNeU7jUeqz22xXPc1V67BZ1/sKXumMAX8z8AEHZAXkiyqquGH2YukqThW+wkyKs0b8ozUFC8883XlUeKWq9qJTcST8UwXcZTSvYj9rPrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784512520; c=relaxed/simple;
	bh=5Jxa1GjCAHTL/btreH6KaGWupKCe5HDzqyvw4pg/D3g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aVSIHj+QTYzxRfm4u6FxSoi5rE/OB+gsd4rbjzW9K2tOzznhbUptAzzXM2xttYtGN9aiguH/vaXBIcHBHDijIMVaKcgLgnOrfzjlytGXe7SiqXZJKKHiukEMe9ySDggNv4b3z/tPD6BSmsZbuoBhL9xq5YLvpHk3ocee+cooSoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BBaXiK5s; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BBaXiK5s"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66K1tElbD2111289, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784512514; bh=j9exp6SFg6JZGIP98WhagC0rL3621PW54cuXichR684=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=BBaXiK5sedJBJ4OQIsZTzSVHDubKJGXlb4Nite0MIhq9ViBmC8NWqCO0+dkHKVSN8
	 8ohOQ2NeyS6OTgShsrUZTkePs24WIargICyEOjH1XLFXLpYEcTE5nOZI8PGBf4+o0d
	 WLMLYrD9xRHj6bEU5GWMErsFrLZMU7CHYjiEEB6syJk7MPYE8dpgOFWuJI3PCv1GfN
	 GemhbA00suaYKIBuNa0tlOiA7+gJa+qpNA1l7hwL815L+cEFeyKYr2lkKMDuK1fUj4
	 qm9u0uDsWj0ulgtUInKlk7Rx2SUzphUhoiEyMmSRIMuw69sf5YBWoNvYqfMSF3dxaO
	 +k3V+TZNRvHIQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66K1tElbD2111289
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 20 Jul 2026 09:55:14 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 20 Jul 2026 09:55:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 20 Jul 2026 09:55:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 20 Jul 2026 09:55:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mihail Dimoski <mihaildimoski@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming
 A15 FA506II
Thread-Topic: [PATCH] wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming
 A15 FA506II
Thread-Index: AQHdFrMUNt/jfwrNk02rEoiwniDEY7Z1p/yg
Date: Mon, 20 Jul 2026 01:55:11 +0000
Message-ID: <cfe2784323f04c2881c4793324fe0b12@realtek.com>
References: <20260718124045.23493-1-mihaildimoski@gmail.com>
In-Reply-To: <20260718124045.23493-1-mihaildimoski@gmail.com>
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

Mihail Dimoski <mihaildimoski@gmail.com> wrote:
> The RTL8822CE on the ASUS TUF Gaming A15 FA506II wedges during normal
> use. The driver watchdog toggles PCIe ASPM while leaving power save;
> the DBI read of the ASPM link-config register fails with -EIO, the PCIe
> link becomes unstable, and the device drops off the bus, taking Wi-Fi
> down until a cold power cycle:
>=20
>   rtw88_8822ce 0000:03:00.0: failed to read ASPM, ret=3D-5
>   rtw88_8822ce 0000:03:00.0: firmware failed to leave lps state
>   rtw88_8822ce 0000:03:00.0: mac power on failed
>=20
> This is the same platform ASPM inter-operability problem already
> handled for other machines through rtw_pci_quirks[]. Disabling PCI
> ASPM and deep power save on this model stops the failure. Add a DMI
> quirk so the workaround is applied automatically.
>=20
> Signed-off-by: Mihail Dimoski <mihaildimoski@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>




