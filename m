Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E417E30C168;
	Tue, 25 Aug 2026 08:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787647780; cv=none; b=MKrE1ZuJbAiTwLdXv+Szsjbkv2bHUdF6DRfUf3CpzFg4kU3B7Cdwm46/7+TuxdVEjZLigIKp68uz8IahPr/49blyQTDH24XG8a2BHLqs5HdLHs59ccMLBzdMZYp18ZJXQlmi8gpmOFAfpCx7jsx9rNfiHl4HDng1aCto5Y/ciaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787647780; c=relaxed/simple;
	bh=NNP5V2edAL+oiVwyvggca4bNACAoaSGpXbPV9sqwxwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zfuai5FqqUV1TLsItPBG7L+/zRtUCpdpX0fu77fZQnnNuu95u3Yj6lZZqzlFQXUb0YhdKBf4svCMxAL5Vmp4tqorkeFbxl2LhEQxnC1PwrXVak8lUcAXgUjo1linkyMlZFpd7HiLNTYbja8475PXhTm4hbSz27A+RCRVQJW4W2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=AFym7r1X; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="AFym7r1X"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P8nNhV53645541, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787647764; bh=NNP5V2edAL+oiVwyvggca4bNACAoaSGpXbPV9sqwxwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=AFym7r1XI7IgNhrRZ5OzGu8KW2dRpOjvrbCkx7z+HBXUI7ey6+LNSWdVKSO7HpBxd
	 1FZqjZvL86IrqcdAWXdn/K+i0bQdcpDBaRsq3Do8kNtKGv3jxa6JSWMm86+66HKhYR
	 RnTUi3b7jUy7Juf365ZhP5zD/MbEj7OcipK+n6FGHU04hSyYpJcBm7DXhD7fgcEoEK
	 M8s/ZclSHV6ezSxAioQEKEDAvutbv1c7cdlVa42pINp9dlLOll5WR++fd3yxmXPHXc
	 +EzjuCCMpypOOIyNqEkdPJ5LlgfUr5Aa0Dt+4k89G4IfY/bMUOUWlEDaWhAXQRyr9m
	 /yOIfQqPd9nxg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P8nNhV53645541
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 16:49:24 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 16:49:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 16:49:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 16:49:23 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdMIL3twfMpykyCEyz233XfbbmBLauSXrw//+T44CAAIcCsP//fHmAgACKsPD//38FgAAQ/dzw//9+zgD//3kBYIAAifaA//95F/A=
Date: Tue, 25 Aug 2026 08:49:23 +0000
Message-ID: <5b9662c3a1ae4de9b5b725ae67898b53@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
 <20260820090412.19574-5-luka.gejak@linux.dev>
 <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com>
 <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev>
 <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com>
 <E2ACBF1F-1C98-4091-A851-E2D8AF006911@linux.dev>
 <68a844f5ea2b4eea827da95080a9dbcb@realtek.com>
 <E037DFDC-7C17-4537-810A-2D5DBFF4EECC@linux.dev>
 <5c6d6a1826334966a4f0893ad306fba4@realtek.com>
 <2776B724-A5C6-4068-BFB5-3F0EC981F650@linux.dev>
 <bb13c730fce14d7bbd54a3e5f7f21a2d@realtek.com>
 <971ADD2E-3336-473E-ADC9-1E16D32B416E@linux.dev>
In-Reply-To: <971ADD2E-3336-473E-ADC9-1E16D32B416E@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPbiB5b3VyIG90aGVy
IG1haWwgYWJvdXQgdGhlIGJhY2sgYW5kIGZvcnRoIGluIHBhdGNoIDY6IHlvdSBhcmUgcmlnaHQs
IGFuZA0KPiBwY2kuYyBpcyB0aGUgYmV0dGVyIG1vZGVsLiBJdCB0YWtlcyBpcnFfbG9jayBhcm91
bmQgdGhlIGNoZWNrIGFuZCB0aGUgc3RvcA0KPiBpbiBydHdfcGNpX3R4X3dyaXRlKCksIGFuZCB0
aGUgd2FrZSBzaWRlIHJ1bnMgaW4gcnR3X3BjaV90eF9pc3IoKSB3aXRoIHRoZQ0KPiBzYW1lIGxv
Y2sgYWxyZWFkeSBoZWxkIGJ5IHRoZSBjYWxsZXIsIHNvIHRoZSB0d28gY2Fubm90IGludGVybGVh
dmUuIFRoYXQgaXMNCj4gd2h5IHRoZXJlIGlzIG5vIHNtcF9tYiwgbm8gUkVBRF9PTkNFIGFuZCBu
byB1bmRvIGFueXdoZXJlIGluIHBjaS5jLg0KPiANCj4gSSB3aWxsIGRvIHRoZSBzYW1lIGZvciBT
RElPLCB1c2luZyB0aGUgdHhfcXVldWUgc3BpbmxvY2sgdGhhdA0KPiBza2JfcXVldWVfdGFpbCgp
IGFuZCBza2JfZGVxdWV1ZSgpIGFscmVhZHkgdGFrZSwgYW5kIGRyb3AgdGhlIGJhcnJpZXJzLA0K
PiB0aGUgX09OQ0UgYWNjZXNzb3JzIGFuZCB0aGUgcmUtY2hlY2sgZW50aXJlbHkuIFRoYXQgcmVh
bGx5IGRvZXMgY2hhbmdlIHRoZQ0KPiBsb2NraW5nLCBzbyBpdCBuZWVkcyByZXRlc3Rpbmcgb24g
aGFyZHdhcmUgYW5kIHY4IHdpbGwgZm9sbG93IG9uY2UgdGhhdCBpcw0KPiBkb25lLg0KDQpUaG91
Z2ggbG9ja3MgbWlnaHQgYmUgYSBib3R0bGVuZWNrIG9mIHBlcmZvcm1hbmNlLCB0aGUgY29kZSB3
b3VsZCBiZSANCm11Y2ggc2ltcGxlci4gU28sIHBsZWFzZSBtZWFzdXJlIHRoZSBwZXJmb3JtYW5j
ZSBpbXBhY3QgYWZ0ZXIgeW91IHJldmlzZQ0KdGhlIGZsb3cuDQoNClBpbmctS2UNCg0KDQo=
