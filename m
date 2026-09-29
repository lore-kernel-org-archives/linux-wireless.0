Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1273CCA12;
	Tue, 29 Sep 2026 02:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790647501; cv=none; b=DJl3c8U+799UYRy4LwtNUG8+NtCVxIKv7Un1LzN271qJsdvf5X3RXCVAVriJ3cqmnS6KqLhVDfqBgiR+hJC9BdFknMqrLI7ztpzAnDB+pATsF2nmyOqclYsGkoJHjdsCCHOyIr/PCZrl2o/wT36tf3Vm3LAnclGbkhp6Bsle3uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790647501; c=relaxed/simple;
	bh=IviRKY5WOdycwaHInnNn8eyo2o0HoDHLZofID3mNcnA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ctzbfUrap0q91criL9IfNDslQqnEdT47xy8hjWXaE2MBvGaYfwsXGH7MxOlgyPFqCmwz9JtQXlnxDz85LxymhTvdLKaIb6MAzwICM58SzmXUIwJauuZuYecUdcp55Isn20TB0LT6fHG0PlXuCmwGjdgy8fGW0RVNhy1b8rQKEvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=YXeG3nEh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="YXeG3nEh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68T24nzfE908757, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790647489; bh=IviRKY5WOdycwaHInnNn8eyo2o0HoDHLZofID3mNcnA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=YXeG3nEhIGU0J9bGC32mlKIOFdyHHb3reCLslp+4DGPYZe2IQDfH6njdZZfEl9Hay
	 0BkvqNzGcTjsDKQTe0MfGJQJMrc+PbgoL0C4PyH6a8ZsvPSFJNnw+LZAKsGKyOV87G
	 Q4hkD5rYQ+CY5CAqNBUmlYPy6QnxhOEDqUPXz/6PybM91y3v/32wjgniIQVC3GQqRe
	 so+sOFR3qNTpaHsQqYu2HAaXKxDYO/GN9gKRrNeVq0WASziPp8wSXbpMweucPzpAZP
	 q4PuxXlfPitcdxRsLSGcEE0QsTF7v1pu1w1hLhW9RNZ3sPzc79neMmTYiGZcYKHnkG
	 ZF5y887BTZHkw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68T24nzfE908757
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 29 Sep 2026 10:04:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 29 Sep 2026 10:04:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 29 Sep 2026 10:04:49 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
  Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v3 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
Thread-Topic: [PATCH v3 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
Thread-Index: AQHdSeAWPTTocmDvm0SCIQejTVX877bbzMuQgABkXICAANifIP//2mqAgAfw+fA=
Date: Tue, 29 Sep 2026 02:04:49 +0000
Message-ID: <78faacdc2ba04d48b663c91194f04bc8@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-4-luka.gejak@linux.dev>
 <39da13e5cdd840f5a5ab86ded478d07c@realtek.com>
 <DLN10FU8L1PQ.3NK0M6NVQ3Y53@linux.dev>
 <304bbb9a43a74e909eec0dd84d86d528@realtek.com>
 <92337f29a7dd8d517c2037e857e13eb2612e10e7@linux.dev>
In-Reply-To: <92337f29a7dd8d517c2037e857e13eb2612e10e7@linux.dev>
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

DQpMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3JvdGU6DQo+IEhpIFBpbmctS2Us
DQo+IA0KPiBTZXB0ZW1iZXIgMjQsIDIwMjYgYXQgMDY6MTEsICJQaW5nLUtlIFNoaWgiIDxwa3No
aWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiA+DQo+ID4gTHVrYSBHZWphayA8bHVrYS5nZWpha0Bs
aW51eC5kZXY+IHdyb3RlOg0KPiANCj4gQW5zd2VycyBpbiB0aGUgb3JkZXIgb2YgeW91ciBtYWls
LiBUaGUgTUFJTlRBSU5FUlMgcG9pbnQgaXMgaW4gYQ0KPiBzZXBhcmF0ZSByZXBseS4NCj4gDQo+
ID4gQ2FuIHlvdSBhbHNvIHJldmlldyBvdGhlciBSVEw4NzIzQiBzcGVjaWZpYyBmdW5jdGlvbnM/
IEkgZGlkbid0IHJldmlldw0KPiA+IHRoZW0gb25lIGJ5IG9uZSBieSB2MywgYnV0IEkgd29uZGVy
IHdoeSBpdCBuZWVkcyBzcGVjaWZpYyBmdW5jdGlvbnMsDQo+ID4gbm90IGNvbW1vbiBmbG93LiBJ
ZiBhbnkgb2YgdGhlbSBpcyBuZWNlc3NhcnksIHBsZWFzZSBwb2ludCBvdXQgcmVhc29ucy4NCj4g
Pg0KPiA+IEJ5IHRoZSB3YXksIEkgZGlkbid0IG9ubHkgbWVudGlvbiB0aGVzZSB0aHJlZSBmdW5j
dGlvbnMuIEF0IGhlcmUgdGhlcmUNCj4gPiBhcmUgbWFueSBzcGVjaWZpYyBmdW5jdGlvbnMuIFBs
ZWFzZSBhbmFseXplIHRoZW0uDQo+ID4gKEhvbmVzdGx5LCBJIGRvbid0IGZ1bGx5IHJlLWV4YW1p
bmF0ZSB5b3VyIGFuYWx5c2lzIGluIGRldGFpbCwgYW5kDQo+ID4gYmVsaWV2ZSB5b3VyIHJlc3Vs
dHMuKQ0KPiANCj4gSSB3ZW50IHRocm91Z2ggdGhlIHdob2xlIGZpbGUuIFRoZSBwYXJ0IHRoYXQg
aXMgYWxyZWFkeSBjb21tb24gZmxvdyBjYW4NCj4gYmUgbGlzdGVkIGV4YWN0bHksIGJlY2F1c2Ug
dGhvc2Ugb3BzIHBvaW50IGF0IHNoYXJlZCBjb2RlOg0KPiANCj4gICBwb3dlcl9vbiwgcG93ZXJf
b2ZmICAgICAgICBydHdfcG93ZXJfb24sIHJ0d19wb3dlcl9vZmYNCj4gICBtYWNfcG9zdGluaXQg
ICAgICAgICAgICAgICBydHc4NzIzeF9tYWNfcG9zdGluaXQNCj4gICBzZXRfdHhfcG93ZXJfaW5k
ZXggICAgICAgICBydHc4NzIzeF9zZXRfdHhfcG93ZXJfaW5kZXgNCj4gICBmYWxzZV9hbGFybV9z
dGF0aXN0aWNzICAgICBydHc4NzIzeF9mYWxzZV9hbGFybV9zdGF0aXN0aWNzDQo+ICAgcmVhZF9y
Ziwgd3JpdGVfcmYgICAgICAgICAgcnR3X3BoeV9yZWFkX3JmX3NpcGksDQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgcnR3X3BoeV93cml0ZV9yZl9yZWdfc2lwaQ0KPiAgIHJlYWRfZWZ1
c2UgICAgICAgICAgICAgICAgIHJ0dzg3MjN4X3JlYWRfZWZ1c2UsIHBsdXMgdGhlIGhhcmR3YXJl
DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2FwYWJpbGl0eSwgYmVjYXVzZSB0aGlz
IGNoaXAgaGFzIG5vDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaGFyZHdhcmUgZmVh
dHVyZSByZXBvcnQ6IHRoZSBmaXJtd2FyZQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHJlcG9ydHMgaWQgMHhmZCBpbnN0ZWFkIG9mIHRoZSBDMkgNCj4gICBlZnVzZV9ncmFudCAgICAg
ICAgICAgICAgICBydHc4NzIzeF9lZnVzZV9ncmFudCwgcGx1cyB0aGUgMHg2YiBCVA0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHBvd2VyIGN1dCBhbmQgb3V0cHV0IGlzb2xhdGlvbiB3
cml0ZSB0aGF0DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGhlIHZlbmRvciBlZnVz
ZSBwYXRoIGRvZXMNCj4gDQoNCkkgdGhpbmsgeW91IGhhdmUgY2hlY2tlZCB0aGVtLiBQbGVhc2Ug
cmVjb25zaWRlciB0byByZXdyaXRlIHRoZW0uIA0KDQpBcyBKb2hhbm5lcyBtZW50aW9uZWQsIExM
TSBpcyBhIHRvb2wsIGJ1dCBwbGVhc2Ugbm90IGZ1bGx5IGJlbGlldmUNCmFuZCByZWx5IG9uIGl0
LiBMTE0gY2FuIGdlbmVyYXRlIGEgbG90IG9mIHN0dWZmLCBidXQgSSByZWFkIGJ5IG15DQpleWVz
IGFuZCB0aGVuIHRoaW5rIGFuZCB0eXBlIGJ5IG15IGhhbmRzLiBUbyB1bmRlcnN0YW5kIGFuZCBy
ZXdvcmsNCnN0dWZmIGdlbmVyYXRlZCBieSBMTE0gaXMgc3VibWl0dGVyJ3MgYnVzaW5lc3MuDQoN
Cj4gDQo+ID4gSSB0aGluayB0aGUgYmV0dGVyIHdheSBpcyB0byBhc3NpZ24gcHJvcGVyIHJ0d2Rl
di0+aGFsLnJjciBwZXIgY2hpcA0KPiA+IGluIHJ0d19jb3JlX2luaXQoKS4NCj4gDQoNClsuLl0N
Cg0KPiANCj4gSWYgeW91IHByZWZlciwgSSBjYW4gcHV0IHRoZSBjb3JlIGNoYW5nZSBpbiBhIHNt
YWxsIHBhdGNoIGJlZm9yZSB0aGUNCj4gY2hpcCBzZXJpZXMgcmF0aGVyIHRoYW4gaW4gcGF0Y2gg
Mywgc28gdGhlIGNoaXAgc2VyaWVzIHN0YXlzIGZyZWUgb2YNCj4gY29yZSBjaGFuZ2VzLg0KDQpZ
ZXMsIHRoYXQnZCBiZSBnb29kLiANCg0KVGhlIDg3MjNCUyBzcGVjaWZpYyBzdHVmZiBzaG91bGQg
ZG8gaW4gdGhlIGtpbmQgb2YgcmV3cml0aW5nLiANCg0KPiANCj4gPiBDYW4geW91IHJldXNlIHRo
ZSBleGlzdGluZyBzaW5jZSB0aGV5IGFyZSB0aGUgc2FtZT8NCj4gDQoNCkkgdGhpbmsgSSBjYW4g
cmVmZXIgYSBjb21tb24gcnVsZS4uLiANCg0KPiANCj4gPiAoUGxlYXNlIHF1b3RlIHRoZSBjb2Rl
OyB0byByZXBseSB0byB0aGlzLCBJIG5lZWQgdG8gc3dpdGNoIHRvIHlvdXINCj4gPiBwYXRjaGVz
IGFnYWluKS4NCj4gT24geW91ciBsYXN0IHNlbnRlbmNlLCB0aGF0IHRoZSByZWFzb24gaXMgaGFy
ZCB0byBleHBsYWluIGxhdGVyIGlmIGl0IGlzDQo+IG5vdCB3cml0dGVuIGRvd246IHdoYXRldmVy
IHdlIGNoYW5nZSB3aWxsIGNhcnJ5IGl0cyByZWFzb24gaW4gdGhlIGNvZGUNCj4gb3IgaW4gdGhl
IGNvbW1pdCBtZXNzYWdlLCBub3Qgb25seSBpbiB0aGlzIG1haWwuIFRoZSBzYW1lIGdvZXMgZm9y
IHRoZQ0KPiB0d28gdGhpbmdzIEkgYW0gYXNraW5nIHRvIGtlZXAsIGNmZ19sZG8yNSgpIGFuZCB0
aGUgUkVTUF9TSUZTIHdyaXRlcywNCj4gd2hpY2ggd2lsbCBzYXkgd2h5IHRoZXkgYXJlIHRoZXJl
Lg0KDQpJdCBpcyBzdGlsbCBoYXJkIHRvIG1lIHRvIHJlY2FsbCB3aGF0IEkgd3JvdGUgYXQgbGFz
dCBzZW50ZW5jZS4uLg0KDQpMZXQncyBmb2xsb3cgQml0dGVyYmx1ZSdzIGNvbW1lbnRzIG9uIHY0
LCBhbmQgbW92ZSB0byB2NS4NCg0KSSBub3RlZCB0aGUgY29weXJpZ2h0IGFyZW4ndCBhbGwgY29u
c2lzdGVudC4gQ2hlY2sgdGhlbSB5b3Vyc2VsZi4NCg0KUGluZy1LZQ0KDQo=
