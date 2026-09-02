Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3B92F12DA
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 02:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788317855; cv=none; b=Edk+c5qGvVV3VY7j4Wh/8oeTZfAAt7Wk4L4cokhBroBKdECNhR1P4mcWpAbOIHR8LbrI9r4VNmg1pmDtYoQ57iIiyeqinCjelrollJrbliaW87oNsu/JOYz943IAgnyLsBGiWIs0qqwAsPdG/XsUbJOoonRSFpvLNEIjSg7GYrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788317855; c=relaxed/simple;
	bh=WQo+3pjU1ZHdkNxPs3psOGE7ipD7yxN+qxWA05EWk4E=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=Ae8vqt3570kTjCoO1kq7nQIjPpXvFTApb4loSABH+6+SuSLLx6vXyw8OfM2AjFHKMBgfZSxnQ5b0UuvVnp4lb73uRhRKwbManTNbolF8A8tV7pRxv3tA2MoQnaRL9T1WmYPc9lRW3g0HU6wdcIwc0JasXSHOtZQrnK7mF2fjs2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=rkWi5i4J; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="rkWi5i4J"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6822vSBV12266264, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788317849; bh=1e4CeXpxEq36BUpLf8PEYemMYniB+R3V3bBtitq3AJo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=rkWi5i4J4hcGSdqYO2amfy98BqlSXGB6l8ak52O3avLIv14XvUoxnsk7ZBIsYarwm
	 OxoOBMexpBM/WBe27GB7wJG6jBK4dSUsvH4AesaOwyma4XzKUVrFecfala9EOVEn0x
	 klPFspnFVSKT4lPLUykXDGBrIJBiiSEzzAxZqSM+oX1U1l1LUsw9Mszv/s0W4yvm95
	 vBZ1NhN9fkGCO+yf45pZdImAQ1C8imtTsIlAQyoVcuQwXcqZM29cD2Clab6rVCEumd
	 bJcPgnMmCBKf7pdioFatW/owxJ3YaXkqLkakOh1ggEWKV0+MGHNivJPb/WsP5PtY3Y
	 cj9SKYCMg0jYg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6822vSBV12266264
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 10:57:29 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:57:28 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 10:57:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH rtw-next v2] wifi: rtw89: usb: Avoid crash with dynamically added device ID
In-Reply-To: <7a537b2e-67d2-40fb-8ef2-fcbc7bbc93af@gmail.com>
References: <7a537b2e-67d2-40fb-8ef2-fcbc7bbc93af@gmail.com>
Message-ID: <7da776f9-bbe1-4308-92ef-2a394bdc551c@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 2 Sep 2026 10:57:27 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:

> Adding a device ID via sysfs causes a crash when the device is plugged
> in, because the driver_info pointer is null.
> 
> Check for null driver_info in rtw89_usb_probe() and add a wrapper in
> each driver to pass it a reasonable default value.
> 
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

b18272271768 wifi: rtw89: usb: Avoid crash with dynamically added device ID

---
https://github.com/pkshih/rtw.git

