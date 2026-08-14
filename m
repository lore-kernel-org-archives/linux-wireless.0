Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132853A9623;
	Fri, 14 Aug 2026 01:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671825; cv=none; b=nb/zYXZfzVf4t8mz92CNXdERs4H+sIlAvkRVSIKu0tu8AQyZuVSGwrw+7o3R2V0PzQqSsKlzT+Mv9/g8xLfMExEC09t7dQ4tOnZTc6+7/5diz7QnISA6EvDg2cYrO1voIg4kK1uhIZH1GGMgdz/dnVuV411dgrpzlfrkQq8KYhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671825; c=relaxed/simple;
	bh=SslfRv6ad8mAnGh/G0s/HOFr+zaQq7MNdTeSn6iRs6k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JUkRCIIPk1RxjzNWG3VFmaPj9jr5XlBvcwwV6SB3jpTqcfYVzdOZnxmPXDU6dh1BoabVsoJ+W1hu7AYVxXL9/l1eltfaHSCl66V30XWZibCwXZHwfOQ+tbK7FsnJFwJaLXv0v6ns9xmh+lL7x/Na9bDr9eLGsGymXyiHKRSv4kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=aIEGq+Zb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="aIEGq+Zb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E1haVG3859840, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786671816; bh=SslfRv6ad8mAnGh/G0s/HOFr+zaQq7MNdTeSn6iRs6k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=aIEGq+Zbunm8nycKCXYOu7sfTBVuC8adWsSDZZGBP0NKQL79J7N4YqX3nzkhaQZXq
	 r+HBqEg8pT+Gxvno5vFPoclE2RFJILeARtQ/I179TwEVGnQYo94ZBT6e1h345wyn/3
	 OhC6QlgcwlK6EY8Mi7Th0y8AgRnf3sylhGu7TOnEPdq8BPSnVhVVyxaqItta+G12OK
	 fOHi/FgZu0o5aJkYyA5KcTFfo+xy2CuOfOe1hHtvtIq9hf36Ux0RWCxh7pLtW3x4xm
	 uKOn8nor+DFbmynFQjkOFAPoUkhxZWD0IiE1jSpnazib9wCFaSmRVolPK3CFPumMMJ
	 1V/uGy9VYtHOQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E1haVG3859840
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 09:43:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 09:43:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 09:43:36 +0800
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
Thread-Index: AQHdKppTbcoyLESKFkui/2RbVZqysbabJXVggABp74CAAS/dkA==
Date: Fri, 14 Aug 2026 01:43:36 +0000
Message-ID: <a11120d38be84234beb6af56a87afc12@realtek.com>
References: <20260812-rtw89-2ghz-quirk-fix-v1-1-7fd2a46e7a02@collabora.com>
	 <6f52ebbc7b784b5ab25d54399a8e411f@realtek.com>
 <cb527333b776e453259f2c73afa483d8f2a4fd9b.camel@collabora.com>
In-Reply-To: <cb527333b776e453259f2c73afa483d8f2a4fd9b.camel@collabora.com>
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
Cj4gT24gVGh1LCAyMDI2LTA4LTEzIGF0IDAwOjUyICswMDAwLCBQaW5nLUtlIFNoaWggd3JvdGU6
DQo+ID4gTsOtY29sYXMgRi4gUi4gQS4gUHJhZG8gPG5mcmFwcmFkb0Bjb2xsYWJvcmEuY29tPiB3
cm90ZToNCj4gPiA+IHJ0dzg5X2dldF9kZWZhdWx0X2NoYW5kZWYoKSBhc3N1bWVzIHRoZSBsb3dl
c3QgZnJlcXVlbmN5IGNoYW5uZWwgaW4NCj4gPiA+IHRoZQ0KPiA+ID4gMkdIeiBiYW5kIGlzIGF2
YWlsYWJsZSBvbiBhbGwgaGFyZHdhcmUsIGFuZCBhbHdheXMgcmV0dXJucyB0aGF0IGFzDQo+ID4g
PiB0aGUNCj4gPiA+IGRlZmF1bHQgY2hhbm5lbC4gVGhpcyBpcyBubyBsb25nZXIgdGhlIGNhc2Ug
YWZ0ZXIgY29tbWl0DQo+ID4gPiAzNTU2MjZhMmMyMzINCj4gPiA+ICgid2lmaTogcnR3ODk6IDg4
NTJjdTogYWRkIHF1aXJrIHRvIGRpc2FibGUgMi40IEdIeiBiYW5kIiksIGFuZCB0aGUNCj4gPiA+
IGN1cnJlbnQgbG9naWMgcmVzdWx0cyBpbiBrZXJuZWwgV0FSTnMgYW5kIG51bGwgcG9pbnRlciBk
ZXJlZmVyZW5jZXMNCj4gPiA+IG9uDQo+ID4gPiBib2FyZHMgd2l0aCB0aGF0IHF1aXJrIHNldC4N
Cj4gPg0KPiA+IENvdWxkIHlvdSBzaGFyZSB0aGUga2VybmVsIFdBUk4/DQo+IA0KPiBTdXJlLCBo
ZXJlIGFyZSB0aGUgZGV0YWlscyBmb3IgdGhvc2UgaXNzdWVzOg0KPiANCj4gV2FybjoNCj4gICBP
cmlnaW46DQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9wa3NoaWgvcnR3L2Jsb2IvMzhjNThkNTQxY2Zl
Mjg2ODgwY2RhZGViYzVkNzI2ZmUxOGUzYjYxNS9uZXQvbWFjODAyMTEvcnguYyNMNTU0DQo+IDIN
Cj4gICBkbWVzZzoNCj4gDQo+ICAgICBXQVJOSU5HOiBDUFU6IDAgUElEOiAwIGF0IG5ldC9tYWM4
MDIxMS9yeC5jOjUzNzYNCj4gaWVlZTgwMjExX3J4X2xpc3QrMHg3NTkvMHhkYTAgW21hYzgwMjEx
XQ0KDQpUaGF0IGlzIHRoZSBpbml0aWFsIGNoYW5uZWwgb24gMkdIeiBiYW5kLCBhbmQgcmVjZWl2
ZSBwYWNrZXRzIHRoZXJlLg0KDQo+IA0KPiBOdWxsIHBvaW50ZXIgZGVyZWZlcmVuY2U6DQo+ICAg
VHJpZ2dlcmVkIHdoZW4gcnVubmluZyAnaXcgZGV2IHdsYW4xIHNldCBiaXRyYXRlcycNCj4gICBP
cmlnaW46DQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9wa3NoaWgvcnR3L2Jsb2IvMzhjNThkNTQxY2Zl
Mjg2ODgwY2RhZGViYzVkNzI2ZmUxOGUzYjYxNS9kcml2ZXJzL25ldC93aXJlbGVzcy9yDQo+IGVh
bHRlay9ydHc4OS9waHkuYyNMNjcyDQo+ICAgZG1lc2c6DQpbLi4uXQ0KPiAgICAgIHJ0dzg5X29w
c19zZXRfYml0cmF0ZV9tYXNrKzB4MzAvMHg4MCBbcnR3ODlfY29yZQ0KPiBjYzI5NzgyMDkxMDRl
NmU5ODcwZGY1NDZhYTYzYzJkZmU2NjNkYWJkXQ0KDQpUaGlzIGlzIHVzZXIgc3BhY2UgdG8gYml0
cmF0ZSBtYXNrIG9uIHRoaXMgdW5leHBlY3RlZCBiYW5kLg0KDQpDb3VsZCB5b3UgcGxlYXNlIGdp
dmUgc2hvcnQgYnJpZWYgaW4gY29tbWl0IG1lc3NhZ2UgYWJvdXQgdGhlc2UgdHdvIHBvaW50cz8N
CihJIHRoaW5rIG5vIG5lZWQgZnVsbCBjYWxsIHRyYWNlKQ0KDQpbLi4uXQ0KDQo+ID4NCj4gPg0K
PiA+ID4gKyAgICAgICAgICAgICAgIGRlZmF1bHRfY2hhbm5lbCA9ICZydHc4OV9jaGFubmVsc18y
Z2h6WzBdOw0KPiA+ID4gKyAgICAgICB9IGVsc2UgaWYgKHN1cHBvcnRfYmFuZHMgJiBCSVQoTkw4
MDIxMV9CQU5EXzVHSFopKSB7DQo+ID4gPiArICAgICAgICAgICAgICAgZGVmYXVsdF9jaGFubmVs
ID0gJnJ0dzg5X2NoYW5uZWxzXzVnaHpbMF07DQo+ID4gPiArICAgICAgIH0gZWxzZSBpZiAoc3Vw
cG9ydF9iYW5kcyAmIEJJVChOTDgwMjExX0JBTkRfNkdIWikpIHsNCj4gPiA+ICsgICAgICAgICAg
ICAgICBkZWZhdWx0X2NoYW5uZWwgPSAmcnR3ODlfY2hhbm5lbHNfNmdoelswXTsNCj4gPiA+ICsg
ICAgICAgfSBlbHNlIHsNCj4gPiA+ICsgICAgICAgICAgICAgICBydHc4OV9lcnIocnR3ZGV2LCAi
RmFpbGVkIHRvIGdldCBkZWZhdWx0IGNoYW5uZWwsDQo+ID4gPiBubyBiYW5kIHN1cHBvcnRlZFxu
Iik7DQo+ID4gPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+DQo+ID4gSWYgaXQgc29tZWhv
dyBmYWxscyBpbnRvIHRoaXMgY2FzZSwgd29uJ3QgaXQgd2FybiBvciBudWxsLQ0KPiA+IGRlcmVm
ZXJlbmNlPw0KPiANCj4gSSBzdXBwb3NlIGl0IGNvdWxkLCBidXQgSSdtIG5vdCBzdXJlIHdoYXQg
d291bGQgYmUgYSBiZXR0ZXIgb3B0aW9uDQo+IGhlcmUsIGRvIHlvdSBoYXZlIGFueSBzdWdnZXN0
aW9ucz8NCj4gDQo+IEluIGFueSBjYXNlIGFsbCBvZiB0aGUgaGFyZHdhcmUgdmFyaWFudHMgY3Vy
cmVudGx5IGRlZmluZWQgaGF2ZSBhdA0KPiBsZWFzdCBvbmUgb2YgdGhvc2UgZmxhZ3Mgc2V0LCBz
byB0aGlzIGJyYW5jaCBjb3VsZCBuZXZlciBiZSByZWFjaGVkLg0KPiBCdXQgaWYgc29tZXRoaW5n
IGV2ZXIgY2hhbmdlcywgdGhlbiB0aGlzIGVycm9yIHdvdWxkIGhlbHAgbm90aWNpbmcgaXQuDQoN
CkluZGVlZC4gSSB0aGluayB3ZSBjYW4gcmV0dXJuIGFuIGVycm9yIGluIHJ0dzg5X2NvcmVfc2V0
X3N1cHBvcnRlZF9iYW5kKCkNCmlmIHN1cHBvcnRfYmFuZHMgaXMgMC4gV2UgY2FuIHN0b3AgaXQg
d2hlbiBwcm9iaW5nLiANCg0KT3V0IG9mIGN1cmlvc2l0eSwgaG93IGRpZCB5b3UgaGF2ZSBvbmUg
dGhpcyBraW5kIG9mIGRldmljZXMgYWxyZWFkeT8NCkknbSB0aGlua2luZyB0aGlzIHByb2R1Y3Qg
aXNuJ3Qgc2hpcHBpbmcgeWV0Lg0KDQpQaW5nLUtlDQoNCg==
