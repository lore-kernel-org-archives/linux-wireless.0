Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B83817C211;
	Sun,  6 Sep 2026 01:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788658720; cv=none; b=OhZLHBgPlWNR77vl2bRdrf/f/1zEjHRy7RORQyYNQc+BPLVT6fib3c1rOuuUumSrb1HgLk7W4McOOiGF2gDPqaHz16DU+6shdIdIZU39CaJqTYTa6yEnqpxUtMbTxefKKFfidEr4ShOlOojzxMyEIV44uiVJZoSRBzNkgQdFe44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788658720; c=relaxed/simple;
	bh=pkVHo6XfekYcbVFSVTGQ5S8EN/iE3gGIxcoeJVVprpE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qqb6FwrensnNPiMHijwyscsP814R2a1aly96Jcrl9rHtzBpmMdGzcwBi6Nu+xBfuRoMvGSvwN0pQS36QkZWDw285Xot1N1SpsqHiMxQBNwBhVNkqOIu1DjJJxVCYxTfupgoOPXbWf3QtClDwJjvNogZ3R3P+12w9VmKmuzN0Dfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=wX45L/Nk; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="wX45L/Nk"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6861bkn871544854, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788658666; bh=pkVHo6XfekYcbVFSVTGQ5S8EN/iE3gGIxcoeJVVprpE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=wX45L/NkZqE++ONL0HvCa9YrVqxWApKVI2GJViBkJghmiXOzVZYJYjpzemxXwOoC5
	 fXIjxVLJem9waHQ8Qa57ESkjoORWZChXRPMHG8tRHydSGF/vvkTwlUO71SghrvDRof
	 anFZrnRPdXiPFPKrlPkHhkst72HaMcYuvqyWeLPNcUdAcnHUmd8OcuVdpYaBVBgNTl
	 cfltK+GOTv14dkOOhY++maM1lYggxePzPMj1rD3RuWPePk5yrl4M7EJ3Kk4B7G6wUa
	 te58RRaZQ4XhznKd7W7Tr9ADSq3lBEY6tzR1XsUoHKm4ARqkyuxjOWJeKDIAWEIY02
	 isdGiNCA8iUBg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6861bkn871544854
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 6 Sep 2026 09:37:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 09:37:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Sun, 6 Sep 2026 09:37:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v8 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Topic: [PATCH v8 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Index: AQHdNK98EWXiqeD5uE6QFc7swG8a87awGBYAgAdVyYCAAdP9gIAHklPg
Date: Sun, 6 Sep 2026 01:37:46 +0000
Message-ID: <f3e7701d6eb045faa31c1b914eae6228@realtek.com>
References: <20260825163314.1590-1-luka.gejak@linux.dev>
 <4866D935-FCC8-4F24-9C05-8678DCB22533@linux.dev>
 <f1454e9c2add47b2b01a0adb8233455f@realtek.com>
 <B2A0C047-C517-4AB4-BD6E-3EC6E9DA23EB@linux.dev>
In-Reply-To: <B2A0C047-C517-4AB4-BD6E-3EC6E9DA23EB@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBIaSBQaW5nLUtlLA0K
PiBPbiBBdWd1c3QgMzEsIDIwMjYgNDoyMzo0OCBBTSBHTVQrMDI6MDAsIFBpbmctS2UgU2hpaCA8
cGtzaGloQHJlYWx0ZWsuY29tPiB3cm90ZToNCj4gDQo+IFRoZSBwcm9iZV93YWl0X21zIHRlc3Qg
eW91IHN1Z2dlc3RlZCBoYXMgcnVuLCBuaW5lIGhvdXJzIGluIHRoZSB0ZXN0ZXIncw0KPiBwb29y
IHNpZ25hbCBlbnZpcm9ubWVudC4gQXQgMjAwMCBtcyBoZSBzYXcgb25lICJGYWlsZWQgdG8gc2Vu
ZCBudWxsZnVuYw0KPiAuLi4gZGlzY29ubmVjdGluZyIuIEF0IDUwMCBtcyBpdCB3YXMgb25lIGV2
ZXJ5IHR3ZW50eSB0byBmb3J0eSBzZWNvbmRzLg0KPiBTYW1lIGVudmlyb25tZW50LCBzYW1lIGRy
aXZlci4NCg0KV2l0aG91dCBwcm9wZXIgcXVvdGEgbWVzc2FnZSwgSSBuZWVkIGNvbWluZyBiYWNr
IHRvIHByZXZpb3VzIG1haWwgYW5kIGZpbmRpbmcNCm91dCB0aGUgc3R1ZmYgeW91IHdhbnQgdG8g
ZGlzY3Vzcy4uLg0KDQpJIGRvbid0IGtub3cgaG93IGJhZCB0aGUgcG9vciBzaWduYWwgZW52aXJv
bm1lbnQgd2FzLiBCdXQgMjAwMG1zIGxvb2tzIHZlcnkNCnN0cmFuZ2UgdG8gbWUsIGl0IGlzIHRv
byBsYXJnZS4gSGF2ZSB5b3UgY2FwdHVyZWQgYWlyIHNuaWZmZXIgdG8gc2VlIHdoYXQNCmhhcHBl
bmVkPyANCg0KSSB0aGluayB3ZSBjYW4gY2hlY2sgdGhyZWUgcG9pbnRzDQoxKSBJZiB0aGUgcHJv
YmUgdXNlcyBsb3cgcmF0ZSAoZS5nLiA2TSkNCjIpIHNpZ25hbCBzdHJlbmd0aCAgDQozKSBzaWdu
YWwgcXVhbGl0eSANCiAgIFdpdGhvdXQgaGFyZHdhcmUgZXF1aXBtZW50LCB0aGlzIGlzIGhhcmQg
dG8gdXMuIEkgdGhpbmsgd2UgY2FuIGNvbXBhcmUNCiAgIHRoZSBsaW5rIHJhdGUgd2l0aCBvdGhl
ciBXaUZpIGNhcmQgYXQgdGhlIHNhbWUgZGlzdGFuY2UgZmFyIGZyb20gQVAuDQoNCg0KPiANCj4g
PiBCdXQgSSBmZWVsIHRoaXMgY2FzZSwgdXNpbmcgaWVlZTgwMjExX3B1cmdlX3R4X3F1ZXVlKCkg
aXMgZXF1aXZhbGVudD8NCj4gDQo+IE5vdCBlcXVpdmFsZW50LiBpZWVlODAyMTFfcHVyZ2VfdHhf
cXVldWUoKSBjYWxscyBpZWVlODAyMTFfZnJlZV90eHNrYigpLA0KPiB3aGljaCBjYWxscyBpZWVl
ODAyMTFfcmVwb3J0X3VzZWRfc2tiKCkgd2l0aCBkcm9wcGVkID0gdHJ1ZTogdGhhdA0KPiBzZXR0
bGVzIHRoZSBhaXJ0aW1lIGFjY291bnRpbmcgYW5kIGZyZWVzIHRoZSBza2IgcHJvcGVybHksIGJ1
dCBuZXZlcg0KPiByZWFjaGVzIGllZWU4MDIxMV9zdGFfdHhfbm90aWZ5KCkuIE9ubHkgaWVlZTgw
MjExX3R4X3N0YXR1c18qKCkgZG9lcy4gSXQNCj4gZml4ZXMgdGhlIG93bmVyc2hpcCBidWcgYW5k
IHRlbGxzIHRoZSBjb25uZWN0aW9uIHBvbGwgbm90aGluZywgd2hpY2gNCj4gZ2l2ZW4gdGhlIGFi
b3ZlIGRvZXMgbm90IG1hdHRlci4NCg0KVGhlIGllZWU4MDIxMV9wdXJnZV90eF9xdWV1ZSgpIEkg
bWVudGlvbmVkIGlzIHRvIHJlZmVyZW5jZSB0byB0aGUgcG9pbnQ6DQoNCj4gPiAgIHJ0d190eF9y
ZXBvcnRfcHVyZ2VfdGltZXIoKSAtPiBza2JfcXVldWVfcHVyZ2UoKQ0KPiBJIHRoaW5rIGl0IHNo
b3VsZCB1c2UgaWVlZTgwMjExX3B1cmdlX3R4X3F1ZXVlKCkgaW5zdGVhZCBvZiBza2JfcXVldWVf
cHVyZ2UoKS4NCg0KDQo=
