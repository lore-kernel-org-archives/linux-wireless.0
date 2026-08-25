Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2398F3CFF55;
	Tue, 25 Aug 2026 07:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787642728; cv=none; b=fILHKSE2BCc4qdbdi5Yk360RfkdlFQFp6DnaJiMfXxp34yvlyQkgZKk+C67lExQiCTtrk3by9Spr4ck6bIb4dXP/nLsueYbd88PEBbhZ7AA2ZhC6wpXWaYkuSSnClIE7fPoSpz9QI3rzI3LcXzyB/AErZ7pnqoUH13HwcpcjzgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787642728; c=relaxed/simple;
	bh=v7RSpo7AWgck4/a9+ABc/eTalfzMaDPX8Ga/zd0v9Xw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EX6mbcWiKagzq0a/nfLoF/W3vqbjKDZdSNLwINpn74hiz5JWRAO/bsatSSVXlYERzr0k5VJcvEDcvIOOb4rqxUU282iSS648urkNaMJ0r03DcIPJ/AY9xaZEqYLW9Min8AltqHRirRttVCh0MBU09ASd0S/pQGl/ilTJG8HJpYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OAJoow9g; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OAJoow9g"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P7PDJh83583740, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787642714; bh=v7RSpo7AWgck4/a9+ABc/eTalfzMaDPX8Ga/zd0v9Xw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=OAJoow9gObwGR5kNjQZoaThSjLxil2mp+CWpHlqvmZWFy6xme2zkk7NPPCF/qN/91
	 D5tUFT2kQiRx8h5V2AYj+IIED8YmZSu3/jVRCXbHlm6ImHmPAZIt9xG6TdlFewIjwc
	 +dXEnJoS/9Yg9ehTiwAw4Va72KNw/+CPMnmhu0uKoN300JpxhV/Vo/ZavKqwrSIqf/
	 zJXbLubpb5Dr0gsqCaIxVWl17xUQiGlTr0FxdjLGOq69Fnh/F4LzyRMsMxKIPcbHk4
	 4FosVVchwS/Sw4GmI00DC8Awrt2p+nV9IW5pphNacNz7vyZToZKFxN0e9rH2HIHrP1
	 ewLlkLxjBIEAw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P7PDJh83583740
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 15:25:14 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:25:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:25:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 15:25:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdMIL3twfMpykyCEyz233XfbbmBLauSXrw//+T44CAAIcCsA==
Date: Tue, 25 Aug 2026 07:25:13 +0000
Message-ID: <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
 <20260820090412.19574-5-luka.gejak@linux.dev>
 <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com>
 <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev>
In-Reply-To: <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev>
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
PiANCj4gT24gQXVndXN0IDI1LCAyMDI2IDg6MTI6NTggQU0gR01UKzAyOjAwLCBQaW5nLUtlIFNo
aWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6DQo+ID4gZ3VhcmQobXV0ZXgpKCZydHdzZGlv
LT50eF9jcmVkaXRfbG9jayk7DQo+IA0KPiBUaGUgbG9jayBpcyBvbmx5IHRha2VuIGZvciB0aGlz
IGNoaXAsIGFuZCBndWFyZCgpIGlzIHVuY29uZGl0aW9uYWwsIHNvIEkNCj4gc3BsaXQgdGhlIGxv
Y2tlZCByZWdpb24gaW50byBpdHMgb3duIGZ1bmN0aW9uIGluc3RlYWQgb2YgYnJhbmNoaW5nIGFy
b3VuZA0KPiB0aGUgbG9jazoNCj4gDQo+ICAgICAgICAgaWYgKCFydHdfaXNfODcyM2JzKHJ0d2Rl
dikpIHsNCj4gICAgICAgICAgICAgICAgIHR4c2l6ZSA9IHNkaW9fYWxpZ25fc2l6ZShydHdzZGlv
LT5zZGlvX2Z1bmMsIHNrYi0+bGVuKTsNCj4gDQo+ICAgICAgICAgICAgICAgICByZXQgPSBydHdf
c2Rpb19jaGVja19mcmVlX3R4cGcocnR3ZGV2LCBxdWV1ZSwgdHhzaXplKTsNCj4gICAgICAgICAg
ICAgICAgIGlmIChyZXQpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+
IA0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIHJ0d19zZGlvX3dyaXRlX3RvX3BvcnQocnR3ZGV2
LCBza2IsIHF1ZXVlLCB0eGFkZHIsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB0eHNpemUpOw0KPiAgICAgICAgIH0NCj4gICAgICAgICAuLi4NCj4gICAg
ICAgICBndWFyZChtdXRleCkoJnJ0d3NkaW8tPnR4X2NyZWRpdF9sb2NrKTsNCj4gDQo+ICAgICAg
ICAgcmV0dXJuIHJ0d19zZGlvXzg3MjNic193cml0ZV9wb3J0KHJ0d2Rldiwgc2tiLCBxdWV1ZSwg
dHhhZGRyLCB0eHNpemUsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHdyaXRlX3NpemUpOw0KDQpJIG1lYW50DQoNCiAgICBpZiAocnR3X2lzXzg3MjNicyhydHdk
ZXYpKQ0KICAgICAgICBndWFyZChtdXRleCkoJnJ0d3NkaW8tPnR4X2NyZWRpdF9sb2NrKTsNCg0K
RG9lc24ndCBpdCB3b3JrPw0KDQoNCg==
