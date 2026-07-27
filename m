Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0574F221277;
	Mon, 27 Jul 2026 02:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785119475; cv=none; b=QJIa0TrmSRYzxJWiyb0SjOKRFyHIlvbRGrHJyVd5+muArW4Y4HCH0Skwze9aeCqxXzoa/snY+2yzDvJz+mfuDVUxJ0cmoQ+hi4F6+ekclk4jYq89LicjfwlQOc/YMXZdUrtpy9EzwRbSpaE3+RqASB5P/RDGhwa9jHbpXj+fcDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785119475; c=relaxed/simple;
	bh=gveR6p9LhkGAJuUy4iGlc1Njsef0MfxugVylVQp0eWE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vqg8LxoSx+dBHam+B7ecqiVg8R5tmlGe8pGkn3yec9s6leWAd72PCfCEhaO0kKS2dv7vNQzHtzOAPse6SamRQyPIY9fMsyd/jCmxfbFTriPn/TV7F+C2LZVNwg9jZ7IycgINa/g4tv4mB8YkouDWKjrDtuJNb3BdVr7/Fs/OhOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qKjXij6J; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qKjXij6J"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R2V0Q702766388, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785119460; bh=gveR6p9LhkGAJuUy4iGlc1Njsef0MfxugVylVQp0eWE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=qKjXij6JgisjGsLNhTYULGZz52jQfHAlzkPE9P2y6xmIapEc+smyh5lHkA8sxc9UT
	 ZDYuWceevNtUbdmYIt6RScA2CNyPtEtVElrLksEQbwCprbgSL3YxRiJsYT9kxOXyZi
	 zyCxAjED7jVDe0dkJXR5mkEAjRRStqiRB3G7PlO1dLHtP5EELoMH/uDDDko4OTbo6v
	 pQAhHC/eLx8yhv5MOw5N5y7HqwfeL6hRTN8Vx9qrl7y8zAqD5ZZhx32aSpYVG/04IO
	 G/NpjEg5P2kQdcvx2l0qCo66Dv6uDTK2AexrAINblne3U2NQHbCfujfrGv3YOyTsjh
	 6kCOTQl77wIkg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R2V0Q702766388
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 10:31:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 10:31:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 10:31:00 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>
Subject: RE: [PATCH 13/19] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Topic: [PATCH 13/19] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Index: AQHdG5rRupGbQ0HR0UWK68XjWP1haLZ9kyMAgAFxNlD//8saAIABu9og
Date: Mon, 27 Jul 2026 02:31:00 +0000
Message-ID: <7169a1ed15ce4cbda56977d3e3872291@realtek.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724183235.196908-1-luka.gejak@linux.dev>
 <8ded63af-64cf-484b-977b-e4458278f9c1@gmail.com>
 <25a64bfc14c14c9ebe544d5d55bc8a45@realtek.com>
 <1EE071EB-219E-4C33-AC0B-D5562D6212AD@linux.dev>
In-Reply-To: <1EE071EB-219E-4C33-AC0B-D5562D6212AD@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPbiBKdWx5IDI2LCAy
MDI2IDM6MzU6MDIgQU0gR01UKzAyOjAwLCBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNv
bT4gd3JvdGU6DQo+ID5CaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNvbT4g
d3JvdGU6DQo+ID4+IE9uIDI0LzA3LzIwMjYgMjE6MzIsIGx1a2EuZ2VqYWtAbGludXguZGV2IHdy
b3RlOg0KPiA+PiA+IEZyb206IEx1a2EgR2VqYWsgPGx1a2EuZ2VqYWtAbGludXguZGV2Pg0KPiA+
PiA+DQo+ID4+ID4gRW5hYmxlIHRoZSBleGlzdGluZyBSWCBhZ2dyZWdhdGlvbiBzZXR1cCBmb3Ig
dGhpcyBjaGlwIGFuZCBzZWxlY3QgdGhlDQo+ID4+ID4gbGFyZ2VyIERNQSBhZ2dyZWdhdGlvbiBt
b2RlIGl0IG5lZWRzLiBUaGUgUlRMODcyM0JTIGRvZXMgbm90IHJhaXNlDQo+ID4+ID4gQ1BXTTEs
IHNvIGxlYXZlIHRoYXQgc291cmNlIG91dCBvZiBpdHMgaW50ZXJydXB0IG1hc2ssIGFuZCBzZXQg
dGhlIFNESU8NCj4gPj4gPiBUWCBjb250cm9sIGJpdCB0aGUgdmVuZG9yIGRyaXZlciB1c2VzIHRv
IGhhdmUgdHJhbnNmZXJzIGFsd2F5cw0KPiA+PiA+IHJlY29nbmlzZWQuDQo+ID4+ID4NCj4gPj4g
PiBJbnRlcnJ1cHQgc3RhdHVzIGlzIGFsc28gYWNrbm93bGVkZ2VkIGRpZmZlcmVudGx5OiB3cml0
ZSBiYWNrIG9ubHkgdGhlDQo+ID4+ID4gYml0cyB0aGF0IGFyZSBhY3R1YWxseSBkZWZpbmVkLCBh
bmQgZm9yIHRoaXMgY2hpcCBvbmx5IHRob3NlIHRoYXQgYXJlDQo+ID4+ID4gdW5tYXNrZWQsIHJh
dGhlciB0aGFuIHdyaXRpbmcgdGhlIHJhdyBzdGF0dXMgd29yZCBiYWNrLiBXcml0aW5nIGJhY2sN
Cj4gPj4gPiB1bmRlZmluZWQgYml0cyBsZWF2ZXMgdGhlIFJUTDg3MjNCUyByYWlzaW5nIGEgcGVy
c2lzdGVudCBpbnRlcnJ1cHQgYWZ0ZXINCj4gPj4gPiByZXN1bWUuIE5vdGUgdGhhdCByZXN0cmlj
dGluZyB0aGUgYWNrbm93bGVkZ21lbnQgdG8gZGVmaW5lZCBiaXRzDQo+ID4+ID4gYXBwbGllcyB0
byB0aGUgb3RoZXIgU0RJTyBwYXJ0cyBhcyB3ZWxsLg0KPiA+Pg0KPiA+PiBXaHkgZG9lcyBpdCBh
cHBseSB0byB0aGUgb3RoZXJzPw0KPiA+DQo+ID5MdWthLCBjb3VsZCB5b3UgYW5zd2VyIEJpdHRl
cmJsdWUncyBxdWVzdGlvbnMgYmVmb3JlIHNlbmRpbmcgdjI/DQo+ID5Zb3UgbWlnaHQgd3JpdGUg
dGhlIGNoYW5nZSBpbiBjb3ZlciBsZXR0ZXIgb2YgdjIsIGJ1dCBpdCBpcyB2ZXJ5IGhhcmQNCj4g
PmZvciByZXZpZXdlcnMgdG8ga25vdyBpZiB5b3UgZGlkIGNoYW5nZXMgYmFzZWQgb24gcmV2aWV3
ZXJzJyBvcGluaW9ucw0KPiA+b3IgeW91IGhhdmUgZGlmZmVyZW50IHJlYXNvbnMuIE1vcmUsIHBs
ZWFzZSBnaXZlIHJldmlld2VycyBtb3JlIHRpbWUgdG8NCj4gPmRpc2N1c3MgZW50aXJlbHkuIEkg
ZG9uJ3Qga25vdyB0aGF0IEkgc2hvdWxkIHJlcGx5IHlvdXIgdjEgb3IgdjIgb3IgUkZDPw0KPiA+
DQo+ID5JIGFkbWl0IHRoYXQgSSBoYXZlIG5vdCB5ZXQgcmV2aWV3ZWQgeW91ciBwYXRjaGVzLCBi
dXQgaXQgZ2V0cyBoYXJkZXINCj4gPnRvIG1lIHNpbmNlIHRoZXJlIGFyZSBtYW55IHZlcnNpb25z
Lg0KPiA+DQo+ID5QaW5nLUtlDQo+ID4NCj4gDQo+IFVuZGVyc3Rvb2QsIEkgYW0gc29ycnkgYWJv
dXQgdGhhdC4gSSB3aWxsIHJlcGx5IHRvIGluZGl2aWR1YWwgZW1haWxzDQo+IGluc3RlYWQgb2Yg
c2VuZGluZyBuZXcgdmVyc2lvbiBmcm9tIG5vdyBvbi4gQmFzaWNhbGx5IGFsbCBoaXMgY29tbWVu
dHMNCj4gd2VyZSBhZGRyZXNzZWQgaW4gdjIuDQoNCkdvb2QgdG8ga25vdyB0aGF0LiBJZiB5b3Ug
Y291bGQgcmVwbHkgdGhhdCBiZWZvcmUgc2VuZGluZyB2MiwgSSBkaWRuJ3QgaGF2ZQ0KcXVlc3Rp
b25zIGFib3V0IHRoYXQuIA0KDQo+IEFsc28gaG93IGxvbmcgc2hvdWxkIEkgd2FpdCwgYmVjYXVz
ZSBJIHRob3VnaHQNCj4gaXQncyB0aGUgYmVzdCBpZiBJIHNlbmQgbmV3IHZlcnNpb24gd2hpY2gg
aXMgfjUwMCBsaW5lcyBzaG9ydGVyIHNvDQo+IHRoZXJlIGlzIGxlc3MgdG8gcmV2aWV3LCBidXQg
SSB3aWxsIHdhaXQgaWYgeW91IHdhbnQsIGp1c3QgdGVsbCBtZSBob3cNCj4gbXVjaD8gDQoNCklm
IHJldmlld2VycyBjb21tZW50IHlvdXIgcGF0Y2hlcyBhbmQgeW91IGZ1bGx5IGFncmVlIHRoZW0s
IHlvdQ0KY2FuIHJlcGx5IGNvbW1lbnRzIGFuZCBzZW5kIG5ldyBwYXRjaGVzIGluIG9uZSBvciB0
d28gZGF5cy4NCg0KSWYgc29tZSBjb21tZW50cyBhcmUgdW5jZXJ0YWluLCBwbGVhc2UgZGlzY3Vz
cyBhbmQgY29udmluY2UgcmV2aWV3ZXJzDQp3aHkvaG93IGl0IHNob3VsZCBiZSwgYW5kIHRoZW4g
c2VuZCBuZXcgdmVyc2lvbi4NCg0KSWYgeW91IHdhbnQgdG8gdXBkYXRlIGEgdmVyc2lvbiBhbmQg
bm8gb25lIGlzIGNvbW1lbnRpbmcgeW91ciBwYXRjaGVzIHlldCwNCnJlcGx5IHRoZSBwYXRjaCB5
b3Vyc2VsZiB0byB0ZWxsIHJldmlld2VycyB0byBpZ25vcmUgeW91ciBwYXRjaGVzLCBhbmQNCnRo
ZW4gc2VuZCBuZXcgdmVyc2lvbi4gDQoNCj4gUmlnaHQgbm93IGxhdGVzdCB2ZXJzaW9uIGlzIHYy
LiBEbyB5b3Ugd2FudCBtZSB0byByZXNwb25kIHRvDQo+IEJpdHRlcmJpbmQncyBpbmRpdmlkdWFs
IGVtYWlscyBub3cNCg0KSSBzdWdnZXN0IHlvdSBjYW4gZG8gdGhhdC4gSSBhbHNvIHdhbnQgdG8g
a25vdyBob3cvd2hhdCB5b3Ugd2lsbCBoYW5kbGUNCnRoZSB0aGluZ3MgQml0dGVyYmx1ZSBjb21t
ZW50ZWQuIENoZWNraW5nIHlvdXIgcmVwbHkgd2lsbCBiZSBzaW1wbGVyIA0KdGhhbiBjb21wYXJp
bmcgdjEgYW5kIHYyIG9yIGNoZWNraW5nIHYyIGNvbW1pdCBtZXNzYWdlcy4NCg0KTW9yZSwgd2Ug
ZG9uJ3Qga25vdyBpZiB3ZSB3YW50IHRvIGdvIGJhY2sgdG8gc2VlIGhvdyB3ZSBkbyB0aGUgY2hh
bmdlcw0KaW4gdGhlIGZ1dHVyZS4gVGhlc2Ugd2lsbCBiZSBnb29kIHJlY29yZHMuIA0KDQo+IG9y
IGRvIHRoYXQgZm9yIGFueSBuZXcgY29tbWVudHMgaW4gdjI/DQoNCkZvciBtZSwgSSB3aWxsIHJl
dmlldyB2Mi4gUGxlYXNlIGxlYXZlIHlvdXIgcmVwbHkgdGhlcmUgaWYgcGVvcGxlIGhhdmUgY29t
bWVudHMuIA0KDQpQaW5nLUtlDQoNCg==
