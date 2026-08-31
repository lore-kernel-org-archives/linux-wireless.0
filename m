Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC35224B1E;
	Mon, 31 Aug 2026 01:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788139757; cv=none; b=QzQbMK1+DqZIRBLIj7PoRKXP/SasitC5WXELOr6XEpQsNwyyCRuSvqFRRAXmvUgEMUvurUZFhur9UO+jFiad2ux8n08jTuLqm08ffMSlFAa8sn/HBfLIezpmrR1BxWiq6tP1O8cghU3DF8egku0yN65TDX6f6ej7nEFXGbas8C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788139757; c=relaxed/simple;
	bh=DZXRvjoDNv+E94JYs2+hYSLZJxbqJ6iy0Kk80E1n40g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mWYqZs8AlBCdqCWuNEzYYk4NjJvKH2Y6lAabs3hc/CXGMXmW4a8HUQCNYvtQIGF6NgJ73zoyGF52UiEV7IkJKgeSfReXRM4dz6LoYBoJP856HmrK/REH2hSMCiOmdg8msGv2GF5mHWgFnC8YdqcMV1W/HmIxrRCbbNBlsB8bX9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XHITpNOB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XHITpNOB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67V1T0Nf8343201, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788139740; bh=DZXRvjoDNv+E94JYs2+hYSLZJxbqJ6iy0Kk80E1n40g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=XHITpNOB2x2gU1LFG6f5zFsbe6FvRsjUQ7EasPMzouA0p+cQ5vPzLSoM7UvEMEfBs
	 VMtxZ8l1K2d/0KO5GJT4nhQFwuKuuI+X0kPIHT8enqFK9lrUYbWzn9DHvv+ItleHcy
	 djwRLRwpiLD9nLTfwlu6DpmCD0kcIZ4EjBgXObAblkWb/noQpMkLaUj6LQ7DetXDOQ
	 LF/79TJN7jRgOepWuZJ7FTf9+n7Kj7SEopBCeYQB6CpRK1VGp3H6Kq9waqM/6+04e0
	 EcbRmFFMA0QWYa50U2QRkdAzKZh4Q6i5RsS2CWLO+EUT8fYwHcQd75/O3wAuu0Z4lv
	 pl9GzV05PJkLA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67V1T0Nf8343201
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 31 Aug 2026 09:29:00 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 31 Aug 2026 09:29:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 31 Aug 2026 09:29:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 31 Aug 2026 09:29:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v8 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v8 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdNK+E+2zknme7j02xPKXo7LOY17azMKZg//+CRgCABK4S4A==
Date: Mon, 31 Aug 2026 01:29:01 +0000
Message-ID: <31b62e61b923484fba30e635373011f8@realtek.com>
References: <20260825163314.1590-1-luka.gejak@linux.dev>
 <20260825163314.1590-5-luka.gejak@linux.dev>
 <068b8747563444869e19399fbfa78654@realtek.com>
 <78117767-9F3F-4A53-A1C0-02B22ED32C52@linux.dev>
In-Reply-To: <78117767-9F3F-4A53-A1C0-02B22ED32C52@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBIaSBQaW5nLUtlLA0K
PiANCj4gT24gQXVndXN0IDI4LCAyMDI2IDExOjIzOjI2IEFNIEdNVCswMjowMCwgUGluZy1LZSBT
aGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiANCj4gPiBTaW5jZSB5b3UgaGF2ZSB0
d28gYnJhbmNoZXMgZm9yIFJUTDg3MjNCUyBhbmQgb3RoZXJzLCBsZXQncyBpbXBsZW1lbnQNCj4g
PiB0aGVtIGJ5IGluZGl2aWR1YWwgZnVuY3Rpb25zLiBIZXJlIGNhbiBqdXN0IGRpc3BhdGNoLCBs
aWtlDQo+IA0KPiBXaWxsIGRvIGluIHY5Lg0KPiANCj4gVHdvIGRldGFpbHMgSSB3b3VsZCByYXRo
ZXIgYXNrIGFib3V0IHRoYW4gZGVjaWRlIG9uIG15IG93biwgc2luY2UgYm90aA0KPiB0b3VjaCB0
aGUgb3RoZXIgU0RJTyBwYXJ0cyByYXRoZXIgdGhhbiB0aGlzIGNoaXAuDQo+IA0KPiBUaGUgdW5h
bGlnbmVkIFNLQiB3YXJuaW5nIHVzZXMgX19mdW5jX18sIGFuZCB0b2RheSB0aGF0IHJlc29sdmVz
IHRvDQo+IHJ0d19zZGlvX3dyaXRlX3BvcnQgb24gZXZlcnkgY2hpcC4gT25jZSB0aGUgZ2VuZXJp
YyBwYXRoIG1vdmVzIGludG8gaXRzDQo+IG93biBmdW5jdGlvbiB0aGUgc3RyaW5nIGJlY29tZXMg
dGhhdCBmdW5jdGlvbidzIG5hbWUgZm9yIDg3MDNiLCA4NzIzZCwNCj4gODgyMWMsIDg4MjJiIGFu
ZCA4ODIyYy4gTm90aGluZyByZWFkcyBpdCwgYnV0IGl0IGlzIHN0aWxsIGEgdmlzaWJsZQ0KPiBj
aGFuZ2UgdG8gcGFydHMgdGhpcyBzZXJpZXMgaXMgbm90IGFib3V0LiBUaGUgb3B0aW9ucyBJIHNl
ZSBhcmUgdG8gbGV0DQo+IGl0IGNoYW5nZSBhbmQgc2F5IHNvIGluIHRoZSBjaGFuZ2UgbG9nLCB0
byBkcm9wIF9fZnVuY19fIGFuZCB3b3JkIHRoZQ0KPiBtZXNzYWdlIHdpdGhvdXQgYSBmdW5jdGlv
biBuYW1lLCBvciB0byBrZWVwIHRoZSBjaGVjayBpbiB0aGUgZGlzcGF0Y2hlcg0KPiBzbyB0aGUg
c3RyaW5nIHN0YXlzIGFzIGl0IGlzLg0KPiANCj4gSSB3b3VsZCB0YWtlIHRoZSBmaXJzdCwgc2lu
Y2UgdGhlIG5hbWUgdGhlbiBzaW1wbHkgZm9sbG93cyB3aGljaGV2ZXINCj4gZnVuY3Rpb24gcmFu
LiBUaGUgdGhpcmQgaXMgdGhlIG9ubHkgb25lIHRoYXQgbGVhdmVzIHRoZSBvdGhlciBwYXJ0cw0K
PiBjb21wbGV0ZWx5IGFsb25lLCBidXQgaXQgd291bGQgbW92ZSB0aGUgd2FybmluZyBhaGVhZCBv
Zg0KPiBydHdfc2Rpb19jaGVja19mcmVlX3R4cGcoKSBvbiB0aGUgZ2VuZXJpYyBwYXRoLCBzbyBh
IHBhZ2Ugc2hvcnRhZ2Ugd291bGQNCj4gc3RhcnQgbG9nZ2luZyBhIGxpbmUgaXQgZG9lcyBub3Qg
bG9nIHRvZGF5LiBUaGF0IHNlZW1zIHdvcnNlIHRoYW4gdGhlDQo+IHN0cmluZyBjaGFuZ2luZy4g
U2F5IGlmIHlvdSB3b3VsZCByYXRoZXIgaGF2ZSBpdCBlaXRoZXIgb2YgdGhlIG90aGVyDQo+IHdh
eXMuDQoNCkkgdGhpbmsgX19mdW5jX18gaXMgb25seSB0byBhZGRyZXNzIHdoaWNoIHBhdGggaXMg
cnVubmluZywgc28gSSBkb24ndA0KaGF2ZSBiaWFzLiBUYWtlIHRoZSBvbmUgeW91IGxpa2UuIA0K
DQpIb3dldmVyLCBpZiB5b3UgaGF2ZSBzaW1wbGUgcHNldWRvIGNvZGUgYXMgZXhhbXBsZXMsIGl0
J2QgYmUgZWFzaWVyDQp0byB0YXN0ZS4NCg0KSSBmZWVsIHRoZSB0aGlyZCBpcyBhbHNvIG5vdCBi
YWQ6DQoNCmludCBydHdfc2Rpb193cml0ZV9wb3J0KCkNCnsNCiAgICBpZiAodW5hbGlnbmVkKHNr
Yi0+ZGF0YSkpDQogICAgICAgIHJ0d193YXJuKHJ0d2RldiwgIi4uLi4iKTsNCg0KICAgIGlmIChy
dHdfaXNfODcyM2JzKCkpDQogICAgICAgIHJ0d19zZGlvX3dyaXRlX3BvcnRfODcyM2JzKCkNCiAg
ICBlbHNlDQogICAgICAgIHJ0d19zZGlvX3dyaXRlX3BvcnRfZ2VuZXJpYygpDQp9DQoNCj4gDQo+
ID4gcnR3X3NkaW9fd3JpdGVfcG9ydF84NzIzYnMoKQ0KPiANCj4gVGhlIGNoaXAgc3BlY2lmaWMg
aGVscGVycyBhbHJlYWR5IHVzZSB0aGUgXzg3MjNic18gcHJlZml4LCB3aGljaCBpcyB0aGUNCj4g
Y29udmVudGlvbiB5b3UgYXNrZWQgZm9yIGluIHY0LCBzbyBJIHBsYW4gdG8ga2VlcA0KPiBydHdf
c2Rpb184NzIzYnNfd3JpdGVfcG9ydCgpIGFuZCBhZGQgcnR3X3NkaW9fd3JpdGVfcG9ydF9jb21t
b24oKQ0KPiBuZXh0IHRvIGl0LiBIYXBweSB0byByZW5hbWUgdGhlbSB0byBtYXRjaCB5b3VyIHNr
ZXRjaCBpZiB5b3Ugd291bGQNCj4gcmF0aGVyIHRoZXkgcmVhZCB0aGF0IHdheS4NCg0KQXQgdGhp
cyBtb21lbnQsIEkgcHJlZmVyIGhhdmluZyBzaW1pbGFyIG5hbWluZyBmb3IgdGhpcyBzZXJpZXMg
b2YNCmZ1bmN0aW9ucywgc28gSSBwcm9wb3NlIHJ0d19zZGlvX3dyaXRlX3BvcnRfKiBhcyBwcmVm
aXguIA0KDQpCeSB0aGUgd2F5LCB1c2luZyAnZ2VuZXJpYycgc2VlbXMgbW9yZSBzdWl0YWJsZSB0
aGFuICdjb21tb24nIEkgcHJvcG9zZWQuDQoNCg0K
