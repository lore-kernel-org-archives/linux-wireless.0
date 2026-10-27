Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793064001;
	b=5aeMXpzuhAr9W8iOA2y54WSg8oRqSfIwNifaZfHJm78/Sdi/cGjdsNxO4pL9xbbx+TkW
	 rLq71OAykod6rcCC0jwjYRFJRxlfiUpvmGuz4b3P7/tjqJ9PB1sMByp5XEgv6LUjhe4JM
	 WKhyu70hYDo23QUXIPkG0jCZK0nlmcBDjTPdF7yk/Lhv961vwbTFGLxz2JW77Y/z1gie9
	 U/U5Fv0gUNt9CEe/MbIW8lyVoP325gEytUobBU3WXIHCn8DiVZRrDcPNdgT1obwYoywFX
	 e1zNYb+hXCU2MCWdlXbIit0c8BAHMtDzwTuSQvCzK7S4lwXW8EVTNvWiPSlpL1jU8ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793064001;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=gQjxAHfirHERq0KG1Aa4flJcWuhh1Z8ni2Z6LML0AC8=;
	b=sp5whgRe98ZV5HWsDk6Y6I+l0dndMYdsv/vZvn/CZdg1AP4dXULaLRt2DrF0Z799aGwI
	 N9GNriLYuW46FUm7mmjNL3udSGm9YYRr63wQc0jFHA75TsMMkmooyTk2x0qKwicaHSeUn
	 J5I4Ifj2t6qFMCr/hnrUh7WgqnnPlWYtVCCV+knxNdHzshk0rTiUx3br8/iGSYtz8mOT7
	 e+SFmHpow/MyoUAZhLeNUAW2a/FfkGDs1oKMI59rKb19oWxn47SEwNuBJljSmzsqihtis
	 16FBHYvrxJlITv+/GUT38ng+ABdOYW39JvCjEYSw+ue+ktpKwo04e1mwhdHEcUQNnRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=uPYiKZuX;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960EB606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 01:20:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 960EB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=uPYiKZuX
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69R1JogaE506613, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793063990; bh=gQjxAHfirHERq0KG1Aa4flJcWuhh1Z8ni2Z6LML0AC8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=uPYiKZuX2z/Ze5/Y7CQr3p80g16+ACzmn+YrNn+D1jY9NpvG4tYlh9dr3kVEJJmmd
	 J29Eu7CgyvTXHCAeniVjmtY78GyEOuygVg1zmvRAq41XBORFHtKJX19tknSbck9c41
	 JmKJJkLoZ0nhqv+yElozLDX84RUpa69TJ0FKK3v3rrsjkMe1wlmGsGAiqbzhD0MHHb
	 wVXb8S1YlkCzbcVsrqbteCBqQlRangYVdyedICyBn5pTEBCjIJcDrJTae+ym9Ar/+9
	 X9wg5Q/sJJxWFGRw+F+M+JhgQU9CL0S+HeXlIamKzHp+DqLbX4n1GcLHbsIzn0ooKR
	 ff4b4Y15Ql7BA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69R1JogaE506613
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 27 Oct 2026 09:19:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 09:19:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 27 Oct 2026 09:19:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
Thread-Topic: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
Thread-Index: AQHdYVnJ0q7282zST0eZU32CdZ8tpbcI07VQ//+rD4CAAqT/gIACboDg///Z4ACAAywJUA==
Date: Tue, 27 Oct 2026 01:19:49 +0000
Message-ID: <d6af5cebfa1a46e2bc2da662634766d7@realtek.com>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
 <ac6d8824bdeb45148ffd6b5dee7da313@realtek.com>
 <5235fd68b703f756cc2ee1e7471339a512db59b8@linux.dev>
 <875b4e96891a2bf256ca1805140b57aeccee4aed@linux.dev>
 <ec4065a1cf2c4d0ea357694a1a73ede8@realtek.com>
 <eaaa18cd9f23a3731bd1f8f17eb0885d1a17049f@linux.dev>
In-Reply-To: <eaaa18cd9f23a3731bd1f8f17eb0885d1a17049f@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPY3RvYmVyIDI1LCAy
MDI2IGF0IDM6NDkgQU0sICJQaW5nLUtlIFNoaWgiIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3Rl
Og0KPiA+DQo+ID4gTHVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiA+
DQo+ID4gPg0KPiA+ID4gSSB3YXMgdGhpbmtpbmcsIGFzIHN0YWdpbmcgZ290IHJlbW92ZWQsIGZv
ciAxMC1pc2ggd2Vla3ModW50aWwgNy41KQ0KPiA+ID4gIHVzZXJzIG9mIFJUTDg3MjNCUyB3b24n
dCBoYXZlIEFQIG1vZGUuIFNvIEkgd2FzIHdvbmRlcmluZyBpZiB0aGVzZSB0d28NCj4gPiA+ICBw
YXRjaGVzIGNvdWxkIHBhc3MgYXMgZml4ZXMgaW50byByYzIgcmVsZWFzZShvciB3aGF0ZXZlciBp
cyB0aGUgZmlyc3QNCj4gPiA+ICByYyBpbnRvIHdoaWNoIHJ0dyB0cmVlIGlzIG1lcmdlZCksIGFz
IHRoaXMgd291bGQgYmUgREhDUCBzdGFsbCBmaXguIFRvDQo+ID4gPiAgZWxhYm9yYXRlOiB3aGVu
IHRoaXMgZHJpdmVyIHdhcyBtZXJnZWQgaXQsIHdhcyBleHBvc2luZ0FQIG1vZGUgdG8NCj4gPiA+
ICB1c2Vyc3BhY2UsIGR1ZSB0byBSVFc4OCBkb2luZyBpdCBnbG9iYWxseS4gVGhlcmVmb3JlIEFQ
IG1vZGUgZXhpc3RlZCwNCj4gPiA+ICBidXQgd2Fzbid0IHdvcmtpbmcgcHJvcGVybHkuIFNvIG1h
eWJlIGl0J3MgYSBiaXQgb2YgYSBzdHJldGNoLCBidXQgSQ0KPiA+ID4gIHRoaW5rIGl0J3MgYSB2
YWxpZCBwcm9wb3NhbCB0byBzZW5kIGl0IGFzIGEgZml4IGludG8gbmV4dCByYyByZWxlYXNlLg0K
PiA+ID4NCj4gPiBEaWQgeW91IHRoaW5rIHBlb3BsZSB1c2Ugc3RhZ2luZyBkcml2ZXIgd2l0aCBB
UCBtb2RlPw0KPiANCj4gSXQgYXBwZWFycyBzby4gSSBzYXcgb24gZm9ydW1zIGFuZCBhcnRpY2xl
cyBhYm91dCB0aGUgbmV3IGRyaXZlciB0aGF0DQo+IHNvbWUgcGVvcGxlIHdlcmUgY29tcGxhaW5p
bmcgYmVjYXVzZSBvbmx5IHN0YXRpb24gbW9kZSBpcyB3b3JraW5nDQo+IGJlY2F1c2UgdGhleSBl
eGNsdXNpdmVseSBvciBtb3N0bHkgdXNlIGl0IGFzIGFuIEFQIHBvaW50Lg0KDQpUaGlzIGxldHMg
bWUgdGhpbmsgaWYgSSBtZXJnZSBSVEw4NzIzQlMgdG8gcnR3ODggYW5kIGRlbGV0ZSBydGw4NzIz
YnMgDQpmcm9tIHN0YWdpbmcgdG9vIGVhcmx5LiBUaGUgc3RhZ2luZyBydGw4NzIzYnMgaXMgYSB2
ZW5kb3IgZHJpdmVyIHdoaWNoDQptb3N0bHkgaW1wbGVtZW50cyAiZnVsbCIgZnVuY3Rpb25zLCBi
dXQgcnR3ODggc2hvdWxkIGJlIG5vdC4gVG8gc21vb3RobHkNCm1pZ3JhdGUgZnJvbSBzdGFnaW5n
IHRvIHJ0dzg4LCB3ZSBzaG91bGQgaW1wbGVtZW50IGVxdWl2YWxlbnQgZnVuY3Rpb25zDQpiZWZv
cmUgbWVyZ2luZywgYXQgbGVhc3QgZnVuY3Rpb25zIHBlb3BsZSBhcmUgdXNpbmcuIA0KDQpCdXQg
SSByZWFsbHkgZG9uJ3Qgd2FudCB0byBnbyBiYWNrIHRvIHN0YWdpbmcgZHJpdmVyLiBMZXQncyBw
aWNrIHRoZQ0KZml4ZXMgb2YgQVAgbW9kZS4gSSBob3BlIG5vIG1vcmUgZnVuY3Rpb25zIG5lZWRl
ZCB0byBiZSBwaWNrZWQuIA0KDQo+IA0KPiA+DQo+ID4gUGVyc29uYWxseSwgSSB3YW50IHRoaXMg
Z29lcyB0byBydHctbmV4dCwgYnV0IGlmIHlvdSBoYXZlIHN0cm9uZyBvcGluaW9uDQo+ID4gdGhh
dCBwZW9wbGUgbmVlZCB0aGlzLiBJIGNhbiBwaWNrIHRoZW0gYW5kIGxldCBpdCBnb2VzIHRvIC1y
Yy4NCj4gDQo+IEkgdGhpbmsgaXQgd291bGQgYmUgYmV0dGVyIHRvIHBpY2sgdGhlc2UgaW50byBy
YywgZXNwZWNpYWxseSBzaW5jZQ0KPiB0aGUgZmVhdHVyZSBleGlzdHMgcmlnaHQgbm93IGJ1dCBp
cyBicm9rZW4uDQoNCkNvbXBhcmluZyB0byBzdGFnaW5nIHJ0bDg3MjNicywgaXQgbWlnaHQgYmUg
c2VlbiBhcyBicm9rZW4sIGJ1dCBmb3IgcnR3ODgNCkkgY29uc2lkZXIgdGhpcyBhcyBhIG5ldyBm
ZWF0dXJlLiANCg0KUGluZy1LZQ0KDQoNCg==
