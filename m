Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554010;
	b=owbtLyhI69TzQWBnwlOt+UoJtQ+sp4KhohMAnFhCj9e94KPMxE/AW9tztQr5FtxlXFFi
	 V0k7ZSUIc11AvCKrsomV43NH/G9dAhC9Km9ylMb9Yt41kIV42S3Oom345ZNGhbDl1aXeI
	 DATgEvVNC7UM8sVAL6W8FylENoP8zaNxcPfoILcJlMI9VwnamL/SSeXISHN3p/coVFK6j
	 GutTSxfjJO31wHFIV4u59O9m+MdShXfR+ftNx+Dicd59hH/7MiyfsrVZxLGowakz57g23
	 zhYSdW6lJErYLzk7jsDYyRbS3L/26fFuLugkEURJA6gdmlr3qIk2MfQBwNgLaCN9FXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554010;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=FfQQEMbyrF5rcn92XS9RQAeKTebEk3n7FWpQPrLRQ2E=;
	b=q64XuylnR5moKsm84Dw6Lvc0PXjJdvNXnNwzk3izWUxN0Z8IhhmswPSmcs5gNGIouWBz
	 d43+y4TIo6GRODH8tKuKJip9GHHblxDFrwHaQIzNzzHXusi13Gy5XYIZPmmmQoObFWYgp
	 fqarXgc6RaN1+RnR3utmfDtMKc5SUUaBx+j1/HKM40Nm7L2UAooFlH6nNlhBn6rnM/Bv+
	 kgc8CvE4acTr7McdDrXzQ67g6U0tktFsglaJBIhNpuKHt2/oFXSWNhwrQiuBJft5Nkhn6
	 dFBpXIJ2urWIjNpzvpYF0hMTaFrgMh6uZbWdEofXX+6BFhBv3ANkpX5GESF6V+7Ucqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=glySPskp;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE87606A31B
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 03:40:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFE87606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=glySPskp
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69L3drkvF3666854, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792553993; bh=FfQQEMbyrF5rcn92XS9RQAeKTebEk3n7FWpQPrLRQ2E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=glySPskpIdcwBYR68I3BRTuj+O76t9uetAn0oQkEY1eljv8XDJ/EFZcA7FY184Mfj
	 7bNG29XN2JgZosJIQfXVupi4G0XcNNZU/aKtu7sRtneLLi98wr1RfcQy4Bk6XmCMnZ
	 oWtFwPUsLbr2obVx6ok/21MKVme2wLnuCrG8cd2d9HN8OxPy+DR00E41ry49IBWn1F
	 qmbiLvauhmYDPpFdbZv4NOD63fVV9Vki1lYWKiDmkrIjnT0Jj/ITa8rMPguqlrm5RG
	 +GGakzFD0i8Ogg1l612hDaW2IpwF4lnUuvJf5MsuYJodoGwqCaVuPxGIpCk07JNWSs
	 ercvGgF4SASyw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69L3drkvF3666854
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Oct 2026 11:39:53 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 11:39:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 11:39:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 21 Oct 2026 11:39:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Luka Gejak <luka.gejak@linux.dev>
Subject: RE: [PATCH rtw-next v2 1/3] wifi: rtw88: Pass the physical map to the
 read_efuse chip op
Thread-Topic: [PATCH rtw-next v2 1/3] wifi: rtw88: Pass the physical map to
 the read_efuse chip op
Thread-Index: AQHdYNSrcXbRgTZ6tUibPx2RsYB/5bcHWePQ
Date: Wed, 21 Oct 2026 03:39:53 +0000
Message-ID: <aa2523762f5f4b19abad7d2dd159302c@realtek.com>
References: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
In-Reply-To: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBydHc4
NzIzYl9yZWFkX2VmdXNlKCkgd2lsbCBuZWVkIHRvIHJlYWQgYSBieXRlIGZyb20gdGhlIHBoeXNp
Y2FsIGVmdXNlDQo+IG1hcCwgc28gcGFzcyB0aGUgbWFwIHRvIHRoZSByZWFkX2VmdXNlIGNoaXAg
b3AuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUy
QGdtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29t
Pg0KDQo=
