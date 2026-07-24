Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA1719A288
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 05:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784871264; cv=none; b=d8cGBkDgBYfr7UPM24IV4SQY7fwv9TmpgfrdxP9P+hn0lHuqezc6cP37FG2ENQhDqX8AzQ/m01crFrRdTjrAaX8L1R2VwNblI6Pu9299mw6EPpqYoCl0PXH4eKZ4VHfM72KtNmTpWidS1GAM+V6thUzr+TReCRtu/ZBERU3VhWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784871264; c=relaxed/simple;
	bh=EHZXgbgTpqX/rj9O5f7+q7eMtfPoCrFpi+9viAe8wNk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tMkf2AL4SImqIIvzmZ/QXI7KLk7ohvrK1cxXux66kAfobnfZwID6NRdHfqdUY/591lkbwkAOn2fVvsh/3+BeceJbjhjt+B0wh0lxydoZ3dycUoGkoQ9l0N30FSNsitP/fzWtOO6NYgiL1/O+IaZSwOnh4WC89Z2+sSpgYIyKdd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SLkjbRqq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SLkjbRqq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66O5YIxI4994660, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784871258; bh=EHZXgbgTpqX/rj9O5f7+q7eMtfPoCrFpi+9viAe8wNk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=SLkjbRqq6ZRgtF3wQzf/vtGQdwYUFb7acVf6Y/GGF610tpUX/ibcvzqjijEOSvsh4
	 VQJul5YOf7njFmMvLjgKORW1hEmpxPjoKud8w0fd8j3piTfSJqO9GkhdOywGk1surt
	 nmCsZqh8AjNI3tsLuvJ0YCrO2FSqjig7rG8SoIMTbfDCKyREWninwinQ6oMLuPohbv
	 3IabwvBQzGSjF/xRkymHb/FfuBh6Cy5EKSfW2N/wjs/g8FbrbACnzyI3fjJwEioX/v
	 UZw0oDJ7kbCh45xFQTVOFjzJmNfsEVizlaqmjd0545sa3fmCwtOkUCyHOPEjfKKF0p
	 UP7SHf4NZXvXg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66O5YIxI4994660
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 13:34:18 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 13:34:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 13:34:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Fri, 24 Jul 2026 13:34:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "stf_xl@wp.pl" <stf_xl@wp.pl>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtl818x: initialize eeprom_93cx6 struct to zero
Thread-Topic: [PATCH] wifi: rtl818x: initialize eeprom_93cx6 struct to zero
Thread-Index: AQHdGpUkd4m9kAYCzUe3BE9bOej5YLZ8Jt9g
Date: Fri, 24 Jul 2026 05:34:16 +0000
Message-ID: <b35f64c478a64e2d8b9d280bed6f0c86@realtek.com>
References: <20260723110640.8588-1-stf_xl@wp.pl>
In-Reply-To: <20260723110640.8588-1-stf_xl@wp.pl>
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

stf_xl@wp.pl <stf_xl@wp.pl> wrote:
> From: Stanislaw Gruszka <stf_xl@wp.pl>
>=20
> Commit 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra
> read clock cycle") added extra 'quirk' field to struct eeprom_93cx6.
>=20
> Many existing users of eeprom_93cx6, including rtl818x drivers, allocate
> the structure on the stack without initializing all fields. As a result,
> the added quirk field has an undefined value and can randomly cause
> reading wrong data from the EEPROM.
>=20
> Fix by initializing the structures with {}.
>=20
> Fixes: 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra rea=
d clock cycle")
> Cc: stable@kernel.org # v6.13+
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>


