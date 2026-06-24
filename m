Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8792E401
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 00:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782262413; cv=none; b=TvrkHDYR7WKGRR0mm3CHPMNdHm0Eyy2pj0+hCfaGkZJH1NYJTZYtB2ff4adKXLqYTRz8v6SNk5uExs5DvvxuLS67pQFgtX2qPu2nOQu5mDTaQj6Fle21F2kPprklpJM3ce1JK2ZO/7YKMsfC5TUMACYXYn1b5CpY5rQsNp3MtUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782262413; c=relaxed/simple;
	bh=JXU7sP1PB753Y4WmvB7/ApVv95Tk1ZzoHn17OSWbphE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CBHQrPoCZHBoDxfuz11RsYC90K2QOsFnKo6qcIb1DDzO737RdYNpbXSNXaDPqIG+19svdFUs9A7BzVv4ujMJ3B+2Qch3CAuLbtZUcZVJeDQQC/jCu5GFND2FJ2F2N6b9eNV75m28eVrx9/zV0GLrgidw2HBHVEyVaSngkADqy6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=sxnMJYK6; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="sxnMJYK6"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65O0rL3f93798734, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782262401; bh=JXU7sP1PB753Y4WmvB7/ApVv95Tk1ZzoHn17OSWbphE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=sxnMJYK6exBAV6GUkds6VenXcqyoSToGF2mMn6TzzJ0txzHLI94kJc10B7Q2Qr8VD
	 VlcAnZnnVtV/dA6LguBLr17cYsazDSn6SeLTob91KFWU/MPmw0UoplZucuByjcBKIo
	 sD9XqDUbhfNRgbenRyghZliWhkWlIJSQRa/lQd2y/PRtIupyEatoD76Z8gUrgDlmFA
	 zYQD3CSXOFVksEzZOKQMIe5jcTzUZtEasF3mrhsH9u6ur55FhxbjIWUES4DLfy8251
	 PUYfYXueQEWcT1utlPF1XsFS9PahhpKRWgbKJXXr6OIAzgU+OV8sFBmfOP9mtdQiiF
	 ZNh8BhoL7YCeQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65O0rL3f93798734
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 24 Jun 2026 08:53:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Jun 2026 08:53:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Wed, 24 Jun 2026 08:53:21 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: =?utf-8?B?R2VvcmcgQmnDn2VsaW5n?= <georg.bisseling@sea-gmbh.com>
Subject: RE: [PATCH rtw-next] wifi: rtw88: Enable receiving control frames in
 monitor mode
Thread-Topic: [PATCH rtw-next] wifi: rtw88: Enable receiving control frames in
 monitor mode
Thread-Index: AQHdAmj1TAcJ9FrazUmywt1BNrR//LZLT9zwgABbjoCAATRJcA==
Date: Wed, 24 Jun 2026 00:53:21 +0000
Message-ID: <f7443fed187f48aa94f54a6f38615f56@realtek.com>
References: <2a52d718-9e46-47f2-84a1-d8e7b1ed89a8@gmail.com>
 <7f12ff0969754a9fa4d78b0ae3d2409e@realtek.com>
 <3445ca1b-2d5a-43ae-9df1-d3f6440fae78@gmail.com>
In-Reply-To: <3445ca1b-2d5a-43ae-9df1-d3f6440fae78@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+Pg0K
PiA+PiBTaWduZWQtb2ZmLWJ5OiBCaXR0ZXJibHVlIFNtaXRoIChTLkUuQS4gRGF0ZW50ZWNobmlr
IEdtYkgpIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNvbT4NCj4gPg0KPiA+IE9uY2UgeW91IG1pZ3Jh
dGUgdG8geW91ciBjb21wYW55IG1haWwsIG1heWJlIHlvdSBjYW4gYWRkIGFuIGVudHJ5IHRvIC5t
YWlsbWFwLA0KPiA+IHdoaWNoIG9ubHkgYWZmZWN0cyB0aGUgb3V0cHV0IG9mIGdpdC1zaG9ydGxv
ZyB0aG91Z2guDQo+ID4NCj4gDQo+IFNlZWluZyB0aGUgY29tcGFueSBuYW1lIGluIHBhcmVudGhl
c2VzIHdpdGggbm8gZXhwbGFuYXRpb24gbWFrZXMgeW91DQo+IHRoaW5rIEknbSBwYXJ0IG9mIHRo
ZSBjb21wYW55LCBkb2Vzbid0IGl0PyANCg0KSSBtaXN1bmRlcnN0b29kIHRoZSBtZWFuaW5nLg0K
DQo+IEJ1dCBJJ20gbm90LCB0aGV5IGp1c3QNCj4gc3BvbnNvcmVkIHRoaXMgcGF0Y2g6DQo+IA0K
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNTAyMDMxNzQ2MjYuMTEzMTIyNS0xLWt1
YmFAa2VybmVsLm9yZy8NCg0KVGhhbmtzIGZvciB0aGUgbGluay4gDQoNCg0K
