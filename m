Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5BB355F5F;
	Thu,  8 Oct 2026 04:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791434104; cv=none; b=mrP54xJ/LcHaDXFXwDOEaJBj+oahu9XBYuQv4xEYWon6eY2Zgo5JIdwOZnn+gNj+fcBGb19qXmCsTO/BvXx7TFHW1cCA81lTYpJ0ZSJgPAD+ykWcltNd3LLSBft5ihdvuEicnXzwBkd2XYM/LTHzXcrAilipWKj9ycN/bYc6myc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791434104; c=relaxed/simple;
	bh=42gXeZg5DDyZlcKy0d0F3QLbzvEzFn0qBS8hOLI2xsE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RDZnyNi0/KgmBeL7+WpgFYGp2TAVJPdmNtvJM/4MSMMTOHUUhjGF1gQOlTRIn4fw+nEDfpWpkhHvqPa/ssi9Qy2sCRCYiGcHnvpzLFfWcP9RoJSWMhF6KkufibLnQKQQbvu0wzCw1+q/CLVIzc4GeewcF7vgy/WAD70MLgb6kZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=bY6LM+rD; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="bY6LM+rD"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6984YntY6183222, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791434089; bh=42gXeZg5DDyZlcKy0d0F3QLbzvEzFn0qBS8hOLI2xsE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=bY6LM+rDcocKDonsHAvxLzqbI0Cb13ASdXnr/3+1LppzHkbRDZM7Hpr9rAWCpVUs0
	 b2eMPlueoCXIfu6xKiILgyKjGHZYxn34wjvwCSq2EvnOwYVZrVrz3231HSPQQSeWG1
	 OVO/6DV/8QIVqVPiJM5FQxIZeF5a8b7OCaMo3we2Y8CsZ8/M4NEQ73zBTJZX/sKys/
	 5t8oH9f4eEVWa33nTQnztxIYdWTSG7rtRUkf3VA9kxwf6dlAwkGTjOjntW6iw+dxx3
	 mvLiidfkj6C1VQ3zL4SvW6vYPOoRIUxVgrktDPlgCLULYYFoOUbDwZxzx5Kdj3n9mP
	 izJuFOIijdvvA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6984YntY6183222
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 8 Oct 2026 12:34:49 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 12:34:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 12:34:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 8 Oct 2026 12:34:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>
Subject: RE: [PATCH] staging: rtl8723bs: remove the obsolete driver
Thread-Topic: [PATCH] staging: rtl8723bs: remove the obsolete driver
Thread-Index: AQHdVkalu7rVOKHvFUSCtbyjdv6EJ7bzCdeg
Date: Thu, 8 Oct 2026 04:34:49 +0000
Message-ID: <7e53bd59b7b146caabebeca4347674c7@realtek.com>
References: <20261007102819.19904-1-luka.gejak@linux.dev>
In-Reply-To: <20261007102819.19904-1-luka.gejak@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBSVFc4OCBub3cgc3Vw
cG9ydHMgUlRMODcyM0IgZmFtaWx5LCB2aWEgcnR3ODcyM2IgZHJpdmVyIHdoaWNoIGhhbmRsZXMN
Cj4gUlRMODcyM0JTLCBzbyB0aGUgc3RhZ2luZyBkcml2ZXIgaXMgb2Jzb2xldGUuIFJlbW92ZSBp
dCB0b2dldGhlcg0KPiB3aXRoIGl0cyBLY29uZmlnIGFuZCBNYWtlZmlsZSB3aXJpbmcuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4NCg0KMSBw
YXRjaChlcykgYXBwbGllZCB0byBydHctbmV4dCBicmFuY2ggb2YgcnR3LmdpdCwgdGhhbmtzLg0K
DQpjNTIwZjNhZjdkZjQgKCJzdGFnaW5nOiBydGw4NzIzYnM6IHJlbW92ZSB0aGUgb2Jzb2xldGUg
ZHJpdmVyIikNCg0KLS0tDQpodHRwczovL2dpdGh1Yi5jb20vcGtzaGloL3J0dy5naXQNCg0K
