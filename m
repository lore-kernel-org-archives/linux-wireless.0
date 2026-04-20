Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6904288C08
	for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2026 08:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674324; cv=none; b=JZcVP+b4aSYNMN9LJW92FH5sqoI2x0sp9D8I2rVbUuTu/6ytX7vCZdeUeNu+NIWLt8VZ5u+mslsbwiNpUaJlksClXlnH8RoG3f5QFnp1aSeSpwARa6RicTjhgqzOLPXbadn8A3oyzWKx0Up6Lr4bHn5EOtfRPyU+X0QLjUOn4bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674324; c=relaxed/simple;
	bh=xfprrJSGXE7STkoD2GJCftDB27mQ7aNsiPRQq1xw5S8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iEF/QDTFnDiNFQJXE8t7ZoRD0u+O4ttyKfAQnQixwiauJllCShmZRmThjk6W+TOggNbhV88jeVfSPzhY7VPK1otT5Noyg8vT2JuTLx0W57pJDQClBRnfes11ZZ69KtadiGZPiB6Bz1fZRegOG7oeYnUEUBfWLvjUViNqWpe0x64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qZwHIbW/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qZwHIbW/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63K8cdx57835816, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776674319; bh=xfprrJSGXE7STkoD2GJCftDB27mQ7aNsiPRQq1xw5S8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=qZwHIbW/rOoug3/wdgni5AfUYQywXyUb623ZZcAdjjNS6GZbB8NwbWePa53wn5ZnU
	 LjA8phh53aVCYvYBm1dnzg+H+5UrxZU9As9ZraofjlKjRiPfJ9jOaHMpO1DI5dpTTp
	 YpwpGxpCQd0KAQQMQtRiSshmTL1fCl2AXWjt3E9/zhIgeqCS+CDy99dIyjgwEEMjEv
	 DrAgLexiIoxnWQgOC/O5n10MV9KjDCNZ4P3j6lGg5rqznZdNvN6L6+U2ufPaxaZb5r
	 ybwV3ImknSywBBqxX3V/joK6dcME8VGP9s6mgyR0w85/1YgR3UudXdy/zaiDsswcgs
	 lrXX8005O+s+g==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63K8cdx57835816
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 16:38:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 20 Apr 2026 16:38:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458%10]) with mapi id
 15.02.1748.010; Mon, 20 Apr 2026 16:38:39 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 05/11] wifi: rtw89: usb: Enable RX aggregation
 for RTL8922AU
Thread-Topic: [PATCH rtw-next v2 05/11] wifi: rtw89: usb: Enable RX
 aggregation for RTL8922AU
Thread-Index: AQHc0AKTwuetZbDV+UyxUfqXI7aPSbXnogkg
Date: Mon, 20 Apr 2026 08:38:39 +0000
Message-ID: <a7bc641517f145879c971cdb7c426c72@realtek.com>
References: <6ba2910d-020c-41bd-86fa-d1b0e0f7a2f5@gmail.com>
 <bd9e444f-257c-48c8-8adb-f58432b2c5c2@gmail.com>
In-Reply-To: <bd9e444f-257c-48c8-8adb-f58432b2c5c2@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBJdCB1
c2VzIHRoZSBzYW1lIHNldHRpbmdzIGFzIFJUTDg4NTJDVSwgYnV0IHRoZSByZWdpc3RlciBhbmQg
Yml0IG5hbWVzDQo+IGhhdmUgIkJFIiBpbnN0ZWFkIG9mICJBWCIuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNvbT4NCg0KQWNrZWQt
Ynk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQoNCg==
