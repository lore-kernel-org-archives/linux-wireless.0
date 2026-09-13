Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C97372B45;
	Sun, 13 Sep 2026 02:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789267541; cv=none; b=gTtNBnVqTYy/nCSMqFrqkfayO89fRVoNPvsfwTUFzZZbKIhoJEcTpQYNpPtUpjB+bUdyrl1G39Jc1/bJsk7xwdm76IGysCzS68x/7LpXmcvL3NaLxEQe9mhdYwqE9GCnRsV9l65eKDvXWH47R1g5lBUVkoQ7+rQE2oxYnHNiXLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789267541; c=relaxed/simple;
	bh=VC/aVvWNe9yF/F0uJGe9mcJyfiXLtmymO5ZxbXs2Sgk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GmlLzizrf9JFmExgNNbwJKjVl3eAjf6Zk+4IyCbpuA7MQC19L4wP3ZF3FI8SruzrLXafNKSmwPswBA7IVY0lMz2GGzpkoZkr3Bu2pN1ElX8/wCMEg3A8FgK51l8Zi5XtQ6z8AkyQ2UtRCP81oRGR3zkwvjjSRbGhrvWJPDsYoi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=oXadYL+1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="oXadYL+1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68D2inSuB3606827, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789267489; bh=VC/aVvWNe9yF/F0uJGe9mcJyfiXLtmymO5ZxbXs2Sgk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=oXadYL+1BHR06sg0a4qUKnhQZt/yMpH9OPayuxrNPOTZdbM+unCpeQ9JO26eTS4aJ
	 pUAO2Prp91pkiCgaNDBe9G27hEVo8rzmlmgBo3oq35PRikSWKCB9K0w17BPlF4o4NE
	 8Y/JNExo0nvxdhe6/Ty2mTQGgdRX9E4tSRCP+Soaxe5vA1SDxDP3RO/0nJKk+lrzrW
	 aKzeVjuetHcetC3Qh+ChZ/3wD7V3IxIjSiYDFZNA0K0ATpaXq7ybSxEztnNPo4/RqE
	 CAyVUw3dEvEgh4culvfcx4nMS6PVSEhB+aPB5895bcCdZ/Zp9Dp+c791uszhZOg5ug
	 DzEucIFFbu0Ng==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68D2inSuB3606827
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 13 Sep 2026 10:44:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 10:44:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 13 Sep 2026 10:44:49 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Cristian Deluxe <me@cristiandeluxe.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] wifi: rtw88: 8703b: complete the card-disable to
 card-emulation transition
Thread-Topic: [PATCH 1/2] wifi: rtw88: 8703b: complete the card-disable to
 card-emulation transition
Thread-Index: AQHdQgqq1aVdXqHk80agk1anab5WYLbLzraA
Date: Sun, 13 Sep 2026 02:44:48 +0000
Message-ID: <e78eb1e6ce404a04a3001b13a1f87002@realtek.com>
References: <178914109042.64584.1681714272474754544@cristiandeluxe.dev>
 <178914109042.64584.1377616159988360897@cristiandeluxe.dev>
In-Reply-To: <178914109042.64584.1377616159988360897@cristiandeluxe.dev>
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

Q3Jpc3RpYW4gRGVsdXhlIDxtZUBjcmlzdGlhbmRlbHV4ZS5kZXY+IHdyb3RlOg0KPiBTZW50OiBG
cmlkYXksIFNlcHRlbWJlciAxMSwgMjAyNiAxMTozOCBQTQ0KPiBPbiBhbiBSVEw4NzIzQ1MgdGhl
IGRyaXZlciBjYW5ub3QgcG93ZXIgdGhlIE1BQyBvbiBhZnRlciBhIHdhcm0gcmVib290Og0KPiB0
aGUgcG93ZXItb24gc2VxdWVuY2Ugd2FpdHMgZm9yZXZlciBmb3IgcG93ZXIgcmVhZHkgYW5kIHBy
b2JlIGZhaWxzLg0KPiANCj4gICBydHc4OF84NzIzY3MgbW1jMjowMDAxOjE6IGZhaWxlZCB0byBw
b2xsIG9mZnNldD0weDYgbWFzaz0weDIgdmFsdWU9MHgyDQo+ICAgcnR3ODhfODcyM2NzIG1tYzI6
MDAwMToxOiBtYWMgcG93ZXIgb24gZmFpbGVkDQo+IA0KPiB0cmFuc19jYXJkZGlzX3RvX2NhcmRl
bXVfODcwM2IgaGFzIGEgc2luZ2xlIGVudHJ5LCBjbGVhcmluZyB0aGUgaGFyZHdhcmUNCj4gcG93
ZXItZG93biBiaXQuIEl0cyBzaWJsaW5nIHRyYW5zX2NhcmRkaXNfdG9fY2FyZGVtdV84NzIzZCBo
YXMgc2l4IG1vcmUsDQo+IGFuZCA4ODIyYiBhbmQgODgyMmMgY2FycnkgdGhlIHNhbWUgU0RJTyBw
YWlyOiB3aXRoZHJhdyB0aGUgU0RJTyBzdXNwZW5kDQo+IHJlcXVlc3Qgb24gbG9jYWwgcmVnaXN0
ZXIgMHg4NiBhbmQgd2FpdCBmb3IgdGhlIGludGVyZmFjZSB0byBsZWF2ZSB0aGUNCj4gc3VzcGVu
ZGVkIHN0YXRlLCBjbGVhciB0aGUgV0wgc3VzcGVuZCBiaXQgYWxvbmdzaWRlIHRoZSBwb3dlci1k
b3duIGJpdCwNCj4gYW5kIHRha2UgdGhlIDEySCBMRE8gb3V0IG9mIHNsZWVwIG1vZGUuIFRoZSB0
cmFuc2l0aW9uIGlzIHRoZSByZXZlcnNlIG9mDQo+IHRyYW5zX2NhcmRlbXVfdG9fY2FyZGRpc184
NzAzYiwgd2hpY2ggc2V0cyAweDIzWzRdIGFuZCBhc2tzIHRoZQ0KPiBpbnRlcmZhY2UgdG8gc3Vz
cGVuZCwgc28gd2l0aCB0aG9zZSBvcGVyYXRpb25zIG1pc3NpbmcgbmVpdGhlciBpcyBldmVyDQo+
IHVuZG9uZS4NCg0KSSBmZWVsIHlvdSBjYW4ganVzdCBkZXNjcmliZSB5b3Ugc3luYyB0aGUgc2V0
dGluZyBmcm9tIHZlbmRvciBkcml2ZXIuDQoNCj4gDQo+IFRoZSBjaGlwIHRoZW4gY29tZXMgYmFj
ayB3aXRoIHRoZSBXTEFOIE1BQyB1bnBvd2VyZWQgd2hpbGUgdGhlIFNESU8NCj4gZnVuY3Rpb24g
c3RpbGwgZW51bWVyYXRlcyBhbmQgQ01ENTIgc3RpbGwgd29ya3MsIGFuZCBub3RoaW5nIGluIHRo
ZQ0KPiBzZXF1ZW5jZSB3YWtlcyBpdC4gcnR3X21hY19wcmVfc3lzdGVtX2NmZygpIGRvZXMgbm90
IGNvdmVyIGl0IGVpdGhlcjogaXQNCj4gcmV0dXJucyBlYXJseSBmb3IgODA1MSB3Y3B1IGNoaXBz
LCBvZiB3aGljaCB0aGlzIGlzIG9uZS4NCj4gDQo+IEl0IHN1cnZpdmVzIGEgcmVib290IG9uIGFu
eSBib2FyZCB3aGVyZSBXTF9SRUdfT04gaXMgdGhlIG9ubHkgcmVzZXQgdGhlDQo+IGhvc3QgaGFz
IGFuZCB0aGUgY2hpcCdzIHJhaWwgaXMgbm90IHN3aXRjaGFibGUuIE9uIHRoZSBEZW52ZXIgVEFR
LTEwMg0KPiB0aGUgcHdyc2VxIHJlc2V0IGxpbmUsIHRoZSBCVCBlbmFibGUgbGluZSwgdGhlIDMy
Ljc2OCBrSHogY2xvY2sgYW5kDQo+IGV2ZXJ5IHN3aXRjaGFibGUgUE1JQyByYWlsIHdlcmUgZWFj
aCB0b2dnbGVkIGFnYWluc3QgYSB3ZWRnZWQgY2hpcCBhbmQNCj4gbm9uZSBvZiB0aGVtIGNsZWFy
ZWQgaXQsIHdoaWxlIHRoZSB2ZW5kb3IgZHJpdmVyIHJlY292ZXJlZCBpdCBldmVyeQ0KPiB0aW1l
Lg0KPiANCj4gVGFrZSB0aGUgb3BlcmF0aW9ucyA4NzIzZCBoYXMgYW5kIHRoaXMgdGFibGUgbGFj
a3MuIFRoYXQgdGFibGUncyBVU0Itb25seQ0KPiBhbmQgUENJLW9ubHkgZW50cmllcyBhcmUgbGVm
dCBvdXQ6IHRoaXMgY2hpcCBoYXMgbm8gc3VjaCB2YXJpYW50Lg0KDQpJIHNlZS4gT3RoZXJzIGFy
ZSB0aGUgc2FtZSBhcyB2ZW5kb3IgZHJpdmVyIGRvZXMuIA0KDQo+IA0KPiBUZXN0ZWQgb24gYW4g
UlRMODcyM0NTIG92ZXIgU0RJTzogcmVjb3ZlcnMgYSBjaGlwIGxlZnQgd2VkZ2VkIGJ5IGENCj4g
cHJldmlvdXMgYm9vdCwgYW5kIHN1cnZpdmVzIHJlcGVhdGVkIHdhcm0gcmVib290cyBhbmQgbG9h
ZGVyLW1vZGUgZmxhc2gNCj4gY3ljbGVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ3Jpc3RpYW4g
RGVsdXhlIDxtZUBjcmlzdGlhbmRlbHV4ZS5kZXY+DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWgg
PHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KDQoNCg==
