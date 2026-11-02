Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793589143;
	b=I1D3QIb2FJNt57q3PUtlDIU3nDQvt9S6tNC8bVaSQZfvlOnCbawy4wCBJesYuKB8YLUG
	 M5jEvehUsxLHvCRwVS0GNzcrGb4BMP82P6NFkYxAiH0HwkfVG4i18voh0DYxPXoGj6rWT
	 4mcLMBNAr0ZSoSL06QKOyFgF1ppQIsc20Azc6nAUeYgjJ3Mk/wH+rDg+ipWYyyHitKApX
	 meT3v8BUIHaQbqerntYVtbNfxtKJ+MkMuPqUwcew+J390AzAQ6s42Sn6tFxkaHGkgoAng
	 MAFxbQgCwa0n5GBJkQQtrCg7Z9M11/DJ7NJrRzxZen8WiMOGrIgcBn07oogiOjB/eXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793589143;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=AYBKL9XjsmurixfqmHMoWMsCCZogboJCU1l9zngJ7v4=;
	b=Wi7vCoUX56c/hQWguCIdWWpLl8YZNh0YHlns3p4GW8KOl/9criv6J0a4NGKrYZK2qMuV
	 MPMQ9zExy6ZpKXxxayO8GN2/ePtm8ZIHbZWI2MawtkAqEiTR5zEDyZSehg9xKfxZSgEH9
	 VumKw1iLqnx3m7sdp8ZFYvLvABG+x8KfxaEwRSjaN+SNHWT51y5W7FfGjy3CtASJwVXdP
	 RNuLjhCHSI0T2rlNhdRD2nz+K2Yuy2xwJED82qPyd1tA3yN7j9cyu9Rb49mEV456Q2bHh
	 MNiSrbrPfkKPtEcwycfB40UNXnTjKkH0Gq6FTTUM/1HkXWO5h8fuEKhYNfDAa0okoaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="lKjMeM7/";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E76606A324;
	Mon,  2 Nov 2026 03:12:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2E76606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=lKjMeM7/
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A23C09v81812815, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793589120; bh=AYBKL9XjsmurixfqmHMoWMsCCZogboJCU1l9zngJ7v4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=lKjMeM7/GLif4Nt210Sb+NbN4t5oXjUjBwvbQt3ZDouqAU3DCJ/ib8xWpLfaPiWgL
	 mFJONnrKrl5rNinlxBhM5uIw24H2cTFeJJiVZ+YjZgLD1f8cqosGw5DuYwe5PirVKy
	 5dIIkYYELYkzc0InwC1MkrhKUgQB1ftY6jXxRkyV0LPyk/w1XtSkLLelwcuG2A6/jd
	 VmqhJZPfxYqWudnXeAJgAQepZ9R5pmATxKXqNOBbCLFnLvqmerFQkkzqH4tM85Q7tS
	 tA/wFzujSO13CRpB9sAZaC6plz0tdv77ihJXvH8/No64vuXymM1PybjbI6ZyoE2hG0
	 71QKzeCbIyv9A==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A23C09v81812815
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 11:12:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 11:12:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 11:11:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Mon, 2 Nov 2026 11:11:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Jie Feng <hjf3108@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Kalle
 Valo" <kvalo@kernel.org>, neo_jou <neo_jou@realtek.com>, Hans Ulli Kroll
	<linux@ulli-kroll.de>, Sascha Hauer <s.hauer@pengutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
Thread-Index: AQHdaI9vizk2vXuz70+nFp0lnrRycrcYkErAgAD4DwCAAJUpAA==
Date: Mon, 2 Nov 2026 03:11:57 +0000
Message-ID: <8006a4a9ca30478aa6c2946df5ee02e5@realtek.com>
References: <20261030165451.365591-1-hjf3108@gmail.com>
 <2d53d5420be945fc9bdfbea5542b61db@realtek.com>
 <CABOQOSWOqGEu7xHH1ap=MYqFd_oH7oAhQqCq6Ch622ipHdF5Nw@mail.gmail.com>
In-Reply-To: <CABOQOSWOqGEu7xHH1ap=MYqFd_oH7oAhQqCq6Ch622ipHdF5Nw@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

DQpKaWUgRmVuZyA8aGpmMzEwOEBnbWFpbC5jb20+IHdyb3RlOg0KPiBPbiBTdW4sIDEgTm92IDIw
MjYgYXQgMTE6NDQsIFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPiB3cm90ZToNCj4g
Pg0KPiA+IEhvIEppZSBGZW5nIDxoamYzMTA4QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gPiBXaGVu
IHJ0d191c2JfdHhfYWdnX3NrYigpIGhhcyBtb3JlIHRoYW4gb25lIGZyYW1lIHF1ZXVlZCwgaXQg
Y29waWVzIHRoZW0NCj4gPiA+IGludG8gYSBuZXcgYnVmZmVyLiBUaGF0IGJ1ZmZlciB3YXMgYWxz
byBoYW5kZWQgdG8gbWFjODAyMTEsIGFzIG9uZQ0KPiA+ID4gYWRkaXRpb25hbCBUWCBjb21wbGV0
aW9uLg0KPiA+ID4NCj4gPiA+IFJlcG9ydCBUWCBzdGF0dXMgb25seSBmb3IgdGhlIG9yaWdpbmFs
IGZyYW1lcywgYW5kIGZyZWUgdGhlIGFnZ3JlZ2F0ZQ0KPiA+ID4gYnVmZmVyIHdpdGhvdXQgcGFz
c2luZyBpdCB0byBtYWM4MDIxMS4NCj4gPg0KPiA+IFRoZSBydHdfdXNiX3dyaXRlX3BvcnQoKSBt
aWdodCBiZSBmYWlsZWQgYW5kIGNhbGwgaWVlZTgwMjExX3B1cmdlX3R4X3F1ZXVlKCkNCj4gPiB0
byBwdXJnZSB0eGNiLT50eF9hY2tfcXVldWUgbGlzdC4gU2hvdWxkIHdlIGNoZWNrIGlmIHRoZSB0
YWlsIHNrYiBvZg0KPiA+IHR4Y2ItPnR4X2Fja19xdWV1ZSAob3IganVzdCBjaGVjayBza2JfaGVh
ZCkgaXMgZHJ2X2ZyYW1lPXRydWU/DQo+IEkgdHJhY2VkIGllZWU4MDIxMV9wdXJnZV90eF9xdWV1
ZSB0byBpZWVlODAyMTFfcmVwb3J0X3VzZWRfc2tiLCBhbmQNCj4gYmFzZWQgb24gdGhlIGNvZGUg
aGVyZToNCj4gaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjcuMy9zb3VyY2UvbmV0
L21hYzgwMjExL3N0YXR1cy5jI0w3NTkNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgaXQgZnVsZmlsbHMg
YW55IG9mIHRoZSBjb25kaXRpb25zLCBzbyBkcnZfZnJhbWU9dHJ1ZSBlbnRyaWVzDQo+IHNob3Vs
ZCBqdXN0IGdvIHRocm91Z2ggYSBub3JtYWwgc2tiIGZyZWUgcGF0aC4NCg0KQ2FuIHlvdSBhZGQg
YSBkZXNjcmlwdGlvbiBpbiBjb21taXQgbWVzc2FnZSBhYm91dCB0aGlzPw0KDQo+IA0KPiA+ID4g
QEAgLTQzMSw2ICs0MzYsOSBAQCBzdGF0aWMgYm9vbCBydHdfdXNiX3R4X2FnZ19za2Ioc3RydWN0
IHJ0d191c2IgKnJ0d3VzYiwgc3RydWN0IHNrX2J1ZmZfaGVhZCAqbGlzdA0KPiA+ID4gICAgICAg
ICAgICAgICAgIGdvdG8gcXVldWU7DQo+ID4gPiAgICAgICAgIH0NCj4gPiA+DQo+ID4gPiArICAg
ICAgIC8qIHJlcG9ydCBUWCBzdGF0dXMgb25seSBmb3IgdGhlIG9yaWdpbmFsIGZyYW1lcyAqLw0K
PiA+ID4gKyAgICAgICBydHdfdXNiX2dldF90eF9kYXRhKHNrYl9oZWFkKS0+ZHJ2X2ZyYW1lID0g
dHJ1ZTsNCj4gPg0KPiA+IElmIHdlIGNhbiBqdXN0IGNoZWNrIGRydl9mcmFtZSBieSBza2JfaGVh
ZCwganVzdCBkZWNsYXJlIGEgbG9jYWwNCj4gPiAgICBzdHJ1Y3QgcnR3X3VzYl90eF9kYXRhICpz
a2JfaGVhZF90eF9kYXRhLg0KPiBJcyB0aGlzIHN0aWxsIG5lZWRlZCBpZiBpZWVlODAyMTFfcHVy
Z2VfdHhfcXVldWUgd29ya3M/DQoNCm5vIG5lZWQuIA0KDQoNCg==
