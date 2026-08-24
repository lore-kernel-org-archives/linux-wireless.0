Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C1A14BF92;
	Mon, 24 Aug 2026 01:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787533838; cv=none; b=NYPoGGDYeLMTvGd+G0wb9KRItZvIizXDvOzeDcYFM9AyDDGcKL2eE5h6ZevG4wSbcWQj/P0wzP0FjJVrl9qY3y2wGdUphYu98UTiqxqN8YhRiWrKN+u5Ze6yo6atV9IMDmVS+lUXCDssWVd77ErgOLfOC57OsX9stQNb3X8vNPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787533838; c=relaxed/simple;
	bh=WnIlgE/lt5X6jvNU3SYuW9E9/mNvCtOy1hmyF7berms=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hnGUN2Jd571dlpgEtUTB6KeU5y89Wo+edKaLP+JA4fLiYLT3CNDeVdLveAVsaJFd9umJBFkljCLA1bxTbqfiJ27LX+Ap+hjzCQKWX0gUAGZhamjnFIYv15q5VzdhNK+lEG8oPdeNPuQAyRu+fJzJn3S+TFC1NuGHxhk/SLjf9Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LzdySCXE; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LzdySCXE"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67O1AV1g82338985, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787533831; bh=WnIlgE/lt5X6jvNU3SYuW9E9/mNvCtOy1hmyF7berms=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=LzdySCXE8nEntilmGKFZOCquO4As8EiWdssfX2axABaJ4DtaturRj68pxmKoqOMPF
	 aIyAY5rwParLb9d6cYG7GzvYTRg85pwHBi3V/pBoydLcK09eyUow2IqO30D1XBKz5t
	 wgDRD21unPTcbwkcd+vKpaUcv3FI7MlPfa1fuW9a3bSTcvm/KW3mKYVGh/f1XGaqJn
	 F52GPBVQWUy6amP+14Swaw/wHwxa7bH8dlQJGhm1ytBlt0djdYrrIxHuJFRwlqTPP4
	 Xe34QaCdKXNGXo7maZL/7dPgshMA2kKlqf5zEQXIPqcAaUgq93GhfX/Yb1Tv4u/+nP
	 82g55lypHZiUw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67O1AV1g82338985
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 24 Aug 2026 09:10:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 24 Aug 2026 09:10:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 24 Aug 2026 09:10:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "learn.rahul.rai@gmail.com" <learn.rahul.rai@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming
 A15 FA506IH
Thread-Topic: [PATCH] wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming
 A15 FA506IH
Thread-Index: AQHdMnlIuwiwUs73HECjS8SgnJZ6g7asZaow
Date: Mon, 24 Aug 2026 01:10:32 +0000
Message-ID: <2ae6b8b6c89844b1942e9ebf97bfaa16@realtek.com>
References: <20260823-fa506ih-rtw88-quirk-v1-1-ef0984d59e72@gmail.com>
In-Reply-To: <20260823-fa506ih-rtw88-quirk-v1-1-ef0984d59e72@gmail.com>
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

UmFodWwgS3VtYXIgUmFpIHZpYSBCNCBSZWxheSA8ZGV2bnVsbCtsZWFybi5yYWh1bC5yYWkuZ21h
aWwuY29tQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiBGcm9tOiBSYWh1bCBLdW1hciBSYWkgPGxlYXJu
LnJhaHVsLnJhaUBnbWFpbC5jb20+DQo+IA0KPiBUaGUgUlRMODgyMkNFIG9uIHRoZSBBU1VTIFRV
RiBHYW1pbmcgQTE1IEZBNTA2SUggZmFpbHMgdG8gcmV0dXJuIGZyb20NCj4gUENJZSBsb3ctcG93
ZXIgc3RhdGVzIGFjcm9zcyBzeXN0ZW0gc3VzcGVuZC4gVGhlIGRldmljZSBpcyBpbmFjY2Vzc2li
bGUNCj4gb24gdGhlIHdheSBiYWNrIHRvIEQwLCBzbyB0aGUgTUFDIHBvd2VyLW9uIHNlcXVlbmNl
IGFuZCB0aGUgZmlybXdhcmUNCj4gaGFuZHNoYWtlIHRoYXQgZm9sbG93IGl0IGZhaWwsIGFuZCB0
aGUgZHJpdmVyIGdpdmVzIHVwLiBXaS1GaSBzdGF5cw0KPiB1bmF2YWlsYWJsZSB1bnRpbCB0aGUg
bWFjaGluZSBpcyBwb3dlcmVkIG9mZiBjb21wbGV0ZWx5Og0KPiANCj4gICBydHc4OF84ODIyY2Ug
MDAwMDowMzowMC4wOiBVbmFibGUgdG8gY2hhbmdlIHBvd2VyIHN0YXRlIGZyb20gRDNjb2xkIHRv
IEQwLCBkZXZpY2UgaW5hY2Nlc3NpYmxlDQo+ICAgcnR3ODhfODgyMmNlIDAwMDA6MDM6MDAuMDog
ZmFpbGVkIHRvIHBvbGwgb2Zmc2V0PTB4NSBtYXNrPTB4MiB2YWx1ZT0weDANCj4gICBydHc4OF84
ODIyY2UgMDAwMDowMzowMC4wOiBtYWMgcG93ZXIgb24gZmFpbGVkDQo+ICAgcnR3ODhfODgyMmNl
IDAwMDA6MDM6MDAuMDogcHJvYmUgd2l0aCBkcml2ZXIgcnR3ODhfODgyMmNlIGZhaWxlZCB3aXRo
IGVycm9yIC0xMTQNCj4gDQo+IFJlYWRzIG9mIHRoZSBBU1BNIGxpbmstY29uZmlndXJhdGlvbiBy
ZWdpc3RlciBvdmVyIERCSSBhbHNvIHRpbWUgb3V0DQo+IGFyb3VuZCB0aGUgc2FtZSB0cmFuc2l0
aW9ucy4NCj4gDQo+IFRoaXMgaXMgbm90IGEgb25lLW9mZi4gSXQgaGFzIGJlZW4gcmVjdXJyaW5n
IG9uIHRoaXMgbWFjaGluZSBmb3IgYSBsb25nDQo+IHRpbWUuIFRoZSBrZXJuZWwgbG9ncyBzdGls
bCBvbiBkaXNrIGJlZ2luIGF0IDIwMjYtMDctMjAgYW5kIGFscmVhZHkNCj4gY29udGFpbiBzaXgg
ZmFpbGVkIEQtc3RhdGUgdHJhbnNpdGlvbnMgYW5kIHRocmVlIHByb2JlIGZhaWx1cmVzIG9mIHRo
aXMNCj4ga2luZCwgYW5kIHRoZSBwcm9ibGVtIHdhcyBwcmVzZW50IHdlbGwgYmVmb3JlIHRoYXQg
d2luZG93Lg0KPiANCj4gVGhpcyBpcyB0aGUgc2FtZSBwbGF0Zm9ybSBBU1BNIGludGVyLW9wZXJh
YmlsaXR5IHByb2JsZW0gYWxyZWFkeSBoYW5kbGVkDQo+IGZvciBvdGhlciBtYWNoaW5lcyB0aHJv
dWdoIHJ0d19wY2lfcXVpcmtzW10sIGluY2x1ZGluZyB0aGUgY2xvc2VseQ0KPiByZWxhdGVkIEFT
VVMgVFVGIEdhbWluZyBBMTUgRkE1MDZJSS4gVGhlIEZBNTA2SUggcmVwb3J0cyBhIGRpZmZlcmVu
dCBETUkNCj4gYm9hcmQgbmFtZSwgc28gdGhhdCBlbnRyeSBkb2VzIG5vdCBtYXRjaC4gRGlzYWJs
aW5nIFBDSSBBU1BNIGFuZCBkZWVwDQo+IHBvd2VyIHNhdmUgc3RvcHMgdGhlIGZhaWx1cmUgb24g
dGhpcyBtb2RlbCBhcyB3ZWxsLg0KPiANCj4gICBETUlfU1lTX1ZFTkRPUiA9IEFTVVNUZUsgQ09N
UFVURVIgSU5DLg0KPiAgIERNSV9CT0FSRF9OQU1FID0gRkE1MDZJSA0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogUmFodWwgS3VtYXIgUmFpIDxsZWFybi5yYWh1bC5yYWlAZ21haWwuY29tPg0KDQpBY2tl
ZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQoNCg0K
