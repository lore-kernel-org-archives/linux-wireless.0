Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526481DD0EF;
	Sun, 13 Sep 2026 02:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789267798; cv=none; b=cwCAl0rwh1gLHtOUZPQdSbo+vZ4tt62XYxujVzQBBG07ECeh1wCFwt9hJBPLp9rQ0eUfnWf5lkdsDDi26tcnYOFRBzlIdkXgJnr5tV3Vx0/imb8XHoXZY/rgh9MVQl8f7l8uHLz516lbRj6DuSOqwOpRC0NTdkCBUeKwcVUTWVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789267798; c=relaxed/simple;
	bh=I889TwsaWKAQxhdCSZc8QRqWu87gxwdtz42D0HI4RHo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A4KjfecciaZau2JmfPNrlhEhAimKQQrcMX8i/CEo10gJGbkK7h10CxTRs3VJAuisch9cSc1ZWdVyRNBx5FkWbkXqBYVqGMgKf1KIW5xx1h1UqESdbUc+hcTXB/3EW9bzJtuRo6Pfb7kcNcRm5DUXG2GnxfDIFQ5JzjLjgsoKw38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CeX4Giz5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CeX4Giz5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68D2n9Kw93607801, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789267750; bh=I889TwsaWKAQxhdCSZc8QRqWu87gxwdtz42D0HI4RHo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=CeX4Giz5HTesJ0gvAA+ks968t7zuFR03exeP4QeshAtFAsXfZNDlwIyHUlsyqC2qF
	 mrpUD7YUHta2qO+MBMuBxIzIXHeqZ74q27JDtGz90nQVlB80W6gSNhKPbXdjN1HqO3
	 VjlugQvGPnoBX9uHo35/dDSXjSinXCvtJxk/EWBoeLR/vLipeU6ypm5mhnvVLwatSW
	 L+T35aAULveYDZhJ5gaS+FtlNEL5CAuBS4lYGQIK2HmAxl0W85TOGkYyXzKnfNRvxI
	 13qH1+sLfsXk70ZBHpxySnULen6H+I2NrtAHBSfkHptxQW7Ksnh0JJVBFdxBfN3D52
	 XLCAeTR99Be0Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68D2n9Kw93607801
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 13 Sep 2026 10:49:09 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 10:49:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 10:49:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 13 Sep 2026 10:49:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Cristian Deluxe <me@cristiandeluxe.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] wifi: rtw88: 8703b: stop the PCIe DMA write reaching
 SDIO
Thread-Topic: [PATCH 2/2] wifi: rtw88: 8703b: stop the PCIe DMA write reaching
 SDIO
Thread-Index: AQHdQgqtELsK+81IkES8TDaZraWRNbbLz6JA
Date: Sun, 13 Sep 2026 02:49:09 +0000
Message-ID: <47279427012044d4afab9b0e76c03ce4@realtek.com>
References: <178914109042.64584.1681714272474754544@cristiandeluxe.dev>
 <178914109042.64584.11316164845616306056@cristiandeluxe.dev>
In-Reply-To: <178914109042.64584.11316164845616306056@cristiandeluxe.dev>
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

Q3Jpc3RpYW4gRGVsdXhlIDxtZUBjcmlzdGlhbmRlbHV4ZS5kZXY+IHdyb3RlOg0KPiBUaGUgZmly
c3QgZW50cnkgb2YgdHJhbnNfYWN0X3RvX2xwc184NzAzYiB3cml0ZXMgMHhmZiB0byBNQUMgcmVn
aXN0ZXINCj4gMHgzMDEgb24gZXZlcnkgaW50ZXJmYWNlLiBUaGF0IHJlZ2lzdGVyIGlzIHRoZSBQ
Q0llIERNQSBjb250cm9sLCBhbmQNCj4gYm90aCB0cmFuc19hY3RfdG9fbHBzXzg3MjNkIGFuZCBS
ZWFsdGVrJ3Mgb3duIDg3MDNiIHNlcXVlbmNlIGhlYWRlcg0KPiByZXN0cmljdCB0aGUgc2FtZSBl
bnRyeSB0byBQQ0ksIHdoZXJlIGl0IGlzIGNvbW1lbnRlZCAiUENJZSBETUEgc3RvcCIuDQo+IA0K
PiBTbyBvbiBhbiBSVEw4NzIzQ1MsIHdoaWNoIGlzIFNESU8gb25seSwgZXZlcnkgdHJhbnNpdGlv
biBpbnRvIGxvdyBwb3dlcg0KPiBwb2tlZCBhIFBDSWUgcmVnaXN0ZXIgZm9yIG5vIHJlYXNvbi4g
UmVzdHJpY3QgaXQgdGhlIHdheSB0aGUgc2libGluZw0KPiBjaGlwIGFuZCB0aGUgdmVuZG9yIGJv
dGggZG8uDQo+IA0KPiBUZXN0ZWQgb24gYW4gUlRMODcyM0NTIG92ZXIgU0RJTzogdGhlIGludGVy
ZmFjZSBnb2VzIGRvd24gYW5kIGJhY2sgdXAsDQo+IHJlYXNzb2NpYXRlcyBhbmQgdGFrZXMgYW4g
YWRkcmVzcywgYW5kIGEgd2FybSByZWJvb3QgYnJpbmdzIFdpLUZpIGJhY2sNCj4gd2l0aCBubyBj
aGFuZ2UgaW4gYmVoYXZpb3VyLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ3Jpc3RpYW4gRGVsdXhl
IDxtZUBjcmlzdGlhbmRlbHV4ZS5kZXY+DQoNCkNoZWNrZWQuIFRoZSBzZXR0aW5ncyBhcmUgaWRl
bnRpY2FsIHRvIHZlbmRvciBkcml2ZXIuDQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hp
aEByZWFsdGVrLmNvbT4NCg0K
