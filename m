Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F98634A791;
	Thu, 17 Sep 2026 01:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789607525; cv=none; b=uxwcQNLDr7BdheSPqmdf76uRj7UAlKGkeL44PS4glww/VnAW//dY9ekU9MqawfpEN5PegPJ6/R9pIuFLUU4N7gZlIT48yM7uLF2dpmPF6YQET/iC+uE3w8W6vZ9g3ZZbfO1uG5fZJhEGavsbbfBdEDDuX9Xz5jcRE0iy2APIfTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789607525; c=relaxed/simple;
	bh=Jjq1Oe40v5kFXyhhBn105uwzVlqWcacroTzvz4jNvi8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ogpCGZ0xmarTNfhA5lX6PKMOM1NpkCd9Ovo4zXGKsGxZ4a6HYhtJDN29FFnkptTWdqQSlpwY8V79vVIMBmkhfnOho3feX5o640qS7oIyZvTSoOWtcI4ga+PaQMm+f6GUXj5kW5xGRJtAXJDsELu/TcuA/r84b8Vq11hXGI+Enh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QOfjA2pP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QOfjA2pP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68H1Bs6022878187, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789607514; bh=Jjq1Oe40v5kFXyhhBn105uwzVlqWcacroTzvz4jNvi8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=QOfjA2pPKjMTPp5dO9Fez0JrzvvG8eM0sKkrRo4ozpkGCRAPqK9ISrmDAffdEGbxg
	 dAfSyGBsei3WnaSf7DqtL93rUcu2dxv2Oq2y2gIxp8UbyatqJVwgHySEXmLT+FHIfZ
	 lVnUBHM4G1+AXhetDL5lSHWV27dLjiLf3Ovp/9Pinu8085/LGi9Lco2g9n1D4dhC6Z
	 bZwXhk5LPLIJ4As0hcYzTQQ4PEdtcO5sIqwhzpmPS3OBg9tXIoMBlWgLCKH7ouMJvb
	 UvzxQmJr13OU03/Yn8sEtb620DY1+BSuNe6jumpo3Tmq/0l/krZO8IjsWxFUnlhTM2
	 Sg7gPrJZdNW5Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68H1Bs6022878187
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 17 Sep 2026 09:11:54 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 09:11:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 09:11:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 17 Sep 2026 09:11:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: kimwooseok <5mghybrid@khu.ac.kr>, Jes Sorensen <Jes.Sorensen@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH wireless 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Topic: [PATCH wireless 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Index: AQHdQvXIGvF0I1VmF0mL7Gmxnqj2RLbR/JqQ
Date: Thu, 17 Sep 2026 01:11:53 +0000
Message-ID: <0b970cf2ade94c569eab459ca996acab@realtek.com>
References: <CAH1Bc_wBUmmNyzF3c2H1aFBRBbAPSw0hR=1MnPOAcCXypVL_Dg@mail.gmail.com>
 <CAH1Bc_xSxOrEUjx11NtTE9Y6WVitF8K0mVws8s3623C8O=Lpkw@mail.gmail.com>
In-Reply-To: <CAH1Bc_xSxOrEUjx11NtTE9Y6WVitF8K0mVws8s3623C8O=Lpkw@mail.gmail.com>
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

a2ltd29vc2VvayA8NW1naHlicmlkQGtodS5hYy5rcj4gd3JvdGU6DQo+IEEgZmFpbGVkIFJYIFVS
QiBzdWJtaXNzaW9uIGNhbiBsZWFrIHRoZSBza2IgYWxsb2NhdGVkIGZvciB0aGF0IGF0dGVtcHQu
DQo+IHJ0bDh4eHh1X3N1Ym1pdF9yeF91cmIoKSBhbGxvY2F0ZXMgdGhlIGJ1ZmZlciBhbmQgc3Rv
cmVzIGl0IGluIHVyYi5jb250ZXh0LA0KPiBidXQgaWYgdXNiX3N1Ym1pdF91cmIoKSBmYWlscywg
aXQgb25seSB1bmFuY2hvcnMgdGhlIFVSQi4gVGhlIFJYIHdvcmtlcg0KPiBxdWV1ZXMgRU5PTUVN
L0VBR0FJTiBmYWlsdXJlcyBmb3IgcmV0cnkgd2l0aCB0aGF0IGJ1ZmZlciBzdGlsbCBhdHRhY2hl
ZC4NCj4gDQo+IE9uIHRoZSBuZXh0IGF0dGVtcHQsIHJ0bDh4eHh1X3N1Ym1pdF9yeF91cmIoKSBh
bGxvY2F0ZXMgYW5vdGhlciBza2IgYW5kDQo+IG92ZXJ3cml0ZXMgdXJiLmNvbnRleHQsIGxvc2lu
ZyB0aGUgcmVmZXJlbmNlIHRvIHRoZSBwcmV2aW91cyBidWZmZXIuDQo+IFN0b3BwaW5nIGJlZm9y
ZSB0aGUgcmV0cnkgYWxzbyBsZWFrcyB0aGUgYnVmZmVyIGJlY2F1c2UgcGVuZGluZy1yZXF1ZXN0
DQo+IGNsZWFudXAgZnJlZXMgb25seSB0aGUgVVJCLg0KPiANCj4gRml4IHRoZSBsZWFrIGF0IHRo
ZSBzdWJtaXNzaW9uIGZhaWx1cmUgYnkgbWFraW5nIHJ0bDh4eHh1X3N1Ym1pdF9yeF91cmIoKQ0K
PiByZXNwb25zaWJsZSBmb3IgYm90aCBhbGxvY2F0aW5nIHRoZSBza2IgYW5kIHJlbGVhc2luZyBp
dCB3aGVuIHN1Ym1pc3Npb24NCj4gZmFpbHMuIEZyZWUgdGhlIG5ld2x5IGFsbG9jYXRlZCBza2Ig
YW5kIGNsZWFyIHVyYi5jb250ZXh0IGJlZm9yZSByZXR1cm5pbmcNCj4gdGhlIGVycm9yLCBzbyBu
ZWl0aGVyIHJldHJ5IG5vciBzdG9wIHJlY2VpdmVzIGEgcGVuZGluZyBVUkIgdGhhdCBzdGlsbA0K
PiBvd25zIGEgYnVmZmVyLiBSZW1vdmUgdGhlIGNhbGxlci1zaWRlIHNrYiBjbGVhbnVwIGZyb20g
c3RhcnQgYW5kIHRoZSBSWA0KPiB3b3JrZXI7IHRob3NlIGNhbGxlcnMgbm93IGhhbmRsZSBvbmx5
IHdoZXRoZXIgdG8gcmV0cnkgb3IgcmVsZWFzZSB0aGUgVVJCLg0KPiANCj4gRml4ZXM6IDI2ZjFm
YWQyOWFkOSAoIk5ldyBkcml2ZXI6IHJ0bDh4eHh1IChtYWM4MDIxMSkiKQ0KPiBBc3Npc3RlZC1i
eTogR1BULTYgQXN0cmENCj4gU2lnbmVkLW9mZi1ieToga2ltd29vc2VvayA8NW1naHlicmlkQGto
dS5hYy5rcj4NCg0KQ2FuIHlvdSBnaXZlIHlvdXIgcy1vLWIgbW9yZSBmb3JtYWw/IExpa2UsIEtp
bSBXb28tU2Vvaz8NCg0KUmV2aWV3ZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsu
Y29tPg0KDQoNCg==
