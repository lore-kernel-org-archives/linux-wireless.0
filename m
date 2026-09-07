Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3F11DFDA1;
	Mon,  7 Sep 2026 01:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788743661; cv=none; b=UDvEESWPmCc0J8OFWTSpJrXvt0wJKqWyfLiigCRa3T9nbv65CjN2hSmeqt9sbtR7tlG8UY56LgD07+CPT8c2/Nl3kuTXzS/H02tbWPu7xJLp89E6tWTA6+sL0V7TFD5cCrNHeXxZRR/nXAamHlhSeb3/FezgblfKuC07xded2f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788743661; c=relaxed/simple;
	bh=mQ/NFX3OWHDPTTN2qSz0eR62Bxai0CIXC1ubEn5GnCU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hEsD9j6o59WjUKUUesRJ0qW3viR5AVj8Agnmv8t3XcCY9rZVCDO0mAubXZRaieROL4dK9Sb552W+jC5uvTOfIYKDLzLFuXmy4lePOluxcmFltV1wrU7CzvkHac88xc/Qf1D1PqZq4TT/UIp1a8Qv7oMnbOFsDuJ/GiHe9xWIbkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DjQzDdF5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DjQzDdF5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6871EGjhC2364427, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788743656; bh=1UZu/SlL0XT/AsyldKNZygQ6J05BvkN7BYU6/vWHY3I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=DjQzDdF5GN5V5zrRAKyX7W4Z0XJu3xPVn/qM7MjR4LIJoMPMMFx7qe0zArEn6WbPm
	 hE9ykLBtA49RPDK2JXb0nkpBJLATinfAg/LxTu271mZ4xMON/wcZUyzsPLfIDu5qvW
	 b3s8qlbbeTG+iV9CcSy+kJmtHfRy8adxNqO2L/oTDaqvJZkshGfwTzAYIUUqRh7ofa
	 7zjREES4PII3OdT7/+8FLcJZ2f+i/Q63nuQ3CV87CMCzXdCnIo8+WkegFY3qlvQCot
	 vv9ylZd5vUK9kfrwPmrat3hK+pxOQAIXLrgCtCQt1a9iLPEPIwzp70DdV8zZ1E8D2Q
	 wxhpTvPlPbBRQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6871EGjhC2364427
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 09:14:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 09:14:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 09:14:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v8 0/3] wifi: rtw88: rtw8822c: refactor DAC IQ
 calibration to s32
Thread-Topic: [PATCH rtw-next v8 0/3] wifi: rtw88: rtw8822c: refactor DAC IQ
 calibration to s32
Thread-Index: AQHdPR4mQMy41+sfwU2Rhnm6hm2vQbbCUYgA
Date: Mon, 7 Sep 2026 01:14:16 +0000
Message-ID: <c1cd0eab60cc42ee8fde834f1df1a16e@realtek.com>
References: <cover.1788601784.git.ulijg308@gmail.com>
In-Reply-To: <cover.1788601784.git.ulijg308@gmail.com>
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

Arsenii Pashchenko <ulijg308@gmail.com> wrote:
>=20
> Testing:
> - Note: The author does not possess the actual rtw8822c hardware. Actual
>   throughput and runtime performance verification is left to the vendor
>   or community testers.

Though I have acked all patches, it is necessary to test with real hardware=
.
I'd wait for someone can test this, and I'll also arrange my time to verify=
 it.

