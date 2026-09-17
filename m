Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2036D3B42D6;
	Thu, 17 Sep 2026 07:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789631560; cv=none; b=n3ITDsGkq5A2Ao/xItXDxyNsjTa4x3Cr36n26GhwrMSyGpmw7vB/DI1mr7wqD2pPqLVub+QTu5mJSHVCCisEAY0OUFeuHjKms2tDBbifm3ON6IBQSAoWxbnJo3GZO719cKfaGjqLl2nBF2ZdfM+e/Biz1b4FhiKvd9V8xFwXGQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789631560; c=relaxed/simple;
	bh=OXK8/9w9cheZCOXJr5vqhqui6g3bHdsoK8EFFdGDNJs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KEvSw4hYmtHkhf8Dgm6M2r1urjWH2+6LcrFyoFghjjOvCtXVntByF5tIleoSJ4yr8/sC/gr4yA5B7e4XxBGGbFASUsh+Xkl2WqVC/ZBYmpEltoOKBMcWXdWG0Uk01axu4EW/czLHFl1ByKQ5lhpMNU13aBYvcMyoSyjx95TLhHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=fxpRd7wR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="fxpRd7wR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68H7qVQa93114411, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789631552; bh=OXK8/9w9cheZCOXJr5vqhqui6g3bHdsoK8EFFdGDNJs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=fxpRd7wRD53vNe2kujb+3IWpW9Pirlqxp3NZZQlOEtH9yw0uOJBv5t3ozSYQ6w0ZL
	 zJDgyvEeQJ1CsahvTcYwgVZWuj8jwBe8c3Y9b5WiNBJr2O7wUXeDvcKYDi3IANhY9O
	 FlKAKemZgD2Uek7zWbhHUDFlXMDOstTEh9j06K1FD/iReM13jGP3M3ImIvCz414LIC
	 niLyZAV1dsB4xPmelmjAe7sIF4Da6x/OIwa2oGj7DU8QON/epC13+pW+p+LloGvO+P
	 SHV6mkdBzM6JRCMfb7grb6Kqhy39zwixNILtptSqKsocwsBpqO0BEoTAfMlu5yKnlw
	 ePtldQF63eHMg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68H7qVQa93114411
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 17 Sep 2026 15:52:32 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 15:52:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 15:52:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 17 Sep 2026 15:52:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: =?utf-8?B?4oCN6rmA7Jqw7ISdW+2VmeyDnV0o7KCE7J6Q7KCV67O064yA7ZWZIOyghA==?=
 =?utf-8?B?7J6Q6rO17ZWZ6rO8KQ==?= <5mghybrid@khu.ac.kr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Jes
 Sorensen" <Jes.Sorensen@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 3/4] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Thread-Topic: [PATCH rtw-next v2 3/4] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Thread-Index: AQHdQ1IzihV6w9HjIUGWB4VYUBvLcbbSJYBw//+6RQCAAIsaIA==
Date: Thu, 17 Sep 2026 07:52:30 +0000
Message-ID: <bcbeef2a98ce411299a7ff97ac9626af@realtek.com>
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
 <20260913-codex-rtw-rx-v2-v2-3-f09c964e0b96@khu.ac.kr>
 <2b956e6e0c5945e596d5825ace0c6203@realtek.com>
 <CAH1Bc_ybPZtieaMkuUdbpv-STvJTqTxbFZgVbifNdbADt21C9Q@mail.gmail.com>
In-Reply-To: <CAH1Bc_ybPZtieaMkuUdbpv-STvJTqTxbFZgVbifNdbADt21C9Q@mail.gmail.com>
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

DQrigI3quYDsmrDshJ1b7ZWZ7IOdXSjsoITsnpDsoJXrs7TrjIDtlZkg7KCE7J6Q6rO17ZWZ6rO8
KSA8NW1naHlicmlkQGtodS5hYy5rcj4gd3JvdGU6DQo+IA0KPiBJJ2QgbGlrZSB0byBrZWVwIHRo
ZSByZXRyeSBsaXN0IGFuZCBkZWxheWVkIHdvcmsgc2VwYXJhdGUgZnJvbSBub3JtYWwNCj4gcGVu
ZGluZyByZXF1ZXN0cywgdGhvdWdoLiBQdXR0aW5nIGZhaWxlZCByZXF1ZXN0cyBkaXJlY3RseSBv
biB0aGUgbm9ybWFsDQo+IHBlbmRpbmcgbGlzdCBjYW4gbGV0IG5vcm1hbCBjb21wbGV0aW9ucyBi
eXBhc3MgdGhlIGVycm9yIGJhY2tvZmYsIHdoaWxlDQo+IGRlbGF5aW5nIHRoZSBzaGFyZWQgc3Vi
bWlzc2lvbiB3b3JrIGNhbiBhbHNvIGRlbGF5IHJlcGxlbmlzaG1lbnQgb2YNCj4gbm9ybWFsIFJY
IHJlcXVlc3RzLiBLZWVwaW5nIHRoZSB0d28gbGlzdHMgcHJlc2VydmVzIHRoZSBleGlzdGluZyBu
b3JtYWwNCj4gUlggc2NoZWR1bGluZyB3aGlsZSByZW1vdmluZyB0aGUgZHVwbGljYXRlZCBxdWV1
ZWluZyBjb2RlLg0KDQpJIHRoaW5rIHRoZSByZXRyeSBsaXN0IGlzIHRvIHJlc29sdmUgcmVzb3Vy
Y2UgdGVtcG9yYXJpbHkgdW5hdmFpbGFibGUsIHJpZ2h0Pw0KSWYgc28sIHRoZSBub3JtYWwgcGVu
ZGluZyBsaXN0IGNhbiBhbHNvIGVuY291bnRlciBpZiBpdCBpbW1lZGlhdGVseSByZXF1ZXN0cw0K
dGhlIHJlc291cmNlLg0KDQpNeSB0aG91Z2h0IGlzIHRvIHVzZSBhIGZsYWcgKGFzIGZ1bmN0aW9u
IGFyZ3VtZW50KSBmb3Igbm9ybWFsIHBlbmRpbmcgbGlzdCwNCmFuZCBtYWtlIGEgZGVsYXkgYmVm
b3JlIGl0IHJlc2NoZWR1bGVzIHRoZSB3b3JrLiANCg0KSSdtIHRyeWluZyB0byBhdm9pZCB2ZXJ5
IHNpbWlsYXIgY29kZS4NCg0KUGluZy1LZQ0KDQo=
