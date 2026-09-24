Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA46E26AE5;
	Thu, 24 Sep 2026 01:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790214156; cv=none; b=aQm6RHrTTB9I0B/Mn16/YKx40swlsZm3hTlXKIlLn2FA1/UL/TQOG/wXO3ETbv10eONHqpD/SdvhLATF7hEYbtztxcWjp1h3Ky1GUVszefqsrEqksdWtizNPWGZ7zh1mxTaHBvYUFvoATgUvyasWgXQ63cq9w2M0v6YPadPVd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790214156; c=relaxed/simple;
	bh=txf8k/HApzXCcO6ciim6t23YezU4r8X1PAYXIfyNCjQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P6hm601FOEAOlyCMRP2ouUgSocK2dXEVe8xnCJ4E6oEE+hBoFNoXDOV88auGhP/UokBhi6j0mYNpC///S2IHQpRVTcyI1IcaQw0Jh7RM8gJZ69CMEjXGpsbhIalSEpPGiBUUQi+KC1wioKZfQr5PxFusr1pPuj7FzMdnkIOv/qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=S8eWmvzf; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="S8eWmvzf"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68O1g73s9792050, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790214128; bh=txf8k/HApzXCcO6ciim6t23YezU4r8X1PAYXIfyNCjQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=S8eWmvzfv6g+gLj9rdXTKwgRiLbyD68SMjEDBzd8aBSWyHOUEfwkPlJZUX0hSAw1q
	 KnhHIGIdU6UZo3696N9ko1TY6TlIfPMQ45M3YtS589N9KJULj5x1okDckHoI1PDqRE
	 XRVWa5Obn7ZDG87BOPIFfwdTwqgefA3PdObVzaQ+9D9fQ4qISCouok0KfrJEFk9V46
	 cLHwCDRDgTbRmiPPg5U2laavZcvtFGAIzsw9gAEyEp41zXmaY8csN1kSUio39HgElR
	 9mOqt2k7uIMQ+CqpLDYPyqT4cq67TbHaG5W528oMUX4krUcgk02vMx4OsJUiOtVJEe
	 SONkUKelmNcbw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68O1g73s9792050
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 24 Sep 2026 09:42:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 24 Sep 2026 09:42:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 24 Sep 2026 09:42:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 24 Sep 2026 09:42:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
   Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
Thread-Topic: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
Thread-Index: AQHdSeAeQzf2/kHhyEaOG4CaLogmfLbYsc0AgAAGuQCAABezgIAASM4AgAAWAACAAI0MQP//gOSAgACGXzD//4BkgIADs1qQ
Date: Thu, 24 Sep 2026 01:42:07 +0000
Message-ID: <5458e6c0dca04e9dbbdc5b714d150252@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-7-luka.gejak@linux.dev>
 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
 <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
 <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
 <bcd5a280-8184-4457-ae52-47a9e0fe763c@oss.qualcomm.com>
 <ffe834a8a469d5febb7e73de371d662f9a0d115f@linux.dev>
 <fe3c6884a96b476799f415a06314f1ba@realtek.com>
 <c419df59280e52baa5e25f665eff599592f3cdff@linux.dev>
 <2694defa2e284ee894005c59197325a0@realtek.com>
 <a4339de07daae1d3ad274067006ed6dfc021434d@linux.dev>
In-Reply-To: <a4339de07daae1d3ad274067006ed6dfc021434d@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiA+DQo+ID4gSW4gZmFj
dCwgZXZlbiB5b3UgYXJlbid0IGluIGxpc3Qgb2YgTUFJTlRBSU5FUlMsIHlvdSBjYW4gc3RpbGwg
cmV2aWV3DQo+ID4gcGF0Y2hlcy4gSnVzdCBzdWJzY3JpYmUgbGludXgtd2lyZWxlc3MgbWFpbGlu
ZyBsaXN0IChJIHRoaW5rIHlvdSBkaWQpLA0KPiA+IGFuZCByZXBseSBwYXRjaGVzIHlvdSBoYXZl
IHJldmlld2VkLg0KPiANCj4gSSB3b3VsZCBwcmVmZXIgdG8gYmUgbGlzdGVkIGFzIGEgcmV2aWV3
ZXIgYmVjYXVzZSBhcyBzdWNoIEkgYW0NCj4gQ0MnZCBvbiBlYWNoIHBhdGNoIGZvciBydHc4OC4g
SSdtIG5vdCBzdWJzY3JpYmVkIHRvIHdpcmVsZXNzDQo+IG1haWxpbmcgbGlzdCBhcyBsaW51eC5k
ZXYgc2VydmljZSBwcm92aWRlZCBieSBsaW51eCBmb3VuZGF0aW9uDQo+IHN0YXRlcyB0aGF0IHdl
IHNob3VsZG4ndCBzdWJzY3JpYmUgdG8gaGlnaCB2b2x1bWUgbGlzdHMuDQoNClRob3VnaCB5b3Ug
b25seSB3YW50IHRvIHJldmlldyB0aGUgcGF0Y2hlcyBmb3IgcnR3ODgsIHN0aWxsIHN1Z2dlc3Qg
dG8NCnN1YnNjcmliZSB3aXJlbGVzcyBtYWlsaW5nIGxpc3QuIE90aGVyd2lzZSwgeW91IHdpbGwg
bWlzcyB0byByZWFkIHNvbWV0aGluZw0KZGlzY3Vzc2VkIGluIG90aGVyIHBhdGNoZXMuIA0KDQpQ
aW5nLUtlDQoNCg==
