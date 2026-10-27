Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793065934;
	b=oUG3zLJ0DOClAeN7UwzOeg/9/BVLTcJiBz8wWUehjAygUIZvovp+wIPBoqzNmCIkHFR3
	 A843Dm0egTA3VPTHYshjCwfcdMOfyypvs4N92cDb9uIKRcDYkKXn3ihtA30rVrBEutud+
	 3aZA5FQZWeiMRV500IW0cJqBLlGfmNYymYGVpohkqSbx59h0U7JmQRhcAQ7737roH8qj2
	 RXCfvQ9354PlTeKbirTYkIfIheg1pfxRFKQCkt+BPHqt2Glgl7ekgVZ+ZnQ08cs20sPRm
	 JFOVosYPFmjt86iIYpqjvrrga1+77r2vcz1O1kEj9xUCAErPWaSXbDVl//EQIkUuA0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793065934;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=2lZFcgTM1rWeyf128dcmohUL/6Z8m6aBP8pUbL68J5I=;
	b=mUOtCl1BrDUmDo8j0OBKJA8cRQfVD+mvD7YLPu/uBL73bv7lhyRxzyqV5/9QX/vAIjws
	 hr41G/il1xm8pb9KStzOisAZNdr0NzEVevz1Cx2QsyEIeDVjkXAlDmY6GjtP+qJl4ZzJ9
	 /crJpwFSsXxSBq6e03fmoasxeqaZKrZDTdvi7shRzuGjzJDZO/1pQ8vw16FMk3SYmF3Iz
	 WRqdhPp0cKdSw4rIuV1wwwSzrof96IkyTS4sOK9Bgb946aLN2ognMw2vE7nWmPd9/HlIK
	 ICFsYVR3C6gN/bIY7qZ9a7D3KQU9U73XYkYSpxnkGy5b4AGYH+fNxT2pB1Hqd90bTHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=P3YYcg+N;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D48606A321
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 01:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97D48606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=P3YYcg+N
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69R1q9aeD523689, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793065929; bh=2lZFcgTM1rWeyf128dcmohUL/6Z8m6aBP8pUbL68J5I=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=P3YYcg+NALpk0Bc4q6R9hVqZItSh5IEoRby2/whgxGkocLa/pWN6AHisQzr+Id2IW
	 27anVW3kJvXhis5Gd1K0h0EYVBuw91ruYA1lbyOQWwZl8rZm+OGggx69ELTGGD47W1
	 pac3q5roekkfkYbs182HqBVWv9q7O7vQcENzpDMnIW2mlzY6nwSrrC5yGFBm1iKjsv
	 bU16wFUSC91oj+pqIiljQSowg6jamXuyo75J1u4mMg31MnV3GebfMicZGPXWQ2dywR
	 I7HMwhehUxD8b9XbiJaSbLxvA3Q+tWOYin1qJYO3c0keUzuFubt2zJHrCMPf7dE5bT
	 7YNuSiJgiJjAQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69R1q9aeD523689
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 27 Oct 2026 09:52:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 09:52:06 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 27 Oct 2026 09:52:06 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Topic: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Index: AQHdY0HfQGIda1zW60KKJQiEj21Ec7cQnBmQ
Date: Tue, 27 Oct 2026 01:52:06 +0000
Message-ID: <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
In-Reply-To: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBUaGlz
IHNlcmllcyBleHRlbmRzIHJ0dzg4X3BjaSB0byBzdXBwb3J0IGFuIG9sZGVyIGRlc2lnbiwgbGlr
ZQ0KPiBSVEw4ODIxQUUsIFJUTDg4MTJBRSwgUlRMODcyM0JFLCBldGMuDQoNClRoZSBvbGRlciBk
ZXNpZ24gaXMgb3duLWJpdCByaW5nLCBhbmQgdGhlIG5ldyBpcyByZWFkL3dyaXRlIGluZGV4IHJp
bmcNCndpdGggYnVmZmVyIGRlc2NyaXB0b3IuIENhbiB3ZSB1c2UgJ293bi1iaXQnIGluc3RlYWQg
b2YgJ29sZCcgYXMgdGhlIGZpbGUNCm5hbWUgPw0KDQo+IA0KPiBBZnRlciB0aGlzLCBhbm90aGVy
IH4yMCBzbWFsbCBwYXRjaGVzIGNhbiBlbmFibGUgc3VwcG9ydCBmb3IgUlRMODgyMUFFDQo+IGFu
ZCBSVEw4ODEyQUUuDQoNCldpbGwgeW91IHBsYW4gdG8gaW1wbGVtZW50IFJUTDg3MjNCRSAoeW91
IGxpc3RlZCBpdCBhYm92ZSkgaW4gcnR3ODg/DQoNCj4gVGhlbiBydGw4ODIxYWUgY2FuIGJlIGRl
bGV0ZWQgZnJvbSBydGx3aWZpLg0KDQpMdWthIGFza2VkIG1lIHRvIG1lcmdlIEFQIG1vZGUgZm9y
IFJUTDg3MjNCUywgYmVjYXVzZSB0aGUgQVAgbW9kZSBvZiBzdGFnaW5nDQpydGw4NzIzYnMgY2Fu
IHdvcmsgd2VsbC4gSWYgeW91IGRlY2lkZSB0byBkZWxldGUgaXQgZnJvbSBydGx3aWZpLCBwbGVh
c2UNCm1ha2Ugc3VyZSBhbGwgZmVhdHVyZXMgYXJlIGltcGxlbWVudGVkIGJlZm9yZSBkZWxldGlu
Zy4gSG93ZXZlciwgSSBjYW4ndA0Kc2F5IHdoYXQgdGhlIGV4YWN0bHkgYWxsIGZlYXR1cmVzIGFy
ZS4gDQoNClsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC13aXJlbGVzcy9kNmFmNWNl
YmZhMWE0NmUyYmMyZGE2NjI2MzQ3NjZkN0ByZWFsdGVrLmNvbS9ULyNtYWEyYTNlODk3ZDVkNDg4
ZDAyMTkzOTlmOTU1NWQ4OGI5ZWY2NTA0Zg0KDQo+IHJ0dzg4IGlzIG5vdCB3aXRob3V0IHByb2Js
ZW1zLCBidXQgaW4gbXkgZXhwZXJpZW5jZSBpdCdzIG1vcmUgcmVsaWFibGUNCj4gd2l0aCB0aGVz
ZSB0d28gY2hpcHMuIEluIHRoZSA2LTggbW9udGhzIEkgdXNlZCB0aGlzIGNvZGUsIEkgb2JzZXJ2
ZWQNCj4gdGhlc2UgcHJvYmxlbXMgd2l0aCBydHc4ODoNCj4gDQo+ICAqIFRoZSB0b3Agc3BlZWQg
aXMgYSBiaXQgbG93ZXI6IH4yMjAgTWJwcyBpbnN0ZWFkIG9mIH4zMDAgTWJwcy4gSW4gdGhlDQo+
ICAgIGNhc2Ugb2YgVFgsIHRoZSBkaWZmZXJlbmNlIGlzIGR1ZSB0byB0aGUgRURDQSBwYXJhbWV0
ZXJzLiBydHc4OCB1c2VzDQo+ICAgIHRoZSBvbmVzIGZyb20gbWFjODAyMTEgKHJ0d19jb25mX3R4
KCkpLCB3aGVyZWFzIHJ0bHdpZmkgdXNlcyBpdHMgb3duDQo+ICAgICJ0dXJibyIgdmFsdWVzIHdo
ZW4gdGhlcmUgYXJlIG5vdCB0b28gbWFueSBub24tQkUgcGFja2V0cw0KPiAgICAocnRsODgyMWFl
X2RtX2NoZWNrX2VkY2FfdHVyYm8oKSkuIE5vdCBzdXJlIHdoeSB0aGUgUlggc3BlZWQgaXMNCj4g
ICAgbG93ZXIuDQoNCk1heWJlIHlvdSBjYW4gdHJ5IHRvIGNvbXBhcmUgdGhlbSBieSBWTyBvciBW
SSBwYWNrZXRzPw0KDQo+IA0KPiAgKiBSVEw4ODIxQUUgUlggc3BlZWQgZ2V0cyBsaW1pdGVkIHRv
IDcwLTEwMCBNYnBzIHNvbWV0aW1lcy4gSWYgSSB3YXRjaA0KPiAgICBhIFlvdXR1YmUgdmlkZW8g
d2l0aCBCbHVldG9vdGggaGVhZHBob25lcyBmb3IgMTAgbWludXRlcyBhbmQgdGhlbg0KPiAgICBz
d2l0Y2ggdG8gYW5vdGhlciB3aWZpIGFkYXB0ZXIgd2hpbGUgdGhlIHZpZGVvIGlzIHBsYXlpbmcs
IGxlYXZpbmcNCj4gICAgdGhlIFJUTDg4MjFBRSdzIHdpZmkgc2lkZSBpZGxlLCB1c3VhbGx5IHdp
dGhpbiAyMCBtaW51dGVzIGl0IHdpbGwNCj4gICAgc3RhcnQgdG8gcmFpc2UgSU1SX1JEVSB3aGVu
IGl0IHJlYWNoZXMgdGhlIGVuZCBvZiB0aGUgUlggcmluZyBhbmQNCj4gICAgZ29lcyBiYWNrIHRv
IHRoZSBiZWdpbm5pbmcuDQoNCkRvZXMgaXQgc3RpbGwgaGFwcGVuIHdpdGhvdXQgQmx1ZXRvb3Ro
PyBJSVJDIHRoZSBydHc4OCBCVC1jb2V4aXN0ZW5jZSANCm1haW5seSBzdXBwb3J0cyBSVEw4ODIy
QkUgYW5kIFJUTDg4MjJDRS4gSSBiZWxpZXZlIHRoZSBhbGdvcml0aG0gY2FuDQpzaGFyZSB3aXRo
IG90aGVyIGNoaXBzLCBidXQgY29udHJvbCByZWdpc3RlcnMgb3IgYWRkaXRpb25hbCBzZXR0aW5n
cyBtaWdodA0KYmUgbWlzc2luZy4NCg0KPiANCj4gICAgSXQgdXNlcyBSWCBkZXNjcmlwdG9yIG51
bWJlciA1MTEsIHRoZW4gbnVtYmVyIDAsIHRoZW4gaXQgZG9lc24ndA0KPiAgICB3YW50IHRvIHVz
ZSBudW1iZXIgMSBmb3IgImEgd2hpbGUiLiBJdCByYWlzZXMgSU1SX1JEVSBvbmNlIG9yIHR3aWNl
LA0KPiAgICBhbmQgb25seSB0aGVuIGl0IG1vdmVzIG9uIHRvIG51bWJlciAxLCAyLi4uDQo+IA0K
PiAgICBVc3VhbGx5IHdoZW4gaXQgcmFpc2VzIElNUl9SRFUgdGhlcmUgYXJlIDUxMCBvciA1MTEg
UlggZGVzY3JpcHRvcnMNCj4gICAgYXZhaWxhYmxlIChvdXQgb2YgNTEyKSwgc28gaXQgaGFzIG5v
IGV4Y3VzZS4NCj4gDQo+ICAgIE9uY2UgaXQgaGFzIHJhaXNlZCBJTVJfUkRVIHRoZSBSWCBzcGVl
ZCBkb2Vzbid0IGV4Y2VlZCA3MC0xMDAgTWJwcw0KPiAgICBhbnltb3JlLg0KDQpJZiBkcml2ZXIg
Y2FuIHJlY2VpdmUgcGFja2V0cyBvbiB0aW1lLCBob3cgZG9lcyBpdCByYWlzZSBJU1JfUkRVPyAN
CklzIFJYIGludGVycnVwdCB0cmlnZ2VyZWQgb24gdGltZT8NCg0KPiANCj4gICAgUG93ZXJpbmcg
b2ZmIGFuZCBvbiBhZ2Fpbiwgd2hpY2ggaGFwcGVucyBhIGxvdCB3aGVuIHRoZSB3aWZpDQo+ICAg
IGludGVyZmFjZSBpcyBpZGxlLCBkb2Vzbid0IGhlbHAuDQo+IA0KPiAgICBUaGUgb25seSB0aGlu
ZyB0aGF0IHNlZW1zIHRvIGhlbHAgaXMgcmVsb2FkaW5nIHRoZSBkcml2ZXIsIGJ1dCBldmVuDQo+
ICAgIHRoYXQgbWF5IG5vdCBhbHdheXMgd29yay4NCg0KSSB0aGluayByZWxvYWRpbmcgdGhlIGRy
aXZlciBhbmQgaW50ZXJmYWNlIGlkbGUgYXJlIHZlcnkgc2ltaWxhciAoYWxtb3N0DQp0aGUgc2Ft
ZSkuIE5vIGlkZWEgd2h5IHRoZXkgaGF2ZSBkaWZmZXJlbnQgcmVzdWx0cy4gDQoNCj4gDQo+ICAg
IFN3aXRjaGluZyB0byBhbm90aGVyIHdpZmkgYWRhcHRlciB3aGlsZSBwbGF5aW5nIHNvbWUgdmlk
ZW8gaXMgdGhlDQo+ICAgIG1vc3QgcmVsaWFibGUgd2F5IHRvIHRyaWdnZXIgdGhlIHByb2JsZW0s
IGJ1dCBpdCBjYW4gYWxzbyBoYXBwZW4NCj4gICAgcmFuZG9tbHksIGl0IGp1c3QgdGFrZXMgbWFu
eSBob3Vycy4NCg0KVGhhbmtzIGZvciB5b3VyIGVmZm9ydC4gDQoNClBpbmctS2UNCg0K
