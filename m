Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793500591;
	b=cdj1KGJ2iyOUEfDsQrQz/8urMjFiwbIWOp6ibwPUbVZUiN0hcDQ6+ojR3i59PkzZi8PS
	 cJaJ/y9P3aw4GfqvEKIvJzg8TtWtWI4Jvsl6/sfhWBKGuBIq4xLxjVK49MptkUib/3uFQ
	 Lv5QEvma/8/GuBx+bfphfA+29b9UES/dknWs9r9FIemnAYlH4Bu7smU6z928BIw8Y0nvq
	 YWzOZmILsPAJSKkPM5AJwCyMzu2r2Dh/Cc3DsRNHf0SykKViT/EQoy1AK5iIZdJGtZfGs
	 BtSwfyc0c7w9RtjEpI02GDuso4L0mPPw76nv9jU6ZD5EFqy+a6GgRnCCUKyGkTz3uqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793500591;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=8TlgoVnt9clqkMBGYTPiaJirKY0RfQ5Adox/Wz7ti1k=;
	b=VIKEzFyl1StpEDcLTIPK0PwlynRZO201SsxDC1GPrRkMZ9aGsSdIWzkko2OS0klwwUOI
	 rOLMXGfi7Z1GSbHPLbrLOkJmkt5Iu0YrHQhNzpBNYFi9OaAy9yLMWk4diVzTYcbt9GhhE
	 1oT5wqLG31vV4Wxd2NbJgpRML2k+dbbWd1bu7Z6TZ480zYWYML7bczj9941TOYsLw9Dcv
	 I2+FfhgJ8X2n9pz9YemPYoSbf+iiT+lkVCcB82QNGmSjyLv2EAAAFzlom3nLCQ9Js6eXA
	 6KVlsJWZXYgpD7wW5U2Y51oc9eW6UHxvTZu0cwn31k4m1NqVMDlwRyqwupFJE1v+Qgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=htNv2RSw;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5E7606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 02:36:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF5E7606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=htNv2RSw
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A12aOvK5970643, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793500584; bh=8TlgoVnt9clqkMBGYTPiaJirKY0RfQ5Adox/Wz7ti1k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=htNv2RSwM8i/rkirOIsiqHmcNdBaJ/ziSz1xASrdjrNIsfD0rWSN8lcQN40tbNWls
	 YoTfGXYO03qI6d+84nMSxyY0v8qsdmkAsTLKOeqh3poUx3QEIo3kgVnOvkYjfF/qc/
	 dqOgtjGRO/o6HNJpfXEhpS7+Hc/Q+uwZs7rjAW//zUwHQNmlnLpPgSJ1ViPObdNSA1
	 Q3AafUsI+3kD+fxHB2SlHYc23ePKBzhsS19JVwMJzNcLj6d119fP/JTarcXrNoj3Rw
	 TISWjW6BYoTikdUw1f4g78dmqnOAX8TIArjjw4JwbrpS34JMq4r48CrllLgCtZ/RgH
	 Kj8nqtq2MDRNg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A12aOvK5970643
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 1 Nov 2026 10:36:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sun, 1 Nov 2026 10:36:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Sun, 1 Nov 2026 10:36:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "V. S." <spam@acio.nl>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw89: do BIP in software when not in
 station mode
Thread-Topic: [PATCH rtw-next] wifi: rtw89: do BIP in software when not in
 station mode
Thread-Index: AQHdYJs1nqEC/6moOkOYSlDC5jn4+LcTzu+wgAIssgCAApQD4A==
Date: Sun, 1 Nov 2026 02:36:24 +0000
Message-ID: <7a673decd1f6461b8f0149b98623b5cb@realtek.com>
References: <20261020130019.137170-1-spam@acio.nl>
 <1ca81a8669be41a6924ad0c5e042fcdc@realtek.com>
 <CAJKtVVb8XedNH4Dcfbe2--CdtWM45JYWVA=2arTEW37Er-e8NA@mail.gmail.com>
In-Reply-To: <CAJKtVVb8XedNH4Dcfbe2--CdtWM45JYWVA=2arTEW37Er-e8NA@mail.gmail.com>
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

Vi4gUy4gPHNwYW1AYWNpby5ubD4gd3JvdGU6IA0KPiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFs
dGVrLmNvbT4gd3JvdGU6DQo+IA0KPiBUZXN0ZWQtYnk6IFYgc2NodXJpbmsgPHNwYW1AYWNpby5u
bD4NCg0KQ291bGQgeW91IHByb3ZpZGUgeW91ciBmdWxsIG5hbWU/IEknZCBDYyAod2l0aCBDYyBv
ciBSZXBvcnRlZC1ieSB0YWcpIHlvdSBpbg0KbXkgZm9ybWF0IHBhdGNoLiBNYXliZSBhbHNvIGlu
Y2x1ZGUgdGhlIGdpdGh1YiBsaW5rOg0KDQpodHRwczovL2dpdGh1Yi5jb20vbW9ycm93bnIvcnR3
ODkvcHVsbC8xMzUNCg0KPiANCj4gT25lIG5vdGU6IG1hYzgwMjExIGluY3JlbWVudHMga2V5LT50
eF9wbiB3aGVuIGl0IHdyaXRlcyB0aGUgSVBOIGludG8NCj4gdGhlIE1NSUUsIGFuZCBydHc4OV9j
b3JlX3R4X3VwZGF0ZV9zZWNfa2V5KCkgaW5jcmVtZW50cyBpdCBhZ2FpbiBmb3INCj4gc2VjX3Nl
cS4gVGh1cywgdGhlIFBOIGluY3JlYXNlcyBieSAyIGZvciBlYWNoIGZyYW1lLiBUaGlzIGRpZCBu
b3QNCj4gY2F1c2UgYSBwcm9ibGVtIGluIG15IHRlc3QuIEkgZG8gbm90IGtub3cgd2hpY2ggdmFs
dWUgdGhlIGhhcmR3YXJlDQo+IHVzZXMgZm9yIHRoZSBNSUMuDQoNCkFzIGNvbW1pdCA3OWE2Yzlh
NGYzYzQgKCJydHc4OTogc3VwcG9ydCBoYXJkd2FyZSBnZW5lcmF0ZSBzZWN1cml0eSBoZWFkZXIi
KSwNCndoaWNoIGludHJvZHVjZXMgY2hpcC0+aHdfc2VjX2hkciBmb3IgbmV3ZXIgY2hpcHMgc3Vw
cG9ydGluZyBoYXJkd2FyZQ0Kc2VjdXJpdHkgaGVhZGVyLCB0aGUga2V5IGZsYWcgSUVFRTgwMjEx
X0tFWV9GTEFHX0dFTkVSQVRFX0lWIGlzIHVuc2V0LCBzbw0KZHJpdmVyIGluY3JlYXNlcyB0aGUg
UE4uDQoNCkkgcGxhbiB0byBjaGVjayB0aGUga2V5IGZsYWcgdG8gZGVjaWRlIGlmIGl0IGlzIG5l
Y2Vzc2FyeSB0byBpbmNyZWFzZSBQTi4NCg0KUGluZy1LZQ0KDQo=
