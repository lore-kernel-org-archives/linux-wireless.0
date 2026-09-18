Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B3749A3B0;
	Fri, 18 Sep 2026 07:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717241; cv=none; b=OysZkwqIL3FUcqFuleQId95/CeP4RemBpjrg9OtI7ft0wfFef1RD+PJkKshYO1OzdC0+8MSrIwCL8zLh1NoVeuJ5JYcVe3cfDNqSDPy1GcLzNinxeDjSyRomenL3YgHmXZFXuMjFh7bLineL+ZNuSYtvB5EfJTcsyESJfAQfwiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717241; c=relaxed/simple;
	bh=R5eAOw5agXhL6LvsyKA+l2oSQNGlXSQo1YB4yQvemj4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qjODKtWaW9GXoUp52PEfyMiAVz3OzdPhDasvtlUCnwKWMCR6RdUJBgtZf/FZmT2ViRusIAja9qEdn+ST5M8UOzU9WxzPtD20ecj+r3kg6wFiQO+MwceNv6Lmbr10KPeiv/kzNugxcf7iVzmjimuuklnfgJvB04QLCrjdQ+wknUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=X7YkYcs5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="X7YkYcs5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68I7eJigD3993411, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789717219; bh=R5eAOw5agXhL6LvsyKA+l2oSQNGlXSQo1YB4yQvemj4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=X7YkYcs5Y+J2SH3XRxzxlX41KFyk3BKFv4n4gBCY540fiXB7qkrzlbfsTWd9H0tV6
	 UIz52pLgHWBx5tqC0q8iHYM7LKHNJiwtCAOrk9bhGWIIRV8iu+ODMtWgPqvYAkzxWA
	 s7dHbe7t+dZr3H4WXl0CN8xFbWA80sQp6gj/zup9WKU2W99Gox1KRbokisaHLgUVaq
	 N/DUCvruhrC3xmGL0r+DvMpzpKzglLwULgWr8Zzq2evOM+q/DKtIi6GFJRrAHQQm8a
	 o4iJSAEJFRST1pA/z6kWk0+Etf0wFvRpVMwg03gaBneleRDOMjOQtz+lSD9n3gstz9
	 0vhQobpeY3E0g==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68I7eJigD3993411
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 18 Sep 2026 15:40:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 18 Sep 2026 15:40:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Fri, 18 Sep 2026 15:40:18 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "5mghybrid@khu.ac.kr" <5mghybrid@khu.ac.kr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Jes Sorensen <Jes.Sorensen@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 0/4] wifi: rtl8xxxu: keep RX requests
 available across transient errors
Thread-Topic: [PATCH rtw-next v2 0/4] wifi: rtl8xxxu: keep RX requests
 available across transient errors
Thread-Index: AQHdQ1I2mDA7fbdcWkGpZktVmj75ArbT+qhQ
Date: Fri, 18 Sep 2026 07:40:18 +0000
Message-ID: <ca51eb88df7b4e83993af73c2f1e26bb@realtek.com>
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
In-Reply-To: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
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

a2ltd29vc2VvayB2aWEgQjQgUmVsYXkgPGRldm51bGwrNW1naHlicmlkLmtodS5hYy5rckBrZXJu
ZWwub3JnPiB3cm90ZToNCj4gLSBSVEw4MTkyRVUgb24gUmFzcGJlcnJ5IFBpLCBrZXJuZWwgNi4x
OC40Ni10aGVzaXMtdGVzdC1ydCs6IDEzLzEzIGNhc2VzDQo+ICAgcGFzc2VkIHVzaW5nIGEgY29t
cGF0aWJpbGl0eSBiYWNrcG9ydC4gDQoNCkZvcmdvdCB0byBhc2sgd2hhdCB0aGUgMTMvMTMgY2Fz
ZXMgbWVhbj8gVGhlIGt1bml0dGVzdCBpcyAxMSBjYXNlcyB0aGF0DQp5b3Ugd2lsbCBkcm9wLg0K
DQoNCg==
