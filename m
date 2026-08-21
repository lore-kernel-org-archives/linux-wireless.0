Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDEE2798F8
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 00:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787272229; cv=none; b=XZkwkJ2ybJuYTPyOqwx1tSEMV7p3r9gKvVYNzB5CIEAMCzscqjzjh/9pBmlCoRUahDys4EVrR4wHl98tfA6NMNPuse7hZRa26p4r+7LRLX1fiN/ojAHZCHF+r6+4gDalQ9pwWCxpHJKQNuyFGSE7kLGI9fufgZgJT/bbkNtYpNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787272229; c=relaxed/simple;
	bh=YgsmKIGVyiKk5ow4xBnymoqky1HeOY17xzDoQELSY+Q=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kEPl+SetQ3HAJnTPu3hSQvBR5JFgysAN9Nvn+wWyXqoFJ1FpkeEkxqJFVwnbrR4/I8U3izASjAnJvcVDcq5E4P9GGk2S6Dwilew7zMmaLIjM1PQzkW8EvMaPtOCJnmsC7BU6yPu1iaZlh+tBn4wL3QDFEokYBXaHPnU6Pq7EEyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ntD6qaBF; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ntD6qaBF"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67L0UMhzC3932933, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787272222; bh=YgsmKIGVyiKk5ow4xBnymoqky1HeOY17xzDoQELSY+Q=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ntD6qaBFATrRwvhqtMmqseKL1GZUjjY7NSsEW0zF2MpDLN867twaJw1+hUgJiyiQs
	 3nFoB6qVwwbJLL1JlnGrnqHd80/PmcWlxLqGD6lX1puRyl+nCeghSu9mxdtpDwq/yr
	 HkTvbQhHw+gjjewJmJcJ6ngjBrrjm8kALN4oEg0LpnSDGL3WOVBQTgrJRtK/R3qV+e
	 VCiVgIs14+Vf40TXbyplF34md29C7uiXnvaGtJJ8mt5lFb5nojg4Cc2Q49Fk8Kxe8L
	 LGElLnS0F8pRSsIF7jht8fhwtyLwSXm2PsqcGLw6eVsRxDMjH3RFzL7t0lR/4qs6fU
	 JI6lQKiIkcJrg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67L0UMhzC3932933
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 21 Aug 2026 08:30:22 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 21 Aug 2026 08:30:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 21 Aug 2026 08:30:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 21 Aug 2026 08:30:23 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2] wifi: rtw89: usb: Avoid crash with
 dynamically added device ID
Thread-Topic: [PATCH rtw-next v2] wifi: rtw89: usb: Avoid crash with
 dynamically added device ID
Thread-Index: AQHdMBYxl19Tb19PckyM5Pg10lEJmLanqD/Q
Date: Fri, 21 Aug 2026 00:30:22 +0000
Message-ID: <6230956f25584d59a97442ed12d280fd@realtek.com>
References: <7a537b2e-67d2-40fb-8ef2-fcbc7bbc93af@gmail.com>
In-Reply-To: <7a537b2e-67d2-40fb-8ef2-fcbc7bbc93af@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBBZGRp
bmcgYSBkZXZpY2UgSUQgdmlhIHN5c2ZzIGNhdXNlcyBhIGNyYXNoIHdoZW4gdGhlIGRldmljZSBp
cyBwbHVnZ2VkDQo+IGluLCBiZWNhdXNlIHRoZSBkcml2ZXJfaW5mbyBwb2ludGVyIGlzIG51bGwu
DQo+IA0KPiBDaGVjayBmb3IgbnVsbCBkcml2ZXJfaW5mbyBpbiBydHc4OV91c2JfcHJvYmUoKSBh
bmQgYWRkIGEgd3JhcHBlciBpbg0KPiBlYWNoIGRyaXZlciB0byBwYXNzIGl0IGEgcmVhc29uYWJs
ZSBkZWZhdWx0IHZhbHVlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQml0dGVyYmx1ZSBTbWl0aCA8
cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hp
aEByZWFsdGVrLmNvbT4NCg0KDQoNCg==
