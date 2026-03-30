Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE93628C87C
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2026 03:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774841789; cv=none; b=M7zgMMKxE/kK3wN2YYzG6D5rIR4cf9JWK8pdMR0WENZw7yZ/kGowQBRvVBAUpglmmjeItxPs05iMkwdruX17AVp+emcaq1RjxW4y3rYndd1bbR22CL43/+JMYyjRMarfmcw555c1A2al48CRdhdOh56LR3buh6983fg+HH+iMBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774841789; c=relaxed/simple;
	bh=Ja3I0PudeAvMQ+OtQXouSDW72loSRi0A1Ekv/ugfSo8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DzGKVSGxW1ydAUwVHzyN6SVaBHzLRcfDd+IV5fgyuU5CmkUlCx5kmEwZuH5Jeu2NhFQcZMUB1hOPi7L4YQhlyFuIprZ2e2bfQIGgp+dKI3IVBOp8BhXaPOOsz0V8x0n4NC/28Pw6wfTXrYeJ9cb6jdqcTp5rFCVkz/ji8PwcTZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=b7qrKydi; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="b7qrKydi"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62U3aOq55259484, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774841784; bh=Ja3I0PudeAvMQ+OtQXouSDW72loSRi0A1Ekv/ugfSo8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=b7qrKydiLpiPKjlwaUrboHrNngyHk8lLqRl1UevQ2BGO4c1Kytxis9k4Kt47kZnBN
	 RNQasY1YS3X4PAa0s20R+Nl22EyHZWdc9US6wTboGqouE7T+qerlPK/HtJ1p9o7o2D
	 O9qXPzqerTCA3Pw1yRDOKtvH22Odj6k/PAYJmW10qiKnQj044v9//l5kt9P4rnBOf3
	 Zxlmt85ihS+0kDYWq4gvAgqhXndsRgOujRlwS7poGagv4bXSypEgpDS4W5lo5T91LS
	 uXoB4dTwZfpSoFT4XcHwpiQwBVh44anCDOjNMW1c4QlppFna8D0V18ddMZbE7b9BWF
	 zM+biKTfRju8g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62U3aOq55259484
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Mar 2026 11:36:24 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 30 Mar 2026 11:36:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 30 Mar 2026 11:36:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::46e9:fab9:b2cf:c99b%10]) with mapi id
 15.02.1748.010; Mon, 30 Mar 2026 11:36:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next 03/12] wifi: rtw89: Fix
 rtw89_usb_ops_mac_lv1_rcvy() for RTL8922AU
Thread-Topic: [PATCH rtw-next 03/12] wifi: rtw89: Fix
 rtw89_usb_ops_mac_lv1_rcvy() for RTL8922AU
Thread-Index: AQHcvUKn0qDtOgNVuEi5MI5Bh5/U1LXGcigA
Date: Mon, 30 Mar 2026 03:36:24 +0000
Message-ID: <c6866785902d4aabbd55139d13644838@realtek.com>
References: <8549233f-dd83-4e77-be88-5e22ecd4f5f1@gmail.com>
 <78bddba4-d87b-4081-b110-8ddf7fb48d93@gmail.com>
In-Reply-To: <78bddba4-d87b-4081-b110-8ddf7fb48d93@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBTZW50
OiBGcmlkYXksIE1hcmNoIDI3LCAyMDI2IDE6MDUgQU0NCj4gUlRMODkyMkFVIHVzZXMgYSBkaWZm
ZXJlbnQgcmVnaXN0ZXIgYW5kIG1hc2sgdG8gcmVzZXQgVFgvUlguIEFkZCB0aGVtDQo+IGhlcmUu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdt
YWlsLmNvbT4NCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0K
DQoNCg==
