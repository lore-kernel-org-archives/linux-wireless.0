Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C019F377EBF;
	Tue,  6 Oct 2026 05:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791264567; cv=none; b=P7l7w3HR7IQMyo1ues1OmePxJ9Difb3R/TUkxcCe2PFfxBSBIxunwZQ77r+sNQ/K/8r7lEziiuNP6FIj/jEaqlUi3S/mxg3knWzFIM1kW/3vs/hKTlmWcw6/wc2W3Qecl9OmO4r5LRLpZumitfc3LE38J75aS5JYTwdXljQVX5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791264567; c=relaxed/simple;
	bh=qydEbsAEnOqPy1tM1wey7IB+3sJMbbLOvbn7P/7qDoI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sVWUZJ+QBGJ6MxW7mIeo2JJMbAgHTfL/qsx6/zOjxbJxzB9g6UkCGTHcqQZe0AjMzVkwZYUiXkaNgCelgmhyjKcHNDAjUB3kvFfb5/zhTiwR5LryANxEEx3Rnc/k7k0QUUA2hSMh2B6mnPcdNt+U4BUPFvk7Yq+KXpZu4rdQK9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QKATaimF; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QKATaimF"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6965TBQc82627167, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791264551; bh=qydEbsAEnOqPy1tM1wey7IB+3sJMbbLOvbn7P/7qDoI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=QKATaimFSHBUtHCIn8pCUf0qLzXlo8nmBuBFrOPZLb2+85l60k49rLqXlVK1SBodJ
	 gWXi3Os7gHNFwQP5rmICyFqnAjhN7dNDrGpeWymujwXNKiiKTfCwDDxiowX4tqp6xH
	 L3Fe+6QSR8yKdqKdWUEBGYTQYRa3R/vlhyJcFo1/+CAUIb403aWVvLNVCZSNr3fO8l
	 dMHGHtA8K7z8Gmsj9lCqiB4427k4SIdy8CVrj/tlaKlKA4nl3piNH8xxONqdAm+mxd
	 cuwdU6TF5eMrEpzt7s/yJ3SAuWe3G2XD7d5Cefhzpyp4AfrN2Ys/pvIBW/1Se2OeGu
	 Ft/bZqTWrfA8Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6965TBQc82627167
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 6 Oct 2026 13:29:11 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 13:29:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 13:29:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 6 Oct 2026 13:29:11 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
  Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B chip
 driver
Thread-Topic: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
Thread-Index: AQHdUkEe+6mTN1t+pkmrNCm0JOCqYbbudRJA///7x4CAAT4DAP//vViAgACViMA=
Date: Tue, 6 Oct 2026 05:29:11 +0000
Message-ID: <f23d5ed909c746ad851bd1038966d271@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-5-luka.gejak@linux.dev>
 <aa7d919d98304ee095990735f39095ac@realtek.com>
 <DLWXWMOGZGX9.UANQJR9PZYWG@linux.dev>
 <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>
 <a1d007fffc35466a2d63a3fe6839286f3488d7be@linux.dev>
In-Reply-To: <a1d007fffc35466a2d63a3fe6839286f3488d7be@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiA+ID4NCj4gPiA+IEhv
d2V2ZXIsIGluY2x1ZGluZyBydHc4NzAzYi5oIGZyb20gYW5vdGhlciBjaGlwIGRyaXZlciBpcw0K
PiA+ID4gIGFscmVhZHkgZXN0YWJsaXNoZWQsIHJ0dzg3MjNjcy5jIGluY2x1ZGVzIGl0IHRvIHJl
dXNlIHJ0dzg3MDNiX2h3X3NwZWMuDQo+ID4gPg0KPiA+IEFzIEkga25vdywgODcyM0NTIGFuZCA4
NzIzQiBhcmUgbXV0dWFsIGFsaWFzLCBubz8NCj4gDQo+IEFzIGZhciBhcyBJIGtub3csIHRoZXkg
YXJlIG5vdC4gVGhleSBhcmUgZGlmZmVyZW50IGNoaXBzLg0KDQpmaXggdHlwby4NCg0KODcyM0NT
IGFuZCA4NzAzQiBhcmUgbXV0dWFsIGFsaWFzLCBubz8NCg0KPiANCj4gPiA+DQo+ID4gPiArLyoN
Cj4gPiA+ICArICogUm93IDIwICgtNi4wIGRCKSBpbnRlbnRpb25hbGx5IGRvZXMgbm90IG1hdGNo
IHRoZSB2NS4yLjE3IHZlbmRvciBkcml2ZXIsDQo+ID4gPg0KPiA+ID4gIEkgcmVhbGx5IGRvbid0
IHdhbnQgdG8gbWVudGlvbiB2ZW5kb3IgZHJpdmVyIGhlcmUuIElmIHlvdSByZWFsbHkgbmVlZCBp
dCwNCj4gPiA+ICBtZW50aW9uIGl0IGluIGNvbW1pdCBtZXNzYWdlIG9yIGNvdmVyLWxldHRlci4N
Cj4gPiA+DQo+ID4gPiAgKyAqIHdoaWNoIGhhcyAweDFjLCAweDFhLCAweDE4LCAweDEyLCAweDBl
LCAweDA4IHRoZXJlLiBFdmVyeSBvdGhlciByb3cgYWdyZWVzLg0KPiA+ID4gICsgKiBUaGUgdmFs
dWVzIGJlbG93IGFyZSB3aGF0IHJ0bDg3MjNiZSwgdGhlIG1haW5saW5lIGRyaXZlciBmb3IgdGhp
cyBzYW1lDQo+ID4gPiAgKyAqIGNoaXAsIHVzZXMgYXQgdGhlIHNhbWUgaW5kZXgsIGFuZCB0aGV5
IGFyZSBhbHNvIHdoYXQgdGhlIHZlbmRvcidzIG93bg0KPiA+ID4gICsgKiBjY2tfc3dpbmdfdGFi
bGVfY2gxX2NoMTNfOTJlIGFuZCB0aGUgc3RhZ2luZyBydGw4NzIzYnMgZHJpdmVyIHVzZS4gVGhl
eQ0KPiA+ID4gICsgKiBhbHNvIHRyYWNrIHRoZSAwLjUgZEIgc3RlcCBvZiB0aGUgc3Vycm91bmRp
bmcgcm93czogYWdhaW5zdCByb3cgMzIgYXMgMCBkQiwNCj4gPiA+ICArICogMHgxYiBpcyB3aXRo
aW4gMC4wNiBvZiB0aGUgaWRlYWwgLTYuMCBkQiB2YWx1ZSB3aGlsZSAweDFjIGlzIDAuOTQgYXdh
eSwNCj4gPiA+ICArICogdGhlIGxhcmdlc3QgZXJyb3IgYW55d2hlcmUgaW4gdGhlIHRhYmxlLiBU
cmVhdCB0aGUgdmVuZG9yIHJvdyBhcyB0aGUNCj4gPiA+ICArICogYW5vbWFseSBhbmQgZG8gbm90
ICJmaXgiIHRoaXMgdG93YXJkcyBpdC4NCj4gPiA+DQo+ID4gPiAgQW5kIHlvdSBoYXZlIGNvbW1l
bnRzIGVhY2ggcm93LiBJcyBpdCBzdGlsbCBuZWVkIHRoaXMgYmxvY2sgY29tbWVudCB0byBleHBs
YWluPw0KPiA+ID4NCj4gPiA+DQo+ID4gPiAgSSBhZ3JlZSwgd2lsbCBkcm9wIHZlbmRvciByZWZl
cmVuY2UgYW5kIGJsb2NrIGNvbW1lbnQuDQo+ID4gPg0KPiA+IEknbSBub3Qgc3VyZSBpZiBMTE0g
d3JpdGVzIHRoaXM/IExMTSBhbHdheXMgd3JpdGUgdmVyYm9zZSBjb21tZW50cyBmb3INCj4gPiBl
YWNoIGxpbmUgaXQgYWRkZWQuIEp1c3QgYXNrIExMTSB0byB3cml0ZSBzZWxmLWV4cGxhaW5lZCBj
b2RlLg0KPiANCj4gTm8sIEkgd3JvdGUgaXQgYmVjYXVzZSBvbmx5IDEgcm93IGRpZmZlcnMgZnJv
bSB2ZW5kb3IgZHJpdmVyIGFuZCBJDQo+IHRob3VnaHQgSSBzaG91bGQgbWVudGlvbiBpdC4NCg0K
Tm8gd29ycmllcy4gSnVzdCByZW1vdmUgdGhlbS4NCg0KPiA+ID4NCj4gPiA+IFNvIEkgd291bGQN
Cj4gPiA+ICBwcmVmZXIgdG8gbGVhdmUgYm90aCB0YWJsZXMgYXMgdGhleSBhcmUuIElmIHlvdSB3
YW50IHRoZSB1bnVzZWQgZmllbGRzIGxpc3RlZCBhcyBkdW1taWVzDQo+ID4gPiAgdG8gcGluIHRo
ZSBvcmRlciwgSSBjYW4gYWRkIHRoZW0sIGJ1dCB0aGUgc2VxdWVuY2UgaXRzZWxmIHdvdWxkIG5v
dCBjaGFuZ2UuDQo+ID4gPg0KPiA+IEkgd2lsbCB0aGluayBhIGJpdCBob3cgdG8gYWxpZ24gdGhl
c2UgbWVzc2VkIHRhYmxlcy4NCj4gDQo+IEkgdW5kZXJzdGFuZC4gSSBhbSBnb25uYSBzZW5kIHY4
IHRvZGF5LCBhbmQgZG8geW91IHRoaW5rIHRoYXQgdjggY291bGQNCj4gYmUgbWVyZ2VkLCBzbyBk
cml2ZXIgbGFuZHMgaW4gNy40IHJlbGVhc2U/DQoNCkkgdGhpbmsgb25seSBtaW5vciBjaGFuZ2Vz
IGFyZSBuZWVkZWQsIGl0IGlzIHBvc3NpYmxlIHRvIGdldCBtZXJnZWQgaW50byA3LjQNClRoZSBt
ZXNzZWQgdGFibGVzIGNhbiBiZSBpZ25vcmVkIGZvciBub3cuIA0KDQpQaW5nLUtlDQoNCg==
