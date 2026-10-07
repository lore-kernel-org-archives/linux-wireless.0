Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6802175A86
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 02:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338603; cv=none; b=R458A1hgvG8Z76Iy0OQYm+OsXp3SLwsNiqpiSqS6vRWbovXBMEOTToGWmbcQ4G3KHJNxDDhaYrBrOytpcm2PaN9xNIERcwszOJssTCdX4ZEMHjFTzDo90L0VD4ooX8DaZfGlBsl9q68KE4eqG9sMhaQtG+U+DxP3lBGi+Xy91Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338603; c=relaxed/simple;
	bh=q0npdwA/fyktPVc2i70z2ymBIrwHPAhvxUU/uKk7wqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TMUy89ac0rm0GWdOrbMZbBcbrYFaoNUeoVwisy4201oxxyuXtp/r8Frd8hgBnqU5Pnn++PF7lvY2nFkZpNbgpDcBXdMRnla2KSAGHTzw9ZQn508ZYQoZGRuVeIvYi5ZHGCeQzmw+vFcDBG1ZhyZQi/8GHpYRjc/8NnHjTGj6AK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Dqfzq/6K; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Dqfzq/6K"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 697235V903449915, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791338585; bh=q0npdwA/fyktPVc2i70z2ymBIrwHPAhvxUU/uKk7wqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Dqfzq/6KuS8ABr6ENy2UBTWeDJUBusbxBcC1LTNWKg0eGQrCGCblY8/6krddDQrSU
	 2Qt6b8Nez0J7mkF9AcszJxLAgWxdT2jcli7MIvJ2OcHUWC/Z15iFSvfHocB8xXFtYy
	 6Gs5PYCFoRshcYppvQpP3n99UoNNjr38UyvCnKQK5V8zdGghVt2+CzmLmzKCBY5H+E
	 YLpN/AHaNBPOm3sodltcMFYGjw0ZSi8KbJSUlIfivspExuxkPYMAFHfeFbBufxg0iF
	 Pc4EBJPVC+Zp3gu1Ojc1yFV07jNXjn896pDbzsqZ1t1TQ25UxTgNZHW6ruuZOYxYkf
	 OUAzS6gHDwdjQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 697235V903449915
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 Oct 2026 10:03:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 10:03:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 7 Oct 2026 10:03:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: PierluigiFrullani <pierluigi.frullani@frumar.it>
Subject: RE: [PATCH rtw-next] wifi: rtw89: Override antenna number for
 RTL8852BE-VS
Thread-Topic: [PATCH rtw-next] wifi: rtw89: Override antenna number for
 RTL8852BE-VS
Thread-Index: AQHdVblesbcSDMGpkUiMOtHNfFslcrbxUroQ
Date: Wed, 7 Oct 2026 02:03:05 +0000
Message-ID: <766d080156ef42518e9b50f52eae7523@realtek.com>
References: <826c8df5-2ee2-4a6a-93d1-2ec4f16840e5@gmail.com>
In-Reply-To: <826c8df5-2ee2-4a6a-93d1-2ec4f16840e5@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KDQpbLi4u
XQ0KDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3J0
dzg4NTJiLmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3J0dzg4NTJi
LmMNCj4gaW5kZXggYzNjNTNhNmI4MTE5Li45ZDgzNGVhMzZjMWEgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvcnR3ODg1MmIuYw0KPiArKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3J0dzg4NTJiLmMNCj4gQEAgLTM1Myw2ICsz
NTMsMTkgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBydHc4OV9idGNfZmJ0Y19tcmVnIHJ0dzg5X2J0
Y184ODUyYl9tb25fcmVnW10gPSB7DQo+ICBzdGF0aWMgY29uc3QgdTggcnR3ODlfYnRjXzg4NTJi
X3dsX3Jzc2lfdGhyZXNbQlRDX1dMX1JTU0lfVEhNQVhdID0gezcwLCA2MCwgNTAsIDQwfTsNCj4g
IHN0YXRpYyBjb25zdCB1OCBydHc4OV9idGNfODg1MmJfYnRfcnNzaV90aHJlc1tCVENfQlRfUlNT
SV9USE1BWF0gPSB7NTAsIDQwLCAzMCwgMjB9Ow0KPiANCj4gK3N0YXRpYyBpbnQgcnR3ODg1MmJf
cmVhZF9lZnVzZShzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYsIHU4ICpsb2dfbWFwLA0KPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZW51bSBydHc4OV9lZnVzZV9ibG9jayBibG9jaykN
Cj4gK3sNCj4gKyAgICAgICBpbnQgcmV0Ow0KPiArDQo+ICsgICAgICAgcmV0ID0gcnR3ODg1MmJ4
X3JlYWRfZWZ1c2UocnR3ZGV2LCBsb2dfbWFwLCBibG9jayk7DQoNCkkgdGhpbmsgaGVyZSBzaG91
bGQgY2hlY2sgcmV0IGFuZCByZXR1cm4gZGlyZWN0bHkgaWYgbm90IHplcm8uIA0KDQo+ICsNCj4g
KyAgICAgICBpZiAocnR3ZGV2LT5lZnVzZS5yZmVfdHlwZSA9PSA0MSkNCj4gKyAgICAgICAgICAg
ICAgIHNldF9iaXQoUlRXODlfUVVJUktfMUFOVCwgcnR3ZGV2LT5xdWlya3MpOw0KPiArDQo+ICsg
ICAgICAgcmV0dXJuIHJldDsNCg0KaGVyZSwgcmV0dXJuIDA7DQoNClRob3VnaCB0aGUgcmVzdWx0
IGlzIHRoZSBzYW1lLCBpdCBsb29rcyByZWFzb25hYmxlLg0KDQo+ICt9DQo+ICsNCj4gIHN0YXRp
YyB2b2lkIHJ0dzg4NTJiX3B3cl9zcHNfYW5hKHN0cnVjdCBydHc4OV9kZXYgKnJ0d2RldikNCj4g
IHsNCj4gICAgICAgICBydHc4OV93cml0ZTE2KHJ0d2RldiwgUl9BWF9TUFNfQU5BX09OX0NUUkwy
LCBSVEw4ODUyQl9ERUZBVUxUX1NQU19BTkEpOw0KPiBAQCAtNzY4LDYgKzc4MSwxMyBAQCBzdGF0
aWMgdm9pZCBydHc4ODUyYl9idGNfc2V0X3JmZShzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYpDQo+
ICAgICAgICAgfSBlbHNlIHsNCj4gICAgICAgICAgICAgICAgIG1kLT5hbnQudHlwZSA9IEJUQ19B
TlRfU0hBUkVEOw0KPiAgICAgICAgICAgICAgICAgbWQtPmJ0MF9wb3MgPSBCVENfQlRfQlRHOw0K
PiArDQo+ICsgICAgICAgICAgICAgICBpZiAodGVzdF9iaXQoUlRXODlfUVVJUktfMUFOVCwgcnR3
ZGV2LT5xdWlya3MpKSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIG1kLT5hbnQubnVtID0g
MTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgbWQtPmFudC5zaW5nbGVfcG9zID0gUkZfUEFU
SF9COw0KPiArICAgICAgICAgICAgICAgICAgICAgICBtZC0+YW50LmJ0Z19wb3MgPSBSRl9QQVRI
X0I7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIG1kLT5hbnQuc3RyZWFtX2NudCA9IDE7DQo+
ICsgICAgICAgICAgICAgICB9DQoNClRoZSBwYXRjaCBbMV0gaW4gcHJvZ3Jlc3MgYWxzbyBtb2Rp
ZnkgaGVyZS4gTWF5YmUsIHlvdSBjYW4gcmViYXNlIGFmdGVyIEkNCm1lcmdlIHRoZSBwYXRjaCwg
b3IganVzdCBzZW5kIHYyIGJhc2VkIG9uIHRoZSBwYXRjaHNldCBpZiB5b3UgaHVycnkuDQooSSdk
IG1lcmdlIHRoZSBwYXRjaCBhbmQgc2VuZCBwdWxsLXJlcXVlc3QgZm9yIC1uZXh0IHRvbW9ycm93
LikNCg0KWzFdIGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC13aXJl
bGVzcy9wYXRjaC8yMDI2MTAwNDAzNDUyMC4zMzY5NS0xMi1wa3NoaWhAcmVhbHRlay5jb20vDQoN
Cj4gICAgICAgICB9DQo+ICAgICAgICAgcnR3ZGV2LT5idGMuYnRnX3BvcyA9IG1kLT5hbnQuYnRn
X3BvczsNCj4gICAgICAgICBydHdkZXYtPmJ0Yy5hbnRfdHlwZSA9IG1kLT5hbnQudHlwZTsNCg0K
DQo=
