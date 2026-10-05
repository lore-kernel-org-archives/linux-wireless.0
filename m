Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059E113776B
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 02:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791166608; cv=none; b=B2nxDa9zPw2fkMN3rcZPwNC4RS2uOph6xWk0qxjANlel7wyMEq/c2FGj4rrtUURP4r1AdQaIK7Z8tYfs9FCQnOd2Fcr1qGH/OFwfk38/pepO5wos5HcB0r7l+67p0/MNueYyTEpOZqUZUQhSDLldQuU2amX3WMVH/pvWXClzoks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791166608; c=relaxed/simple;
	bh=8PyysHFjAliSqjE1DN/H2LanJr9fiGLDdHFkNuB3Us4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VdXn+VhWTeGPOclT1pSZmPL1rokRATCxMyh5C5xUNPwyyhkJvsRcWX9PN+qJCheEWuvzdcyr1pGYxYkRxLJ3xSI9hsCYVonkcjqZQsey065lRlXyqHCBZ1To5zVsQOkkxh1TaQcnAfjemXJKZFoj1sEZ50j+i4B2R6e9TT9UCpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KFazWSyD; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KFazWSyD"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6952GUwG41561601, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791166590; bh=8PyysHFjAliSqjE1DN/H2LanJr9fiGLDdHFkNuB3Us4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=KFazWSyDu1kfgByxCrTFCPORgyWuD9EjA3olXJhr4/gLy+HNy7QTK8SBkR8TYP09y
	 xxVpl215RODz6fVbgAZpf89jmmqprh1TEgi9Uwh0MvXIXDfkko7kPfLyouNkHRKx65
	 Btdrw5gqAuvUIycmLSZpFSvZFoYHdQ4EVVyM3J8ZKJFyFc/68of/DXCLUZcGPMY22+
	 lad9vrB2VJDZEj9UKtGzBK2oP0dC6yDddtlaM0EvBKPVCp8xaPO0tVVIZXZ4EXy/0J
	 LQYzygoRuK8tbaaU4CfWukNkhF1AvAZRZdXjnm00F6DpvH29bm+AAnQ9l2lbKxFIrJ
	 XfK2nS0UEjwNQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6952GUwG41561601
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 10:16:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 10:16:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 10:16:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Adilson <aoleandro@proton.me>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: wifi: rtw89: 8852AE: zero SMA in addr CAM for virtual monitor
 vif, and ~200 ms delay before first TX attempt of injected unicast
Thread-Topic: wifi: rtw89: 8852AE: zero SMA in addr CAM for virtual monitor
 vif, and ~200 ms delay before first TX attempt of injected unicast
Thread-Index: AQHdUhjUEdMeafmWU0yJDBWOnUTZc7buNr0g
Date: Mon, 5 Oct 2026 02:16:30 +0000
Message-ID: <d869d864b8fa40c683829d49c23e2291@realtek.com>
References: <b41nlcULR-r_hxbVG6EOsjESlvS4yT_ArYlWgP26g34UKbdoMRoLxMd2pLl4h0L6sB1GOAGr2pT2ofsCRXAcJSqm4lxEWIwH4gTZbjFVmiI=@proton.me>
In-Reply-To: <b41nlcULR-r_hxbVG6EOsjESlvS4yT_ArYlWgP26g34UKbdoMRoLxMd2pLl4h0L6sB1GOAGr2pT2ofsCRXAcJSqm4lxEWIwH4gTZbjFVmiI=@proton.me>
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

QWRpbHNvbiA8YW9sZWFuZHJvQHByb3Rvbi5tZT4gd3JvdGU6DQo+IFdvdWxkIGEgcGF0Y2ggYWxv
bmcgdGhlc2UgbGluZXMgYmUgYWNjZXB0YWJsZSB1cHN0cmVhbT8gQW5kIHdvdWxkIGl0DQo+IGJl
IGVub3VnaCBmb3IsIG9yIGEgc3RlcCB0b3dhcmRzLCBhZHZlcnRpc2luZyBBQ1RJVkVfTU9OSVRP
UiBvbiB0aGVzZQ0KPiBjaGlwcz8gVGhlIGZpeCBjb3VsZCBhbHNvIGtleSBvbiBhZGRyX3ZhbGlk
IGluc3RlYWQgb2YgdGVzdGluZyBmb3IgYQ0KPiB6ZXJvIGFkZHJlc3MsIGlmIHlvdSBwcmVmZXIu
DQoNCkkgdGhpbmsgYWR2ZXJ0aXNpbmcgTkw4MDIxMV9GRUFUVVJFX0FDVElWRV9NT05JVE9SIHRv
IHN1cHBvcnQgYWN0aXZlDQptb25pdG9yIGlzIGJldHRlciB3YXkuDQoNCj4gDQo+IDIpIEluamVj
dGVkIHVuaWNhc3Qgd2FpdHMgfjIwMCBtcyBiZWZvcmUgdGhlIGZpcnN0IFRYIGF0dGVtcHQNCj4g
DQo+IEluamVjdGVkIHVuaWNhc3QgZGF0YSBmcmFtZXMgcmVhY2ggdGhlIHBlZXIgbXVjaCBsYXRl
ciB0aGFuIGluamVjdGVkDQo+IG11bHRpY2FzdC4gWW91ciBzZXJpZXMgZnJvbSBOb3ZlbWJlciAy
MDI1IChyYXRlL2J3L0dJIGZvciBpbmplY3RlZA0KPiBwYWNrZXRzKSBpcyBpbmNsdWRlZCBpbiB0
aGlzIGtlcm5lbDsgaXQgZG9lcyBub3Qgc2VlbSB0byB0b3VjaCB0aGlzDQo+IHdhaXQuDQoNClRo
ZSBtYWluIGRpZmZlcmVuY2VzIGZyb20gdW5pY2FzdCBhbmQgbXVsdGljYXN0IGZyYW1lcyBhcmU6
DQoxLiBodyBxdWV1ZSANCjIuIHdpdGggZGlmZmVyZW50IHF1ZXVlLiBJdCByZWxpZXMgb24gRURD
QSBwYXJhbWV0ZXIuDQozLiByYXRlDQoNCllvdSBjYW4gYWRqdXN0IHVuaWNhc3QgZnJhbWUgdG8g
VFggd2l0aCB0aGUgc2FtZSBkZXNjX2luZm8gYXR0cmlidXRlcw0KYXMgbXVsdGljYXN0IGZyYW1l
IHRvIHNlZSBpZiBhbnl0aGluZyBpbXByb3ZlZC4gDQoNCj4gRGlzY2xvc3VyZTogSSBkaWQgdGhp
cyBpbnZlc3RpZ2F0aW9uIHdpdGggdGhlIGhlbHAgb2YgYW4gQUkgYXNzaXN0YW50DQo+IChDbGF1
ZGUsIGJ5IEFudGhyb3BpYyksIHdoaWNoIEkgdXNlZCB0byByZWFkIHRoZSBkcml2ZXIgY29kZSwg
d3JpdGUgdGhlDQo+IG1lYXN1cmVtZW50IHNjcmlwdHMgYW5kIHRoZSBleHBlcmltZW50YWwgcGF0
Y2hlcywgYW5kIGRyYWZ0IHRoaXMNCj4gbWVzc2FnZS4gQWxsIG1lYXN1cmVtZW50cyB3ZXJlIHJ1
biBieSBtZSBvbiBteSBvd24gaGFyZHdhcmUsIGFuZCBJDQo+IGhhdmUgcmV2aWV3ZWQgZXZlcnkg
Y2xhaW0gYWJvdmUgYW5kIGNhbiBhbnN3ZXIgcXVlc3Rpb25zIGFib3V0IGl0Lg0KDQpVbmRlcnN0
b29kLiBDdXJyZW50bHkgSSBhc3N1bWUgbG9uZyBsb25nIGFydGljbGUgaXMgZ2VuZXJhdGVkIGJ5
IExMTS4NCkkga25ldyB0aGF0IGJlY29tZXMgY29tbW9uLCBidXQgaXQgaXMgYWN0dWFsIGhlYXZ5
IGxvYWQgdG8gbWUgdG8NCnJlYWQgYSBsb3QuIEJ1dCBzdGlsbCBub3RlZCB5b3VyIGRpc2Nsb3N1
cmUuDQoNCg0K
