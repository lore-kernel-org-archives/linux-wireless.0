Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792457695;
	b=Me18ozqDYwqMlGKTyzLH8n/8/eZ+QmUmFJskLlQKeVpAek5hakzdMeC70IfNYfLH1qjQ
	 uG6TdTcrZHLNjdCveVkb18awx43vJrLXrpsZzjQqjf07ZSfOP8yWp0lkyERptdzby/v99
	 tUj2IgmvS5DDLmfQzepEhIOA97WHFuZL0uMnZvddOBb9NsMwp3LjqHrZ0/ofUZIE7YCRo
	 XJddeDzVBN9Zc2KAyIJZEs+G9eO7vLz+dqxTXOG8CMgtZseLcyeXBzKKqTQ9jNiQaSNQ6
	 5ufdUEc7F1T5tdun4h8SbjIKrPqhkJxXf2Plhxz+WVEIuRlil5HeUgMh2K/gkqq6mrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792457695;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=rDtz8GYJaCwVJ2HDA9ZFuiknJZGpUk1eaA4CSQ4BgPk=;
	b=P7axSjE5gzsXIQr59QpowpurdzFRgkBeCwLZVjlR9w1ETuQ557ib2T/ms71UJ2qDzYsx
	 qQbViF9hCYWayFoubl3wwzMSGB2zXgmdB3HH/FehJ0+EzCoxGlquX8MUSFMdrxnFB9f2f
	 W/Xr917+31ihAoeCYzjbkvpbM0X7EVrO64XvDWxUbvu7hX8i/J1e0vh/hc6Ew6mIJdqnz
	 f5WqKMPAv2x0Ze5JIxNkqWmfXZ3CwkhlDjL9I8Mv1sirdmWent6FP+v+s1hncWNM9eWcQ
	 zvrrgwFZ5W255glvjWDt7SfvXMs/qFo9CZF5q9J2G/CJBYZKv0lKjeuk2LcDmvp1Fdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=qmEK+GCI;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE40B606A31C
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:54:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE40B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=qmEK+GCI
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69K0soLR32526955, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792457690; bh=rDtz8GYJaCwVJ2HDA9ZFuiknJZGpUk1eaA4CSQ4BgPk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=qmEK+GCIECF1YP16jGnsKFU1Y1+BUFZ9h2s3GV6Un2TXqISRB+7RWO4ooXB+3YRK6
	 9I+t86aHYoj7ijyVWOn0cAgjzwv+7fEh8Fcma0ntUD5naU/qMGGnTwDyuOgcKm6rM7
	 3BzLVqi60emnxFnOAEpmuzgHecqD1+1gnIbmXNuRg8S/Vm5VTqWhGtcYOPUfDFAbSS
	 +4fJxxy6Ko9j+JwJOGFauAqkEahi75+1Sw10dgvMRqWD+VZf1lzvYqyly/ZVCUu0//
	 pWVCGSpZXKsFT+CuZBo9lrURLx75sf2+/eDwwsG8b2O3khQQWyakRl4b21yjYBtuA3
	 FqNEwFWZKy8OQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69K0soLR32526955
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 20 Oct 2026 08:54:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 08:54:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 08:54:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 20 Oct 2026 08:54:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: D <do.savenko@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: rtw88: WARNING in rtw_get_tx_power_params (phy.c) during
 connection attempts, RTL8822BE authentication times out
Thread-Topic: rtw88: WARNING in rtw_get_tx_power_params (phy.c) during
 connection attempts, RTL8822BE authentication times out
Thread-Index: AQHdX6qsbiHTg7rPe0yzLj8Pu+iNercFmPFw
Date: Tue, 20 Oct 2026 00:54:50 +0000
Message-ID: <4994a9e471014cbfa219f9b161f266cc@realtek.com>
References: <CAGzmDW=m-g0FFotR4wWniH3O3zXOFej2_bHvUmHyPJ6sY7QOfA@mail.gmail.com>
In-Reply-To: <CAGzmDW=m-g0FFotR4wWniH3O3zXOFej2_bHvUmHyPJ6sY7QOfA@mail.gmail.com>
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

RCA8ZG8uc2F2ZW5rb0BnbWFpbC5jb20+IHdyb3RlOg0KDQovLyBwbGVhc2Ugc2VuZCBpbiBwbGFp
biB0ZXh0IG1vZGUuDQoNCj4gQWZmZWN0ZWQgbmV0d29ya3MgaW5jbHVkZSBhIDIuNCBHSHogQVAg
b24gY2hhbm5lbCA4IGFuZCBhIDUgR0h6IEFQIG9uIA0KPiBjaGFubmVsIDEyOCAoREZTKS4gVGhl
IHJlZ3VsYXRvcnkgZG9tYWluIGlzIHNldCB0byBVQSAoREZTLUVUU0kpLg0KDQpUaGUgY2hpcCBj
YW4ndCBzdXBwb3J0IHRoZSBjaGFubmVscywgc28gaXQgd2FybnM6DQoNCmludmFsaWQgYXJndW1l
bnRzLCBiYW5kPTEsIGJ3PTIsIHBhdGg9MSwgcmF0ZT02MCwgY2g9MTMwDQoNCkRvZXMgaXQgc3Rp
bGwgd2FybiBpZiB5b3UgY29ubmVjdCB0byBjaGFubmVsIDggb24gMi40R0h6IGJhbmQ/DQpJIHRo
aW5rIGl0IHNob3VsZCBub3QuDQoNCj4gVHJpZWQgc2V2ZXJhbCBhY2Nlc3MgcG9pbnRzIG9uIGRp
ZmZlcmVudCBjaGFubmVscywgaW5jbHVkaW5nIDIuNCBHSHogDQo+IGNoYW5uZWwgOCBhbmQgNSBH
SHogY2hhbm5lbCAxMjguIFNhbWUgcmVzdWx0Lg0KDQpXaGF0IGRvZXMgdGhlIGNoYW5uZWxzIHlv
dSB0ZXN0ZWQ/IEhvdyBhYm91dCA1R0h6IGNoYW5uZWwgMzYgd2l0aA0KYmFuZHdpZHRoIDgwTUh6
Pw0KDQo+IFF1ZXN0aW9ucw0KPiBJcyB0aGlzIGEga25vd24gaXNzdWU/IElmIHNvLCBpcyB0aGVy
ZSBhIGZpeCBvciBhIGRlYnVnIHBhdGNoPw0KDQpXZSBhcmUgY29uc2lkZXJpbmcgdG8gZGlzYWJs
ZSB0aGUgY2hhbm5lbHMgWzFdLCBiZWNhdXNlIHRoZXNlIGNoYW5uZWxzDQpkb2Vzbid0IGdldCBj
ZXJ0aWZpY2F0ZWQgYW5kIHRlc3RlZC4NCg0KQSBwZW9wbGUgcHJvcG9zZWQgYSBwYXRjaCBbMl0s
IHdoaWNoIHlvdSBjYW4gcGljayBpdCB0byB0ZXN0IGxvY2FsbHksDQpidXQgSSBkb24ndCB0aGlu
ayBpdCB3aWxsIGJlIHRoZSBzb2x1dGlvbi4gDQoNClsxXSBodHRwczovL3BhdGNod29yay5rZXJu
ZWwub3JnL3Byb2plY3QvbGludXgtd2lyZWxlc3MvcGF0Y2gvMjAyNjA0MTMwNTM2MDEuMTMwMzct
MS1wa3NoaWhAcmVhbHRlay5jb20vDQpbMl0gaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9w
cm9qZWN0L2xpbnV4LXdpcmVsZXNzL3BhdGNoLzIwMjYwMzA2LXJ0dzg4X2NoYW5uZWwxMzAtdjEt
MS1mZjI1YTViYzkzMGFAaWdhbGlhLmNvbS8NCg0KPiBJcyB0aGVyZSBhIGtub3duIGludGVyYWN0
aW9uIGJldHdlZW4gc3VzcGVuZC9yZXN1bWUgYW5kIHJ0dzg4IGNoYW5uZWwvVFggDQo+IHBvd2Vy
IHNldHVwIG9uIFJUTDg4MjJCRSB0aGF0IGNvdWxkIGV4cGxhaW4gd2h5IEJsdWV0b290aCBzdGls
bCB3b3JrcyB3aGlsZSANCj4gV2ktRmkgYXNzb2NpYXRpb24gZmFpbHM/DQoNCllvdSBjYW4gY29u
c2lkZXIgdGhlbSBhcyBpbmRlcGVuZGVudCBtb2R1bGVzIGV4Y2VwdCB0byBhbnRlbm5hIHNoYXJp
bmcuIA0KDQpQaW5nLUtlDQoNCg==
