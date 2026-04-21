Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32CC5C613
	for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2026 01:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776735507; cv=none; b=AxWfXzfGSL04v2i22rfoiC57fmKRslS8Erk5j/xUSU/hrxq2xSCJ7+9qLcd4JeRduU8D646VkUo8AHpQHBSHslK5UN4Q7zxROVkV/rT+96surb+BcqBITvmWBg655M6ixxuntFj4n7a8N0ZyNM72YJas8EXn2o7r/cjfGGj58JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776735507; c=relaxed/simple;
	bh=y6ozPoh+NRINjYKVv9q+p05lS0mopKFh5enoeddi+tQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZyB4kadRdx5T6f+hqZ2J8oDKDV1H14fqxg56lObt9a8bR7GV8cMitIHrVqRpziTjaycvqF1S+FnEpYZIG2iYUgUp45w9Fr5e8IxZvibkQtk93XNeHa9M4UGEmuPHSSGpLz82VXYFBIy2IqH6M+amC7e5HzAG0XHkUc36Z37+sl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=YAUqhtkO; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="YAUqhtkO"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63L1c90H12182004, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776735489; bh=y6ozPoh+NRINjYKVv9q+p05lS0mopKFh5enoeddi+tQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=YAUqhtkOEBO2SWAxSxLSfxZUOZ7OfEu/vyymrxeH6ol+9RSlk3uwcQAfnHpmbPcWE
	 xu5JxvGLCowna3ZTd/c71MXfSa6tvvnL5uheHyXJ3Czfxuh2fsJTIlTnTcpiuZH3Fb
	 A6km4+Gv3/PNH+9ynD5LBTGtzu4cHgq8E4Y44EjuXwKy6rFyb2YlwS06NJA63netaQ
	 GpiRiQ19sUxb7AwUyJdunHQT8hxR6a8245Y2sWGqpPYzSUwKLPujEI9OTzy7sC8RRp
	 Au/8pGPeDYmYV7FUTNgASox29IbikLrSpOk4p+GQ/ckpBeuaSJmTc9oKz9YomZSTeo
	 WS87jQA9z7CvA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63L1c90H12182004
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 09:38:09 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 21 Apr 2026 09:38:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 21 Apr 2026 09:38:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458%10]) with mapi id
 15.02.1748.010; Tue, 21 Apr 2026 09:38:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Tristan Madani
	<tristmd@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtw88: fix OOB read from firmware RX descriptor
 exceeding DMA buffer
Thread-Topic: [PATCH v2] wifi: rtw88: fix OOB read from firmware RX descriptor
 exceeding DMA buffer
Thread-Index: AQHczSaqhBvUmo6aWEamddJNumcqzLXi2VmAgASYQWCAAJZpAIAAt0lA
Date: Tue, 21 Apr 2026 01:38:06 +0000
Message-ID: <1fdd2ad66029409eb719ae984959fbad@realtek.com>
References: <20260415222440.1545959-1-tristmd@gmail.com>
 <090b3c83-e3d5-4c8d-bd46-aaff692de529@gmail.com>
 <e4f18297feda4056bb461b6b2516b27c@realtek.com>
 <a5aaf34f-d2ec-40ef-a176-9a921dcf435e@gmail.com>
In-Reply-To: <a5aaf34f-d2ec-40ef-a176-9a921dcf435e@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBPbiAy
MC8wNC8yMDI2IDA4OjMxLCBQaW5nLUtlIFNoaWggd3JvdGU6DQo+ID4gQml0dGVyYmx1ZSBTbWl0
aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+Pg0KPiA+PiBXZWxsLCBraW5k
IG9mLiBNYXliZSBSVEtfUENJX1JYX0JVRl9TSVpFIGlzIHRvbyBzbWFsbD8gMTE0NTQgKyAyNA0K
PiA+PiBkb2Vzbid0IHRha2UgaW50byBhY2NvdW50IHRoZSBQSFkgaW5mbyBzaXplLg0KPiA+DQo+
ID4gSW4gcnR3X3BjaV9zeW5jX3J4X2Rlc2NfZGV2aWNlKCksIGRyaXZlciBkb2VzDQo+ID4gICAg
IGJ1Zl9kZXNjLT5idWZfc2l6ZSA9IGNwdV90b19sZTE2KFJUS19QQ0lfUlhfQlVGX1NJWkUpOw0K
PiA+DQo+ID4gVGhpcyBpcyB0byB0ZWxsIGhhcmR3YXJlIHRoZSBzaXplIG9mIFJYIERNQSBidWZm
ZXIuIEkgdGhpbmsgaGFyZHdhcmUNCj4gPiBjYW4ndCBETUEgZGF0YSBvdmVyIHRoaXMgc2l6ZS4N
Cj4gPg0KPiANCj4gSW5kZWVkLCBJIGRvbid0IHRoaW5rIHRoZSBoYXJkd2FyZSB3aWxsIHdyaXRl
IG1vcmUgdGhhbg0KPiBSVEtfUENJX1JYX0JVRl9TSVpFIGJ5dGVzLiBCdXQgSSB3b25kZXIgaWYg
c29tZSBieXRlcyB3b24ndCBiZSBsb3N0DQo+IChvciB0aGUgZW50aXJlIHBhY2tldD8pIGlmIGl0
IGV2ZXIgcmVjZWl2ZXMgYSBmcmFtZSBvZiAxMTQ1NCBieXRlcw0KPiBhbmQgd2FudHMgdG8gYXR0
YWNoIGEgUEhZIHN0YXR1cz8gVGhlbiBpdCB3b3VsZCBuZWVkIGEgYnVmZmVyIG9mDQo+IDExNDU0
ICsgMjQgKyAzMiBieXRlcy4gSSBkb24ndCBrbm93IGlmIHRoaXMgZXZlciBoYXBwZW5zLg0KDQpJ
IHRoaW5rIHRoZSB0b3RhbCBzaXplIGluY2x1ZGluZyBQSFkgc3RhdHVzIG11c3QgYmUgc21hbGxl
ciB0aGFuDQpSVEtfUENJX1JYX0JVRl9TSVpFLCBvdGhlcndpc2Ugd2Ugc2hvdWxkIGVubGFyZ2Ug
UlRLX1BDSV9SWF9CVUZfU0laRS4NCg0KVGhlIHJ0dzg5IGNhbiBzcGxpdCBhIHBhY2tldCBpbnRv
IG11bHRpcGxlIHNlZ21lbnRzIGlmIFJYIGJ1ZmZlciBpcyANCnNtYWxsZXIgdGhhbiBhIHJlY2Vp
dmluZyBwYWNrZXQsIGJ1dCBpdCBoYXMgZXhhY3Qgb3ZlcmxvYWQsIHNvIHdlDQplbmxhcmdlIHRo
ZSBidWZmZXIgYXMgbGFyZ2UgYXMgbmVjZXNzYXJ5LiANCg0KRm9yIHJ0dzg4LCBJIGNhbid0IGZp
bmQgc2ltaWxhciBpbXBsZW1lbnRhdGlvbi4gTWF5YmUgd2UgY2FuIHRyeSB0bw0KZW5sYXJnZSB0
aGUgc2l6ZSB0byBzZWUgaWYgYW55IGltcHJvdmVtZW50LiANCg0KUGluZy1LZQ0KDQo=
