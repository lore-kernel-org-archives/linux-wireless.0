Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770132E737E;
	Thu, 17 Sep 2026 01:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789607966; cv=none; b=GMOvEPFU/Fb2lS976fPCe+eSsthe+vno59C7jcIc2tCN26f9PvpVjguxuVmRWqHOjAtJ0dFIZaq8VX/tgcNSyv5E5ovbs/tU/nwwFo0rUGo9Dd0At5yfTe5D9cFzqpNILr+9akk6H0ABg4H75VR0Y0A8Km7STzXnkmnks3yu/p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789607966; c=relaxed/simple;
	bh=vZR3spMFjMRLPqMDvKKt4CDJ4eAGxnrRrjdclCNYlbg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HTXGKCdyCEi7Jg25XCEDK6QPPf9icTe9OSxTkAHPg5JWqHTmOR1Nn0dEitfievM3uF+AqLna18UPhurwgGKygHfg6L3OZGApuZR4Gyt3ohq9Be7HEvIHZYiv/q4k8Wk3tjyqCAJ0LE9JbrtW+VHdtVvmbrkJbo6xsFMVdEMfP6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=JLWEcMo3; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="JLWEcMo3"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68H1JJRi82881999, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789607959; bh=vZR3spMFjMRLPqMDvKKt4CDJ4eAGxnrRrjdclCNYlbg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=JLWEcMo3JGfQxmsMkmBlxGO3zXzIP0c7kGdbHdwOK8g7xy3butYUMN9oD2q/8FNMx
	 eGH5xgNhU3VU2/2sniZAVKMqfUvUsvb2zqNoK2zZWTS5kLt5DakarGVUEg0vtFlejy
	 ZLLd4zRG6tY7CmnvxgyyapjiYeVcqwIClSFV210zkDP45Wl/YZFjX/LMozzfKhMP7u
	 vNbaztgwYTH/76ZajdaugSTyduZY4Nr3LnBeMfHJngNX5iQLhucNj1zpokM6nL5/Nn
	 kMSCToX+JrT7mk7sU8PVT+6qrEOlWd6GyEyml7QlownSbfB9mRjGwja9l9m5IUo3w5
	 zeHuVK+0AZpBA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68H1JJRi82881999
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 17 Sep 2026 09:19:19 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 09:19:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 09:19:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 17 Sep 2026 09:19:18 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: kimwooseok <5mghybrid@khu.ac.kr>, Jes Sorensen <Jes.Sorensen@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH wireless 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Topic: [PATCH wireless 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Index: AQHdQvXIGvF0I1VmF0mL7Gmxnqj2RLbR/JqQgAACSQA=
Date: Thu, 17 Sep 2026 01:19:18 +0000
Message-ID: <25ce622248254cefbb3226fda18df6ff@realtek.com>
References: <CAH1Bc_wBUmmNyzF3c2H1aFBRBbAPSw0hR=1MnPOAcCXypVL_Dg@mail.gmail.com>
 <CAH1Bc_xSxOrEUjx11NtTE9Y6WVitF8K0mVws8s3623C8O=Lpkw@mail.gmail.com>
 <0b970cf2ade94c569eab459ca996acab@realtek.com>
In-Reply-To: <0b970cf2ade94c569eab459ca996acab@realtek.com>
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

UGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiBraW13b29zZW9rIDw1
bWdoeWJyaWRAa2h1LmFjLmtyPiB3cm90ZToNCj4gPiBBIGZhaWxlZCBSWCBVUkIgc3VibWlzc2lv
biBjYW4gbGVhayB0aGUgc2tiIGFsbG9jYXRlZCBmb3IgdGhhdCBhdHRlbXB0Lg0KPiA+IHJ0bDh4
eHh1X3N1Ym1pdF9yeF91cmIoKSBhbGxvY2F0ZXMgdGhlIGJ1ZmZlciBhbmQgc3RvcmVzIGl0IGlu
IHVyYi5jb250ZXh0LA0KPiA+IGJ1dCBpZiB1c2Jfc3VibWl0X3VyYigpIGZhaWxzLCBpdCBvbmx5
IHVuYW5jaG9ycyB0aGUgVVJCLiBUaGUgUlggd29ya2VyDQo+ID4gcXVldWVzIEVOT01FTS9FQUdB
SU4gZmFpbHVyZXMgZm9yIHJldHJ5IHdpdGggdGhhdCBidWZmZXIgc3RpbGwgYXR0YWNoZWQuDQo+
ID4NCj4gPiBPbiB0aGUgbmV4dCBhdHRlbXB0LCBydGw4eHh4dV9zdWJtaXRfcnhfdXJiKCkgYWxs
b2NhdGVzIGFub3RoZXIgc2tiIGFuZA0KPiA+IG92ZXJ3cml0ZXMgdXJiLmNvbnRleHQsIGxvc2lu
ZyB0aGUgcmVmZXJlbmNlIHRvIHRoZSBwcmV2aW91cyBidWZmZXIuDQo+ID4gU3RvcHBpbmcgYmVm
b3JlIHRoZSByZXRyeSBhbHNvIGxlYWtzIHRoZSBidWZmZXIgYmVjYXVzZSBwZW5kaW5nLXJlcXVl
c3QNCj4gPiBjbGVhbnVwIGZyZWVzIG9ubHkgdGhlIFVSQi4NCj4gPg0KPiA+IEZpeCB0aGUgbGVh
ayBhdCB0aGUgc3VibWlzc2lvbiBmYWlsdXJlIGJ5IG1ha2luZyBydGw4eHh4dV9zdWJtaXRfcnhf
dXJiKCkNCj4gPiByZXNwb25zaWJsZSBmb3IgYm90aCBhbGxvY2F0aW5nIHRoZSBza2IgYW5kIHJl
bGVhc2luZyBpdCB3aGVuIHN1Ym1pc3Npb24NCj4gPiBmYWlscy4gRnJlZSB0aGUgbmV3bHkgYWxs
b2NhdGVkIHNrYiBhbmQgY2xlYXIgdXJiLmNvbnRleHQgYmVmb3JlIHJldHVybmluZw0KPiA+IHRo
ZSBlcnJvciwgc28gbmVpdGhlciByZXRyeSBub3Igc3RvcCByZWNlaXZlcyBhIHBlbmRpbmcgVVJC
IHRoYXQgc3RpbGwNCj4gPiBvd25zIGEgYnVmZmVyLiBSZW1vdmUgdGhlIGNhbGxlci1zaWRlIHNr
YiBjbGVhbnVwIGZyb20gc3RhcnQgYW5kIHRoZSBSWA0KPiA+IHdvcmtlcjsgdGhvc2UgY2FsbGVy
cyBub3cgaGFuZGxlIG9ubHkgd2hldGhlciB0byByZXRyeSBvciByZWxlYXNlIHRoZSBVUkIuDQo+
ID4NCj4gPiBGaXhlczogMjZmMWZhZDI5YWQ5ICgiTmV3IGRyaXZlcjogcnRsOHh4eHUgKG1hYzgw
MjExKSIpDQo+ID4gQXNzaXN0ZWQtYnk6IEdQVC02IEFzdHJhDQo+ID4gU2lnbmVkLW9mZi1ieTog
a2ltd29vc2VvayA8NW1naHlicmlkQGtodS5hYy5rcj4NCj4gDQo+IENhbiB5b3UgZ2l2ZSB5b3Vy
IHMtby1iIG1vcmUgZm9ybWFsPyBMaWtlLCBLaW0gV29vLVNlb2s/DQo+IA0KPiBSZXZpZXdlZC1i
eTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+IA0KDQpJZ25vcmUgdGhpcy4g
SSBzaG91bGQgcmVwbHkgdjIuDQoNCg0K
