Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6D4421234;
	Wed,  7 Oct 2026 08:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791363258; cv=none; b=MAQjxOkhHN7M5HH+NTg2lglLZUUyhWVyXvVD8Tux5A24L4dY/pEce2dOfY2eLiki1KYH5noNZOf12VCbWuOMUK6gmaOZmSYH49YOyLrKWvR4IW5eBZkKNdn7xbCsAIdBML5T1y8kMpw1yT1+Og84hoew6mLR9VAPAGOL3B1TgUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791363258; c=relaxed/simple;
	bh=1EzMU5R7IOOhvEWjlhuAR3RXb+er0nij+1V1E0MLt7c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HkGdCtqhgPlq/oMXoPqPWv560hGqd+nqjUpR7fSlduppZpwXDuNTFA4+T18BKrtauMCMRcXNGiqQBeXKdUchZ/NNYJ0zY4tyb/QoC2D/5jflzq0DSp7sZXFBbtcYdmR70J3ERAnRugm+G5amchxqQjBkb8IeWjtd3S39b0nPEvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=O8/KYTUP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="O8/KYTUP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6978s3lxD3680629, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791363243; bh=1EzMU5R7IOOhvEWjlhuAR3RXb+er0nij+1V1E0MLt7c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=O8/KYTUP0OyIFaXUATjU9psHoEFd1T4krg4nOae/mNkgw1OX1ibRKiFWR1B3aPhaN
	 zBqsYY52BCdPdACPgWGxzrdD/CIHUmsJuT/s/jEGgqy1Vjx0V95vKX9of4vQPRoO4Y
	 0IPRvMtKLvW1hxWACa0TfYKCkbaw5yY1Ety7tdBiI60FAp3VCtCmoiL3oceGEnlC6N
	 H4I+ean2ti/p2RFlP7utYkl51gyG20Fxr+4Ggaoaw5u7gj6y38yA0djY1KXPVAFK+b
	 cJYn+J420PSVL3J2uxgKuk3Z/IbBj5FxZ86TJnD5kkL+saWsmojUQk2Ax2l4wozrkT
	 M0OEu4nrxy4hA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6978s3lxD3680629
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 Oct 2026 16:54:03 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:54:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:54:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 7 Oct 2026 16:54:03 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Greg KH <gregkh@linuxfoundation.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
   Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B chip
 driver
Thread-Topic: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
Thread-Index: AQHdVZOkAJbLY4OQZU62Znwke6F4RrbxY8UA///VogCAAIaF0P//fZQAgACG1sA=
Date: Wed, 7 Oct 2026 08:54:03 +0000
Message-ID: <d403e88ca53841fba87190764e2a45cc@realtek.com>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
 <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
 <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
 <e983dedfeb9341ad9d8cf159656395c6@realtek.com>
 <df8313a72bdef1dc8859a4ac018370b24b606766@linux.dev>
In-Reply-To: <df8313a72bdef1dc8859a4ac018370b24b606766@linux.dev>
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

KyBHcmVnIHRvIHN0YWdpbmcgcnRsODcyM2JzIGRyaXZlciBxdWVzdGlvbg0KDQpIaSBHcmVnLA0K
DQpMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3JvdGU6DQo+IE9jdG9iZXIgNywg
MjAyNiBhdCAxMDozMiwgIlBpbmctS2UgU2hpaCIgPHBrc2hpaEByZWFsdGVrLmNvbQ0KPiBtYWls
dG86cGtzaGloQHJlYWx0ZWsuY29tP3RvPSUyMlBpbmctS2UlMjBTaGloJTIyJTIwJTNDcGtzaGlo
JTQwcmVhbHRlay5jb20lM0UgPiB3cm90ZToNCj4gDQo+IA0KPiA+DQo+ID4gTHVrYSBHZWphayA8
bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiA+DQo+ID4gPg0KPiA+ID4gT2N0b2JlciA3
LCAyMDI2IGF0IDA0OjU3LCAiUGluZy1LZSBTaGloIiA8cGtzaGloQHJlYWx0ZWsuY29tDQo+ID4g
PiAgbWFpbHRvOnBrc2hpaEByZWFsdGVrLmNvbT90bz0lMjJQaW5nLUtlJTIwU2hpaCUyMiUyMCUz
Q3Brc2hpaCU0MHJlYWx0ZWsuY29tJTNFID4gd3JvdGU6DQo+ID4gPg0KPiA+ID4NCj4gPiA+DQo+
ID4gPiAgTHVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiA+ID4NCj4g
PiA+ICA+DQo+ID4gPiAgPiBBZGQgdGhlIFJlYWx0ZWsgUlRMODcyM0IgODAyLjExbiBjaGlwIGRy
aXZlcjogdGhlIGNoaXAgb3BlcmF0aW9ucywgdGhlDQo+ID4gPiAgPiBwb3dlciBzZXF1ZW5jZXMs
IHRoZSBlZnVzZSBsYXlvdXQsIHRoZSBSRiBhbmQgSVEgY2FsaWJyYXRpb24sIGFuZCB0aGUNCj4g
PiA+ICA+IGNoaXAgc3BlY2lmaWMgY29leGlzdGVuY2UgaGFuZGxpbmcuDQo+ID4gPiAgPg0KPiA+
ID4gID4gVGhlIFJUTDg3MjNCIGNoaXAgc3VwcG9ydCBpcyBiYXNlZCBvbiB0aGUgaW5pdGlhbCB3
b3JrIGJ5DQo+ID4gPiAgPiBNaWNoYWVsIFN0cmF1YmUgPHN0cmF1YmUubGludXhAZ21haWwuY29t
Pi4NCj4gPiA+ICA+IExpbms6IGh0dHBzOi8vZ2l0aHViLmNvbS9taXN0cmF1YmUvcnR3ODgvdHJl
ZS9ydGw4NzIzYnMNCj4gPiA+ICA+DQo+ID4gPiAgPiBDby1kZXZlbG9wZWQtYnk6IE1pY2hhZWwg
U3RyYXViZSA8c3RyYXViZS5saW51eEBnbWFpbC5jb20+DQo+ID4gPiAgPiBTaWduZWQtb2ZmLWJ5
OiBNaWNoYWVsIFN0cmF1YmUgPHN0cmF1YmUubGludXhAZ21haWwuY29tPg0KPiA+ID4gID4gU2ln
bmVkLW9mZi1ieTogTHVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+DQo+ID4gPiAgPiBS
ZXZpZXdlZC1ieTogQml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+DQo+
ID4gPiAgPg0KPiA+ID4gIEFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNv
bT4NCj4gPiA+DQo+ID4gPg0KPiA+ID4gIEhpIFBpbmctS2UsDQo+ID4gPg0KPiA+ID4gIFRoYW5r
cyBmb3IgaGVscGluZyBhbmQgcmV2aWV3aW5nIHRoZSBzZXJpZXMgdGhyb3VnaG91dCB0aGlzDQo+
ID4gPiAgdXBzdHJlYW1pbmcgcHJvY2Vzcy4gSnVzdCBvbmUgcXVlc3Rpb24sIHdoZW4gaXMgdGhl
IHNlcmllcyBwbGFubmVkIHRvDQo+ID4gPiAgYmUgYXBwbGllZCB0byBydHctbmV4dD8gSSBhbSBw
bGFubmluZyB0byBzZW5kIGEgcGF0Y2ggdG8gc3RhZ2luZyB0bw0KPiA+ID4gIHJlbW92ZSBzdGFn
aW5nIHJ0bDg3MjNicyBhbmQgSSBuZWVkIHRvIGhhdmUgaW5mb3JtYXRpb24gd2hlbiBpcyBpdA0K
PiA+ID4gIGxhbmRpbmcuDQo+ID4gPg0KPiA+IEknbGwgbWVyZ2UgdGhpcyBwYXRjaHNldCBhbmQg
c2VuZCBwdWxsLXJlcXVlc3QgdG9tb3Jyb3csIGJ1dCBJIHRoaW5rIHlvdQ0KPiA+IHNob3VsZCBy
ZW1vdmUgc3RhZ2luZyBydGw4NzIzYnMgdW50aWwgdGhpcyBwYXRjaHNldCBkcmFpbnMgdG8gdXBz
dHJlYW0uDQo+ID4NCj4gPiBQaW5nLUtlDQo+ID4NCj4gDQo+IE9rLiBUaGFua3MgZm9yIGluZm9y
bWF0aW9uLiBIb3dldmVyLCBieSB0aGUgdGltZSB0aGlzIHNlcmllcyByZWFjaGVzDQo+IHVwc3Ry
ZWFtLCB3b24ndCB0aGUgbWVyZ2Ugd2luZG93IGJlIGNsb3NlZD8gVGhlcmVmb3JlIDIgZHJpdmVy
cyBmb3INCj4gdGhlIHNhbWUgY2hpcCB3aWxsIGV4aXN0IGZvciBvbmUga2VybmVsIHZlcnNpb24s
IGFuZCBHcmVnIHByZXZpb3VzbHkNCj4gc2FpZCB0aGF0IHdoZW4gYSBkcml2ZXIgaXMgbWVyZ2Vk
IHdlIHNob3VsZCByZW1vdmUgc3RhZ2luZyBzbyB0aGVyZQ0KPiBhcmUgbm8gdHdvIGRyaXZlcnMg
Zm9yIHRoZSBzYW1lIGNoaXAuDQoNCkx1a2EgZGlkIHJld3JpdGUgUlRMODcyM0JTIHZlbmRvciBk
cml2ZXIgKGkuZS4gc3RhZ2luZyBydGw4NzIzYnMpIGludG8NCnVwc3RyZWFtIHJ0dzg4IGRyaXZl
ciwgYW5kIEkgcGxhbiB0byBtZXJnZSB0aGlzIHBhdGNoc2V0IGFuZCBzZW5kDQpwdWxsLXJlcXVl
c3QgdG8gd2lyZWxlc3MgbWFpbnRhaW5lciB0b21vcnJvdy4gSG93ZXZlciwgdGhlIHR3byBkcml2
ZXJzDQphcmUgZXhpc3RpbmcgYXQgdGhpcyBtb21lbnQuIA0KDQpNeSBxdWVzdGlvbiBpcyB0aGF0
IGNhbiBMdWthIHNlbmQgYSBwYXRjaCB0byByZW1vdmUgc3RhZ2luZyBydGw4NzIzYnMsDQphbmQg
Z29lcyB2aWEgbXkgdHJlZT8gVGhlbiB5b3UgZG9uJ3QgbmVlZCB0byB3YWl0IGZvciBteSBwdWxs
LXJlcXVlc3QNCmJlaW5nIHVwc3RyZWFtLiBDYW4gaXQgd29yayB0byB5b3U/IA0KDQpQaW5nLUtl
DQoNCg==
