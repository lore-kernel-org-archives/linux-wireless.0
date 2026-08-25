Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407162E739E;
	Tue, 25 Aug 2026 08:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787646477; cv=none; b=hC3BzfQnrPhD5i2LoqgACwh6XCiAxOAFXTazSCcmensVVZB+yqHrFMgMLvtg8tvi+a+d9CzZwf/Iw3lw+cMSuo+oY8zIiGJn4d9aP3VwhxNYAUlBsuPoLz1ktlCtHCom/ZfkwUsUkGHlY3uINkKGfSOs8usE8roGufZEss2g1mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787646477; c=relaxed/simple;
	bh=DN7SIR7QuVphdDpnZyF12hRTfRaLtiI+2yPi6PsFblk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a0PgkQqASSACC/HpxYuf3LLRB6NZ8b3nvpvQOXv+eSgn0pLh9FgTA5bG/x6+oqHvMUiqOo7tgMNpsu7lZgS9udZhkmMx5KfpAUR+Yw7C4ecYX8S7kAn0obNWdm3UmWOlCq2t6Sqvk+yJHJ8kNJO/Y5sYiQ9V0Ku2QrJhKx/gjiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=dUCxFKKm; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="dUCxFKKm"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P8RgQaA3636888, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787646462; bh=DN7SIR7QuVphdDpnZyF12hRTfRaLtiI+2yPi6PsFblk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=dUCxFKKmuEYBzeMQ+zE0G/9UXRovkvniG3Ti1kjf3flbAE9W1jDc+jxkCCs4aIAH7
	 6BJC11JboLD+VwQtmDVj7zalJgoBCnniIhBFkw6TLFIiBOiEPjc82FJF4p7QVlmCft
	 ExjZ7eAgTXpBe9OzicQP7y6rxJxbEsmQP5wC0tqQA2Qo5oHTkzGRVRBhAKJ/7hPv9C
	 3taOmgPH0shYR/pe0CBd5EugyK9dHZxoTiHh0z5on3y/tBVZKpbv+JDudzNNtJI0Ip
	 +C3UUnG+cAGFHs6C/FjLjFiQnzVwHJvIOJVB2NMw8iraO0xUkmy8JNTd11wo5PugVo
	 vQSzbdeMcvs/A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P8RgQaA3636888
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 16:27:42 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 16:27:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 16:27:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 16:27:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v7 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Topic: [PATCH v7 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Index: AQHdMIL7G//TSj3zZkqzYEB+swGRO7auVSeA//+IogCAAJdlkA==
Date: Tue, 25 Aug 2026 08:27:42 +0000
Message-ID: <370ad8d9b2ab4de3ac1b3e0da01413bc@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
 <20260820090412.19574-7-luka.gejak@linux.dev>
 <348bea609cee45179ee2a0c7dd03f0d1@realtek.com>
 <6EA9DEEA-DFF7-4AFC-9C46-55D0EDF256BB@linux.dev>
In-Reply-To: <6EA9DEEA-DFF7-4AFC-9C46-55D0EDF256BB@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBIaSBQaW5nLUtlLA0K
PiANCj4gT24gQXVndXN0IDI1LCAyMDI2IDg6MzY6MzAgQU0gR01UKzAyOjAwLCBQaW5nLUtlIFNo
aWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6DQo+IA0KPiA+IFdpdGggV1JJVEVfT05DRSgp
IGFuZCBSRUFEX09OQ0UoKSwgSSB0aGluayBpdCB3aWxsIGNvbmN1cnJlbmN5IHdvcmsNCj4gPiB3
ZWxsLiBEaWQgeW91IHJlYWxseSBlbmNvdW50ZXIgcHJvYmxlbXMgd2l0aCBzbXBfbWIoKT8NCj4g
DQo+IE5vdCBmcm9tIGEgZmFpbHVyZSBJIGhpdCwgbm8uIEl0IGNhbWUgb3V0IG9mIHJlYWRpbmcg
dGhlIGNvZGUsIGFuZCBJIHRoaW5rDQo+IGl0IGlzIHN0aWxsIG5lZWRlZCwgc28gbGV0IG1lIGxh
eSBvdXQgdGhlIGNhc2UgcmF0aGVyIHRoYW4ganVzdCBhc3NlcnQgaXQuDQo+IA0KPiBUaGUgZmxh
ZyBhbG9uZSBpcyBub3QgZW5vdWdoIGJlY2F1c2Ugb2YgdGhpcyBvcmRlcjoNCj4gDQo+ICAgcHJv
ZHVjZXIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB3b3JrZXINCj4gICBza2JfcXVldWVf
dGFpbCgpDQo+ICAgcmVhZHMgbGVuLCBzZWVzID49IEhJV0FURVINCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGRyYWlucyB0aGUgcXVldWUgdG8gZW1wdHkNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJlYWRzIHRoZSBmbGFnLCBzdGls
bCBmYWxzZSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNvIGl0
IGRvZXMgbm90IHdha2UNCj4gICB3cml0ZXMgdGhlIGZsYWcgdHJ1ZQ0KPiAgIGllZWU4MDIxMV9z
dG9wX3F1ZXVlKCkNCj4gDQo+IFRoZSBBQyBpcyBub3cgc3RvcHBlZCB3aXRoIGFuIGVtcHR5IHF1
ZXVlIGFuZCBub2JvZHkgbGVmdCB0byB3YWtlIGl0LiBUaGF0DQo+IGlzIHdoYXQgdGhlIHJlLWNo
ZWNrIHVuZGVyIHRoZSBiYXJyaWVyIGlzIGZvcjogb25jZSB0aGUgZmxhZyBpcyBzZXQsIHJlYWQN
Cj4gdGhlIGxlbmd0aCBhZ2FpbiwgYW5kIGlmIHRoZSB3b3JrZXIgZHJhaW5lZCBpdCBtZWFud2hp
bGUsIHVuZG8gdGhlIHN0b3AuDQoNCkkgdGhpbmsgdGhlIGtleSBwb2ludCBpcyB0byAidW5kbyIg
dGhlIHN0b3AuIA0KDQpwY2kuYyBkb2Vzbid0IGhhdmUgdGhpcyBiYWNrIGFuZCBmb3J0aCBjb2Rl
LiBDYW4geW91IHJlZmVyZW5jZSBhbmQgaW1pdGF0ZSBpdD8NCihJIHdpbGwgYWxzbyBzcGVuZCB0
aW1lIHRvIGNvbnNpZGVyIHRoYXQpLg0KDQpQaW5nLUtlDQoNCg==
