Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793773268;
	b=ePRdNmWfj6oOCmC0YvQJvwrdGqPz9iVPw9VBbZ17E29QK/OScSyfFgYpGXB8nE/lj3hi
	 9BnvU7aFGoZBx2LUkqGeyUvonkqEcjP+2ZmjvLd9pUzBThYBC3BDwCGJTnpQnMBzAagcK
	 kJu3bDIgqGO55ON5Sa1pnrivPKe+egJq+8ZWMeiTceG29En/S5E+A2AfhHwMRfc+JcXVq
	 LPt3oup14EJsaTZ2zzHLtOt2EadSwtr5R7G5KIvh44aiZm+xWP3n8bOLgDEX4ZOheDbQC
	 vfMMzOi9d8vUcOuIkcL/HSo2K+OTzoGOQpeccJWcDjLK0ylVvFSOZTENew/dKXkjyBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793773268;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=4fMAFa78wnwcnmnyVC7AmCvIGyES08QBsJdHu4XHLOo=;
	b=OD/kKBeFQuk42tnk/db1LnT8yo/OWTuaPokJo0TYeYxRfPB38MPyEDoZgpdrPTdlBITB
	 hshqnKbBzceezvhsOfc1vtyIQ4JZfGA+QjI/56IJCw1EI4AMGW/PPFtSQ5dtBjbuRx71i
	 A1MS3f7DLQj8r9Iy7274/P81vLOJyCxOH196lSyRBrIzPN0wT5sLD/xBcvsz4iGe5QROe
	 UabdwyeiC1RQrHAHF29arw0IOCUJr38e1HdGKwOw5FdVfhm7o3aJVtybLXMe1CJhjkVwY
	 fz9SXKmUX8ye8r4//LwmyZ/kRwM7EupPheSpbGthPHDeDOXhczQpm1v+w3/jRCBWZ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=HlZqPn0e;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540A5606A31B;
	Wed,  4 Nov 2026 06:21:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 540A5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=HlZqPn0e
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A46L25w83773804, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793773263; bh=4fMAFa78wnwcnmnyVC7AmCvIGyES08QBsJdHu4XHLOo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HlZqPn0e/jx8wilKcVgtGEdQqeRpJuuYQvvu1fKyDQq9ZCTSMroxEeSjonxh8lPrV
	 3u5KYy8Z5FAQQQEapuXrRSKMPrmNBxF4fqO7TQIAlNJPmRCFB1CiHbo0GjD44Ou9I3
	 RrFHkzJ/kI9RFgb8hzyXY0VFWkBsewHII9z4HlSm3dTDZYV0b3RcFb7iXfam22vbyy
	 3Jivs284okrLThl1K4StiynoQ8QJla3pkA6g34TsLjIrw8pA144uSHlEOyOSI4OmMz
	 CHwuHGjFIN2TrbuSIBbCwSuJvKNk/hdsCOYLhBWcwTqAPMQ8Xy/MxNmdB5p+zN3D7u
	 dRlK/UHcOloMQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A46L25w83773804
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 4 Nov 2026 14:21:02 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 14:21:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 14:21:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Wed, 4 Nov 2026 14:21:03 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Rosen Penev <rosenp@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
Thread-Topic: [PATCH rtw-next v2] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
Thread-Index: AQHda94e8ktfMF9qOEe8mjt2M2R0LbcdE7IQ//+/FACAAIx78P//inmAgACHohA=
Date: Wed, 4 Nov 2026 06:21:03 +0000
Message-ID: <652c4e96dc2549ceb977fffe3707b269@realtek.com>
References: <20261103215557.183459-1-rosenp@gmail.com>
 <a5f044a803a64a1eb68815f075bda2ee@realtek.com>
 <CAKxU2N9OpxoKF6M5rJpNOJ1HWXx8oJ3wXHpfyGGVgQpZaMi+uA@mail.gmail.com>
 <55e67132a79243cc9e214f9de7788132@realtek.com>
 <CAKxU2N_JCRjWXkD8SNGf-LJGOHfCsAMM1JU+AoTD6cfZZYJ03g@mail.gmail.com>
In-Reply-To: <CAKxU2N_JCRjWXkD8SNGf-LJGOHfCsAMM1JU+AoTD6cfZZYJ03g@mail.gmail.com>
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
MDI2IGF0IDk6MjHigK9QTSBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPiBSb3NlbiBQZW5ldiA8cm9zZW5wQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gPiBP
biBUdWUsIE5vdiAzLCAyMDI2IGF0IDQ6NDfigK9QTSBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFs
dGVrLmNvbT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IFJvc2VuIFBlbmV2IDxyb3NlbnBAZ21h
aWwuY29tPiB3cm90ZToNCj4gPiA+ID4gPiBXaGVuIHRoZSBXaUZpIGRldmljZSBoYXMgbm8gQUNQ
SSBjb21wYW5pb24sIG9yIHRoZSBmaXJtd2FyZSBkb2VzIG5vdA0KPiA+ID4gPiA+IGltcGxlbWVu
dCBhIGdpdmVuIHJ0dzg5IF9EU00gZnVuY3Rpb24sIHJ0dzg5X2FjcGlfZXZhbHVhdGVfZHNtKCkg
Y2FsbHMNCj4gPiA+ID4gPiBhY3BpX2V2YWx1YXRlX2RzbSgpIGFueXdheS4gQUNQSSBjb3JlIHRo
ZW4gd2FybnMgb24gZXZlcnkgcHJvYmU6DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiAgIEFDUEk6IFw6
IGZhaWxlZCB0byBldmFsdWF0ZSBfRFNNIGU4YzNhOGQyLTY5NGItMDA0Zi04MmJkLWZlODYwNzgw
M2FhNyByZXY6MCBmdW5jOjEwICgweDEwMDEpDQo+ID4gPiA+ID4gICBBQ1BJOiBcOiBmYWlsZWQg
dG8gZXZhbHVhdGUgX0RTTSBlOGMzYThkMi02OTRiLTAwNGYtODJiZC1mZTg2MDc4MDNhYTcgcmV2
OjAgZnVuYzo2ICgweDEwMDEpDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBIZXJlIHRoZSBoYW5kbGUg
aXMgTlVMTCwgYW5kIGFjcGlfZXZhbHVhdGVfb2JqZWN0KCkgcmV0dXJucw0KPiA+ID4gPiA+IEFF
X0JBRF9QQVJBTUVURVIuIEFsbCBjYWxsZXJzIGFscmVhZHkgdHJlYXQgZmFpbHVyZSBhcyAibm8g
cG9saWN5DQo+ID4gPiA+ID4gcHJvdmlkZWQgYnkgdGhlIHBsYXRmb3JtIiwgc28gdGhpcyBpcyBv
bmx5IG5vaXNlLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gQmFpbCBvdXQgZWFybHkgd2hlbiB0aGVy
ZSBpcyBubyBBQ1BJIGhhbmRsZSwgYXMgYWNwaV9jaGVja19kc20oKSB3b3VsZA0KPiA+ID4gPiA+
IG90aGVyd2lzZSBoaXQgdGhlIHNhbWUgd2FybmluZyB3aGlsZSBxdWVyeWluZyBmdW5jdGlvbiAw
LiBUaGVuIHVzZQ0KPiA+ID4gPiA+IGFjcGlfY2hlY2tfZHNtKCkgc28gdGhhdCBmdW5jdGlvbnMg
dGhlIGZpcm13YXJlIGRvZXMgbm90IGFkdmVydGlzZSBmYWlsDQo+ID4gPiA+ID4gcXVpZXRseSBh
dCBkZWJ1ZyBsZXZlbCwgYXMgcnR3ODlfYWNwaV9ldmFsdWF0ZV9tZXRob2QoKSBhbHJlYWR5IGRv
ZXMuDQo+ID4gPiA+DQo+ID4gPiA+IEFkZGluZyB0aGlzIGNoZWNrIGlzIGZpbmUgdG8gbWUuIEJ1
dCBteSBxdWVzdGlvbiBpbiB2MSBpcyB0aGF0DQo+ID4gPiA+IGFjcGlfY2hlY2tfZHNtKCkgY2hl
Y2tzIGZ1bmMgMCB0byBkZXRlcm1pbmUgaWYgQklUKGZ1bmMpIGlzIGV4aXN0aW5nLg0KPiA+ID4g
PiBJcyBpdCBwb3NzaWJsZSBmdW5jIDAgbm90IGV4aXN0aW5nLCBidXQgQklUKGZ1bmMpIGV4aXN0
aW5nPw0KPiA+ID4gU2hvdWxkbid0IGhhcHBlbiwgYnV0IHdobyBrbm93cy4NCj4gPg0KPiA+IEkg
ZG9uJ3QgbWluZCB0YWtpbmcgdGhpcyBwYXRjaCwgYnV0IHRoaXMgaXMgdGhlIG9ubHkgb25lIHBv
aW50IEkgZG9uJ3Qga25vdy4NCj4gPg0KPiA+ID4gSSBjYW4gZHJvcCB0aGUgYWNwaV9jaGVja19k
c20oKSBwYXJ0Lg0KPiA+DQo+ID4gSWYgeW91IGRyb3AgdGhlIHBhcnQsIHdoYXQgd2lsbCB0aGlz
IHBhdGNoIGRvPyBhbG1vc3Qgbm90aGluZy4NCj4gVGhlICFoYW5kbGUgY2hlY2sgaXMgdGhlIGJp
ZyBvbmUgdGhhdCBzaWxlbmNlcyBpdC4NCg0KSSdtIG5vdCBhd2FyZSBvZiB0aGF0LiBMZXQncyBk
byB0aGlzIG9ubHkgYnkgdjMuDQoNCg0K
