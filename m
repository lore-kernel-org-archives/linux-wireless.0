Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFD03890EC;
	Tue, 25 Aug 2026 07:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787644220; cv=none; b=IR1MOno8KdCfIqSivVpw84bw5dN+qX0e1gsPg3+47RQFiTtez5aZfnIgQ82JD4qT7h3xm9V8AYQaHirUDiYQJ8OPZhxqhEswp+/8nboeK7wWsRZ4CVZsZAURMXh68eay1/PlVcpa73bztkvUH098uAr1ttTPdupNilhGzrxx5Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787644220; c=relaxed/simple;
	bh=ecDEFd7mLzRKu8SJBCVxy+792hrqCDqJF3n0Ge5ez60=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mptf4xHaEon8pINEOyvlSKhz9dbB1Ef9gLFSQ1EANPB6yZv9snXIakEZJFirB3u8/CjltF9/tLrzkgzi0+zy/g/FpU/psC2p1hCQCoxifdjqGc7CgTiXpHhPJHjviaWGjLC9u4ple9zymrU4eHb0J/GVidyQVeFIvT3vJVGPWJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mzZPOEpI; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mzZPOEpI"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P7o5Ms93615587, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787644205; bh=ecDEFd7mLzRKu8SJBCVxy+792hrqCDqJF3n0Ge5ez60=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=mzZPOEpIrV/2hIVztAkRyVTrOoPwXdw6ZOLCQFjpK/qf05wBMfCaTQyStPrNKBivI
	 6HjwiGTsYavMyaowthg6dduHFhWQQijohzR1I1JJ4RxcoFcDI816huaN4IwINt5gln
	 Ox3pE8K3lhX0fScXlFdUlMs6dInY90Wpn+0HiIN0gsnU/Dh8j6kN/4K7lP1FTSKWR9
	 6VwniwfmetZuCh/CUcvxtMXmcNr9TAz5cl2KBHtjg3NKQh7AL1NSlZ0u/B+lEnjy4a
	 Wgn/BRo5mJaaanDF4jKmwEK/JboZOReQyy3FR5+aHjr/bfXjc3/Dv441P/840Lne0l
	 g7fV2wzI+XgSA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P7o5Ms93615587
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 15:50:05 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:50:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:50:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 15:50:05 +0800
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
Thread-Index: AQHdMIL3twfMpykyCEyz233XfbbmBLauSXrw//+T44CAAIcCsP//fHmAgACKsPA=
Date: Tue, 25 Aug 2026 07:50:05 +0000
Message-ID: <68a844f5ea2b4eea827da95080a9dbcb@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
 <20260820090412.19574-5-luka.gejak@linux.dev>
 <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com>
 <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev>
 <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com>
 <E2ACBF1F-1C98-4091-A851-E2D8AF006911@linux.dev>
In-Reply-To: <E2ACBF1F-1C98-4091-A851-E2D8AF006911@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPbiBBdWd1c3QgMjUs
IDIwMjYgOToyNToxMyBBTSBHTVQrMDI6MDAsIFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsu
Y29tPiB3cm90ZToNCj4gPkx1a2EgR2VqYWsgPGx1a2EuZ2VqYWtAbGludXguZGV2PiB3cm90ZToN
Cj4gPj4gSGkgUGluZy1LZSwNCj4gPj4NCj4gPj4gT24gQXVndXN0IDI1LCAyMDI2IDg6MTI6NTgg
QU0gR01UKzAyOjAwLCBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6DQo+
ID4+ID4gZ3VhcmQobXV0ZXgpKCZydHdzZGlvLT50eF9jcmVkaXRfbG9jayk7DQo+ID4+DQo+ID4+
IFRoZSBsb2NrIGlzIG9ubHkgdGFrZW4gZm9yIHRoaXMgY2hpcCwgYW5kIGd1YXJkKCkgaXMgdW5j
b25kaXRpb25hbCwgc28gSQ0KPiA+PiBzcGxpdCB0aGUgbG9ja2VkIHJlZ2lvbiBpbnRvIGl0cyBv
d24gZnVuY3Rpb24gaW5zdGVhZCBvZiBicmFuY2hpbmcgYXJvdW5kDQo+ID4+IHRoZSBsb2NrOg0K
PiA+Pg0KPiA+PiAgICAgICAgIGlmICghcnR3X2lzXzg3MjNicyhydHdkZXYpKSB7DQo+ID4+ICAg
ICAgICAgICAgICAgICB0eHNpemUgPSBzZGlvX2FsaWduX3NpemUocnR3c2Rpby0+c2Rpb19mdW5j
LCBza2ItPmxlbik7DQo+ID4+DQo+ID4+ICAgICAgICAgICAgICAgICByZXQgPSBydHdfc2Rpb19j
aGVja19mcmVlX3R4cGcocnR3ZGV2LCBxdWV1ZSwgdHhzaXplKTsNCj4gPj4gICAgICAgICAgICAg
ICAgIGlmIChyZXQpDQo+ID4+ICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+
ID4+DQo+ID4+ICAgICAgICAgICAgICAgICByZXR1cm4gcnR3X3NkaW9fd3JpdGVfdG9fcG9ydChy
dHdkZXYsIHNrYiwgcXVldWUsIHR4YWRkciwNCj4gPj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHR4c2l6ZSk7DQo+ID4+ICAgICAgICAgfQ0KPiA+PiAgICAg
ICAgIC4uLg0KPiA+PiAgICAgICAgIGd1YXJkKG11dGV4KSgmcnR3c2Rpby0+dHhfY3JlZGl0X2xv
Y2spOw0KPiA+Pg0KPiA+PiAgICAgICAgIHJldHVybiBydHdfc2Rpb184NzIzYnNfd3JpdGVfcG9y
dChydHdkZXYsIHNrYiwgcXVldWUsIHR4YWRkciwgdHhzaXplLA0KPiA+PiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB3cml0ZV9zaXplKTsNCj4gPg0KPiA+SSBtZWFu
dA0KPiA+DQo+ID4gICAgaWYgKHJ0d19pc184NzIzYnMocnR3ZGV2KSkNCj4gPiAgICAgICAgZ3Vh
cmQobXV0ZXgpKCZydHdzZGlvLT50eF9jcmVkaXRfbG9jayk7DQo+ID4NCj4gPkRvZXNuJ3QgaXQg
d29yaz8NCj4gPg0KPiA+DQo+IA0KPiBJIHRyaWVkIGl0LCBhbmQgbm8uIGd1YXJkKCkgZXhwYW5k
cyB0byBhIGRlY2xhcmF0aW9uLCBhbmQgYSBkZWNsYXJhdGlvbg0KPiBjYW5ub3QgYmUgdGhlIGJv
ZHkgb2YgYW4gaWYsIHNvIGl0IGRvZXMgbm90IGJ1aWxkOg0KPiANCj4gICBzZGlvLmM6IEluIGZ1
bmN0aW9uICdydHdfc2Rpb193cml0ZV9wb3J0JzoNCj4gICBpbmNsdWRlL2xpbnV4L2NsZWFudXAu
aDozMDI6OTogZXJyb3I6IGV4cGVjdGVkIGV4cHJlc3Npb24gYmVmb3JlDQo+ICAgJ2NsYXNzX211
dGV4X3QnDQo+ICAgICAzMDIgfCAgICAgICAgIGNsYXNzXyMjX25hbWUjI190IHZhciBfX2NsZWFu
dXAoLi4uKSA9DQo+IA0KPiBBZGRpbmcgYnJhY2VzIGJ1aWxkcyBjbGVhbmx5LCB3aGljaCBpcyB0
aGUgbW9yZSBkYW5nZXJvdXMgdmVyc2lvbiwgYmVjYXVzZQ0KPiB0aGUgY2xlYW51cCB0aGVuIHJ1
bnMgYXQgdGhlIGNsb3NpbmcgYnJhY2UgYW5kIHRoZSBtdXRleCBpcyByZWxlYXNlZCBhZ2Fpbg0K
PiBiZWZvcmUgYW55IG9mIHRoZSBjb2RlIGl0IGlzIG1lYW50IHRvIHByb3RlY3QgcnVucy4NCj4g
DQo+IFRoYXQgaXMgd2h5IEkgbW92ZWQgdGhlIGxvY2tlZCBwYXJ0IGludG8gaXRzIG93biBmdW5j
dGlvbjogdGhlIGd1YXJkIG5lZWRzDQo+IGEgc2NvcGUgdGhhdCBpcyBleGFjdGx5IHRoZSBjcml0
aWNhbCBzZWN0aW9uLCBhbmQgYW4gaWYgYm9keSBpcyBlaXRoZXIgdG9vDQo+IHNtYWxsIG9yIG5v
dCBhbGxvd2VkLg0KDQpPa2F5LiBHb3QgaXQuDQoNCg0K
