Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793235078;
	b=BmDcNHRkXetzcln5bYU0KCJ3nj34VVVV10w84MkkKvG4UWAzvfOnEG2NYrq0oUc3xpJ7
	 BJdHiexPOuuRNx8GowGCJ7DZgjFC++fhVAd6rIibFAK41mdl/bNNALySPWHM6LUcOxTMl
	 nwO9VJBrMjN6JnQhEHpJ0ODWaPJp8T1E2CWlMYBm6BUbULQQ+yKFmRtxAbgwe0ugsqILu
	 KdCyYfIPBF1fpOb4nYxkEVPF/xlNUAvNTiOKjSmSBnixAY+/YSHfnmijtwvmWcRpmR9y8
	 +w9pbdS4X+gx+nNdgG8lbfdyayL/aiE6TSs3aNqJ8gUx6wgAD+feS1d78nYduRo8BRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793235078;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=54YIbZzkMIviaN6dsvNhhtwC2L2Ij3IE1LR9Qbzz+Ps=;
	b=SyJWJP7yhIVYMY0yMJZ/m1zFg+nobLOnyGga0AjPDXduKF8dZOenWQuYBo8Aj44VTYW6
	 yrQ3/ucw1rQXqD951P7kZnsC03M0nMOVZE5aNUTAanyTevyMOvXsKBEDkWBBKbdaBmoZs
	 mJi0xbqJ5p4PTS7tXforqpTPuWEhOBAMTGVrLL+s0RbrZi+fcGexX0QkNDZRhInA4124U
	 /bTP6ZUBDQVXgbAmcCKL4HA6TfC5ET7vzAIxUFReB1qXCckrFgrU2wx+vt70qFuaQQXtz
	 LVw/r1Eoe2TjMiiqxf1GxEDB18tSncyLDzKrSL7QwbMkr/TAJwLgC0vkUhzuzoOZXLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=QB2FB1hU;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5CF606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 00:51:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C5CF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=QB2FB1hU
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69T0pCRA12383385, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793235072; bh=54YIbZzkMIviaN6dsvNhhtwC2L2Ij3IE1LR9Qbzz+Ps=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=QB2FB1hUmDgiWwtUU3B8WahfSgwCmPNNxitFtsnpOVj9+C7AxWmPe/gakgehB2P9H
	 GS3dcOudrQZwpAEKP4BlBSu268eQnwpck1+hKxPLmrXz3cZSDFuulwb4jAfVeGn7Jg
	 Nm2gBxSRAnNZL39Yxq9NHetkMI/p+XKYoNmI6qGYuTz9eegYBaJ5pSdtj1eRNC53xL
	 IRO+dB/0iIIsuPDStRHXt5YZyU5m1uIpzjA9wufgNCGG25heFJMj9D7BgZIen/MyqD
	 HOLR1VOIf5k9C0MvkPcg5GZcTfCHJStEg3m7qGiNWnJtM37gOU1/q/vktXJHZbyrey
	 FfUaJz3Mpky2g==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69T0pCRA12383385
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 29 Oct 2026 08:51:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 29 Oct 2026 08:51:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Thu, 29 Oct 2026 08:51:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Topic: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Index: AQHdY0HfQGIda1zW60KKJQiEj21Ec7cQnBmQgAIecQCAAPv2QA==
Date: Thu, 29 Oct 2026 00:51:12 +0000
Message-ID: <f5ec572f354f4c67a2a65b2b1676eae0@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
 <152bc5bf-4e5e-443e-b191-198205ad81bc@gmail.com>
In-Reply-To: <152bc5bf-4e5e-443e-b191-198205ad81bc@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBPbiAy
Ny8xMC8yMDI2IDAzOjUyLCBQaW5nLUtlIFNoaWggd3JvdGU6DQo+ID4gQml0dGVyYmx1ZSBTbWl0
aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+PiBUaGlzIHNlcmllcyBleHRl
bmRzIHJ0dzg4X3BjaSB0byBzdXBwb3J0IGFuIG9sZGVyIGRlc2lnbiwgbGlrZQ0KPiA+PiBSVEw4
ODIxQUUsIFJUTDg4MTJBRSwgUlRMODcyM0JFLCBldGMuDQo+ID4NCj4gPiBUaGUgb2xkZXIgZGVz
aWduIGlzIG93bi1iaXQgcmluZywgYW5kIHRoZSBuZXcgaXMgcmVhZC93cml0ZSBpbmRleCByaW5n
DQo+ID4gd2l0aCBidWZmZXIgZGVzY3JpcHRvci4gQ2FuIHdlIHVzZSAnb3duLWJpdCcgaW5zdGVh
ZCBvZiAnb2xkJyBhcyB0aGUgZmlsZQ0KPiA+IG5hbWUgPw0KPiA+DQo+IA0KPiBTdXJlLCB0aGUg
ZmlsZSBuYW1lIGlzIG5vdCBhIHByb2JsZW0uIFdoYXQgYWJvdXQgdGhlIGNvZGU/IEFsbCB0aGUg
ZnVuY3Rpb25zDQo+IGluIHBjaV9vbGQuYyBhcmUgcHJlZml4ZWQgd2l0aCAicnR3X3BjaV9vbGQi
LCBhbmQgdGhlcmUgaXMgcnR3X3BjaV9nZW5fb2xkDQo+IGFuZCBydHdfcGNpX2dlbl9uZXcuIFNo
b3VsZCBJIHJlbmFtZSBhbGwgb2YgdGhlc2U/DQoNCkknZCBwcmVmZXIgaGF2aW5nIGNvbnNpc3Rl
bnQgc3VmZml4IGFzIGZpbGUgbmFtZSwgYnV0IEkgaGF2ZSBubyBnb29kIGlkZWENCmZvciB0aGUg
c3VmZml4LiBNYXliZSwgJ19vYicgbWVhbnMgJ293bi1iaXQgcmluZyc/DQoNCj4gPj4gcnR3ODgg
aXMgbm90IHdpdGhvdXQgcHJvYmxlbXMsIGJ1dCBpbiBteSBleHBlcmllbmNlIGl0J3MgbW9yZSBy
ZWxpYWJsZQ0KPiA+PiB3aXRoIHRoZXNlIHR3byBjaGlwcy4gSW4gdGhlIDYtOCBtb250aHMgSSB1
c2VkIHRoaXMgY29kZSwgSSBvYnNlcnZlZA0KPiA+PiB0aGVzZSBwcm9ibGVtcyB3aXRoIHJ0dzg4
Og0KPiA+Pg0KPiA+PiAgKiBUaGUgdG9wIHNwZWVkIGlzIGEgYml0IGxvd2VyOiB+MjIwIE1icHMg
aW5zdGVhZCBvZiB+MzAwIE1icHMuIEluIHRoZQ0KPiA+PiAgICBjYXNlIG9mIFRYLCB0aGUgZGlm
ZmVyZW5jZSBpcyBkdWUgdG8gdGhlIEVEQ0EgcGFyYW1ldGVycy4gcnR3ODggdXNlcw0KPiA+PiAg
ICB0aGUgb25lcyBmcm9tIG1hYzgwMjExIChydHdfY29uZl90eCgpKSwgd2hlcmVhcyBydGx3aWZp
IHVzZXMgaXRzIG93bg0KPiA+PiAgICAidHVyYm8iIHZhbHVlcyB3aGVuIHRoZXJlIGFyZSBub3Qg
dG9vIG1hbnkgbm9uLUJFIHBhY2tldHMNCj4gPj4gICAgKHJ0bDg4MjFhZV9kbV9jaGVja19lZGNh
X3R1cmJvKCkpLiBOb3Qgc3VyZSB3aHkgdGhlIFJYIHNwZWVkIGlzDQo+ID4+ICAgIGxvd2VyLg0K
PiA+DQo+ID4gTWF5YmUgeW91IGNhbiB0cnkgdG8gY29tcGFyZSB0aGVtIGJ5IFZPIG9yIFZJIHBh
Y2tldHM/DQo+ID4NCj4gDQo+IERvIHlvdSBtZWFuIGZvciB0aGUgVFggc3BlZWQgY29tcGFyaXNv
bj8NCg0KWWVzLg0KDQo+ID4+DQo+ID4+ICAgIEl0IHVzZXMgUlggZGVzY3JpcHRvciBudW1iZXIg
NTExLCB0aGVuIG51bWJlciAwLCB0aGVuIGl0IGRvZXNuJ3QNCj4gPj4gICAgd2FudCB0byB1c2Ug
bnVtYmVyIDEgZm9yICJhIHdoaWxlIi4gSXQgcmFpc2VzIElNUl9SRFUgb25jZSBvciB0d2ljZSwN
Cj4gPj4gICAgYW5kIG9ubHkgdGhlbiBpdCBtb3ZlcyBvbiB0byBudW1iZXIgMSwgMi4uLg0KPiA+
Pg0KPiA+PiAgICBVc3VhbGx5IHdoZW4gaXQgcmFpc2VzIElNUl9SRFUgdGhlcmUgYXJlIDUxMCBv
ciA1MTEgUlggZGVzY3JpcHRvcnMNCj4gPj4gICAgYXZhaWxhYmxlIChvdXQgb2YgNTEyKSwgc28g
aXQgaGFzIG5vIGV4Y3VzZS4NCj4gPj4NCj4gPj4gICAgT25jZSBpdCBoYXMgcmFpc2VkIElNUl9S
RFUgdGhlIFJYIHNwZWVkIGRvZXNuJ3QgZXhjZWVkIDcwLTEwMCBNYnBzDQo+ID4+ICAgIGFueW1v
cmUuDQo+ID4NCj4gPiBJZiBkcml2ZXIgY2FuIHJlY2VpdmUgcGFja2V0cyBvbiB0aW1lLCBob3cg
ZG9lcyBpdCByYWlzZSBJU1JfUkRVPw0KPiANCj4gSXQncyBhIG15c3RlcnkgZm9yIG1lLg0KPiAN
Cj4gPiBJcyBSWCBpbnRlcnJ1cHQgdHJpZ2dlcmVkIG9uIHRpbWU/DQo+ID4NCj4gDQo+IEknbSBu
b3Qgc3VyZSBob3cgdG8gY2hlY2sgdGhpcy4gSSBhc3N1bWUgaXQgaXMgdHJpZ2dlcmVkIG9uIHRp
bWUgYmVjYXVzZQ0KPiB0aGUgcmluZyB3YXMgYWx3YXlzIG5lYXJseSBlbXB0eSB3aGVuIGl0IHJh
aXNlZCBJTVJfUkRVLg0KDQpJZiBpbnRlcnJ1cHQgaGFuZGxlciBjYW4gaGFuZGxlIChpZ25vcmUp
ICJlbXB0eSIgUlggcmluZyAsIGl0IG1pZ2h0IGJlIGhhcm1sZXNzDQp0byBzZWUgcmFpc2VkIElN
Ul9SRFUsIHJpZ2h0Pw0KDQoNCg==
