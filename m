Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EEC225791;
	Thu, 13 Aug 2026 00:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786582370; cv=none; b=BbbHQkTkd2dRXQm/ZT6ymAmi1Zi98/NC9ru7bIKI+AUkoT0EKa4T33bVe/NF7p4LPUz2R/RF8TmJtpFFsDtnXoMgw95G3MPj5XnrsKzbZWulEVFb0Kk6yW4xkecri0JO/3sAJ2LrlTUxoIS6OMvFIiDwQ+zB5CexzMqf0q3VKbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786582370; c=relaxed/simple;
	bh=nsCGV8eGAqQTOSwtfwe4fPaphKH9moQx2+a2s/pheqQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n2DNWv2VqSXk0JWa896mWI66TdA+ucI4RlqgUMf2xFcTR1K2VT1fIMzf1zNGdf73pSkBvhmOhyDrGqiDiXuapRh7mSzY26LePE3bApO0nWVBPgTECKhzFkgip5RVnEKQsh8tpRdNdde5gci5BNoHg35Zefi0uJboeMyJaUdZjVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=W6CHAQE/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="W6CHAQE/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67D0qgo774039146, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786582362; bh=nsCGV8eGAqQTOSwtfwe4fPaphKH9moQx2+a2s/pheqQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=W6CHAQE//Hc3gwc+t1+RkCZ3M8sogxfEvt+ohutY1zaQ4jT9KTv/hu/v/KB+yOay+
	 +HQG8EivpMmNXW9+hBpFxg3PPIxX2Mqtso3XQHel0L4SoKRGkNqklCVAxL9eeYQdan
	 o/yaTSLwCBl3VDpu7HcLSVedMmvkWFw+RnonRvjcGXGj6zZNdz2oPSr5FLEmpPwk5P
	 bPLn7Y6IYdZUzM33xHm3M4Y5k9UqhRmuwklC61HHY+3IdS4AgzDP9L4EGhM7J3W/en
	 VYk/EPzTcqUMSMBLAW1tabSJXgA3TzGU+kZ93+f4D4S5aiGdgqpfo6SHWl9CnHSP8X
	 L17BjzGyJa0tA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67D0qgo774039146
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 13 Aug 2026 08:52:42 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 13 Aug 2026 08:52:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 13 Aug 2026 08:52:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Thu, 13 Aug 2026 08:52:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: =?utf-8?B?TsOtY29sYXMgRi4gUi4gQS4gUHJhZG8=?= <nfraprado@collabora.com>,
	David Lee <sc.lee@realtek.com>
CC: "kernel@collabora.com" <kernel@collabora.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Zong-Zhe Yang
	<kevin_yang@realtek.com>
Subject: RE: [PATCH] wifi: rtw89: Don't return default channel from disabled
 bands
Thread-Topic: [PATCH] wifi: rtw89: Don't return default channel from disabled
 bands
Thread-Index: AQHdKppTbcoyLESKFkui/2RbVZqysbabJXVg
Date: Thu, 13 Aug 2026 00:52:42 +0000
Message-ID: <6f52ebbc7b784b5ab25d54399a8e411f@realtek.com>
References: <20260812-rtw89-2ghz-quirk-fix-v1-1-7fd2a46e7a02@collabora.com>
In-Reply-To: <20260812-rtw89-2ghz-quirk-fix-v1-1-7fd2a46e7a02@collabora.com>
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

TsOtY29sYXMgRi4gUi4gQS4gUHJhZG8gPG5mcmFwcmFkb0Bjb2xsYWJvcmEuY29tPiB3cm90ZToN
Cj4gcnR3ODlfZ2V0X2RlZmF1bHRfY2hhbmRlZigpIGFzc3VtZXMgdGhlIGxvd2VzdCBmcmVxdWVu
Y3kgY2hhbm5lbCBpbiB0aGUNCj4gMkdIeiBiYW5kIGlzIGF2YWlsYWJsZSBvbiBhbGwgaGFyZHdh
cmUsIGFuZCBhbHdheXMgcmV0dXJucyB0aGF0IGFzIHRoZQ0KPiBkZWZhdWx0IGNoYW5uZWwuIFRo
aXMgaXMgbm8gbG9uZ2VyIHRoZSBjYXNlIGFmdGVyIGNvbW1pdCAzNTU2MjZhMmMyMzINCj4gKCJ3
aWZpOiBydHc4OTogODg1MmN1OiBhZGQgcXVpcmsgdG8gZGlzYWJsZSAyLjQgR0h6IGJhbmQiKSwg
YW5kIHRoZQ0KPiBjdXJyZW50IGxvZ2ljIHJlc3VsdHMgaW4ga2VybmVsIFdBUk5zIGFuZCBudWxs
IHBvaW50ZXIgZGVyZWZlcmVuY2VzIG9uDQo+IGJvYXJkcyB3aXRoIHRoYXQgcXVpcmsgc2V0Lg0K
DQpDb3VsZCB5b3Ugc2hhcmUgdGhlIGtlcm5lbCBXQVJOPw0KDQo+IA0KPiBVcGRhdGUgcnR3ODlf
Z2V0X2RlZmF1bHRfY2hhbmRlZigpIHRvIGNvbnNpZGVyIHRoZSBhdmFpbGFibGUgYmFuZHMgd2hl
bg0KPiBwaWNraW5nIHRoZSBkZWZhdWx0IGNoYW5uZWwuDQo+IA0KPiBGaXhlczogMzU1NjI2YTJj
MjMyICgid2lmaTogcnR3ODk6IDg4NTJjdTogYWRkIHF1aXJrIHRvIGRpc2FibGUgMi40IEdIeiBi
YW5kIikNCj4gU2lnbmVkLW9mZi1ieTogTsOtY29sYXMgRi4gUi4gQS4gUHJhZG8gPG5mcmFwcmFk
b0Bjb2xsYWJvcmEuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODkvY2hhbi5jIHwgIDIgKy0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3
ODkvY29yZS5jIHwgMjEgKysrKysrKysrKysrKysrKysrLS0tDQo+ICBkcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0dzg5L2NvcmUuaCB8ICAzICsrLQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAy
MSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvY2hhbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydHc4OS9jaGFuLmMNCj4gaW5kZXggNmYxMTMzNWI0OTY4Li42NTEyZmM5ZWVm
MjkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvY2hh
bi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvY2hhbi5jDQo+
IEBAIC0yOTcsNyArMjk3LDcgQEAgc3RhdGljIHZvaWQgcnR3ODlfY29uZmlnX2RlZmF1bHRfY2hh
bmRlZihzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYpDQo+ICB7DQo+ICAgICAgICAgc3RydWN0IGNm
ZzgwMjExX2NoYW5fZGVmIGNoYW5kZWYgPSB7MH07DQo+IA0KPiAtICAgICAgIHJ0dzg5X2dldF9k
ZWZhdWx0X2NoYW5kZWYoJmNoYW5kZWYpOw0KPiArICAgICAgIHJ0dzg5X2dldF9kZWZhdWx0X2No
YW5kZWYocnR3ZGV2LCAmY2hhbmRlZik7DQo+ICAgICAgICAgX19ydHc4OV9jb25maWdfZW50aXR5
X2NoYW5kZWYocnR3ZGV2LCBSVFc4OV9DSEFOQ1RYXzAsICZjaGFuZGVmKTsNCj4gIH0NCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L2NvcmUuYyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvY29yZS5jDQo+IGluZGV4IDM5N2Vi
YmZjYWMwOS4uNWFlOTUyMzY2N2M2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0dzg5L2NvcmUuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0dzg5L2NvcmUuYw0KPiBAQCAtMzkzLDEwICszOTMsMjUgQEAgc3RhdGljIHZvaWQgcnR3
ODlfdHJhZmZpY19zdGF0c19hY2N1KHN0cnVjdCBydHc4OV9kZXYgKnJ0d2RldiwNCj4gICAgICAg
ICB9DQo+ICB9DQo+IA0KPiAtdm9pZCBydHc4OV9nZXRfZGVmYXVsdF9jaGFuZGVmKHN0cnVjdCBj
Zmc4MDIxMV9jaGFuX2RlZiAqY2hhbmRlZikNCj4gK3ZvaWQgcnR3ODlfZ2V0X2RlZmF1bHRfY2hh
bmRlZihzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYsDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBzdHJ1Y3QgY2ZnODAyMTFfY2hhbl9kZWYgKmNoYW5kZWYpDQo+ICB7DQo+IC0gICAg
ICAgY2ZnODAyMTFfY2hhbmRlZl9jcmVhdGUoY2hhbmRlZiwgJnJ0dzg5X2NoYW5uZWxzXzJnaHpb
MF0sDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTkw4MDIxMV9DSEFOX05PX0hU
KTsNCj4gKyAgICAgICB1OCBzdXBwb3J0X2JhbmRzID0gcnR3ZGV2LT5jaGlwLT5zdXBwb3J0X2Jh
bmRzOw0KPiArICAgICAgIHN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqZGVmYXVsdF9jaGFubmVs
Ow0KPiArDQo+ICsgICAgICAgaWYgKHN1cHBvcnRfYmFuZHMgJiBCSVQoTkw4MDIxMV9CQU5EXzJH
SFopICYmDQo+ICsgICAgICAgICAgICF0ZXN0X2JpdChSVFc4OV9RVUlSS19ESVNBQkxFXzJHSFos
IHJ0d2Rldi0+cXVpcmtzKSkgew0KDQpJJ2QgcHJlZmVyIHRoZSBzdHlsZSBpbXBsZW1lbnRlZCBp
biBydHc4OV9jb3JlX3NldF9zdXBwb3J0ZWRfYmFuZCgpIGJlZm9yZQ0KdGhpcyBpZi1icmFuY2gu
DQoNCglpZiAodGVzdF9iaXQoUlRXODlfUVVJUktfRElTQUJMRV8yR0haLCBydHdkZXYtPnF1aXJr
cykpDQoJCXN1cHBvcnRfYmFuZHMgJj0gfkJJVChOTDgwMjExX0JBTkRfMkdIWik7DQoNCg0KPiAr
ICAgICAgICAgICAgICAgZGVmYXVsdF9jaGFubmVsID0gJnJ0dzg5X2NoYW5uZWxzXzJnaHpbMF07
DQo+ICsgICAgICAgfSBlbHNlIGlmIChzdXBwb3J0X2JhbmRzICYgQklUKE5MODAyMTFfQkFORF81
R0haKSkgew0KPiArICAgICAgICAgICAgICAgZGVmYXVsdF9jaGFubmVsID0gJnJ0dzg5X2NoYW5u
ZWxzXzVnaHpbMF07DQo+ICsgICAgICAgfSBlbHNlIGlmIChzdXBwb3J0X2JhbmRzICYgQklUKE5M
ODAyMTFfQkFORF82R0haKSkgew0KPiArICAgICAgICAgICAgICAgZGVmYXVsdF9jaGFubmVsID0g
JnJ0dzg5X2NoYW5uZWxzXzZnaHpbMF07DQo+ICsgICAgICAgfSBlbHNlIHsNCj4gKyAgICAgICAg
ICAgICAgIHJ0dzg5X2VycihydHdkZXYsICJGYWlsZWQgdG8gZ2V0IGRlZmF1bHQgY2hhbm5lbCwg
bm8gYmFuZCBzdXBwb3J0ZWRcbiIpOw0KPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KDQpJZiBp
dCBzb21laG93IGZhbGxzIGludG8gdGhpcyBjYXNlLCB3b24ndCBpdCB3YXJuIG9yIG51bGwtZGVy
ZWZlcmVuY2U/DQoNCg0KPiArICAgICAgIH0NCj4gKw0KPiArICAgICAgIGNmZzgwMjExX2NoYW5k
ZWZfY3JlYXRlKGNoYW5kZWYsIGRlZmF1bHRfY2hhbm5lbCwgTkw4MDIxMV9DSEFOX05PX0hUKTsN
Cj4gIH0NCj4gDQo+ICB2b2lkIHJ0dzg5X2dldF9jaGFubmVsX3BhcmFtcyhjb25zdCBzdHJ1Y3Qg
Y2ZnODAyMTFfY2hhbl9kZWYgKmNoYW5kZWYsDQoNCg0K
