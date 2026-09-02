Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8F12EFDA4;
	Wed,  2 Sep 2026 03:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788320575; cv=none; b=t9zdnyx/MhidwhC7iKQB7ibHM6c52rJFo2s/j1qoC4UoPgI/biDOxTIVv3wIgopkgbwsxoTT4WIVcjiQNHyHmueSxTafLmkLLqkHQ6dsn+sf3jYHhn5aLiSX/qrrgpm59BIQhbwMT+uxWe3JoAlmFhDeGVKplk6XGVDgJc+znqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788320575; c=relaxed/simple;
	bh=I97Rm5RU/Ehx80EPFmzwBvE0g1YGt2KEAYgFcX1Lwrg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=MRZvsKxy1N0C51/t3nnfUevUVSAm4+OnGUZaKe0MaGkeYJljdcAVNvy37KMWMM/+6T8FDitDiYEV6L6lvsB3B2BJSsLuK27QqS30icTploC0VZLZ+lctmjprh41QHuXIumbg8frFOPVXiw+U0DYkezFFFCUQOwo4uiwcjA4Xzco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KgwubGeA; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KgwubGeA"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6823gmytF2287240, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788320568; bh=I97Rm5RU/Ehx80EPFmzwBvE0g1YGt2KEAYgFcX1Lwrg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date;
	b=KgwubGeAQz98zOLNwZrP/0eVOUQ9NNEL4Yc9K+izxiGf/tGKU5VRZGyaa3Db+z4pr
	 0dpW9Jvyc6gyV02HHGFOQ2QfjYic/2q6VhzgCBnlwN/oWuxPWRJCbTplqqpijcSeDU
	 OUrkvW5/SqbrKhataxEz/ZkAJoXV4+JWl1eEJ4QRv87TySmIAPHuYI2vZpWt85rDgR
	 //UjGCetM1POl+n5tvpJw6n3EPLGDE0ymDggKhRg37/1ZmPIWovu5w0a4t1qHCaDPw
	 bMT9NZN366lekCuCbR7peqrcB9PXOVeql1h5JcCkq/dxMO5KsKNusm2KH5e4MQ/RyE
	 cOLQzGdUix43Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6823gmytF2287240
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 11:42:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 11:42:49 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 11:42:48 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 11:42:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: =?utf-8?b?QXRhIMSwbGhhbiBLw7ZrdMO8cms=?= <atailhan2006@gmail.com>,
	<pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	=?utf-8?b?QXRhIMSwbGhhbiBLw7ZrdMO8cms=?= <atailhan2006@gmail.com>
Subject: Re: [PATCH v2] wifi: rtw88: disable ASPM for Lenovo IdeaPad S340-14IWL
In-Reply-To: <20260823094640.22585-1-atailhan2006@gmail.com>
References: <20260823094640.22585-1-atailhan2006@gmail.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Message-ID: <21b34014-a046-4a4a-948b-6d955c57cb5f@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 2 Sep 2026 11:42:42 +0800

PT91dGYtOD9iP1FYUmhJTVN3YkdoaGJpQkx3N1pyZE1POGNtcz0/PSA8YXRhaWxoYW4yMDA2QGdt
YWlsLmNvbT4gd3JvdGU6Cgo+IFRoZSBMZW5vdm8gSWRlYVBhZCBTMzQwLTE0SVdMIChETUkgcHJv
ZHVjdCBuYW1lICI4MU40IikgZXhwZXJpZW5jZXMKPiBzZXZlcmUgY29ubmVjdGl2aXR5IGlzc3Vl
cyB3aXRoIHRoZSBSZWFsdGVrIDg4MjJCRSBydHc4OCBQQ0llCj4gd2lyZWxlc3MgY2FyZCB3aGVu
IEFTUE0gaXMgZW5hYmxlZC4gUmVwb3J0ZWQgc3ltcHRvbXMgaW5jbHVkZQo+IGZyZXF1ZW50IGRp
c2Nvbm5lY3Rpb25zLCBjYW5ub3QgcmVzdW1lIGFmdGVyIHNsZWVwLCBrZXJuZWwgcGFuaWNzLAo+
IGFuZCB0aGUgZHJpdmVyIGZhaWxpbmcgdG8gbG9hZCB0aW1lIHRvIHRpbWUuCj4gCj4gVGhlIGlz
c3VlIGNhbiBiZSB3b3JrZWQgYXJvdW5kIGJ5IGVpdGhlciBhZGRpbmcgcGNpPW5vYXNwbSB0byB0
aGUKPiBrZXJuZWwgY29tbWFuZCBsaW5lIG9yIGJ5IHJlbG9hZGluZyB0aGUgZHJpdmVyIHdpdGgg
ZGlzYWJsZV9hc3BtPTEKPiB2aWEgbW9kcHJvYmUuIEFkZCBhIERNSSBxdWlyayB0byBkaXNhYmxl
IEFTUE0gYXV0b21hdGljYWxseSBmb3IKPiB0aGlzIGRldmljZS4KPiAKPiBTaWduZWQtb2ZmLWJ5
OiBBdGEgxLBsaGFuIEvDtmt0w7xyayA8YXRhaWxoYW4yMDA2QGdtYWlsLmNvbT4KPiBBY2tlZC1i
eTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+CgoxIHBhdGNoKGVzKSBhcHBsaWVk
IHRvIHJ0dy1uZXh0IGJyYW5jaCBvZiBydHcuZ2l0LCB0aGFua3MuCgo1M2VlYmQyYjdmM2Ugd2lm
aTogcnR3ODg6IGRpc2FibGUgQVNQTSBmb3IgTGVub3ZvIElkZWFQYWQgUzM0MC0xNElXTAoKLS0t
Cmh0dHBzOi8vZ2l0aHViLmNvbS9wa3NoaWgvcnR3LmdpdAoK
