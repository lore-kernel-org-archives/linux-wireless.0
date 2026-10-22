Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792647616;
	b=wyW+/rOfaCCvVXpuaVhesP2s6eyOf41H5dv98X0pnc0+C2bzShA4r93VkdO+WraJO8Kp
	 eRnwVOGTEIzazvAqZVU34dxTxfrSp1SlBTKSGt36HluN+M0fuE7P+NWyQlmOFp2TAv1V/
	 AF93mMWo6Af2ScE2eIyC7P75M4x1PLDB5w/yobFPZhKXvmCZdtqUm78krDpfQllW9L6ho
	 58rVsuz4609fpkNekJRA2SrV9mUgBRBYcv9mGpuJE07bOcMEvaR5zLr+igI6DHG3gaVxg
	 0ESaewxguFoCaVNZCLpOXP+t5zAfRzbO8WExrOIckmZWen1aUhiS86niyFleYo/l/4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792647616;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=eHNujbVAHVvVmJFTE3LatXdfjEwxzqCNyIH4RDOuvBQ=;
	b=yvhgtsgawsDKxayyW+WGHgyeNfpalC0S15EY1e7PGdnrF0PYomG7xQyQ4qfw3ifJaw+9
	 ePhKmCCqYOqPNi1+PHrotQ8SuOc2+m11GVRuIXmfZ7g72hFphtpfH2kbya2cU7lokCgXk
	 Sdls/UboVuIpQhtV8jPGKSrT/CQzRbPz57mExDF8yyibDhdq9KB1HPhrH1tFokqy0IcL/
	 zTa3IeS9H4Tru1Mm2zdiuW9BkQxZpe+Y7g5izqhzOcUwiib4j4/k9/FGle52ojgnxQ1nV
	 uvcK5u0T2Eqi9Vw0HQuM+Khl1tPxXNefWycPskatSUTj6ZBFUVdI8YQiN5B6Wv+UG+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=p1dzO5v8;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45408606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 05:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45408606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=p1dzO5v8
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69M5duhV7637722, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792647596; bh=eHNujbVAHVvVmJFTE3LatXdfjEwxzqCNyIH4RDOuvBQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=p1dzO5v8SLc0GYdBLANpfLMWrtK/+uI9g5TPwWAPeE0tNeAIVWmEg+TEeCy45J+ER
	 4Z5BaolkQZXS/5IGICYjFUJqWmPu2rjl0TQ73MZfjTd1rtg7iihL7UEqXxkjrU46fz
	 svIQbS7O5G6Lft2s9lAxo8C01SB3Qx47hXNF2xtbJN8Ussr0+7FCkGJBUjDmY5N6ae
	 MfWTetrky2TL0qqJd/LZInU5crEJrwh8/vVaSwEq9/Y4lQCQRwJsrzYw3zoDAlxTD7
	 QviNtEgG9x9aN0Zc+oqnQPWkrQOLWcE4oVhVDsr9aKpVoym5jSBFSiRcHC3i07PapS
	 8VEAvqeTzWhMA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69M5duhV7637722
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 13:39:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 13:39:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 13:39:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 22 Oct 2026 13:39:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bob Beckett <bob.beckett@collabora.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Luka
 Gejak" <luka.gejak@linux.dev>, Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Timlee <timlee@realtek.com>, "matthew.leach@collabora.com"
	<matthew.leach@collabora.com>, "kernel@collabora.com" <kernel@collabora.com>
Subject: RE: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted, poisoning
 CCMP replay counter
Thread-Topic: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted,
 poisoning CCMP replay counter
Thread-Index: AQHdXaL8zmsOj0CE6U6ENy6Km2GOWLcHlFUQgABIg4CAATP90A==
Date: Thu, 22 Oct 2026 05:39:55 +0000
Message-ID: <90c40c3223c34562b2c171c52d987c2e@realtek.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com>
 <20261021190529.3893821-1-bob.beckett@collabora.com>
In-Reply-To: <20261021190529.3893821-1-bob.beckett@collabora.com>
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

Qm9iIEJlY2tldHQgPGJvYi5iZWNrZXR0QGNvbGxhYm9yYS5jb20+IHdyb3RlOg0KPiBPbiBXZWQs
IDIxIE9jdCAyMDI2IDA3OjMwOjU4ICswMDAwLCBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVr
LmNvbT4gd3JvdGU6DQo+ID4gQm9iIEJlY2tldHQgPGJvYi5iZWNrZXR0QGNvbGxhYm9yYS5jb20+
IHdyb3RlOg0KPiA+ID4NCj4gPiA+IFRoZSBBUCdzIG93biBQTiBzZXF1ZW5jZSBpcyBjb25zaXN0
ZW50IGJlZm9yZSBhbmQgYWZ0ZXIgdGhlIGJhZCBmcmFtZSwNCj4gPiA+IHNvIHRoZSBjb3JydXB0
aW9uIGhhcHBlbnMgb24gdGhlIHJlY2VpdmUgc2lkZS4NCj4gPg0KPiA+IE1heWJlIHRoaXMgaXMg
YSBoaW50IHRvIG1ha2UgYSBwYXRjaCB0byBkZWZlciAoZHJvcCkgcmVwb3J0aW5nIHdlaXJkIHBh
Y2tldCwNCj4gPiBhcyBMdWthIGhhcyBmaXhlZCAzIG9mIDQgcHJvYmxlbXMuDQoNCkkgcXVpY2ts
eSBjaGVja2VkIHRoZSBkZWJ1ZyBwYXRjaGVzLCB3aGljaCBzZWVtIG5vdCBkZXRlY3QgaWYgUE4g
c2VxdWVuY2UgaXMNCmNvcnJlY3QgYWZ0ZXIgdGhlIGJhZCBmcmFtZSwgZm9yIGV4YW1wbGUNCiAg
c2VxICAgICBQTg0KICAgMSAgICAgIDEwMQ0KICAgMiAgICAgIDk5OTk5ICAgLy8gYmFkIGZyYW1l
LiBzaG91bGQgYmUgMTAyLg0KICAgMyAgICAgIDEwMyAgICAgLy8gbm90IGRldGVjdCB0aGlzDQoN
Ck9yIEkgbWlzc2VkIHNvbWV0aGluZz8NCg0KPiA+ID4gNC4gRm9yIGNvbXBsZXRlbmVzczogb24g
dGhlc2UgY2hpcHMgY2FuIFJYQkRfSURYIG9yIHRoZQ0KPiA+ID4gICAgYnVmZmVyLWRlc2NyaXB0
b3IgUlggdGFnIGV2ZXIgYmUgdXBkYXRlZCBiZWZvcmUgdGhlIHBhY2tldCBkYXRhIERNQQ0KPiA+
ID4gICAgaGFzIGNvbXBsZXRlZCwgYXMgZGVzY3JpYmVkIGZvciBXaUZpIDcgaW4gcnR3ODkgMGJj
N2QxZDRlNjNjPw0KPiA+DQo+ID4gVGhlIFJYIHRhZyBpbiBydHc4OCBsb2NhdGVkIG9uIG1lbW9y
eSBhbGxvY2F0ZWQgYnkgZG1hX2FsbG9jX2NvaGVyZW50KCksIGFuZA0KPiA+IHRoZSBSWCB0YWcg
bXVzdCBiZSBzZXQgYWZ0ZXIgcGFja2V0IGRhdGEgTUFDIGNvbXBsZXRlZC4NCg0KKGZpeCB0eXBv
OiAgICAgICAgICAgICAgICAgICAgICAgICAgLi4uIGRhdGEgRE1BIGNvbXBsZXRlZC4pDQoNCj4g
DQo+IFVuZGVyc3Rvb2QgdGhhdCB0aGlzIGlzIHRoZSBkZXNpZ24gaW50ZW50LiBNeSBxdWVzdGlv
biB3YXMgd2hldGhlciB0aGUgaG9zdCBjYW4NCj4gZXZlciBvYnNlcnZlIHRoZSB0YWcgYmVmb3Jl
IHRoZSBkYXRhLiBkbWFfYWxsb2NfY29oZXJlbnQoKSBvbmx5IG1ha2VzIHRoZSB0YWcNCj4gdmlz
aWJsZSB0byB0aGUgQ1BVIHdpdGhvdXQgY2FjaGUgbWFpbnRlbmFuY2U7IHRoZSBwYXlsb2FkIGlz
IGluIGEgc2VwYXJhdGUNCj4gc3RyZWFtaW5nIG1hcHBpbmcgKGEgU1dJT1RMQiBib3VuY2UgYnVm
ZmVyIG9uIHRoaXMgcGxhdGZvcm0pLCBzbyB0aGUgb3JkZXIgaW4NCj4gd2hpY2ggdGhlIGhvc3Qg
c2VlcyB0aGVtIGRlcGVuZHMgb24gdGhlIG9yZGVyIG9mIHRoZSBkZXZpY2UncyBQQ0llIHdyaXRl
cy4NCj4gUmVsYXhlZCBPcmRlcmluZyBpcyBlbmFibGVkIG9uIHRoZSA4ODIyQ0UgaGVyZSAoRGV2
Q3RsIFJseGRPcmQrKS4NCj4gRG9lcyB0aGUgODgyMkNFIHNldCB0aGUgUk8gYXR0cmlidXRlIG9u
IFJYIERNQSB3cml0ZXMsIGluIHBhcnRpY3VsYXIgdGhlDQo+IGJ1ZmZlci1kZXNjcmlwdG9yL3Rh
ZyB1cGRhdGU/IElmIGl0IGRvZXMsIHRoZSB0YWcgd3JpdGUgbWF5IHBhc3MgdGhlIHBheWxvYWQN
Cj4gd3JpdGVzLg0KPiANCj4gV2UgYXJlIGhvcGluZyB0byB0ZXN0IHRoaXMgZGlyZWN0bHkgd2l0
aCB0aGUgbmV4dCByb3VuZCBvZiB0ZXN0cy4gdGhlIHJ4X2RlYnVnDQo+IG9wdGlvbiByZS1zeW5j
cyBhIHN1c3BlY3QgYnVmZmVyIDEwMCB1cyBsYXRlciwgc28gbGF0ZSBwYXlsb2FkIHdyaXRlcyBt
aWdodA0KPiBzaG93IHVwIGFzIGNoYW5nZWQgYnl0ZXMsIGFuZCB3ZSBjYW4gcmVwZWF0IHRoZSB0
ZXN0IHdpdGggUmVsYXhlZCBPcmRlcmluZw0KPiBkaXNhYmxlZC4NCg0KSSdsbCBjaGVjayB0aGUg
YmVoYXZpb3IgaW50ZXJuYWxseSBhbmQgZ2V0IGJhY2sgdG8geW91LiANCg0KDQo=
