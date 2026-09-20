Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950F13C3C0E;
	Sun, 20 Sep 2026 02:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789871821; cv=none; b=dP/6ouIcxUWsPsa4TvygCrgrFduYTBBLKivaXTlGcsBXzWdh7jnQvh6G1p6LeCjc2kkVAUxCcNMtL1wNcvs8rdyd79IeYBFaGg19JEYBk/wai6as5Tkbf+pb35TOtfUcS3yPhr17hstsUrGZrwLHL/IIaOflE2HTv+lX4NbZsUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789871821; c=relaxed/simple;
	bh=rgYM4b5R3MWixIxzmNyFSREeayMkIBlnnfjyf+w4XK8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=omXdKyxHCUnJoBAI4EeuJMqDS5SnBC3Kii11bTZpsuZs1diYD1DbLzGcmGBvzSvPPZULC0+frZZC6YnQ7E1QircS/+vjAc6UUTOqtj+LXq0GNaxh2nT9iRu91ajgSw2DT8FQ4xAgcwkTaeHiAjnzYjvXdboaGzZecFHyYZSYu1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=n21KlU+U; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="n21KlU+U"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68K2aZgyD1369115, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789871795; bh=rgYM4b5R3MWixIxzmNyFSREeayMkIBlnnfjyf+w4XK8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=n21KlU+Ui/bzOlrQjXtSGkW/str+ROYIoDzSMiEq//BBoZwT57wn5X3qIh62EL/vR
	 QTvtnjhNByFT0x6Ircv03KnkwTLk4ihgzwnBXxtWyhdXz5d8UBR3yIwO160rQlyben
	 UzMpBE1zbWRfScGY/+F58puu1nnEDy7VgoNpUkzKgPSltqoUmD2DKOcEJJAjEBdHjw
	 tZyQgOIH8QgaILKpJNfUHT3ZCQbbA+SKPcGS6DExoCCkcxO2t1CD3b6iDbkC+ciVM6
	 SJD+OZYXvRyOUJiGRZW+0bSqs1I9IaorwS0/dE1lb6bEMWkLsyoyzcUOflslR3wAq/
	 NLI/6T/55tZ2w==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68K2aZgyD1369115
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 20 Sep 2026 10:36:35 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 20 Sep 2026 10:36:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 20 Sep 2026 10:36:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 20 Sep 2026 10:36:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>, Paolo Lazzaroni
	<eexto@aol.com>, Kalle Valo <kvalo@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Oleksandr Havrylov <goainwo@gmail.com>, Gabriel Maia
	<gabrielvinicius.damaia@gmail.com>, Rahul Kumar Rai
	<learn.rahul.rai@gmail.com>, Mihail Dimoski <mihaildimoski@gmail.com>,
	=?utf-8?B?QXRhIMSwbGhhbiBLw7ZrdMO8cms=?= <atailhan2006@gmail.com>
Subject: RE: [PATCH rtw-next] wifi: rtw88: 8821c: disable deep LPS on PCIe
 devices
Thread-Topic: [PATCH rtw-next] wifi: rtw88: 8821c: disable deep LPS on PCIe
 devices
Thread-Index: AQHdR8VgRb0AFz8J/02a5VCtUHNfvLbVpdyAgAEXFXA=
Date: Sun, 20 Sep 2026 02:36:35 +0000
Message-ID: <6ef40cf436a54a319ab228c19a137cc4@realtek.com>
References: <20260918232801.119348-1-eexto.ref@aol.com>
 <20260918232801.119348-1-eexto@aol.com>
 <2f2f2366-bf64-45d1-911d-6a769be9d7aa@gmail.com>
In-Reply-To: <2f2f2366-bf64-45d1-911d-6a769be9d7aa@gmail.com>
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

DQpCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNvbT4gd3JvdGU6DQo+IE9u
IDE5LzA5LzIwMjYgMDI6MjgsIFBhb2xvIExhenphcm9uaSB3cm90ZToNCj4gPiBPbiBSVEw4ODIx
Q0UgUENJZSBhZGFwdGVycywgZW50ZXJpbmcgMzJrSHogbG93LXBvd2VyIGNsb2NrIGRlZXAgc2xl
ZXANCj4gPiAoTFBTX0RFRVBfTU9ERV9MQ0xLKSBjYXVzZXMgcmVjdXJyZW50IFBDSWUgY29tcGxl
dGlvbiB0aW1lb3V0cywNCj4gPiAiZmlybXdhcmUgZmFpbGVkIHRvIGxlYXZlIGxwcyBzdGF0ZSIs
ICJmYWlsZWQgdG8gc2VuZCBoMmMgY29tbWFuZCIsDQo+ID4gYW5kIGhhcmQgc3lzdGVtIGZyZWV6
ZXMgd2hlbiB0cmFuc2l0aW9uaW5nIG91dCBvZiBsb3cgcG93ZXIgc3RhdGVzIHdpdGgNCj4gPiBQ
Q0llIEFTUE0gZW5hYmxlZC4NCj4gPg0KPiA+IFRvIHdvcmsgYXJvdW5kIHRoaXMsIGEgRE1JIHF1
aXJrIGxpc3QgKHJ0d19wY2lfcXVpcmtzW10pIHdhcyBpbnRyb2R1Y2VkDQo+ID4gYW5kIGhhcyBn
cm93biBhY3Jvc3MgSFAsIEFTVVMsIERlbGwsIGFuZCBMZW5vdm8gbWFjaGluZXMuIEhvd2V2ZXIs
IERNSQ0KPiA+IG1hdGNoaW5nIGlzIHVuc3VzdGFpbmFibGU6IG1pbm9yIHN1Yi1tb2RlbCB2YXJp
YW5jZXMgKHN1Y2ggYXMgQVNVUw0KPiA+IEZBNTA2SUkgdnMgRkE1MDZJSCkgb3IgdW5saXN0ZWQg
bW9kZWxzIChzdWNoIGFzIEFTVVMgVml2b0Jvb2sgWDUxNUpBLA0KPiA+IEJtYXggWTE0LCBvciBt
b2Rlcm4gQWxkZXIgTGFrZS1OIG1pbmkgUENzKSBsZWF2ZSB1c2VycyBleHBlcmllbmNpbmcgYnVz
DQo+ID4gbG9ja3VwcyBvciBmaXJtd2FyZSBkcm9wcyB1bmxlc3MgdGhleSBtYW51YWxseSB0dXJu
IG9mZiBwb3dlciBzYXZpbmcgdmlhDQo+ID4gaXcuDQo+ID4NCj4gPiBFeGFtaW5hdGlvbiBvZiBv
ZmZpY2lhbCBPRU0gV2luZG93cyBkcml2ZXIgSU5GIGZpbGVzIGZvciBSVEw4ODIxQ0UNCj4gPiAo
SFAgYW5kIEFTVVMgbmV0cnR3bGFuZS5pbmYpIHJldmVhbHMgdGhhdCB2ZW5kb3IgZHJpdmVycyBl
eHBsaWNpdGx5DQo+ID4gZGlzYWJsZSBkZWVwIHBvd2VyIHNhdmluZyAoV29XTEFOUFNNb2RlID0g
MCwgYkxQU19QR19FbiA9IDApIGFuZCBlbmFibGUNCj4gDQo+IERpc2FibGluZyBMUFNfUEcgZG9l
c24ndCBtZWFuIGRpc2FibGluZyBMQ0xLLCBJIHRoaW5rLg0KDQpJbmRlZWQuIGJMUFNfUEdfRW4g
c2hvdWxkIGJlIExQU19ERUVQX01PREVfUEcgd2hpY2ggODgyMWMncw0KLmxwc19kZWVwX21vZGVf
c3VwcG9ydGVkIGRvZXNuJ3QgZGVjbGFyZSB0aGlzLiANCg0KPiANCj4gPiBmaXJtd2FyZSBQQ0ll
IHJlY292ZXJ5LCB3aGlsZSBrZWVwaW5nIHN0YW5kYXJkIFBDSWUgQVNQTSBlbmFibGVkLg0KPiA+
IEZ1cnRoZXJtb3JlLCBvdGhlciBjaGlwcyBpbiBydHc4OCAoUlRMODcyM0RFLCBSVEw4ODEyQUUs
IFJUTDg4MjFBRSkNCj4gPiBhbHJlYWR5IHNldCBscHNfZGVlcF9tb2RlX3N1cHBvcnRlZCA9IDAg
YnkgZGVmYXVsdC4NCj4gDQo+IFdoYXQgdGhvc2Ugb3RoZXIgY2hpcHMgYXJlIGRvaW5nIGlzIG5v
dCByZWxldmFudC4gUlRMODgxMkFFIGFuZA0KPiBSVEw4ODIxQUUgYXJlIG5vdCBvZmZpY2lhbGx5
IHN1cHBvcnRlZCBpbiBydHc4OC4gKE5vdCB5ZXQ/KQ0KPiBscHNfZGVlcF9tb2RlX3N1cHBvcnRl
ZCBpcyB6ZXJvIGluIHJ0dzg4MTJhLmMgYW5kIHJ0dzg4MjFhLmMgYmVjYXVzZQ0KPiBydHc4OF91
c2IgZG9lc24ndCBpbXBsZW1lbnQgZGVlcCBQUyBhbmQgSSBkaWRuJ3QgcmVzZWFyY2ggd2hpY2gN
Cj4gbW9kZXMgdGhleSBjb3VsZCBzdXBwb3J0IGlmIGRlZXAgUFMgd2FzIGltcGxlbWVudGVkIGZv
ciBVU0IuDQo+IA0KPiA+DQo+ID4gQ29uc2VydmF0aXZlbHkgZGlzYWJsZSBMUFNfREVFUF9NT0RF
X0xDTEsgc3BlY2lmaWNhbGx5IGZvciBSVEw4ODIxQyBvbg0KPiA+IFBDSWUgaW50ZXJmYWNlcyBp
biBydHdfdXBkYXRlX2xwc19kZWVwX21vZGUoKS4gU3RhbmRhcmQgODAyLjExIExQUw0KPiA+IHBv
d2VyIHNhdmluZyBhbmQgUENJZSBBU1BNIHJlbWFpbiBmdW5jdGlvbmFsLCBwcmV2ZW50aW5nIHN5
c3RlbSBsb2NrdXBzDQo+ID4gYW5kIGZpcm13YXJlIGZhaWx1cmVzIHdpdGhvdXQgYWZmZWN0aW5n
IFNESU8gb3IgVVNCIHZhcmlhbnRzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUGFvbG8gTGF6
emFyb25pIDxlZXh0b0Bhb2wuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0dzg4L21haW4uYyB8IDggKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDggaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dHc4OC9tYWluLmMNCj4gPiBpbmRleCAwZjIzNDk4YjUuLjViZDg1NDIyMyAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L21haW4uYw0KPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5jDQo+ID4gQEAgLTEzNjAs
NiArMTM2MCwxNCBAQCBzdGF0aWMgZW51bSBydHdfbHBzX2RlZXBfbW9kZSBydHdfdXBkYXRlX2xw
c19kZWVwX21vZGUoc3RydWN0IHJ0d19kZXYgKnJ0d2RldiwNCj4gPiAgICAgICAgICAgIWZ3LT5m
ZWF0dXJlKQ0KPiA+ICAgICAgICAgICAgICAgcmV0dXJuIExQU19ERUVQX01PREVfTk9ORTsNCj4g
Pg0KPiA+ICsgICAgIC8qIFJUTDg4MjFDRSBQQ0llIGRldmljZXMgZmFpbCB0byB3YWtlIHVwIGZy
b20gMzJrSHogTENMSyBkZWVwIHNsZWVwDQoNCkZpcnN0IGxpbmUgb2YgYmxvY2sgY29tbWVudCBz
aG91bGQgYmUgZW1wdHkuDQoNCj4gPiArICAgICAgKiBpbiB0aW1lIGZvciBQQ0llIGNvbXBsZXRp
b24gZGVhZGxpbmVzLCBsZWFkaW5nIHRvIFBDSWUgYnVzIGZyZWV6ZQ0KPiANCj4gQ29tcGxldGlv
biB0aW1lb3V0IGlzIGFscmVhZHkgZGlzYWJsZWQgZm9yIHRoaXMgY2hpcC4NCj4gDQo+ID4gKyAg
ICAgICogYW5kIGNvbW11bmljYXRpb24gdGltZW91dHMuDQo+ID4gKyAgICAgICovDQo+ID4gKyAg
ICAgaWYgKHJ0d19oY2lfdHlwZShydHdkZXYpID09IFJUV19IQ0lfVFlQRV9QQ0lFICYmDQo+ID4g
KyAgICAgICAgIGNoaXAtPmlkID09IFJUV19DSElQX1RZUEVfODgyMUMpDQo+ID4gKyAgICAgICAg
ICAgICByZXR1cm4gTFBTX0RFRVBfTU9ERV9OT05FOw0KPiA+ICsNCj4gPiAgICAgICBpZiAoKGNo
aXAtPmxwc19kZWVwX21vZGVfc3VwcG9ydGVkICYgQklUKExQU19ERUVQX01PREVfUEcpKSAmJg0K
PiA+ICAgICAgICAgICBydHdfZndfZmVhdHVyZV9jaGVjayhmdywgRldfRkVBVFVSRV9QRykpDQo+
ID4gICAgICAgICAgICAgICByZXR1cm4gTFBTX0RFRVBfTU9ERV9QRzsNCj4gDQo+IEhvd2V2ZXIs
IEknbSBub3Qgc2F5aW5nIGl0J3MgbmVjZXNzYXJpbHkgd3JvbmcgdG8gZGlzYWJsZSBkZWVwIFBT
IGZvcg0KPiB0aGlzIGNoaXAgY29tcGxldGVseS4gSSdtIGp1c3Qgb2JqZWN0aW5nIHRvIHlvdXIg
TExNJ3MgY29uY2x1c2lvbnMuDQoNCkknbGwgY29uc3VsdCBpbnRlcm5hbGx5IHRvIHNlZSBpZiB3
ZSBkaXNhYmxlIGRlZXAgUFMgZW50aXJlbHkNCmZvciB0aGlzIGNoaXAuDQoNCk15IHF1ZXN0aW9u
IGlzIHRoYXQgYXJlIHlvdSAxMDAlIHN1cmUgdGhpcyBjYW4gcmVzb2x2ZSB0aGUgcHJvYmxlbQ0K
eW91IGVuY291bnRlcmVkPyANCg0KUGluZy1LZQ0KDQo=
