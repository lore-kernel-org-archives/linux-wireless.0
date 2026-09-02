Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1736528F5;
	Wed,  2 Sep 2026 02:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316435; cv=none; b=igvdYRoJt4WamO42FOAiMNiDZ2ai2X8HyciR5BluJ5J7R5SXX+O6uxJITjrl4Ze3bFN9EmJVFiELgX4xKrUMl7gz8A0hnZDOY8jjgc0q/j45giJXuhpdnhRRqrJLJwZ60BefNjebNBoA0+TgerJ7a736CmVskecR7bVWVjIg418=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316435; c=relaxed/simple;
	bh=W5JVoYYq+L7KF3jKRu3beQsIJJNn4rMSk8rsaYm43cI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IvVvRZ9diXoDKyMYjB6hXH0aCTzYeS2RXLzWtnOT+xCqx9LJXtN3I6W/kDynVAdGQERHV1Z2ain5gvxaXzCNm2UJdlNxKkcvA6oJWNzP16/8dbyxChoydNX6OMP19MiRDzgAyFaQJ+bM90lECdBgvE9acP9NvaDb0gPI+lW918k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=n7CJzZmu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="n7CJzZmu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6822Xi5gA2248745, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788316425; bh=utrlhcbIN9C7yKDYBbWYNQqvIX9DffW2TALU/H0gSVE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=n7CJzZmuZfQvgbWxdo+FS/Rzm7a5748bWxnsBs6ilUyX5iqNoxBLgSSmhGIBNJeNs
	 /KqKjc8vhqnQrYXTHJ0OgvkfM/1VOF0BoId9qR2mZXNCCeakWmL/Q9nir40QsGLrtD
	 PSRo4uyIQZYTaEMrF0Kocp+HigRLnUimJzKSYZpsmPFU+FBHRKAxrP/BkTDJTplYlr
	 0kI74VQDVs3Z/pGUtiWegoTHs3QRqA0OMNG6cKpnHfEHX8ng6hVm40XnyPVAigBfo3
	 khofd6YwhAxm1q16x1rj/5ExIH2AdouFYwVBakgcWs9IsGuGk+sdvHWwLo3t4coQmH
	 KceMy6z51siyg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6822Xi5gA2248745
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 10:33:44 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:33:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:33:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 2 Sep 2026 10:33:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "raspberrykan@stu.hqu.edu.cn" <raspberrykan@stu.hqu.edu.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: use firmware MAC address as fallback
Thread-Topic: [PATCH] wifi: rtw88: use firmware MAC address as fallback
Thread-Index: AQHdOg/rKigchPTsY0+A+iPeLR6Lhba6fQxQ//+JlICAAIsQYA==
Date: Wed, 2 Sep 2026 02:33:44 +0000
Message-ID: <57178758e2d9499c9582d4bcf821f2fe@realtek.com>
References: <20260901124551.3921506-1-raspberrykan@stu.hqu.edu.cn>
 <4d1e5555bad84badba213f11b431c762@realtek.com>
 <SEZPR04MB617269B16E24E662180A7678FFB72@SEZPR04MB6172.apcprd04.prod.outlook.com>
In-Reply-To: <SEZPR04MB617269B16E24E662180A7678FFB72@SEZPR04MB6172.apcprd04.prod.outlook.com>
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

(Please in plain text and not top posting)

raspberrykan@stu.hqu.edu.cn <raspberrykan@stu.hqu.edu.cn>  wrote:
> > Please share the board and WiFi chip you are using.
> The board is a Xiaomi Mi Box 4 based on the Amlogic S905L SoC, and the
> WiFi chip is an RTL8723DS.
> On this device, the actual WiFi MAC address is stored in the S905L
> SoC's eFuse rather than in the RTL8723DS efuse. The platform firmware
> provides this MAC address to the device, so I am using
> device_get_mac_address() as a fallback when the MAC address read by
> rtw88 is invalid.

Please share it in commit message.

> The kernel tree I used for testing is also available here:
> https://github.com/Raspberry-Monster/linux

I see the top commit of [1]. The mac_ret is also missed. How can you
test it?

[1] https://github.com/Raspberry-Monster/linux/commits/rtw88-dt-mac/

