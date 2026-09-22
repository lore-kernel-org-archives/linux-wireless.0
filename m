Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B5B1DC198;
	Tue, 22 Sep 2026 00:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790036945; cv=none; b=QfsxgHTRsk6DKjKn2BxKE3rPOgcJ3baSblOx0G3Eay/fhs5e1O3DRYpBNOD40rhvO71eI4RYizX28bruQQoMTi9ejQO8XzeCbS3DtK0sLVAsvAqdAulsJcWsQh2evshFF6PVLfAmg7oipnbexDZxfPd/p7Uf0feYFOAONrFkTgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790036945; c=relaxed/simple;
	bh=n7B7jdiRS7bIuaoPrxGTnoJxQRC1M7+u+8sa5u0UyuQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jUZBVjVukF2HAToqVhNp+MHvWrZKqjIL/+gHK9dB0nuCXA/I4+bwZCcQsoj1zK/zpGbHqMNxepQ90EbOe7SkH34gBjKwN+M9LaJgFLjEr0hp+mmO8wB62K7l75CvSHB1LBFbAt5fgn59W6IUtOb5mEpdJoJb2yFym/zxwjSx5Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XEjyBBS7; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XEjyBBS7"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68M0SeoV63068831, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790036920; bh=n7B7jdiRS7bIuaoPrxGTnoJxQRC1M7+u+8sa5u0UyuQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=XEjyBBS7Upj/Fd5ccm7lRe74TmethZ9p0+tW8S0kkutowzN0WT5CZJbwDvBwWlgUw
	 z2NXZfj9804TJN/m85o5J5F2ArrG2Hgqg1ENBgkm67rMlH4XT4vyf97Ys9ui5fuUw6
	 FhV3ABrZdBV7szIPBafB3ytdI+iHzzyq2AIcxdpz7sxyEpF+svkI4tpDOKxGruvzQw
	 k9NGPyrtoA2vejyyCeb+VYcngPp2z5j1X3Gc4Oqx6YxQmgAzz4u1LHMsxXsB+WWCeS
	 VdA4Xar3TTy2qxZqPuNO3nvSTF7rnwwRNo28C6yleE6fQ+e+Dtv6RdqMACnC3S1Dck
	 EHrk8ARA/tLVg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68M0SeoV63068831
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 22 Sep 2026 08:28:40 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 08:28:40 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 08:28:40 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 22 Sep 2026 08:28:40 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
Thread-Topic: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
Thread-Index: AQHdSeAeQzf2/kHhyEaOG4CaLogmfLbYsc0AgAAGuQCAABezgIAASM4AgAAWAACAAI0MQA==
Date: Tue, 22 Sep 2026 00:28:40 +0000
Message-ID: <fe3c6884a96b476799f415a06314f1ba@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-7-luka.gejak@linux.dev>
 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
 <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
 <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
 <bcd5a280-8184-4457-ae52-47a9e0fe763c@oss.qualcomm.com>
 <ffe834a8a469d5febb7e73de371d662f9a0d115f@linux.dev>
In-Reply-To: <ffe834a8a469d5febb7e73de371d662f9a0d115f@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBTZXB0ZW1iZXIgMjIs
IDIwMjYgYXQgMTozNSBBTSwgIkplZmYgSm9obnNvbiIgPGplZmYuam9obnNvbkBvc3MucXVhbGNv
bW0uY29tPiB3cm90ZToNCj4gDQo+IA0KPiA+DQo+ID4gT24gOS8yMS8yMDI2IDExOjE0IEFNLCBK
b2hhbm5lcyBCZXJnIHdyb3RlOg0KPiA+DQo+ID4gPg0KPiA+ID4gT24gTW9uLCAyMDI2LTA5LTIx
IGF0IDE2OjQ5ICswMDAwLCBMdWthIEdlamFrIHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4NCj4gPiA+
ID4gSXQgaXMgc3VwcG9zZWQgdG8gd29yayBpbiB0aGUgc2FtZSB3YXkgaXQgd29ya3MgZm9yIG90
aGVyIGRyaXZlcg0KPiA+ID4gPiAgbWFpbnRhaW5lcnMuIEkgd291bGQgcmV2aWV3IHBhdGNoZXMg
YW5kIHByb3ZpZGUgbXkgYWNrZWQgYnkgb3INCj4gPiA+ID4gIHJldmlld2VkIGJ5IHRoZW0gYW5k
IFBpbmctS2Ugd291bGQgYXBwbHkgdGhlbSB0byBoaXMgcnR3LW5leHQgYnJhbmNoLg0KPiA+ID4g
Pg0KPiA+ID4NCj4gPiA+ICBJIGRvbid0IHRoaW5rIHdlIGhhdmUgYSBsb3Qgb2YgZm9sa3MgYmVs
b3cgdGhlIGRyaXZlciBtYWludGFpbmVycyB3aG8gcw0KPiA+ID4gIGVuZCBtZSBwdWxsIHJlcXVl
c3RzIChleGNlcHQgVG9rZSBtYXliZT8pIC0gYnV0IGFzIGxvbmcgYXMgSSBkb24ndCBuZWVkDQo+
ID4gPiAgdG8gZGVhbCB3aXRoIGl0IEknbSBoYXBweSwgeW91IGNhbiBmaWd1cmUgaXQgb3V0IGJl
dHdlZW4geW91cnNlbHZlcyA6KQ0KPiA+ID4NCj4gPiBGb3IgYXRoLmdpdCB0aGVyZSBhcmUgc3Vi
LW1haW50YWluZXJzIGZvciBhdGg1ayAoTXVsdGlwbGUpLCBhdGg5ayAoVG9rZSksDQo+ID4gY2Fy
bDkxNzAgKENocmlzdGlhbiksIGFuZCB3Y24zNnh4IChMb2ljKS4NCj4gPg0KPiA+IFRva2UgaGFz
IGEgbGludXgtd2lyZWxlc3MgcGF0Y2h3b3JrIGFjY291bnQgc28gdGhlIGF0aDlrIHBhdGNoZXMg
YXJlIGluaXRpYWxseQ0KPiA+IGFzc2lnbmVkIHRvIGhpbSBpbiBwYXRjaHdvcmssIGFuZCBoZSBB
Y2tzIG9uIHRoZSBsaXN0IGFuZCBhc3NpZ25zIHRoZQ0KPiA+IHBhdGNod29yayByZWNvcmRzIHRv
IG1lIHdoZW4gaGUgYXBwcm92ZXMgcGF0Y2hlcy4NCj4gPg0KPiA+IEZvciB0aGUgb3RoZXJzIHRo
ZSBtYWludGFpbmVycyBqdXN0IEFjayBvbiB0aGUgbGlzdCwgYW5kIEkgdGFrZSB0aGVtIGZyb20g
dGhlcmUuDQo+ID4NCj4gPiBTbyB0aGUgcXVlc3Rpb24gaXMgZG8gaG93IGRvIHlvdSB3YW50IHRv
IGhhbmRsZSB0aGlzIGluIHBhdGNod29yaz8NCj4gPg0KPiA+IC9qZWZmDQo+ID4NCj4gDQo+IFdo
YXQgZG8geW91IHRoaW5rIG1ha2VzIG1vcmUgc2Vuc2UgaGVyZTogcGF0Y2h3b3JrIGRlbGVnYXRl
DQo+IGFjY2VzcyBsaWtlIFRva2UgaGFzIGZvciBhdGg5aywgb3Igb24gbGlzdCBhY2sgYmFzZWQ/
IEknZCBsZWFuDQo+IHRvd2FyZHMgZGVsZWdhdGUgYWNjZXNzIGlmIGl0J3Mgbm90IGEgYmlnIGFz
ayBvbiB5b3VyIGVuZCwgYnV0DQo+IGhhcHB5IHRvIGdvIHdpdGggd2hhdGV2ZXIgd29ya3MgYmVz
dCBvcGVyYXRpb25hbGx5IGZvciB5b3UuDQoNCkknbSBoYXBweSB0aGF0IHBlb3BsZSBqb2luIHJ0
dzg4IHJldmlld2Vycy4gDQoNClBlcnNvbmFsbHkgSSBwcmVmZXIgcGVvcGxlIGdpdmUgUmV2aWV3
ZWQtYnkgdGFnIHRvIHRoZSBwYXRjaGVzLCBhbmQNCkkgY2FuIG15c2VsZiB0YWtlIHRoZSBwYXRj
aGVzIGJ5IHBhdGNod29yayBzdGF0ZSBhbmQgc2VuZCBwdWxsLXJlcXVlc3QNCnRvIEpvaGFubmVz
LiANCg0KV2l0aCBhZGRpdGlvbmFsIGZsb3dzIG9mIHBhdGNod29yayBhbmQgcHVsbC1yZXF1ZXN0
LCBpdCBsb29rcyBtdWNoDQpoYXJkIHRvIG1haW50YWluLCBzaW5jZSBJIGRvbid0IHRoaW5rIHRo
ZXJlIHdpbGwgYmUgYSBsb3Qgb2YgcGF0Y2hlcyBvZg0KZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydHc4OC9ydHc4NzIzYioue2MsaH0NCg0KQnkgdGhlIHdheSwgaWYgeW91IGFyZSBpbnRl
cmVzdGVkIGluIHJ0dzg4LCBtYXliZSBhZGQgYSAiUjoiDQplbnRyeSB0byBiZSBhIHJldmlld2Vy
IG9mIHJ0dzg4Pw0KDQpQaW5nLUtlDQoNCg==
