Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792474159;
	b=cTQLOfe3/Gb5sz0RwIUEZihjn6x8NpxQK1qlojPZpxg1lA2AHC4bEa/3UlorxJwlY48S
	 AHiDlzXKy9m4mdhdRroqJwj8Z0szCj8xvMtCPcNJFi9WXC3479HWMhQJAeCLe7iWYWGPR
	 0/4ovypP5tgH+IbdNBq4W9edLpZY5WiUWaO4eOC+Mkt5wKP+fAtwBLqHOE2cHo6gGbn+R
	 eS6pHrP+yg/LB5hq+0Ms56piE9bRD3t51AQAskUmnj3S1uTUi2R//tc/lbwRn5Q0Rzs/P
	 zyawo5SOURZ+cFsOCe1EBCc72GZ1HzJObM4r0atzCgGICsW/G/oZjEaf9ZcEiXNZlkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792474159;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=0Ub+UudVZh6+Pop1X2tCnVJRsbTR40D/96nuKlIS9ls=;
	b=lShF+xIO/qEIqy3VM8XjiTcdesiQwGNkIL6RAEmDFYkt9Qs+Ams67DWGtnQdBNusqHsr
	 er5MI1qySR6AO1ARWnK57Sgo5psJd2AputMD35i8XEPOfw55DBflqd2Db7USjijWXcGOc
	 gzR5JCCGEDPXfwyjcYy14pvEn8WykP8HFEbWKUz/4WQJJzoLyfDLYDCcg9m1bXWi9YPn+
	 N4g1eotP3ziaNb9u2oj/7MwhJ0wW1Q8KN9AMvrdayg115eXn676vq/A8d/+ieRIdjfpJB
	 PSIgcxvlImEw207Kvenbxo9Twj4zWTTwKnwTyeLxTre7pBkqozenRTbNAOuudWduxfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=r0D7+zxQ;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C630606A319;
	Tue, 20 Oct 2026 05:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C630606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=r0D7+zxQ
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69K5T7nmC2667120, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792474147; bh=0Ub+UudVZh6+Pop1X2tCnVJRsbTR40D/96nuKlIS9ls=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=r0D7+zxQ8iUtOg635DZQr2pwExg333apx1YY9BvvMdR3vJMra8K3IyHpjzmsKW9dj
	 iLtcsn/Vt/LMGdug1K3JKHS61HRcWxxsqkSns0FpWlyDRZJEE7TT0tmZp2Wdf+q2DJ
	 TtV7x7E/N6VS3MaJ9k+lwHUSLYEgmtSFVImc1ex/dPHvGeimI1hMqpzU1FOwDKHfn5
	 F8/TCqaQMfx3Xmgor7fMklwwPNSJ1UOCvXIA9N69VJiINdQBFhPBY7BTqWqKDzV+L9
	 awWe1ZabVymJN7619b7NDxcmIbLkIEmeaXxQSzSUJFnYDUU87WMvew2aCX9mZmag6F
	 OY1K19HnjGFnQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69K5T7nmC2667120
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 20 Oct 2026 13:29:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 13:29:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 20 Oct 2026 13:29:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Hungyu Lin <dennylin0707@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"reza1234khan1234@gmail.com" <reza1234khan1234@gmail.com>
Subject: RE: [PATCH] wifi: rtw88: allow key removal when the CAM table is full
Thread-Topic: [PATCH] wifi: rtw88: allow key removal when the CAM table is
 full
Thread-Index: AQHdX+uKpKj5AeqD60mYtFtK4iFuvbcFrrNw//+mgICAAJDAYA==
Date: Tue, 20 Oct 2026 05:29:07 +0000
Message-ID: <4f48c50cab1145fd9dbd6df6d424c877@realtek.com>
References: <20261019165103.5990-1-dennylin0707@gmail.com>
 <9bde49a2e7794e4fb6bc3ae104eef87e@realtek.com>
 <334c6e785a5d242c6f168d57d042d63b777a242a@linux.dev>
In-Reply-To: <334c6e785a5d242c6f168d57d042d63b777a242a@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBIaSBQaW5nLUtlLA0K
PiANCj4gT2N0b2JlciAyMCwgMjAyNiBhdCA0OjA3IEFNLCAiUGluZy1LZSBTaGloIiA8cGtzaGlo
QHJlYWx0ZWsuY29tPiB3cm90ZToNCj4gDQo+ID4NCj4gPiBIdW5neXUgTGluIDxkZW5ueWxpbjA3
MDdAZ21haWwuY29tPiB3cm90ZToNCj4gPg0KPiA+ID4NCj4gPiA+IHJ0d19vcHNfc2V0X2tleSgp
IGxvb2tzIGZvciBhIGZyZWUgQ0FNIGVudHJ5IGJlZm9yZSBjaGVja2luZyB0aGUNCj4gPiA+ICBj
b21tYW5kLiBXaGVuIGFsbCBwYWlyd2lzZSBlbnRyaWVzIGFyZSBpbiB1c2UsIERJU0FCTEVfS0VZ
IHJldHVybnMNCj4gPiA+ICAtRU5PU1BDIHdpdGhvdXQgY2xlYXJpbmcgdGhlIGV4aXN0aW5nIGVu
dHJ5Lg0KPiA+ID4NCj4gPiBJcyB0aGlzIHRoZSBhY3R1YWwgY2FzZSB5b3UgbWV0Pw0KPiA+DQo+
IA0KPiBGcm9tIG15IGludmVzdGlnYXRpb24gaXQgc2VlbXMgcmVhY2hhYmxlLg0KDQpJIGtuZXcu
IEkganVzdCB3YW50IHRvIGtub3cgaWYgcGVvcGxlIGVuY291bnRlcmVkIHRoZSBwcm9ibGVtLCBv
ciANCmZvdW5kIGFuZCBmaXhlZCB0aGlzIGJ5IHJldmlld2luZy4gDQoNCj4gDQo+IEFzIGZhciBh
cyBJIHVuZGVyc3JhbmQsIGl0IG5lZWRzIGFsbCAyOCBwYWlyd2lzZSBlbnRyaWVzICg0LTMxKSBp
bg0KPiB1c2UgYXQgb25jZSwgc28gQVAgbW9kZSB3aXRoIDI4IHNlY3VyZWQgc3RhdGlvbnMgKDMx
IG1hY19pZHMgYXJlDQo+IGxlZnQgYWZ0ZXIgdGhlIEFQIHZpZiksIG9yIElCU1MvVERMUyB3aXRo
IGFzIG1hbnkgcGVlcnMuIE5vdA0KPiByZWFjaGFibGUgYXMgYSBwbGFpbiBjbGllbnQuIE9uY2Ug
aXQgaXMgaGl0IGl0cyBwYWlyd2lzZQ0KPiBESVNBQkxFX0tFWSBmYWlscywgbWFjODAyMTEgZnJl
ZXMgdGhlIGtleSBhbnl3YXkgYWZ0ZXIgbG9nZ2luZw0KPiAiZmFpbGVkIHRvIHJlbW92ZSBrZXki
LCB0aGUgY2FtX21hcCBiaXQgaXMgbmV2ZXIgY2xlYXJlZCwgYW5kIHRoZQ0KPiB0YWJsZSBzdGF5
cyBmdWxsIHVudGlsIHRoZSBkcml2ZXIgaXMgcmVsb2FkZWQuDQo+IA0KPiBJIHRoaW5rIGl0IGNh
biBiZSB0ZXN0ZWQgd2l0aCB0d28gY2xpZW50cyBieSB0ZW1wb3JhcmlseSBzZXR0aW5nDQo+IHNl
Yy50b3RhbF9jYW1fbnVtID0gNi4NCj4gDQo+ID4gPg0KPiA+ID4gTW92ZSB0aGUgYWxsb2NhdGlv
biBhbmQgYm91bmRzIGNoZWNrIGludG8gU0VUX0tFWS4gRElTQUJMRV9LRVkgdXNlcw0KPiA+ID4g
IHRoZSBleGlzdGluZyBrZXktPmh3X2tleV9pZHguDQo+ID4gPg0KPiA+ID4gIEZpeGVzOiAxMGQ1
ODgyM2NiNDQgKCJ3aWZpOiBydHc4ODogZml4IG91dC1vZi1ib3VuZHMgQ0FNIHdyaXRlIHdoZW4g
a2V5IHRhYmxlIGlzIGZ1bGwiKQ0KPiA+ID4NCj4gPiBTaG91bGQgaXQgYmUgPw0KPiA+DQo+ID4g
Rml4ZXM6IGUzMDM3NDg1YzY4ZSAoInJ0dzg4OiBuZXcgUmVhbHRlayA4MDIuMTFhYyBkcml2ZXIi
KQ0KPiA+DQo+IA0KPiBJIHRoaW5rIDEwZDU4ODIzY2I0NCBpcyB0aGUgcmlnaHQgdGFnLiBJbiBl
MzAzNzQ4NWM2OGUgdGhlIGNoZWNrIHdhcw0KPiANCj4gICAgICAgaWYgKGh3X2tleV9pZHggPiBz
ZWMtPnRvdGFsX2NhbV9udW0pIHsNCj4gDQo+IGFuZCBydHdfc2VjX2dldF9mcmVlX2NhbSgpIHJl
dHVybnMgYXQgbW9zdCBSVFdfTUFYX1NFQ19DQU1fTlVNICgzMiksDQo+IHdoaWNoIGVxdWFscyB0
b3RhbF9jYW1fbnVtLCBzbyB0aGUgY2hlY2sgbmV2ZXIgZmlyZWQgYW5kIERJU0FCTEVfS0VZDQo+
IGFsd2F5cyByZWFjaGVkIHJ0d19zZWNfY2xlYXJfY2FtKCkuIFRoZSBidWcgdGhlcmUgd2FzIHRo
ZQ0KPiBvdXQtb2YtYm91bmRzIFNFVF9LRVksIHdoaWNoIDEwZDU4ODIzY2I0NCBmaXhlZC4gRElT
QUJMRV9LRVkgb25seQ0KPiBzdGFydGVkIGZhaWxpbmcgb25jZSB0aGUgY2hlY2sgYmVjYW1lICI+
PSIuIFRoaXMgcGF0Y2ggYWxzbyBkb2VzIG5vdA0KPiBhcHBseSB3aXRob3V0IDEwZDU4ODIzY2I0
NCwgc2luY2UgaXRzIGNvbnRleHQgaGFzIHRoZSAiPj0iLg0KDQpJIGZlZWwgdGhlIGluaXRpYWwg
Y29tbWl0IGUzMDM3NDg1YzY4ZSBjb250YWluaW5nIHR3byBidWdzLiBPbmUgaXMgDQptaXNzaW5n
IHRvIGNoZWNrIHByb3BlciBib3VuZGFyeSwgYW5kIHRoZSBvdGhlciBpcyB0aGlzIG9uZS4gDQoN
CldpdGhvdXQgZTMwMzc0ODVjNjhlLCBpdCB3aWxsIG91dC1vZi1ib3VuZHMgU0VUX0tFWSwgYW5k
IHRoZW4NCml0IGlzIHBvc3NpYmxlIHRvIERJU0FCTEVfS0VZIGZhaWwgKGF0IHdyb25nIGJvdW5k
YXJ5KSwgbm8/DQoNClBpbmctS2UNCg0KDQo=
