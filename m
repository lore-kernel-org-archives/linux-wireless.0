Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D62A3515D4
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 01:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789867344; cv=none; b=iTU1KVOpp4qI2a0FSvvWLWABGZBDY7PzSSeuaKgUQCrchX2SdyYb2WXRFdHYO1uB89v5qAztrEjh9zRR0f2mGCAYlOazBruw6qdvDWQy9m0GrN8C55XToK57NCEdRBBJZn8hBJyRvHlIxa9Xz5vdWviGLxaYDDooWVPkslMNnR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789867344; c=relaxed/simple;
	bh=LrNTFK8WH8twmKkGuYzuLKuuRf3a77N0UhNxEz92YwU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZGMVcsaNCK+ah+oHx2ZfOhrH3ZMYmVgd2nMnk45Mpby0AISn3DSBJQZkGoFBUikn6YHacYDJk4Yals2KZlcMLPJ9F4n2u2WAVg5kopQ7ydbYwx/BKxqNtzSkTcH/kgcctAtAxohdbY+23R8ga7P32WPmmcf+KjREV1Vbp5lqoNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IH7o2zeS; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IH7o2zeS"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68K1MGpoC1325635, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789867337; bh=DQi70DRvk7LZlRqc6HokaFdDP/Taks21qmvcGClHyuM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=IH7o2zeSK6SmEEVF2ZbjioWOzR+q67vfqabNBCv43hK0UuJ1VwIDyMDiXi9A+wHU2
	 eq5HSvI6tInfuf/DhvCX/vtO+QHepDBK9neGPmi1xokGdPy0fAjkL82cm0mj1RfCwZ
	 95ASXfK159RnjhCJlw4bkH8unrv2wv/7kgoW1gnegce4ZEFrq1YuHEc0OfLBPi+LQe
	 QbAg5eNROjT5CE+4MEpGhWu2wj4vwDVCrnAm12VIzc8Y7PGBiuYMBdzOx8rqGeEulz
	 bTinA2RmlSGRaIgsC7eizM1BNZJraFdw7brTJllEv7AWKT+KX3JwRjSyiugnckDH+q
	 Q8ceZDnvqqRoQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68K1MGpoC1325635
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 20 Sep 2026 09:22:16 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 20 Sep 2026 09:22:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 20 Sep 2026 09:22:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 20 Sep 2026 09:22:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Paolo Lazzaroni <eexto@aol.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: 8821c: Add HP single-antenna quirk
Thread-Topic: [PATCH] wifi: rtw88: 8821c: Add HP single-antenna quirk
Thread-Index: AQHdQdWXUlvmBxMEWUiMWC9yQBgQJLbLu3PQgAiLMICAAnIhsA==
Date: Sun, 20 Sep 2026 01:22:16 +0000
Message-ID: <4486aa8a910246deb2eef5ff392f9f37@realtek.com>
References: <3b3788a7c4f240899e630938a6c7b472@realtek.com>
 <20260918195927.30118-1-eexto@aol.com>
In-Reply-To: <20260918195927.30118-1-eexto@aol.com>
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

Paolo Lazzaroni <eexto@aol.com> wrote:
> > If this is the only one platform which needs this kind of quirk. Add an=
 entry
> > to rtw_pci_quirks[].
>=20
> Regarding rtw_pci_quirks[]:
>=20
> The reason I matched the PCI subsystem ID (10ec:c821 [103c:831a]) rather
> than DMI in rtw_pci_quirks[] is that HP assigns this specific subsystem
> ID across a family of laptop platforms (e.g. HP 15-da, 15-db, and related
> chassis) to denote the single physical antenna connected to Aux/S1.
> This is documented in the OEM Windows driver INF (netrtwlane.inf):
>   "PCI\VEN_10EC&DEV_C821&SUBSYS_831A103C ;;single ant(connect to right on=
e S1)"
>=20
> If we use DMI matching in rtw_pci_quirks[], it would only match this spec=
ific
> laptop SKU ("HP Laptop 15-da0xxx" / "4XW76EA#ABZ"), leaving other HP mode=
ls
> sharing this identical 103c:831a single-antenna card with severe signal l=
oss.
>=20
> However, I understand that inspecting PCI structures inside rtw8821c_read=
_efuse()
> violates bus abstraction for rtw8821c.c.
>=20
> Would you prefer:
> Option A: Keep the PCI subsystem match, but handle it cleanly in rtw_pci_=
probe()
>           (e.g., setting a flag or rfe_option override in rtwdev before c=
hip setup)?
> Option B: Add a DMI entry to rtw_pci_quirks[] matching this platform?

I prefer option A, but yes, please handle it cleanly in pci.c.=20
You can flag a quirk at pci.c, and update rfe_option in 8821c.c.

Ping-Ke


