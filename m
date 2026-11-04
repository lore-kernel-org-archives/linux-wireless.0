Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793769672;
	b=AC0R9xYKixrZ6vcQnwX29QsxNG2bfdpjUu4n2R6S0aNIVpXN30GMTGOW6yk6lj3Kh9cL
	 CV71IeFgME12Xi0Gd1drN0541XKl+EHqRpfkjPcgCc3WuaK3eDlFgCHbgr7RyjBHa0+kU
	 TGNEf57mHDQs3HdNPs6pf3Eq/0/QI2gDW296Ads/aBJU+gnf+7WB/5wRzcBWfOyYHRyez
	 SUdfYTYS8PA5z+nhdieq9qkwW2+M6ovU8TdOfMO7UWpvMEapOdN75av909H0zSxS7Bsyj
	 gWvGWowCIgvVFMk7hiuH1p1eZH5wg5tjdWlhygIWq/TghIFbJSchM4Sei+AMyvRdywQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793769672;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=i47cQNWRFMeWkUEu0AHMIuU7QbYQ/oKfSyeAA21Fl2Q=;
	b=rKpm/1cmK2vMb3h9ZpLOtiGcdv9/y23uOGPuF+3IWM6SsRheOrAaDrcFHAP3n3LTAPRt
	 uaNgsG3DZoaUjQbAmhZlns0Eyiid4qmv+YWkwSJAkrDl+pwdgJocR5JOLByNLDz9wploQ
	 Oh+I8Lbbg3u2LzVjHnsGQlehWo3+9K6dn4J5Dy/jCsmFwuxRtxa9WhcYKihLgfV4EZ76J
	 mPlVOU7zw5eq0h5LinFaSF01Rr1c5G8rJLANzvIh6WaiEHWEoVpWL2IFCraZ60D4JR0oP
	 qCfrWanrxED1l7xj4zdEYrbZ/2aRTWoJGhWLC7pPEGNrSKPAOjySngod83TOmvBgOPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=e4z0ZDIj;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC055606A31B;
	Wed,  4 Nov 2026 05:21:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC055606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=e4z0ZDIj
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A45L7zY43751301, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793769667; bh=i47cQNWRFMeWkUEu0AHMIuU7QbYQ/oKfSyeAA21Fl2Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=e4z0ZDIjvckzu7PH0TVp4mEQSc1OIrrFCb+IoIe7Ep1Z36w0lrCMYsHuZRCdY6SWl
	 oYGV3G2KgWRIpD7lkjwNz8Av+lSHCKYopOyfiYCAs3UAB8vCVROqmwZpt6vXfnGGL4
	 1prDHNxn849aZELiGc+KpKy+D3YuSqYx0VB3sR/a2p4Xy91/CVJlKO1BEIt7c3EdeB
	 bJaC4uy4GG8lYxNKkihNY3Z0knqEyyMPVRBvbqgHvJA6jmhK0YnlsrtBCGGYVlAIB9
	 N25fo7+yG81GAsrCgHd7xf284UpWh8dA1bsqW/4pW83DcMQMIYNhRrNYX/WOUlzSmg
	 1AFgN2z8GxH/g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A45L7zY43751301
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 4 Nov 2026 13:21:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 13:21:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Wed, 4 Nov 2026 13:21:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Rosen Penev <rosenp@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
Thread-Topic: [PATCH rtw-next v2] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
Thread-Index: AQHda94e8ktfMF9qOEe8mjt2M2R0LbcdE7IQ//+/FACAAIx78A==
Date: Wed, 4 Nov 2026 05:21:07 +0000
Message-ID: <55e67132a79243cc9e214f9de7788132@realtek.com>
References: <20261103215557.183459-1-rosenp@gmail.com>
 <a5f044a803a64a1eb68815f075bda2ee@realtek.com>
 <CAKxU2N9OpxoKF6M5rJpNOJ1HWXx8oJ3wXHpfyGGVgQpZaMi+uA@mail.gmail.com>
In-Reply-To: <CAKxU2N9OpxoKF6M5rJpNOJ1HWXx8oJ3wXHpfyGGVgQpZaMi+uA@mail.gmail.com>
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

Um9zZW4gUGVuZXYgPHJvc2VucEBnbWFpbC5jb20+IHdyb3RlOg0KPiBPbiBUdWUsIE5vdiAzLCAy
MDI2IGF0IDQ6NDfigK9QTSBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPiBSb3NlbiBQZW5ldiA8cm9zZW5wQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gPiBX
aGVuIHRoZSBXaUZpIGRldmljZSBoYXMgbm8gQUNQSSBjb21wYW5pb24sIG9yIHRoZSBmaXJtd2Fy
ZSBkb2VzIG5vdA0KPiA+ID4gaW1wbGVtZW50IGEgZ2l2ZW4gcnR3ODkgX0RTTSBmdW5jdGlvbiwg
cnR3ODlfYWNwaV9ldmFsdWF0ZV9kc20oKSBjYWxscw0KPiA+ID4gYWNwaV9ldmFsdWF0ZV9kc20o
KSBhbnl3YXkuIEFDUEkgY29yZSB0aGVuIHdhcm5zIG9uIGV2ZXJ5IHByb2JlOg0KPiA+ID4NCj4g
PiA+ICAgQUNQSTogXDogZmFpbGVkIHRvIGV2YWx1YXRlIF9EU00gZThjM2E4ZDItNjk0Yi0wMDRm
LTgyYmQtZmU4NjA3ODAzYWE3IHJldjowIGZ1bmM6MTAgKDB4MTAwMSkNCj4gPiA+ICAgQUNQSTog
XDogZmFpbGVkIHRvIGV2YWx1YXRlIF9EU00gZThjM2E4ZDItNjk0Yi0wMDRmLTgyYmQtZmU4NjA3
ODAzYWE3IHJldjowIGZ1bmM6NiAoMHgxMDAxKQ0KPiA+ID4NCj4gPiA+IEhlcmUgdGhlIGhhbmRs
ZSBpcyBOVUxMLCBhbmQgYWNwaV9ldmFsdWF0ZV9vYmplY3QoKSByZXR1cm5zDQo+ID4gPiBBRV9C
QURfUEFSQU1FVEVSLiBBbGwgY2FsbGVycyBhbHJlYWR5IHRyZWF0IGZhaWx1cmUgYXMgIm5vIHBv
bGljeQ0KPiA+ID4gcHJvdmlkZWQgYnkgdGhlIHBsYXRmb3JtIiwgc28gdGhpcyBpcyBvbmx5IG5v
aXNlLg0KPiA+ID4NCj4gPiA+IEJhaWwgb3V0IGVhcmx5IHdoZW4gdGhlcmUgaXMgbm8gQUNQSSBo
YW5kbGUsIGFzIGFjcGlfY2hlY2tfZHNtKCkgd291bGQNCj4gPiA+IG90aGVyd2lzZSBoaXQgdGhl
IHNhbWUgd2FybmluZyB3aGlsZSBxdWVyeWluZyBmdW5jdGlvbiAwLiBUaGVuIHVzZQ0KPiA+ID4g
YWNwaV9jaGVja19kc20oKSBzbyB0aGF0IGZ1bmN0aW9ucyB0aGUgZmlybXdhcmUgZG9lcyBub3Qg
YWR2ZXJ0aXNlIGZhaWwNCj4gPiA+IHF1aWV0bHkgYXQgZGVidWcgbGV2ZWwsIGFzIHJ0dzg5X2Fj
cGlfZXZhbHVhdGVfbWV0aG9kKCkgYWxyZWFkeSBkb2VzLg0KPiA+DQo+ID4gQWRkaW5nIHRoaXMg
Y2hlY2sgaXMgZmluZSB0byBtZS4gQnV0IG15IHF1ZXN0aW9uIGluIHYxIGlzIHRoYXQNCj4gPiBh
Y3BpX2NoZWNrX2RzbSgpIGNoZWNrcyBmdW5jIDAgdG8gZGV0ZXJtaW5lIGlmIEJJVChmdW5jKSBp
cyBleGlzdGluZy4NCj4gPiBJcyBpdCBwb3NzaWJsZSBmdW5jIDAgbm90IGV4aXN0aW5nLCBidXQg
QklUKGZ1bmMpIGV4aXN0aW5nPw0KPiBTaG91bGRuJ3QgaGFwcGVuLCBidXQgd2hvIGtub3dzLiAg
DQoNCkkgZG9uJ3QgbWluZCB0YWtpbmcgdGhpcyBwYXRjaCwgYnV0IHRoaXMgaXMgdGhlIG9ubHkg
b25lIHBvaW50IEkgZG9uJ3Qga25vdy4NCg0KPiBJIGNhbiBkcm9wIHRoZSBhY3BpX2NoZWNrX2Rz
bSgpIHBhcnQuDQoNCklmIHlvdSBkcm9wIHRoZSBwYXJ0LCB3aGF0IHdpbGwgdGhpcyBwYXRjaCBk
bz8gYWxtb3N0IG5vdGhpbmcuDQoNCj4gDQo+IDdiZjJkZmNjYzJkZDcwODIxMTA0ZDE1Y2JhYjdi
NmZjYTIxODcyYmUNCj4gDQo+IGlzIGVmZmVjdGl2ZWx5IHRoZSBzYW1lIGFzIHRoaXMuDQoNClNp
bmNlIHJ0dzg5X2FjcGlfZXZhbHVhdGVfZHNtKCkgaXMgY2FsbGVkIGF0IHByb2JlIHN0YWdlLCBJ
IGRvbid0IG1pbmQNCmFjcGlfY2hlY2tfZHNtKCkgYmVpbmcgY2FsbGVkIG9uIGV2ZXJ5IGNhbGwu
DQoNCj4gDQo+IE5vdGUgdGhhdCB0aGlzIHNwZWNpZmljIGNhcmQgd2FzIHRha2VuIG91dCBvZiBh
IGxhcHRvcCBhbmQgcGxhY2VkIGluIGENCj4gZGVza3RvcCwgaGVuY2UgdGhlIHdhcm5pbmcuDQoN
ClNvLCB0aGUgd2FybmluZ3MgcmVhbGx5IGJvdGhlciB5b3U/DQoNCg0KDQo=
