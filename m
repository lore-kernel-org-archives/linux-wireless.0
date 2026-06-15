Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE02223DFB;
	Mon, 15 Jun 2026 01:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781487710; cv=none; b=nYM03ozmpnOg1qq2IXmtNjJ+iCyQxJKWMOF1NBK7x7nZMfNOwik9NrqMttizJSBY9ctHdTqc6GPFHSsNUzyP/QGThugdh+W6264YkkhcM6R7rexyhe7M2dhwDp8tnl35iOBMeDQz0so6jsqbxXoa9r2nMC4lMCeuIHsj46APNAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781487710; c=relaxed/simple;
	bh=spMW0Sxc8Z4hzyaBNABTIpy5N9Kplp/47JzZuuaLzGk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cAkijo6jNr9aXuwmPEJlEVr8KeLNsQyXvsHy3ZvTp67zGshADZV0bcfXcbr2wezRlV6BKYFRo5CJY6RZLe6EK+7wFaSKaTD8MJkMASUPJr5R3+F1NEhGDnVgJK19cMdjJFcUaNztmjwXMt97w+apAXBH+3sP81nkfaUYJmxEhzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MBOEvbq9; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MBOEvbq9"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65F1feV93393303, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1781487700; bh=cjMk7fWbRRVZRH7SbP4xYWCFTIFImYoWdtieT+ZDbxc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=MBOEvbq96jkLFZ1nUCJ1+ylA1GD+1hkYW8NtRoKQB7ENVgvpnqp2x3nNxga07t3Bs
	 7f+KlSkoC/tVnTY03MS7CYHzIAUQjBt7P8bJYX36OAUvsbKT9TY73S9jLaqFC+bUHI
	 b3z3iTLCm2I8NRzQbltQYvbcqyLlzoweTnga9Z7nD0hO+PbwGvIULIGGqF2qiCWr3b
	 mVzQy8UaPhRNNMMzHI0E1wr2MnjbrUD7QzTSSLXfmSxPjGc83yaqr2dFNW+sm+9R1/
	 0xUTtSpbSfHK8NNREng/oNTcTKX4uKGUl0uCvM6kwO89ceKesC7IsZzxW+kKHYVD9L
	 YMyhcqIMQm6Qw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65F1feV93393303
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 15 Jun 2026 09:41:40 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Jun 2026 09:41:40 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 15 Jun 2026 09:41:40 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: William Hansen-Baird <william.hansen.baird@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next 3/3] wifi: rtlwifi: disable ASPM for RTL8723BE
 with subsystem ID 17aa:b736
Thread-Topic: [PATCH rtw-next 3/3] wifi: rtlwifi: disable ASPM for RTL8723BE
 with subsystem ID 17aa:b736
Thread-Index: AQHc/AV/IKHRv9u+uUC9TTRlRkHg9bY+1wlA
Date: Mon, 15 Jun 2026 01:41:40 +0000
Message-ID: <eb874df08873478b8f2ad373e8b2ca05@realtek.com>
References: <20260614135508.70307-1-william.hansen.baird@gmail.com>
 <20260614135508.70307-4-william.hansen.baird@gmail.com>
In-Reply-To: <20260614135508.70307-4-william.hansen.baird@gmail.com>
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

William Hansen-Baird <william.hansen.baird@gmail.com> wrote:
>  drivers/net/wireless/realtek/rtlwifi/pci.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c
> b/drivers/net/wireless/realtek/rtlwifi/pci.c
> index 03b743809258..bbcd1922acb2 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> @@ -33,6 +33,7 @@ static const u8 ac_to_hwq[] =3D {
>=20
>  static const struct pci_device_id rtl8723be_aspm_quirks[] =3D {

Please change to rtl_aspm_quirks[] by patch 2/3.=20

>         { PCI_DEVICE_SUB(PCI_ANY_ID, PCI_ANY_ID, 0x11ad, 0x1723) },
> +       { PCI_DEVICE_SUB(PCI_ANY_ID, PCI_ANY_ID, 0x17aa, 0xb736) },

As opinion in patch 2/3, fill VID/PID "PCI_VENDOR_ID_REALTEK, 0xB723".=20

>         { 0 }
>  };
>=20
> --
> 2.54.0

