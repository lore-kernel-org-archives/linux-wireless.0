Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EAB1E492D;
	Tue, 18 Aug 2026 00:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787013002; cv=none; b=f8LhpgaQY2HfMKDSe+5Qk60UXPDLs7uxkztkB6gcL5hFmsBLhs8DX9l7VkQR9BCaesyz7mDnYfLOUJg8cUOHiSst9JH6c+nWMOWhRwOHJ3cgyOwVZ9mJDkAaRZud99wqOwNBYot8CUyXmlmowkm6z3g8jvuHqxFsXspu5TNwNUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787013002; c=relaxed/simple;
	bh=ztKljwXrbXPlGT1VoLYt6mcmJXR7lCs9Jhz77xF4kwQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IRJMw+G/LP8xGeStuB8j/KPEIG0elhHU9L5PUABMd3UEowm9zEtwAczLRlWGP30AghFqek0DjMscj5wd+h51FySZyYznMCPrUdxx8iDxeWSWCDKfSok4OSy9Sn0Yq/MnIuucGKqS/OlExnv+4OJWj/xk5yhNSSP73luk5Duze9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Edyu2QZ3; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Edyu2QZ3"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67I0Ts7bA313476, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787012994; bh=ztKljwXrbXPlGT1VoLYt6mcmJXR7lCs9Jhz77xF4kwQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Edyu2QZ3zGpQntHqvS9yDmMJuXykmdvegoqliCm7ZCIt3m3MMjwWI1IQwcPxaEDEJ
	 15tV2+M+7lmmu8T+nefR9qOt9AZ6TuqLuS6fN5rQVhgqJyOuybU7yenWD3sZUCones
	 Ll000LKzvwMN20IwjdlutL0s1pgPd0U9XScp180xeqCFuk2dmRA5xDzomUKi8FoxDD
	 K0GSNI2Uo1At1AkhXe155Vcb8/AhzuYld7b5F0/QMitWaG9bFXJXDl+1PQ+z0tkOFM
	 N0M3A1D0s2X/CNBo5BesAP5fysDwuHJfMZvQgoU4KZe0xKc7mWBuipZNYlQBfkFTdT
	 lh35Q6LzKLHEA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67I0Ts7bA313476
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 18 Aug 2026 08:29:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 18 Aug 2026 08:29:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 18 Aug 2026 08:29:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 18 Aug 2026 08:29:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: =?utf-8?B?UmFmYWVsIEFsZWphbmRybyBEw61heiBDcnV6?= <rafad900@gmail.com>
CC: "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Topic: [PATCH v2] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Index: AQHdLgiHVkEs16CGAkyT0LtmQvZ3HLah6MhggABglgCAAKtxAA==
Date: Tue, 18 Aug 2026 00:29:54 +0000
Message-ID: <86ac3ac02e834eeabc60ebb5b5d85612@realtek.com>
References: <20260817052250.358796-1-rafad900@gmail.com>
 <f6efe2a8bf464a3cb4e53fdac161f6e7@realtek.com>
 <CALp66yFJCwBEwwP3wf25VEuvYBpuDSdeidyuvbpUtbvizP_3SQ@mail.gmail.com>
In-Reply-To: <CALp66yFJCwBEwwP3wf25VEuvYBpuDSdeidyuvbpUtbvizP_3SQ@mail.gmail.com>
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

UmFmYWVsIEFsZWphbmRybyBEw61heiBDcnV6IDxyYWZhZDkwMEBnbWFpbC5jb20+IHdyb3RlOg0K
PiBIZWxsbyBQaW5nLUtlLA0KPiANCj4gVGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbnMgc28gZmFy
LiBJJ20gdHJ5aW5nIHRvIGZpbmQgdGhlIHJ0dy1uZXh0DQo+IHRyZWUgZ2l0Lmtlcm5lbC5vcmcg
YnV0IEkgY2FuJ3Qgc2VlbSB0byBmaW5kIGl0LiBXb3VsZCB5b3UgYmUgYWJsZSB0bw0KPiBwcm92
aWRlIHRoZSBsaW5rIHNvIHRoYXQgSSBjYW4gcHVsbC9mZXRjaCBmcm9tIGl0IHBsei4NCj4gSSBm
b3VuZCB0aGlzIGxpbmssIGJ1dCBJJ20gbm90IHN1cmUgaWYgaXRzIHRoZSByaWdodCBvbmUgOg0K
PiBodHRwczovL2dpdGh1Yi5jb20vcGtzaGloL3J0dy90cmVlL3J0dy1uZXh0DQoNClllcy4gRm9y
IHRoZSByZWNvcmQsIHRoZSBnaXQgdHJlZSBvZiBydGw4eHh4dSBpcyBsaXN0ZWQ6DQoNClJUTDhY
WFhVIFdJUkVMRVNTIERSSVZFUiAocnRsOHh4eHUpDQpNOiAgICAgIEplcyBTb3JlbnNlbiA8SmVz
LlNvcmVuc2VuQGdtYWlsLmNvbT4NCkw6ICAgICAgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwu
b3JnDQpTOiAgICAgIE1haW50YWluZWQNClQ6ICAgICAgZ2l0IGh0dHBzOi8vZ2l0aHViLmNvbS9w
a3NoaWgvcnR3LmdpdA0KRjogICAgICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bDh4
eHh1Lw0KDQpQaW5nLUtlDQoNCg==
