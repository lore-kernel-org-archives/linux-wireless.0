Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6A33016E7
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 02:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785723400; cv=none; b=EowDc+ChbcGQeEQn818TnA1UG+QiiHc2x7KfepNWyDuWzOTd1QD15Ho8BaBthZ8mn1eXW9fluphb8OeraT9XxFFuyWqDktmYK2Qwp6lMCkJyt7bC8NfRSO4uMWdMY1FpSqwDz4LiyZPaFG6yOqQ2YgdBmBstFpkwGTt1j+VrtrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785723400; c=relaxed/simple;
	bh=QQ5dDfw5r0JH9CKubLUvKaPXpFZBevFLmoG+f69cJrE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eF1m1c60Uo5FrNMgclk+ga4jXq0G9tonG1XU7HE17kkBf8NXyEgtX3J3nMolZDNCrUzEel86pBtk4cWggyMPpHTysdKDierICiExDo2cK9IxMzEax5MKDUdqBKvOVf8QAVgQJCrVe9gr/Obal7dIs9BCL2M7gtuiuGG184XSdmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=FOCktAIq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="FOCktAIq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6732GXEl83813905, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785723393; bh=QQ5dDfw5r0JH9CKubLUvKaPXpFZBevFLmoG+f69cJrE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=FOCktAIqFYG4Xp0j8q4uNe1Cy6V+K/3o7UXdB4TyfOvDcoKd61sUvMxblGk0gJQhs
	 xyMOhchcG3+yCNI4xdoCDsESpZRGuG2wQ7sNN5laDgtviJ3uT4Chz1pq6ixYE43qS+
	 xEgZjGDQzp1hCUGXl5qKZtVIJ4SfDwuX99QCtJt2ArSUQgKazKoh5bdEI0QgUyZuvt
	 39+YUJi8C3NvqpLIu3JA0DCQp+FybpuZAraO+r6LCf/hhjxKP3t9InMmp1hFpVg+KY
	 I/a6bc4r02NYtlDW9+DEiGXx0zV8M918u0eXsuQtccIIK0Xj1hEJ+oMkCtih3XQBRe
	 Ccapgmw0dXJfg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6732GXEl83813905
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 3 Aug 2026 10:16:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 3 Aug 2026 10:16:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 3 Aug 2026 10:16:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Rohit Mahesh <rm4336@columbia.edu>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [BUG] wifi: rtw89: RTL8852BE firmware fails to leave LPS and
 recovery times out
Thread-Topic: [BUG] wifi: rtw89: RTL8852BE firmware fails to leave LPS and
 recovery times out
Thread-Index: AQHdIQR1qVVsOjTKCkerRIzw06kG9LaLltJA
Date: Mon, 3 Aug 2026 02:16:33 +0000
Message-ID: <6a2bc2412ed74af7ae1f41154542a281@realtek.com>
References: <CADTd5_O89StWx0O=PkxpQN3z+hUTHb2KkUd=AGOiyXZa=cdR=w@mail.gmail.com>
In-Reply-To: <CADTd5_O89StWx0O=PkxpQN3z+hUTHb2KkUd=AGOiyXZa=cdR=w@mail.gmail.com>
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

Um9oaXQgTWFoZXNoIDxybTQzMzZAY29sdW1iaWEuZWR1PiAgd3JvdGU6DQo+IEkgYW0gc2VlaW5n
IGEgcmVjdXJyaW5nIGZhaWx1cmUgd2l0aCB0aGUgUlRMODg1MkJFIHdoaWxlIGxlYXZpbmcgbG93
LXBvd2VyDQo+IHN0YXRlLiBJdCBoYXMgb2NjdXJyZWQgKGF0IGxlYXN0KSB0d2ljZSB3aXRoIHRo
ZSBzYW1lIHNpZ25hdHVyZS4gVGhlDQo8IGF1dG9tYXRpYyBoYXJkd2FyZSByZXN0YXJ0IGZhaWxz
LCBhZnRlciB3aGljaCB3bGFuMCBjYW5ub3QgYmUgYnJvdWdodA0KPiBiYWNrIHVwOyByZWJvb3Rp
bmcgb3IgcG93ZXJpbmcgb2ZmIHJlc3RvcmVzIG5vcm1hbCBvcGVyYXRpb24uDQo+IA0KPiBIYXJk
d2FyZToNCj4gDQo+IExhcHRvcDogTGVub3ZvIElkZWFQYWQgU2xpbSAzIDE1QUJSOCAoODJYTSkN
Cj4gTWFpbmJvYXJkOiBMTlZOQjE2MTIxNg0KPiBCSU9TOiBLWUNOMzFXVywgMjAyNC0wMy0xOA0K
PiANCj4gMDI6MDAuMCBOZXR3b3JrIGNvbnRyb2xsZXIgWzAyODBdOg0KPiBSZWFsdGVrIFJUTDg4
NTJCRSBQQ0llIDgwMi4xMWF4IFsxMGVjXQ0KPiBTdWJzeXN0ZW06IExlbm92byBbMTdhYTo0ODUz
XQ0KPiBEcml2ZXI6IHJ0dzg5Xzg4NTJiZQ0KPiANCj4gU29mdHdhcmU6DQo+IA0KPiBEaXN0cmli
dXRpb246IEFydGl4IExpbnV4DQo+IEtlcm5lbDogNy4xLjQtYXJ0aXgxLTENCj4gbGludXgtZmly
bXdhcmUtcmVhbHRlazogMjAyNjA2MjItMQ0KPiBGaXJtd2FyZSBmaWxlOiBydHc4OS9ydHc4ODUy
Yl9mdy0yLmJpbg0KPiBGaXJtd2FyZSB2ZXJzaW9uOiAwLjI5LjI5LjE4DQo+IA0KPiBQb3dlci1z
YXZpbmcgb3B0aW9ucyBhcmUgYXQgdGhlaXIgZGVmYXVsdHM6DQo+IA0KPiBydHc4OV9jb3JlLmRp
c2FibGVfcHNfbW9kZT1ODQo+IHJ0dzg5X3BjaS5kaXNhYmxlX2FzcG1fbDE9Tg0KPiBydHc4OV9w
Y2kuZGlzYWJsZV9hc3BtX2wxc3M9Tg0KPiBydHc4OV9wY2kuZGlzYWJsZV9jbGtyZXE9Tg0KDQpU
cnkgdG8gc2V0IHRoZXNlIHRvIFkgdG8gc2VlIGlmIGhlbHAuDQoNCj4gDQo+IFRoZSBpbmNpZGVu
dHMgb2NjdXJyZWQgb246DQo+IA0KPiAyMDI2LTA3LTMwIDE3OjU3OjMwIEFtZXJpY2EvRGV0cm9p
dA0KPiAyMDI2LTA3LTMxIDExOjI5OjE3IEFtZXJpY2EvRGV0cm9pdA0KPiANCj4gQm90aCBzdGFy
dGVkIHdpdGg6DQo+IA0KPiBydHc4OV84ODUyYmUgMDAwMDowMjowMC4wOiBmYWlsZWQgdG8gcHJl
LXJlbGVhc2UgZndjbWQNCj4gcnR3ODlfODg1MmJlIDAwMDA6MDI6MDAuMDogZmlybXdhcmUgZmFp
bGVkIHRvIGFjayBmb3IgbGVhdmluZyBwcyBtb2RlDQo+IHJ0dzg5Xzg4NTJiZSAwMDAwOjAyOjAw
LjA6IFNFUiBjYXRjaGVzIGVycm9yOiAweDQwMDANCj4gcnR3ODlfODg1MmJlIDAwMDA6MDI6MDAu
MDogcnR3ODk6IGZhaWxlZCB0byBsZWF2ZSBscHMgc3RhdGUNCj4gcnR3ODlfODg1MmJlIDAwMDA6
MDI6MDAuMDogRlcgYmFja3RyYWNlIGludmFsaWQga2V5OiAweGZmZmZmZmZmDQo+IHJ0dzg5Xzg4
NTJiZSAwMDAwOjAyOjAwLjA6IHh0YWwgc2kgbm90IHJlYWR5KFcpOiBvZmZzZXQ9OTAgdmFsPTEw
IG1hc2s9MTANCj4gaWVlZTgwMjExIHBoeTA6IEhhcmR3YXJlIHJlc3RhcnQgd2FzIHJlcXVlc3Rl
ZA0KPiBydHc4OV84ODUyYmUgMDAwMDowMjowMC4wOiBtYWMgcHJlaW5pdCBmYWlsLCByZXQ6IC0x
MTANCj4gbWFjODAyMTE6IEhhcmR3YXJlIGJlY2FtZSB1bmF2YWlsYWJsZSBkdXJpbmcgcmVzdGFy
dC4NCj4gcnR3ODlfODg1MmJlIDAwMDA6MDI6MDAuMDogRXJyOiBzZXIgTDIgcmUtY29uZmlnIHRp
bWVvdXQNCg0KRGlkIGl0IG9jY3VyIHJpZ2h0IGFmdGVyIHN5c3RlbSByZXN1bWU/IENhbiB5b3Ug
c2hhcmUgdGhlIGZ1bGwgbG9nPw0KDQo+IA0KPiBUaGUgZmFpbGVkIHJlc3RhcnQgYWxzbyB0cmln
Z2VycyBzZXZlcmFsIG1hYzgwMjExIHdhcm5pbmdzIGR1cmluZyBpbnRlcmZhY2UNCj4gdGVhcmRv
d24uIFN1YnNlcXVlbnQgYXR0ZW1wdHMgdG8gaW5pdGlhbGl6ZSB3bGFuMCBmYWlsIHdpdGggY29u
bmVjdGlvbg0KPiB0aW1lb3V0cyBhbmQgcmVwZWF0ZWQg4oCcbWFjIHByZWluaXQgZmFpbCwgcmV0
OiAtMTEw4oCdIG1lc3NhZ2VzLg0KPiBOZXR3b3JrTWFuYWdlciBldmVudHVhbGx5IHN0b3BzIHRy
eWluZyB0byBhY3F1aXJlIHRoZSBzdXBwbGljYW50IGludGVyZmFjZS4NCg0KTWFpbGluZyBsaXN0
IG9ubHkgYWNjZXB0cyBwbGFpbiB0ZXh0IG1haWwuIEkgYWxzbyB3cmFwIGxpZW5zLg0KQWxzbyBw
bGVhc2UgcmVtZW1iZXIgbm90IHRvcC1wb3N0aW5nLg0KDQo+IA0KPiBQb3NzaWJsZSByZWdyZXNz
aW9uOg0KPiANCj4gT24gMjAyNi0wNy0yNiwgSSB1cGdyYWRlZDoNCj4gDQo+IGxpbnV4OiA3LjAu
My5hcnRpeDEtMiAtPiA3LjEuNC5hcnRpeDEtMQ0KPiBsaW51eC1maXJtd2FyZS1yZWFsdGVrOiAy
MDI2MDQxMC0xIC0+IDIwMjYwNjIyLTENCj4gDQo+IFRoZSBydHc4ODUyYl9mdy0yLmJpbiBmaWxl
IGNoYW5nZWQgaW4gdGhhdCBmaXJtd2FyZSB1cGRhdGUsIGFuZCBib3RoDQo+IGZhaWx1cmVzIG9j
Y3VycmVkIGFmdGVyd2FyZC4gSSBoYXZlIG5vdCB5ZXQgdGVzdGVkIHRoZSBwcmV2aW91cw0KPiBr
ZXJuZWwvZmlybXdhcmUgY29tYmluYXRpb24gb3IgYSB2YW5pbGxhIHVwc3RyZWFtIGtlcm5lbCwg
c28gSSBjYW5ub3QNCj4gZGV0ZXJtaW5lIHdoZXRoZXIgdGhlIHJlZ3Jlc3Npb24gaXMgaW4gdGhl
IGtlcm5lbCBvciBmaXJtd2FyZS4NCg0KSWYgeW91IGNhbiBwb2ludCBhIHZlcnNpb24gdGhhdCBj
YW4gd29yayB3ZWxsIG9uIHlvdXIgcGxhdGZvcm0sIGl0J2QgYmUNCmhlbHBmdWwgdG8gYmlzZWN0
IHRoZSBjYXVzZS4NCg0KUGluZy1LZQ0KDQo=
