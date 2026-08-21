Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA32A25B0A4;
	Fri, 21 Aug 2026 02:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787280891; cv=none; b=iM2qWvD8hs9QhozshEnROjix57NOGv6yk0SwdVtlTqIIRq82mh9xFRkTbUkUdcptFXcfJEougpmCY5Tsuxe1KObBrS1FKaJwxjF4hwljBS8m2pJt3185om/j/pi6BN/0/Ko7OY64zpktA+Djgm6rmLUNbw6qB3RlT3GzWI6RWyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787280891; c=relaxed/simple;
	bh=4TprAzpQLLBG7JEa2ew2UgbAlQ/8mitUXSUu06PcV7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uvCxB0JqGFpeNe9Zjp7raNG8HgL4QGbloRGaxkFt+4lwnYZlWe/qx+v2SPmMWcl5LSavMxxdyKofmn6Y6+eyqkt0pWKTGMb00a49Q4HUCdFeNF0djzHxf+icg2zggdmvQC2aeMrzpWVssELyfelK2ibVMHwMt3Rxef2Iqz+aNXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OhqDNqQH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OhqDNqQH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67L2sjwT74026951, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787280885; bh=4TprAzpQLLBG7JEa2ew2UgbAlQ/8mitUXSUu06PcV7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=OhqDNqQHYfCF6UgEtQ9gSuUmxSjDELT70pAsCzicyv4waiEiX5xp32DUFLBGH2I32
	 LwiQO8p3QL5hzUH4uxtq6eZKyZQGGuGAo615uPecBO2RkUylV2lWuz1XqBSnDOScTp
	 OcJeXbGF2IpmAHRZbMyTcPJj1Zt2L00Du1ZYk7RjlRosNyqu6xihlbiRPMW3UyCDwG
	 GKno6NEtc6j8tUEQeYhkrio+vhWEdB9uOC57Ab3B7U1g/A2uSIaWX/1o5ZcDPIMkZB
	 UQxJjAHOHMXUM3E67XSnKayJuDXP2ymqDAb/O/UVmgAQhSJaQDMbwvYZaY+HTdBNFo
	 1NmDvpmupx20Q==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67L2sjwT74026951
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 21 Aug 2026 10:54:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 21 Aug 2026 10:54:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 21 Aug 2026 10:54:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: =?utf-8?B?QXRhIMSwbGhhbiBLw7ZrdMO8cms=?= <atailhan2006@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: disable ASPM for Lenovo IdeaPad S340-14IWL
Thread-Topic: [PATCH] wifi: rtw88: disable ASPM for Lenovo IdeaPad S340-14IWL
Thread-Index: AQHdMI0ZkVxkkYU5IU6B69wle8oiYranz4dQ
Date: Fri, 21 Aug 2026 02:54:45 +0000
Message-ID: <5b28c2d41aca478a9d4e11581a934f29@realtek.com>
References: <20260820101642.35003-1-atailhan2006@gmail.com>
In-Reply-To: <20260820101642.35003-1-atailhan2006@gmail.com>
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

DQpBdGEgxLBsaGFuIEvDtmt0w7xyayA8YXRhaWxoYW4yMDA2QGdtYWlsLmNvbT4gd3JvdGU6DQo+
IFRoZSBMZW5vdm8gSWRlYVBhZCBTMzQwLTE0SVdMIChETUkgcHJvZHVjdCBuYW1lICI4MU40Iikg
ZXhwZXJpZW5jZXMNCj4gc2V2ZXJlIGNvbm5lY3Rpdml0eSBpc3N1ZXMgd2l0aCB0aGUgcnR3ODgg
UENJZSB3aXJlbGVzcyBjYXJkIHdoZW4NCj4gQVNQTSBpcyBlbmFibGVkLiBSZXBvcnRlZCBzeW1w
dG9tcyBpbmNsdWRlIGZyZXF1ZW50IGRpc2Nvbm5lY3Rpb25zLA0KPiBrZXJuZWwgcGFuaWNzLCBh
bmQgdGhlIGRyaXZlciBmYWlsaW5nIHRvIGxvYWQuDQo+IA0KPiBUaGUgaXNzdWUgY2FuIGJlIHdv
cmtlZCBhcm91bmQgYnkgZWl0aGVyIGFkZGluZyBwY2k9bm9hc3BtIHRvIHRoZQ0KPiBrZXJuZWwg
Y29tbWFuZCBsaW5lIG9yIGJ5IHJlbG9hZGluZyB0aGUgZHJpdmVyIHZpYSBtb2Rwcm9iZS4gQWRk
IGENCj4gRE1JIHF1aXJrIHRvIGRpc2FibGUgQVNQTSBhdXRvbWF0aWNhbGx5IGZvciB0aGlzIGRl
dmljZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEF0YSDEsGxoYW4gS8O2a3TDvHJrIDxhdGFpbGhh
bjIwMDZAZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODgvcGNpLmMgfCA5ICsrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9u
cygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3
ODgvcGNpLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5jDQo+IGlu
ZGV4IGEzMDQ2NzIyOC4uOWRmODk1NGQ4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnR3ODgvcGNpLmMNCj4gQEAgLTE3NzksNiArMTc3OSwxNSBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IGRtaV9zeXN0ZW1faWQgcnR3X3BjaV9xdWlya3NbXSA9IHsNCj4gICAgICAgICAgICAg
ICAgIC5kcml2ZXJfZGF0YSA9ICh2b2lkICopKEJJVChRVUlSS19ESVNfQ0FQX1BDSV9BU1BNKSB8
DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBCSVQoUVVJUktfRElT
X0NBUF9MUFNfREVFUCkpLA0KPiAgICAgICAgIH0sDQo+ICsgICAgICAgew0KPiArICAgICAgICAg
ICAgICAgLmNhbGxiYWNrID0gcnR3X3BjaV9kaXNhYmxlX2NhcHMsDQo+ICsgICAgICAgICAgICAg
ICAuaWRlbnQgPSAiTGVub3ZvIElkZWFQYWQgUzM0MC0xNElXTCIsDQo+ICsgICAgICAgICAgICAg
ICAubWF0Y2hlcyA9IHsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgRE1JX01BVENIKERNSV9T
WVNfVkVORE9SLCAiTEVOT1ZPIiksDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIERNSV9NQVRD
SChETUlfUFJPRFVDVF9OQU1FLCAiODFONCIpLA0KPiArICAgICAgICAgICAgICAgfSwNCj4gKyAg
ICAgICAgICAgICAgIC5kcml2ZXJfZGF0YSA9ICh2b2lkICopKEJJVChRVUlSS19ESVNfQ0FQX1BD
SV9BU1BNKSksDQoNClJlbW92ZSByZWR1bmRhbnQgcGFyZW50aGVzaXMuIA0KDQouZHJpdmVyX2Rh
dGEgPSAodm9pZCAqKUJJVChRVUlSS19ESVNfQ0FQX1BDSV9BU1BNKSwNCg0KDQo+ICsgICAgICAg
fSwNCj4gICAgICAgICB7fQ0KPiAgfTsNCj4gDQo+IC0tDQo+IDIuNTUuMA0KDQo=
