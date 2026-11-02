Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793603718;
	b=EEqp4P2e6xYDrCj2qA8p0QcvIAVLuvoh4MeVNEn+NVxOSgHr9XcKXnfYnfd9ciMBeYm8
	 PpJ9ILvficoM8tZEdUMmEDIPXF/9fxKOomh1ld+GkoExNTdLkRN7Xei16u49EURyI7RRS
	 GYP15MODbILkqEdK766ICPeinBcrPMc5DcqQ64QCwU3ziRyhPFa+jLscuZKdHf9EuAwvi
	 CSE2H0MgrB/iacP+Z2Offmcz/LjaIsMoQ+BrR3gl5HsmQ3gbvk1VKKR9wD5/ZMcxaRJZR
	 0u1MZOE/eSPEtraHSst2i4wjfHKvCf7V6KXuzCLM9n57GQLjdSCK7tPJJyklSIaSLhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793603718;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=H0OdelCUrdARXfo49e/aXaVDBrk2jFhqmdb9SdEOuqU=;
	b=CeDmm6vUVMxCkk2tBkdJKEaKPO18GHS6tppOdUeXGSlVSQjRqIew2wCXU5XX/2X/MPyL
	 cU3HNL7xqK6DW4t91QjmjlMhi1178FkS1tNh3JWCNxBZbxA9n+BhurRcGD+tmwBwmeoLU
	 93Wfa3RSTZzLlp6r1sV/lzGmO4P9nvgDKJn3UI6XmPGdH2Gm0w3yZ8tl4LW59AAZIdO5W
	 OqL62xWpD/SNTGcF38QX/BtBP4czxp0kfVDIK+aid9UqC1+mCWkDjisLO9WARGvbRBXw+
	 Li10prJsFq9CvBlNvU9Lf+WbH5nVI6w+ku4K1MV5bayOVlN7Lh0lftTakuk2NVEN48g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=HxqAdGwq;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63908606A330
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 07:15:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63908606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=HxqAdGwq
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A27FCjzC1954627, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793603713; bh=H0OdelCUrdARXfo49e/aXaVDBrk2jFhqmdb9SdEOuqU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HxqAdGwqmoZKsA6qcCp8R0kGlITH2PgDgwa3DlCu5tu+HcZzIQD4YaKyNLF+hdceC
	 BJCjBs8eeEVlIvUxB+VL2dMJuTuoNn3uq6g289AEApu2vnZB/fPRX8xAElt6i6H0fm
	 VVsg9Hd+cu5XY4jIH2IxooaIGs/rFmcY4Xs/NVfpHmKcg770qKiupyDmf+n9bwGdEC
	 hwj2uRTVdwW3+sTdpFxsuv7gtvQsGSfdzqa5z+PqqZqCD6vUciagLnB+5Xbd1oV6lK
	 9hOCbgGNFtp+VrdYMVaU1fYVLvw3rDK5i247rdyodLAToDs8P66mNcanyGzi+qFj8q
	 m367B5BlqLXfQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A27FCjzC1954627
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 15:15:12 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 15:15:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 15:10:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Mon, 2 Nov 2026 15:10:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hyeon Woo Bae <yoursanstv@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: rtw88: question about RTL8812F (8812FR) support
Thread-Topic: rtw88: question about RTL8812F (8812FR) support
Thread-Index: AQHdapdUKRhjZNEF2EaZxuxLiUxUpbcaXIFw
Date: Mon, 2 Nov 2026 07:10:12 +0000
Message-ID: <0a81982f89ff4e4f9d1757b4fc06e4b3@realtek.com>
References: <CAAATUifZVZjjNm_sLqshpc8uwAawnDNivysacCYuVgVfF2x7Eg@mail.gmail.com>
In-Reply-To: <CAAATUifZVZjjNm_sLqshpc8uwAawnDNivysacCYuVgVfF2x7Eg@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

SHllb24gV29vIEJhZSA8eW91cnNhbnN0dkBnbWFpbC5jb20+IHdyb3RlOg0KPiBIaSBQaW5nLUtl
LA0KPiANCj4gSSBhbSB3b3JraW5nIG9uIGFuIE9wZW5XcnQgcG9ydCBmb3IgYSByb3V0ZXIgYmFz
ZWQgb24gdGhlIFJUTDgxOTdGIFNvQy4NCj4gSXRzIDUgR0h6IHJhZGlvIGlzIGFuIFJUTDg4MTJG
UiAoMTFhYyAyeDIsIFBDSWUpLg0KPiANCj4gQXMgZmFyIGFzIEkgY2FuIHRlbGwsIHJ0dzg4IGFu
ZCBydHc4OSBkbyBub3Qgc3VwcG9ydCBSVEw4ODEyRiwgYW5kIEkNCj4gY291bGQgbm90IGZpbmQg
YW55IHB1YmxpYyBzb3VyY2UgZm9yIGl0LiBUaGUgdmVuZG9yIGZpcm13YXJlIG9uIHRoZQ0KPiBy
b3V0ZXIgb25seSBjb250YWlucyBhIGJ1aWx0LWluIGJpbmFyeSBkcml2ZXIuDQo+IA0KPiBJIHdv
dWxkIGxpa2UgdG8gYXNrOg0KPiANCj4gMS4gQXJlIHRoZXJlIGFueSBwbGFucyB0byBzdXBwb3J0
IFJUTDg4MTJGIGluIHJ0dzg4Pw0KDQpuby4NCg0KPiAyLiBJZiBub3QsIHdvdWxkIFJlYWx0ZWsg
YmUgb3BlbiB0byBhIGNvbW11bml0eSBjb250cmlidXRpb24/IEluIHRoYXQNCj4gICAgY2FzZSwg
Y291bGQgdGhlIGZpcm13YXJlIGJlIG1hZGUgcmVkaXN0cmlidXRhYmxlIHZpYSBsaW51eC1maXJt
d2FyZSwNCj4gICAgYW5kIGlzIHRoZXJlIGEgcmVmZXJlbmNlICh2ZW5kb3IgZHJpdmVyIHNvdXJj
ZSBvciBhIHNpbWlsYXIgY2hpcCBzdWNoDQo+ICAgIGFzIDg4MjJDKSB0aGF0IEkgc2hvdWxkIGJh
c2UgdGhlIHdvcmsgb24/DQoNCkknbSB3b3JraW5nIG9uIE5JQyBXaUZpLCBidXQgUlRMODgxMkYg
aXMgdXNlZCBieSBBUCByb3V0ZXIsIHNvDQpJIGRvbid0IGtub3cgbXVjaCBhYm91dCB0aGF0LiBT
b3JyeS4gDQoNClBpbmctS2UNCg0KDQo=
