Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793320987;
	b=d7LaSlq7e81YwpPhw/oM1cBRHYrmpAa1zEIGuMf5IgbEJjflqi2fqoiNWbU8E18/ePPC
	 qAqkyM+ukRkAy60eaN/ZB0NjzU3muzGby3oYt1nF6gJ/lmQT4q9xFsNYnpFfOshsWWHto
	 d8rrzvokBwqlPVycSsyif1Aj2r5wKaOUOLx6BYGys3gWBsUi/GiAne17uhUbBcaL/hkLZ
	 hWprYckkhL3toU1dlMmEur8yXnwXmfQK++Q9G/PWju7x+6b1/lpc3h6Gd5FtcuQz59jcZ
	 d1do4ND/ztsKIWsPm71XDv0BLU8C97OR8h+XfJCIXwF9iY5LrJJ7k17wrKFnKjYaHJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793320987;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=sX9C3RLC62dfvt1ktoRTMSaGsY1A1YX+qPzInUxxcTw=;
	b=DJPtwXS8u6a9wEVJoXUhQx24BWaeXJs24g5Dy+XSVydR8DeBvKkPN72F6CWnaHUysEHu
	 kFrY4SivPgSL2wbXd/Y5mLCIoP5wg5oQkwVeOEf59qFoScVt0W5+3nbUoyB7lbpDy9S4f
	 Q35JKprJHvogHbK8+NSMPvGohCBCIlN4vdbmtKJiKkuJN7OYzidbUc1ZRxrH7xhqWYlwk
	 ZWJSrxRQhP4HAIpPvYdL8BL+s/2FzsmwdNZ+EFMKXxbWodH1FZEUJ3NlTeNYFtTUk2ocD
	 arVnsQIfFAcA+cSNZj6Okv+XPXfhdDPvAQ2cngyNXeennZEloXCTJ2dZC0F68xAAg8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=cm1LlqbI;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C640A606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 00:43:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C640A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=cm1LlqbI
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69U0h19d93377703, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793320981; bh=sX9C3RLC62dfvt1ktoRTMSaGsY1A1YX+qPzInUxxcTw=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=cm1LlqbIYYdtYCR5dRmdMvRRv0zccNNTYYISwBzdqB274Ga9EMXvRclQBE0bGlXq1
	 0TA14FykMIcob82YL2TmYa3S/uFt4k9b3i3vqvWFlqqC2iZvLFXkDDdEXO56VDqzXh
	 Zsks6jpJ353RqJeFtAb7QIpsHaOiKo0YmFHPv3uz+1gOasulmEd2ZWBpPMScbS4Q+8
	 zV5z5HAvjwww44Xai9mb9oJD6+Nw0M94/gDcTSOn0Hr0HyTo50kAAetgatG/P7mYM0
	 sd8ctxhsJFSNS6BUi/YT/OZT0kX6AmHFH5jxSPovO6Ls8/YUWtz6CTclOA2dixXn/r
	 BbxTIKIfrMDKQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69U0h19d93377703
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 30 Oct 2026 08:43:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 30 Oct 2026 08:43:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Fri, 30 Oct 2026 08:43:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Topic: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Index: AQHdY0HfQGIda1zW60KKJQiEj21Ec7cQnBmQgAIecQCAAPv2QIAAzeMAgADDelA=
Date: Fri, 30 Oct 2026 00:43:02 +0000
Message-ID: <08b040fc2f7e4311aa7721cf4969896f@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
 <152bc5bf-4e5e-443e-b191-198205ad81bc@gmail.com>
 <f5ec572f354f4c67a2a65b2b1676eae0@realtek.com>
 <ca4921aa-c8aa-4f88-880a-bc717aa103d4@gmail.com>
In-Reply-To: <ca4921aa-c8aa-4f88-880a-bc717aa103d4@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+Pj4+
DQo+ID4+Pj4gICAgSXQgdXNlcyBSWCBkZXNjcmlwdG9yIG51bWJlciA1MTEsIHRoZW4gbnVtYmVy
IDAsIHRoZW4gaXQgZG9lc24ndA0KPiA+Pj4+ICAgIHdhbnQgdG8gdXNlIG51bWJlciAxIGZvciAi
YSB3aGlsZSIuIEl0IHJhaXNlcyBJTVJfUkRVIG9uY2Ugb3IgdHdpY2UsDQo+ID4+Pj4gICAgYW5k
IG9ubHkgdGhlbiBpdCBtb3ZlcyBvbiB0byBudW1iZXIgMSwgMi4uLg0KPiA+Pj4+DQo+ID4+Pj4g
ICAgVXN1YWxseSB3aGVuIGl0IHJhaXNlcyBJTVJfUkRVIHRoZXJlIGFyZSA1MTAgb3IgNTExIFJY
IGRlc2NyaXB0b3JzDQo+ID4+Pj4gICAgYXZhaWxhYmxlIChvdXQgb2YgNTEyKSwgc28gaXQgaGFz
IG5vIGV4Y3VzZS4NCj4gPj4+Pg0KPiA+Pj4+ICAgIE9uY2UgaXQgaGFzIHJhaXNlZCBJTVJfUkRV
IHRoZSBSWCBzcGVlZCBkb2Vzbid0IGV4Y2VlZCA3MC0xMDAgTWJwcw0KPiA+Pj4+ICAgIGFueW1v
cmUuDQo+ID4+Pg0KPiA+Pj4gSWYgZHJpdmVyIGNhbiByZWNlaXZlIHBhY2tldHMgb24gdGltZSwg
aG93IGRvZXMgaXQgcmFpc2UgSVNSX1JEVT8NCj4gPj4NCj4gPj4gSXQncyBhIG15c3RlcnkgZm9y
IG1lLg0KPiA+Pg0KPiA+Pj4gSXMgUlggaW50ZXJydXB0IHRyaWdnZXJlZCBvbiB0aW1lPw0KPiA+
Pj4NCj4gPj4NCj4gPj4gSSdtIG5vdCBzdXJlIGhvdyB0byBjaGVjayB0aGlzLiBJIGFzc3VtZSBp
dCBpcyB0cmlnZ2VyZWQgb24gdGltZSBiZWNhdXNlDQo+ID4+IHRoZSByaW5nIHdhcyBhbHdheXMg
bmVhcmx5IGVtcHR5IHdoZW4gaXQgcmFpc2VkIElNUl9SRFUuDQo+ID4NCj4gPiBJZiBpbnRlcnJ1
cHQgaGFuZGxlciBjYW4gaGFuZGxlIChpZ25vcmUpICJlbXB0eSIgUlggcmluZyAsIGl0IG1pZ2h0
IGJlIGhhcm1sZXNzDQo+ID4gdG8gc2VlIHJhaXNlZCBJTVJfUkRVLCByaWdodD8NCj4gDQo+IEl0
IGlzIGhhcm1sZXNzIGluIHRoZSBzZW5zZSB0aGF0IGV2ZXJ5dGhpbmcga2VlcHMgd29ya2luZywg
anVzdCB0aGUgUlgNCj4gc3BlZWQgaXMgbG93Lg0KDQpIYXZlIHlvdSBkdWcgdGhlIGNhdXNlIFJY
IHNwZWVkIGlzIGxvdz8gVGhlIFBIWSByYXRlIGJlY29tZXMgbG93IGF0IHRoYXQgdGltZT8gDQpP
ciBjYW4gYWlyIGNhcHR1cmUgc2VlIGFueSB3ZWlyZCBwYWNrZXRzPyBPciBkaWQgeW91IHRoaW5r
IFBDSUUgZ2V0IHN0dWNrDQpzb21laG93Pw0KDQoNCg==
