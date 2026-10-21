Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554152;
	b=rDbzxURUdJMqF2kyr9A9/6gn2+1WTnnS9UCzt7bMzYw1nXW0j9dD/BR0fFyK07sABja+
	 UUaidjVSgwuS1/GX5zfS70/zTqLbLEO7eeb+/uBRejAjjklM2P+1eyoy2TLkTySWhHcDq
	 Z+u+h4Cd9mr6dO4k5fSpDoNHbYWUXPOleXsL78k0EaJiXzXsqccNBUiZMJzlYeVNsWQvM
	 V07Zeiox2WsWyAewknFgpfH04tyLNIjbmZVYsKedco+fT39KiQXW9z0TILHNpMeOC9v43
	 a5MYqw6efTmYduEhAJlVou4kUBXKkpHyRo7SfeVV3AI8MVU3Wq5PyTWfw3rEro/0+7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554152;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=+EqM0HIJea0n/sZ/MAtCpcdgZP6SUgTpAZnI98xF2JA=;
	b=3cUyEEZfH7HjDEh4nff+VME6V5HxNkXbZFAHYU5lGRqo5a6kI1Z/Xgc4TFLxrU7jGS9c
	 nziev5ykGpV8RLW+29lrHmJaiqVmNYkUyQhBhrKZ4XZL8RoNpYTdqn68wI6BXVTI3azwg
	 L6PkJgCHuu3ziVfQboysGhXtCw3/h5Yspk84pyKMDRH+c1SVObZjkDK8GfG+5PCfk+gwZ
	 1ZBeFp1u8thQ3K/YyX1z+A6Jl2od2lvihOZvWj0m6GzasZpBRQwf9KHiO/Ee2q0QiFkLM
	 xbBqnfCI27wFomXD+BO3ZtAvKxAzh1nfhJ0gAzsjCT0sWKKsasHv5gd/cOhg/Fq0hZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=sd5Ykvx8;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02504606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 03:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02504606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=sd5Ykvx8
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69L3gIxdD3667641, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792554138; bh=+EqM0HIJea0n/sZ/MAtCpcdgZP6SUgTpAZnI98xF2JA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=sd5Ykvx8mcFaOb35AJWiGnGcUn0D2auT/gTtMkGT1ZcYMGdSLfAoLDamKXRJE+f56
	 B+/++T1WD/TAsCJn7R6o8RWGkLJ8SG5vUSHFmokBN2FgOxI+P+lK5n/qu/LQ4uCPDa
	 32vZwiwgyZ6/QANH3YwfspxK3/CXT0T2Be3UDTA6wswgJ6Wx2BXpfIYbvxcnpvwvZn
	 gahlEdiRyZvp7XYwLYxz/LtDz1qwOige8XcOuUO3FXjVDT1hqSYJCWpQSRg5YDoDMj
	 MrAYFboAzSsY7gj8eDQwvFmEXxo2CGd4KnC1+CQPZ5OOyqPfykcvOpy6O+CV5FzbVe
	 qC1y7BCH2nEvQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69L3gIxdD3667641
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Oct 2026 11:42:18 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 11:42:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 11:42:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 21 Oct 2026 11:42:18 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Luka Gejak <luka.gejak@linux.dev>
Subject: RE: [PATCH rtw-next v2 2/3] wifi: rtw88: 8723b: Read the package type
 from efuse
Thread-Topic: [PATCH rtw-next v2 2/3] wifi: rtw88: 8723b: Read the package
 type from efuse
Thread-Index: AQHdYNTYFJL5XJ9OaUa92VlYNG2HB7cHWpFw
Date: Wed, 21 Oct 2026 03:42:18 +0000
Message-ID: <cdd66dcf96bf48acb09b013f53ac835f@realtek.com>
References: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
 <2d1f9c05-4837-4c62-ba27-4275d2cc5d0c@gmail.com>
In-Reply-To: <2d1f9c05-4837-4c62-ba27-4275d2cc5d0c@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBTb21l
IGNoaXAgcGFja2FnZSB0eXBlcyBuZWVkIGRpZmZlcmVudCBwYXJ0cyBvZiB0aGUgUkYgaW5pdGlh
bGlzYXRpb24NCj4gdGFibGUsIHNvIHJlYWQgdGhlIHBhY2thZ2UgdHlwZSBmcm9tIGVmdXNlLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFp
bC5jb20+DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0K
