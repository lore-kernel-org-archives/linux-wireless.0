Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792896577;
	b=cEn8G5ni53zeRxTkiIDj6IxrYoK6/cf4W+uk1gK2xyPlphIeR9RZE9FqKNvYnfaNGRe0
	 azC3w7tcbsjfzQ5J19ve/T2ZcrszVIQLiV56KOhQ5noic1RNwHLw90FzZeARknzz+aXka
	 xT5CUgIiQXuph+5Dkj7JTE0igk48JnK4zyeRhk5eGS+/4jV8A2LKTcK+miOM8MiwdTYri
	 gCA4Ie8InWrd71PYrjxfBWYE7/Y7L86R+AgY1lEGdgbIFd/CVjJGYGrPIAkMuQWDrCKXI
	 fiIrhaKfwfENFkqlKpiZGIRYz8l0onIRJV0ddahNz1JIErj3SLpZc035/Np3iigdt8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792896577;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=HC76HxefKhWHAcoZqjxRhtpRvmhkbgehQUtWy/qplWw=;
	b=dygSOv8iaN2kY8etu0SSBetGomNQK9XdgWRvW2XgxeLuaNcadTqkIkaETfkRnSebuTCR
	 zCp8eztqPFzm5VtLIq5U3vCsykpTJktUM5tL0thPz61BDrQyQq5C0WU4KURNKwDHlIIOa
	 bwB4ydLh1IaswF1W+TZauB77eXtDkDqnvUG7By+abg4f8TTL31WELRPzPPA1vqxavTBfX
	 kI3F6CLPeclaBu4awBeXyltSUesdAtZStnioUPj9VeVxWGRlECFREYISpsPKjOY10J9sM
	 rsMFYDfJvufFa6QVUE/JuW0WVyDfZX9KqAsJzOWYMhZ0fIANv+UyjwIBnefmSQmGYBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=MBLjgdRX;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64B8606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 02:49:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C64B8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=MBLjgdRX
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69P2nQCP13145906, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792896566; bh=HC76HxefKhWHAcoZqjxRhtpRvmhkbgehQUtWy/qplWw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=MBLjgdRXY9V1vuTHMmv1OuET/wxWLEgI9lcO9GAxXRvKRbGzlo1PER2oBc3/Li5cK
	 131MsGgk/GYGWpXuN2Vl1ecnHhGhgV7KhnuRhRq5gP3nPrc6hzjqGpst294RU2SvmF
	 2szTgSLQxn0HnIDnklFHfooTUxW8L7DyS1mwrbde+nf3rCmC4MyvUOsSlu1o0XtUob
	 XwIth2gbXxU+BPKNUnUxx1+Gi2AT+8ZBiCQso8z8qf7ASolfNTus8lqyBDGhXkLDcV
	 p+0wWhn7R2jcPGAtxm6gx6DoudLf+aUnMah0sK3Ju/SXDFKBMkN1nssBlJFj4cuuuz
	 Nqk3tMaIJCgiw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69P2nQCP13145906
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 25 Oct 2026 10:49:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 25 Oct 2026 10:49:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 25 Oct 2026 10:49:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 25 Oct 2026 10:49:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
Thread-Topic: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
Thread-Index: AQHdYVnJ0q7282zST0eZU32CdZ8tpbcI07VQ//+rD4CAAqT/gIACboDg
Date: Sun, 25 Oct 2026 02:49:26 +0000
Message-ID: <ec4065a1cf2c4d0ea357694a1a73ede8@realtek.com>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
 <ac6d8824bdeb45148ffd6b5dee7da313@realtek.com>
 <5235fd68b703f756cc2ee1e7471339a512db59b8@linux.dev>
 <875b4e96891a2bf256ca1805140b57aeccee4aed@linux.dev>
In-Reply-To: <875b4e96891a2bf256ca1805140b57aeccee4aed@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBJIHdhcyB0aGlua2lu
ZywgYXMgc3RhZ2luZyBnb3QgcmVtb3ZlZCwgZm9yIDEwLWlzaCB3ZWVrcyh1bnRpbCA3LjUpDQo+
IHVzZXJzIG9mIFJUTDg3MjNCUyB3b24ndCBoYXZlIEFQIG1vZGUuIFNvIEkgd2FzIHdvbmRlcmlu
ZyBpZiB0aGVzZSB0d28NCj4gcGF0Y2hlcyBjb3VsZCBwYXNzIGFzIGZpeGVzIGludG8gcmMyIHJl
bGVhc2Uob3Igd2hhdGV2ZXIgaXMgdGhlIGZpcnN0DQo+IHJjIGludG8gd2hpY2ggcnR3IHRyZWUg
aXMgbWVyZ2VkKSwgYXMgdGhpcyB3b3VsZCBiZSBESENQIHN0YWxsIGZpeC4gVG8NCj4gZWxhYm9y
YXRlOiB3aGVuIHRoaXMgZHJpdmVyIHdhcyBtZXJnZWQgaXQsIHdhcyBleHBvc2luZ0FQIG1vZGUg
dG8NCj4gdXNlcnNwYWNlLCBkdWUgdG8gUlRXODggZG9pbmcgaXQgZ2xvYmFsbHkuIFRoZXJlZm9y
ZSBBUCBtb2RlIGV4aXN0ZWQsDQo+IGJ1dCB3YXNuJ3Qgd29ya2luZyBwcm9wZXJseS4gU28gbWF5
YmUgaXQncyBhIGJpdCBvZiBhIHN0cmV0Y2gsIGJ1dCBJDQo+IHRoaW5rIGl0J3MgYSB2YWxpZCBw
cm9wb3NhbCB0byBzZW5kIGl0IGFzIGEgZml4IGludG8gbmV4dCByYyByZWxlYXNlLg0KDQpEaWQg
eW91IHRoaW5rIHBlb3BsZSB1c2Ugc3RhZ2luZyBkcml2ZXIgd2l0aCBBUCBtb2RlPyANCg0KUGVy
c29uYWxseSwgSSB3YW50IHRoaXMgZ29lcyB0byBydHctbmV4dCwgYnV0IGlmIHlvdSBoYXZlIHN0
cm9uZyBvcGluaW9uDQp0aGF0IHBlb3BsZSBuZWVkIHRoaXMuIEkgY2FuIHBpY2sgdGhlbSBhbmQg
bGV0IGl0IGdvZXMgdG8gLXJjLiANCg0KUGluZy1LZQ0KDQo=
