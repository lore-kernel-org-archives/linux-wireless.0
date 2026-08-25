Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E4F3E49C8;
	Tue, 25 Aug 2026 08:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787647111; cv=none; b=D9BCveWDZ67bO9QHbTCfr1z+oh9SWDq35sGB8EkfEJu2uhBoPCHjVW7TT4QRlxjYTql6bxJtfEWjf0bkYWtKX1lBoaROahDo3XNdFO4FRMy4y8rSELH++L0Hu9cooA7jSYb+6DKMAj0UVUx6EEdYcBV3zIU6F0CUn+78i5KyHc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787647111; c=relaxed/simple;
	bh=QJPm1yPDgfKNuAeybPYU/ex3euJnoE0M3b97YTa9t1Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BN+cqDHS+in9y5HWErZ5DsDA/hacLtNw1TrFs/fUVhtGugBs4U89SYngtkfSpt6YvcvjehsCOvjK3vuHENNyr4UeDXIanvFzql3XJAeYOcFOLLeSOSsEgMqQANge8ZW5cLxNKLfw7FEebDBJ3olZcx0dAcFONhnmSFPZ5ajYoB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=m4NEkGDH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="m4NEkGDH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P8cGnP53640552, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787647096; bh=QJPm1yPDgfKNuAeybPYU/ex3euJnoE0M3b97YTa9t1Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=m4NEkGDH0RHMe48xPpcmJz2UugIDiNimA8CAvwMlzVT43DbBD9TJav+mRBd6alnUe
	 5BXzIa0M29CLPcAAcFL5pkkyE+kSW/rQAkqiasHukUAoBNXMpyU656NuOf1UzRj0ms
	 aZkGQox+YOORdJ0uIqMpZmjVPf8gIDtPD4xNZTvphQGnaXAiB7B6uIS4j4VNDJgLUK
	 siMqRQ9anxIACDO5uXeWgLkgkd+uMJwCGegTdbWggV3mrjmnMej+eNGBCj44FjEOQv
	 0m2uoKTCgubTm581tDfOSusQB+GlBwvjGz/EaVn+iPWFEWCq3hK2DTjnjEtNJnyUou
	 uVB8bzMKv5P+g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P8cGnP53640552
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 16:38:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 16:38:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 16:38:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdMIL3twfMpykyCEyz233XfbbmBLauSXrw//+T44CAAIcCsP//fHmAgACKsPD//38FgAAQ/dzw//9+zgD//3kBYA==
Date: Tue, 25 Aug 2026 08:38:15 +0000
Message-ID: <bb13c730fce14d7bbd54a3e5f7f21a2d@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
 <20260820090412.19574-5-luka.gejak@linux.dev>
 <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com>
 <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev>
 <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com>
 <E2ACBF1F-1C98-4091-A851-E2D8AF006911@linux.dev>
 <68a844f5ea2b4eea827da95080a9dbcb@realtek.com>
 <E037DFDC-7C17-4537-810A-2D5DBFF4EECC@linux.dev>
 <5c6d6a1826334966a4f0893ad306fba4@realtek.com>
 <2776B724-A5C6-4068-BFB5-3F0EC981F650@linux.dev>
In-Reply-To: <2776B724-A5C6-4068-BFB5-3F0EC981F650@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPbiBBdWd1c3QgMjUs
IDIwMjYgMTA6MjI6NTMgQU0gR01UKzAyOjAwLCBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVr
LmNvbT4gd3JvdGU6DQo+IA0KPiA+IEJ1dCBJIGRvbid0IGZpbmQgcnR3X3NkaW9fd3JpdGVfdG9f
cG9ydCgpPw0KPiANCj4gTXkgZmF1bHQsIGl0IGRvZXMgbm90IGV4aXN0IGluIHY3LiBJdCBpcyBh
IGZ1bmN0aW9uIEkgYWRkZWQgaW4gdjggd2hpbGUNCj4gc3BsaXR0aW5nIHRoZSBsb2NrZWQgcmVn
aW9uIG91dCBmb3IgZ3VhcmQoKSwgYW5kIEkgYXNrZWQgeW91IGFib3V0IGl0DQo+IHdpdGhvdXQg
c2F5aW5nIHRoYXQuIFNvcnJ5IGZvciB0aGUgY29uZnVzaW9uLiBJbiB2OCB0aGUgdHJhbnNmZXIg
bW92ZWQNCj4gaW50byBydHdfc2Rpb193cml0ZV90b19wb3J0KCksIGNhbGxlZCBmcm9tIGJvdGgg
dGhlIGdlbmVyaWMgcGF0aCBhbmQgdGhlDQo+IDg3MjNCUyBvbmUsIGFuZCB0aGUgd2FybmluZyBo
YWQgdG8gZ28gZWl0aGVyIGluc2lkZSBpdCBvbmNlIG9yIGluIGJvdGgNCj4gY2FsbGVycy4gVGhh
dCB3YXMgdGhlIHdob2xlIG9mIG15IHF1ZXN0aW9uLg0KDQpMZXQncyByZXZpZXcgaXQgYnkgdjgu
IFBsZWFzZSBoZWxwIHRvIG1lbnRpb24gdGhpcyBieSBjaGFuZ2UgbG9nLg0KDQo+IA0KPiA+IElz
IHRoaXMgYSBub3JtYWwgY2FzZT8gQ2FuIGN1cnJlbnQgc2Rpby5jIGhhbmRsZSB0aGlzIHByb3Bl
cmx5Pw0KPiA+IElmIHNvLCBJJ2QgY2hhbmdlIHRvIGRlYnVnIGxldmVsLg0KPiANCj4gSXQgc2hv
dWxkIG5ldmVyIGhhcHBlbi4gcnR3X3NkaW9fdHhfc2tiX3ByZXBhcmUoKSBhbGlnbnMgdGhlIHBv
aW50ZXINCj4gaXRzZWxmOiBpdCBwdXNoZXMgdGhlIHBhY2tldCBkZXNjcmlwdG9yLCBhbmQgaWYg
dGhlIHJlc3VsdCBpcyBub3QgYWxpZ25lZA0KPiB0byBSVFdfU0RJT19EQVRBX1BUUl9BTElHTiBp
dCBwdXNoZXMgdGhlIGRpZmZlcmVuY2UgYXMgcGFkZGluZyBhbmQgdGVsbHMNCj4gdGhlIGZpcm13
YXJlIGFib3V0IHRoZSBzaGlmdGVkIG9mZnNldC4gbWFpbi5jIHJlc2VydmVzIHRob3NlIDggYnl0
ZXMgaW4NCj4gaHctPmV4dHJhX3R4X2hlYWRyb29tIGZvciBTRElPIHNvIHRoZSBwdXNoIGFsd2F5
cyBoYXMgcm9vbS4gU28gYnkgdGhlIHRpbWUNCj4gcnR3X3NkaW9fd3JpdGVfcG9ydCgpIHJ1bnMg
dGhlIHBvaW50ZXIgaXMgYWxpZ25lZCBieSBjb25zdHJ1Y3Rpb24sIGFuZCB0aGUNCj4gY2hlY2sg
aXMgcmVhbGx5IGFuIGFzc2VydGlvbiB0aGF0IHRoZSBhbGlnbm1lbnQgc3RlcCBkaWQgaXRzIGpv
Yi4NCj4gDQo+IEl0IGhhcyBuZXZlciBmaXJlZCBoZXJlLCBhY3Jvc3MgYWxsIHRoZSB0ZXN0aW5n
IG9uIHRoaXMgY2hpcC4NCj4gDQo+IFNvIEkgd291bGQga2VlcCBpdCBhdCB3YXJuIHJhdGhlciB0
aGFuIGRlYnVnLiBJZiBpdCBldmVyIGRvZXMgZmlyZSBpdCBtZWFucw0KPiB0aGUgYWxpZ25tZW50
IHBhdGggYWJvdmUgaXMgYnJva2VuLCBhbmQgdGhlIHRyYW5zZmVyIHdvdWxkIGdvIG91dCB3aXRo
IGENCj4gbWlzYWxpZ25lZCBwb2ludGVyLCB3aGljaCBpcyB3b3J0aCBiZWluZyBsb3VkIGFib3V0
LiBCdXQgaXQgaXMgeW91ciBjb2RlDQo+IGFuZCB5b3VyIGNhbGwuDQoNCk9rYXkuIA0KDQpCeSB0
aGUgd2F5LCBJJ20gbm90IHNvIGZhbWlsaWFyIHdpdGggU0RJTyBjb2RlLiBKdXN0IGxlYXJuIGJ5
IHJldmlld2luZy4gOikNCg0KUGluZy1LZQ0KDQo=
