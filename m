Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954AB2931D5
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 05:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791351130; cv=none; b=RgLj8YDUUzd86HSAKROpfj9kpiR9+lh2k/56Mwmdb2f31bimVTP+5r3x2NOfo+sbMMzjC16MG4OXX+1ocEeNz62N7RAV2owSI1UJqOp/TeCcNDwf6IdCDLIXAE6KZJJal0fUZmu3vq/GvNAFtCUqalq/dfk787CmPznKJceO4/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791351130; c=relaxed/simple;
	bh=11Y6CqICcbvH+v0Xj82oNnrdqhkrZQl2jXxcpAxiMoA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nTpdD10XohCUH4DNLfN30gdlMbIVES1NOQiE1R8TaEQU38ooSkJ2FnV+vx24tHBIwkFifvTSWSvmrUPyprMbGSbqwu/9Dbc3ubChWB5HAo9z8otqnhOfg5WKLuRQRD/novRr4tgsCYo/hjbBeunn17xIaT+EHYSkA3lGBzEvsB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=RgX8dsGb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="RgX8dsGb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6975VraC63589655, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791351113; bh=11Y6CqICcbvH+v0Xj82oNnrdqhkrZQl2jXxcpAxiMoA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=RgX8dsGb90aszWYHUhXPcHt33Q1aq6Jm2RWy3nlbN9VzneC3SwOt/U+Ax1kl0Sqal
	 5bdBPoVk60OGRjnoUFAU4qnKaHj8+vP0OLlxEmMBlU3Wav858rqPcx5E5FGicp5jyw
	 xdAn6dWN4Z8EdSOOm3/5fN2NXf/3mHdoBKTWPlripCQrltk8v3x65JyHq5tOecBhXw
	 tBPy5CQCp+WzLWnjUyh3O/LFvlAQRHgCxyxihqtQl1BZ7wftM4APYYvjMdO7xFuq3x
	 UeCa7q7tUm0F8tMmtMX1klh9OAA9BXzH0MQ7KUmRakdPWagCLFaAirZjvQOxluzjiv
	 k73UsvuhB3oAg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6975VraC63589655
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 Oct 2026 13:31:53 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 13:31:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 13:31:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 7 Oct 2026 13:31:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: PierluigiFrullani <pierluigi.frullani@frumar.it>
Subject: RE: [PATCH rtw-next] wifi: rtw89: Override antenna number for
 RTL8852BE-VS
Thread-Topic: [PATCH rtw-next] wifi: rtw89: Override antenna number for
 RTL8852BE-VS
Thread-Index: AQHdVblesbcSDMGpkUiMOtHNfFslcrbxUroQgAA7rVA=
Date: Wed, 7 Oct 2026 05:31:53 +0000
Message-ID: <02b3e685b5674515b19e0b36eb0ba1cf@realtek.com>
References: <826c8df5-2ee2-4a6a-93d1-2ec4f16840e5@gmail.com>
 <766d080156ef42518e9b50f52eae7523@realtek.com>
In-Reply-To: <766d080156ef42518e9b50f52eae7523@realtek.com>
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

UGluZy1LZSBTaGloIHdyb3RlOg0KPiBCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdt
YWlsLmNvbT4gd3JvdGU6DQo+ID4gQEAgLTc2OCw2ICs3ODEsMTMgQEAgc3RhdGljIHZvaWQgcnR3
ODg1MmJfYnRjX3NldF9yZmUoc3RydWN0IHJ0dzg5X2RldiAqcnR3ZGV2KQ0KPiA+ICAgICAgICAg
fSBlbHNlIHsNCj4gPiAgICAgICAgICAgICAgICAgbWQtPmFudC50eXBlID0gQlRDX0FOVF9TSEFS
RUQ7DQo+ID4gICAgICAgICAgICAgICAgIG1kLT5idDBfcG9zID0gQlRDX0JUX0JURzsNCj4gPiAr
DQo+ID4gKyAgICAgICAgICAgICAgIGlmICh0ZXN0X2JpdChSVFc4OV9RVUlSS18xQU5ULCBydHdk
ZXYtPnF1aXJrcykpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBtZC0+YW50Lm51bSA9
IDE7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgbWQtPmFudC5zaW5nbGVfcG9zID0gUkZf
UEFUSF9COw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIG1kLT5hbnQuYnRnX3BvcyA9IFJG
X1BBVEhfQjsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBtZC0+YW50LnN0cmVhbV9jbnQg
PSAxOw0KPiA+ICsgICAgICAgICAgICAgICB9DQo+IA0KPiBUaGUgcGF0Y2ggWzFdIGluIHByb2dy
ZXNzIGFsc28gbW9kaWZ5IGhlcmUuIE1heWJlLCB5b3UgY2FuIHJlYmFzZSBhZnRlciBJDQo+IG1l
cmdlIHRoZSBwYXRjaCwgb3IganVzdCBzZW5kIHYyIGJhc2VkIG9uIHRoZSBwYXRjaHNldCBpZiB5
b3UgaHVycnkuDQo+IChJJ2QgbWVyZ2UgdGhlIHBhdGNoIGFuZCBzZW5kIHB1bGwtcmVxdWVzdCBm
b3IgLW5leHQgdG9tb3Jyb3cuKQ0KDQpGWUkuIEkgbWVyZ2VkIFsxXSBwYXRjaHNldC4gUGxlYXNl
IHJlYmFzZSB0aGlzIHBhdGNoIG9uIHRoZSBsYXRlc3QgcnR3LW5leHQgYnJhbmNoLg0KDQpQaW5n
LUtlDQoNCg==
