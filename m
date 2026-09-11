Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A084CA6B;
	Fri, 11 Sep 2026 00:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789087545; cv=none; b=IZvGv0OHygH1TU+2GhKqVJ9Wvh4kLKOfOTIIkxngWURcVeYxZWdr7wwUuber+ghrUc0eDFHEc5TX2w/R9SjXmUHixbEJKFOVTNSb2hriXBpZ+0XB2J8vMPL7PVW8t3AT+uSbBV6EWv0yL75yElYAKOiMf7P6K+CwhxCFUv9yrWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789087545; c=relaxed/simple;
	bh=F0w1OuP3Vm/DJZ9MetDFv+V1Qh7Geb0OkKEf1ZGeVlg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EXeClilZzEOzVCidNV1QyWSrrI9FXInVv4VltOyMFQ5n2Mj5vzLKSfcJO9fOdJPrvTS3JcRkJGB23+SGfKIZJoEnoXZg2qRuDaZd1Zx8XKe2rUUvZXQ1DH9QWq4I0zcvJr3G7uYIWuzKlZXdVAz2BR2WsQGuhNcltaVsLS/AuQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IJ7DF3Wx; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IJ7DF3Wx"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68B0jWBB11991306, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789087532; bh=F0w1OuP3Vm/DJZ9MetDFv+V1Qh7Geb0OkKEf1ZGeVlg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=IJ7DF3WxFtb0x7Wx5gDg79Oznj/H5AdNyYLJWgrqh5ZglEoqx7MBrO6Tg2akjyfL8
	 lQ+fHM1LJgZ9ltPEN9IEOmqPZb7/KCOtPjOd3JKviehy3e7IZP2GVyQwqx7C+ngtt6
	 uJ/+xCH36ZoX4pG417zcsqavBlTe225eOmF+0BmUG0HdWnnzlyJGFbb1K8zL14FLEX
	 m5PVoVIc3GeEOhVvLzbxWgi3WXwuA5gUFWqU15oIcnu/bXDdHvssV4Ts47DLiTehtT
	 5p9UxACtiCxxgkjfeOBaEyhk7OIJmDcMXxB+7VjwAFaeSXgC62kXqMkqwUeuhdeTF3
	 PQ7Se8TWJfx9Q==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68B0jWBB11991306
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Sep 2026 08:45:32 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 11 Sep 2026 08:45:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 11 Sep 2026 08:45:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Fri, 11 Sep 2026 08:45:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a TX
 transfer
Thread-Topic: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a
 TX transfer
Thread-Index: AQHdQC9VHG8DgIV+fU6Rc/HoW7uZv7bHFi4ggABMaYCAAA+IAIABFupQ
Date: Fri, 11 Sep 2026 00:45:32 +0000
Message-ID: <2294d792e937441fbf4ef8169c03df18@realtek.com>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
 <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev> <DLBR915C5L0S.1TEYXZ8LADNTH@linux.dev>
In-Reply-To: <DLBR915C5L0S.1TEYXZ8LADNTH@linux.dev>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBtYWM4MDIxMSByZXNl
cnZlcyBJRUVFODAyMTFfRU5DUllQVF9UQUlMUk9PTSwgMTggYnl0ZXMsIGFuZCBvZmZlcnMNCj4g
bm8gd2F5IGZvciBhIGRyaXZlciB0byBhc2sgZm9yIG1vcmUgb24gVFg7IGV4dHJhX3R4X2hlYWRy
b29tIGlzIGhlYWRyb29tDQo+IGFuZCBleHRyYV9iZWFjb25fdGFpbHJvb20gaXMgYmVhY29ucyBv
bmx5Lg0KDQpZb3UgY2FuIG1vZGlmeSBtYWM4MDIxMSB0byByZXNlcnZlIGxhcmdlciBuZGV2LT5u
ZWVkZWRfdGFpbHJvb20gdG8gDQpzZWUgaWYgaXQgY2FuIHJlYWxseSByZXNvbHZlIHRoZSBzeW1w
dG9tLiBJZiBzbywgeW91IGNhbiBwcm9wb3NlDQp0byBhZGQgZmllbGRzIGZvciB0YWlscm9vbSBs
aWtlIGhlYWRyb29tOg0KDQogIHN0cnVjdCBpZWVlODAyMTFfaHc6OiBleHRyYV90eF90YWlscm9v
bQ0KICBzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsOjogdHhfaGVhZHJvb20NCg0KUGluZy1LZQ0KDQo=
