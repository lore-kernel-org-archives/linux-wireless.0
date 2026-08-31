Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8D038BF72
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 02:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143362; cv=none; b=j2msDyvHb1Q21r7IuMeObK+glcOKsNTuvDj2k+w8GV6MWDRM1CuXXUTu9UXk0zXO7AtEwuunN08tN031J9Rjr2sSWR8Atr4YKoLQ5zzEpcHPByP5xAfIyG95kmdkKBchcl02iu+jlDCPr4EvvVIxJtD1f28CHSIA+MTkBcYN8b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143362; c=relaxed/simple;
	bh=j6PukVoK69tyLjFUWXGGDNQQJyXw1D5kpxMwakrjkCs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HcVqPxHIXUdbiaAhsNM+I/ey9yB1nP0P3Nbq7BX1jFEXQZihGsy+ZCf8kQNb6ck6N+cOWjuchzBOiOnjHOnbPA0/rYqs6lRhJ+hN+QKR2yEMqvH49SVbyL7vLIM2iO2p3s1I3LGn4IQRJ6wFVNcYImADl0waQauDmo7g0C/TXFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QrFaeEpJ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QrFaeEpJ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67V2T1jU4374257, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788143341; bh=j6PukVoK69tyLjFUWXGGDNQQJyXw1D5kpxMwakrjkCs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=QrFaeEpJXjzbyxT5dCi6zDNkn2p+7CeVMmyBIN4+PGtQcQkNyPMBMDBtnRsUHKLnS
	 AyIZXSXv4FcFbfGWWqJ7kJGr5+/0Smuc0TbBOrTqk6Zs1n/rZCVC65rdsEdBMsnMcx
	 fId5FKZ0GwQ2yH2hylD6qklXnbkU+JQgQKw2gkYZzNqxdwQuLAy8iRt4RZGMozUHE2
	 pJUZcEj5LZ3QPnYLtt1QWIbUput74+gXfOe6/J0d9m6G8vUFBKi4JtHud79y8Wn5Th
	 LkvLSMj0UphAiKtriWOEfqJ31kuBeUvLFS7oMD08kbgMJtuNB8y20Vn7R/cL+uIF91
	 fa847bzWOhoZQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67V2T1jU4374257
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 31 Aug 2026 10:29:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 31 Aug 2026 10:29:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 31 Aug 2026 10:29:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "nick@venenga.com" <nick@venenga.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "tyrelpark@gmail.com" <tyrelpark@gmail.com>
Subject: RE: [PATCH rtw-next] wifi: rtw89: 8922au: Add support for TP-Link
 TBE400U
Thread-Topic: [PATCH rtw-next] wifi: rtw89: 8922au: Add support for TP-Link
 TBE400U
Thread-Index: AQHdN80rK32yGe896kGQhQYx9KMSVra3cUjw
Date: Mon, 31 Aug 2026 02:29:00 +0000
Message-ID: <ee4729cf13d349ca90d73ee20f2030d1@realtek.com>
References: <010f01a04e02d70c-a52abf35-2e60-47a5-99f5-b064b344ac19-000000@us-east-2.amazonses.com>
In-Reply-To: <010f01a04e02d70c-a52abf35-2e60-47a5-99f5-b064b344ac19-000000@us-east-2.amazonses.com>
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

nick@venenga.com <nick@venenga.com> wrote:
> From: Nick Venenga <nick@venenga.com>
>=20
> idVendor=3D37ad, idProduct=3D0104 TP-Link TBE400U (USB-C, no external
> antenna)
> idVendor=3D37ad, idProduct=3D0106 TP-Link Archer TBE400U Plus (USB-A,
> antenna)
>=20
> https://github.com/morrownr/rtw89/pull/123
> https://github.com/morrownr/rtw89/commit/c98e6ff31c331be35383b5a500cfaf76=
620e2d0c
>=20
> Signed-off-by: Nick Venenga <nick@venenga.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


