Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB263515CE;
	Wed,  7 Oct 2026 08:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791361961; cv=none; b=khtRQ+UIfUEEgUbtsDj4HhBkzBp/WTMj5/LGdgAqKvSjxPP+VY/sc2dV+YehrmvOXdxqX/2eQABRq/M3zX9y8DCMTRIWEnaKbxGNtQX7QNw2CrWgoPyKeBto/6X45bLjCFHRHM5BqdK50/2ac0CSZQ3R0ptyhfHV4q8M3EKFMb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791361961; c=relaxed/simple;
	bh=A4aNBc9UmUwXHvXzPTVhZv6e4SKMZycEv52atrgnI0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hLvaMG2xVu1k/CBOrY/Orn+IMwpgu+sqXi6h7SfF5mPOj7Z4qWoUuYHxmgr2imVbiJKqNIdd7j52lWb+23M1iqvWWzLFb+RpknAdSq3UldgYLPzJZ5VJfu8RPk1wuKEdVQBbXXszl7NXafLL4tuNax5MsO4OpZOlkw2yaIOQe98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=j2q0zQ66; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="j2q0zQ66"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6978WRkY43672843, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791361947; bh=A4aNBc9UmUwXHvXzPTVhZv6e4SKMZycEv52atrgnI0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=j2q0zQ663KLDbNPnNtkMPqh/mYDtmdxT9UxW894f/utvKaPlpOJMwKFhEQJjoJ4J6
	 J66M1q8LZbg4kxEG9eje0qBb1kFizzBz0aH/nqEr+JPy3jD2gZYLUFdPscMrDXLlvn
	 UwPNfSEiHda76ddUyPd6DlClDd5cXVmuQTfwE0/YaZ/i1TcGyIivcfcKbeZ457i9xd
	 +haXT7NutH4XxrCBzq5SNgdpW3ICVQ/VZgkoMrrrDxz5/BvU9AHzDeP0+5pIHlLinS
	 lvcj7YcMOeeHXoT02nZDVa2WH1Poo76+m3gsHldEyQo7fJQ4RCtOUOfWv6oOMv0J/O
	 nFLtQTsBS8KMQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6978WRkY43672843
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 Oct 2026 16:32:27 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:32:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:32:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 7 Oct 2026 16:32:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
  Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B chip
 driver
Thread-Topic: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
Thread-Index: AQHdVZOkAJbLY4OQZU62Znwke6F4RrbxY8UA///VogCAAIaF0A==
Date: Wed, 7 Oct 2026 08:32:27 +0000
Message-ID: <e983dedfeb9341ad9d8cf159656395c6@realtek.com>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
 <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
 <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
In-Reply-To: <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPY3RvYmVyIDcsIDIw
MjYgYXQgMDQ6NTcsICJQaW5nLUtlIFNoaWgiIDxwa3NoaWhAcmVhbHRlay5jb20NCj4gbWFpbHRv
OnBrc2hpaEByZWFsdGVrLmNvbT90bz0lMjJQaW5nLUtlJTIwU2hpaCUyMiUyMCUzQ3Brc2hpaCU0
MHJlYWx0ZWsuY29tJTNFID4gd3JvdGU6DQo+IA0KPiANCj4gPg0KPiA+IEx1a2EgR2VqYWsgPGx1
a2EuZ2VqYWtAbGludXguZGV2PiB3cm90ZToNCj4gPg0KPiA+ID4NCj4gPiA+IEFkZCB0aGUgUmVh
bHRlayBSVEw4NzIzQiA4MDIuMTFuIGNoaXAgZHJpdmVyOiB0aGUgY2hpcCBvcGVyYXRpb25zLCB0
aGUNCj4gPiA+ICBwb3dlciBzZXF1ZW5jZXMsIHRoZSBlZnVzZSBsYXlvdXQsIHRoZSBSRiBhbmQg
SVEgY2FsaWJyYXRpb24sIGFuZCB0aGUNCj4gPiA+ICBjaGlwIHNwZWNpZmljIGNvZXhpc3RlbmNl
IGhhbmRsaW5nLg0KPiA+ID4NCj4gPiA+ICBUaGUgUlRMODcyM0IgY2hpcCBzdXBwb3J0IGlzIGJh
c2VkIG9uIHRoZSBpbml0aWFsIHdvcmsgYnkNCj4gPiA+ICBNaWNoYWVsIFN0cmF1YmUgPHN0cmF1
YmUubGludXhAZ21haWwuY29tPi4NCj4gPiA+ICBMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vbWlz
dHJhdWJlL3J0dzg4L3RyZWUvcnRsODcyM2JzDQo+ID4gPg0KPiA+ID4gIENvLWRldmVsb3BlZC1i
eTogTWljaGFlbCBTdHJhdWJlIDxzdHJhdWJlLmxpbnV4QGdtYWlsLmNvbT4NCj4gPiA+ICBTaWdu
ZWQtb2ZmLWJ5OiBNaWNoYWVsIFN0cmF1YmUgPHN0cmF1YmUubGludXhAZ21haWwuY29tPg0KPiA+
ID4gIFNpZ25lZC1vZmYtYnk6IEx1a2EgR2VqYWsgPGx1a2EuZ2VqYWtAbGludXguZGV2Pg0KPiA+
ID4gIFJldmlld2VkLWJ5OiBCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNv
bT4NCj4gPiA+DQo+ID4gQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29t
Pg0KPiA+DQo+IA0KPiBIaSBQaW5nLUtlLA0KPiANCj4gVGhhbmtzIGZvciBoZWxwaW5nIGFuZCBy
ZXZpZXdpbmcgdGhlIHNlcmllcyB0aHJvdWdob3V0IHRoaXMNCj4gdXBzdHJlYW1pbmcgcHJvY2Vz
cy4gSnVzdCBvbmUgcXVlc3Rpb24sIHdoZW4gaXMgdGhlIHNlcmllcyBwbGFubmVkIHRvDQo+IGJl
IGFwcGxpZWQgdG8gcnR3LW5leHQ/IEkgYW0gcGxhbm5pbmcgdG8gc2VuZCBhIHBhdGNoIHRvIHN0
YWdpbmcgdG8NCj4gcmVtb3ZlIHN0YWdpbmcgcnRsODcyM2JzIGFuZCBJIG5lZWQgdG8gaGF2ZSBp
bmZvcm1hdGlvbiB3aGVuIGlzIGl0DQo+IGxhbmRpbmcuDQoNCkknbGwgbWVyZ2UgdGhpcyBwYXRj
aHNldCBhbmQgc2VuZCBwdWxsLXJlcXVlc3QgdG9tb3Jyb3csIGJ1dCBJIHRoaW5rIHlvdQ0Kc2hv
dWxkIHJlbW92ZSBzdGFnaW5nIHJ0bDg3MjNicyB1bnRpbCB0aGlzIHBhdGNoc2V0IGRyYWlucyB0
byB1cHN0cmVhbS4NCg0KUGluZy1LZQ0KDQo=
