Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793237376;
	b=QWQC0ELZU5LwZX1Cv7M1hoW2QaTETUbAVYESYsxXtkXM9BocXNxIYYT7oTRdXx/BJrTk
	 XCCQxaBVBzihp+eiHD82n79faycT4DSfraAngMFmpTeAHvmQjEVaRiWqoXLKRQVuS9xUY
	 9YXHMorrco2u9ysUPZvTHkH5jZGIBzInQf0JpJDGxF2bxdYoaE8HAIJSqUZgKbofsR08n
	 kVcj7+RaUDBtVRwABVL70Ee0bgiT9nKZNOy+eAVXF3benB8d2u+52wzb9qIYrklpmBrbG
	 YCud86OXWjec6UlTNpDxGkSyjoFeTNcKTSgnrT0uAoRABIG2/195x20WlHOGhlumwUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793237376;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=4r+SqHACHaFkQVRR7p2Yzcc3V4kjgDrSI+WxPZ1suNo=;
	b=4Xorh3IoJwmrgJzxtZI4pR1QSyIdChNVBnTJEw6ExJZBcFVs1sau6paE0YkPtcsP5/Ns
	 zmSdypu7UDPys5O6AViALwoQrTphUGuKQcXHditZX2qowQ7ppUF7LTLz2pU2Kga6OsqI+
	 ykAYU5I/JV/4DbVShER85Ro05qIVsaQnjEKlJ6O7ek/fEM5i/ir0WmaIcQg7OmMCtpKQc
	 AMTSLfDPS5t+TFccuCvvrrvBQLAGvUWr6cz4D8VILdaMpaGOGR2QFSvKrz7wFL9lGxUFN
	 pq3g3UM3n4BGBWPGt1Ux+V5LzzRBkmHIqtIwKSu25oN41Vc8GuBRDItGHLOwJ/gfExQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=kCEsaSfA;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F3E606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 01:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5F3E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=kCEsaSfA
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69T1TQMf82403022, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793237366; bh=4r+SqHACHaFkQVRR7p2Yzcc3V4kjgDrSI+WxPZ1suNo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=kCEsaSfAwYI/0hmprF23Jfy7j9qEkssf7sNNbycYA9hEuRJOodHEOBmo8o0MNfO6v
	 WF9m2f455euHKaMjf1H0oNl5IfQx+eeUXUT4xD6GG5GzExW4Ep88QfYnHc3S9aQSb1
	 I4XQtMcyfBm8+MkqBZ1eDiaNoUX6GB0TJSbYEd5R+x8Nra84WZLOgqFf5+iDt7mM8N
	 gb0l2jwO2qra7Q4A/UsFNWnY/sJmY2kuC8aYk8GJBkU/ErBF8dab29j+MzCVSPAS7c
	 r8u+E72o826KUDdx5l5McIt4VEV7AKT3jTcxjaghjybktiP17EKyd+EIpNuwpq5nR0
	 hCIwJpw7nw9pw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69T1TQMf82403022
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 29 Oct 2026 09:29:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 29 Oct 2026 09:29:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 29 Oct 2026 09:29:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Thu, 29 Oct 2026 09:29:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Topic: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Index: AQHdY0HfQGIda1zW60KKJQiEj21Ec7cQnBmQgAIecQCAAPv2QIAAC2Rw
Date: Thu, 29 Oct 2026 01:29:25 +0000
Message-ID: <13e17aa587024dd3b6d89741e24be5de@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
 <152bc5bf-4e5e-443e-b191-198205ad81bc@gmail.com>
 <f5ec572f354f4c67a2a65b2b1676eae0@realtek.com>
In-Reply-To: <f5ec572f354f4c67a2a65b2b1676eae0@realtek.com>
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

UGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiBCaXR0ZXJibHVlIFNt
aXRoIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gT24gMjcvMTAvMjAyNiAw
Mzo1MiwgUGluZy1LZSBTaGloIHdyb3RlOg0KPiA+ID4gQml0dGVyYmx1ZSBTbWl0aCA8cnRsODgy
MWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+ID4+IFRoaXMgc2VyaWVzIGV4dGVuZHMgcnR3
ODhfcGNpIHRvIHN1cHBvcnQgYW4gb2xkZXIgZGVzaWduLCBsaWtlDQo+ID4gPj4gUlRMODgyMUFF
LCBSVEw4ODEyQUUsIFJUTDg3MjNCRSwgZXRjLg0KPiA+ID4NCj4gPiA+IFRoZSBvbGRlciBkZXNp
Z24gaXMgb3duLWJpdCByaW5nLCBhbmQgdGhlIG5ldyBpcyByZWFkL3dyaXRlIGluZGV4IHJpbmcN
Cj4gPiA+IHdpdGggYnVmZmVyIGRlc2NyaXB0b3IuIENhbiB3ZSB1c2UgJ293bi1iaXQnIGluc3Rl
YWQgb2YgJ29sZCcgYXMgdGhlIGZpbGUNCj4gPiA+IG5hbWUgPw0KPiA+ID4NCj4gPg0KPiA+IFN1
cmUsIHRoZSBmaWxlIG5hbWUgaXMgbm90IGEgcHJvYmxlbS4gV2hhdCBhYm91dCB0aGUgY29kZT8g
QWxsIHRoZSBmdW5jdGlvbnMNCj4gPiBpbiBwY2lfb2xkLmMgYXJlIHByZWZpeGVkIHdpdGggInJ0
d19wY2lfb2xkIiwgYW5kIHRoZXJlIGlzIHJ0d19wY2lfZ2VuX29sZA0KPiA+IGFuZCBydHdfcGNp
X2dlbl9uZXcuIFNob3VsZCBJIHJlbmFtZSBhbGwgb2YgdGhlc2U/DQo+IA0KPiBJJ2QgcHJlZmVy
IGhhdmluZyBjb25zaXN0ZW50IHN1ZmZpeCBhcyBmaWxlIG5hbWUsIGJ1dCBJIGhhdmUgbm8gZ29v
ZCBpZGVhDQo+IGZvciB0aGUgc3VmZml4LiBNYXliZSwgJ19vYicgbWVhbnMgJ293bi1iaXQgcmlu
Zyc/DQoNCk9yIGp1c3QgJ192MCcsIG9yICdfZ2VuMCc/DQoNClRoaW5rIGEgYml0IG1vcmUuIE1h
eWJlLCAnb2xkJyBpcyBzdGlsbCBtZWFuaW5nZnVsIGZvciBnZW5lcmF0aW9uIG9mIFBDSQ0KYXJj
aGl0ZWN0dXJlLCBzaW5jZSBSZWFsdGVrIFdpRmkgUENJRSBjaGlwIGhhcyBvbmx5IHR3byBraW5k
cyBvZiBhcmNoaXRlY3R1cmUuDQpJZiB0aGVyZSBpcyB0aGlyZCBvbmUgaW4gdGhlIGZ1dHVyZSwg
dGhhdCBtdXN0IG5vdCBiZSBhZGRlZCB0byBydHc4OC4NCg0KQXQgZmlyc3QgZ2xhbmNlIG9mICdv
bGQnIGRheXMgYWdvLCBJIGp1c3Qgd2FudCB0byBhdm9pZCB0aGUgaW1wbGljaXQgbmFtaW5nLg0K
DQoNCg==
