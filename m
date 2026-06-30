Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24194238C2A;
	Tue, 30 Jun 2026 07:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782805891; cv=none; b=Qy3K5kwZf16akqs0UoBFc/fP4Hhvn6vzibVg/fnyan3PXl320oqfULrbsQbJQc+mLc3ymagOAIX4P34zBl37+I1ACQaWFf0zvSfSddtlhaTZJsv4I5bswFUeH5gUO1DM3nKL3lKitn2LcM9z09PUZ8U4FdLYkdmnkewkwtPTwb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782805891; c=relaxed/simple;
	bh=rZYlV7Ds2CrRKdeeclsHWTEoVGnqDPyOGYZA0gLWXG8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qsz/DN2XpW6v7KIp24xggTebEzVKMP4CE17DoPh2VIay4u/VlQ1lUnEfKapnzF5CbfM6tabrEUDc8zYZQalYcmysV9bHt8ovNDLKrId0tDKxZr5jGky5FMI++qc0INC+fHQU5yijpB0fUeNVjzrHi/SQr2UxTO/86+raEDGWKh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MUVXJV8c; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MUVXJV8c"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65U7pOQz9126317, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782805884; bh=rZYlV7Ds2CrRKdeeclsHWTEoVGnqDPyOGYZA0gLWXG8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=MUVXJV8cn7ervuIxqHdXWouBcANXxBtqe+jN+TdyOxnkC7/crfyNiKKB09U2x/PHa
	 6WmQp5ElO/GII2w9ZgyrXmiuZz7XwNriXPzbFLIky1jNW6u/P6XntiW99aU4IGRHMY
	 oyijbDjebCMtsDspvZ4k2SffpZdUIscdbnu/ZQAb8AioGVc+gN6TQHnsl5h/X5l2gw
	 xHd8JliW0hfG2VOE5yhtnb07kne/w25uPQkGGJSg5IlrYXou9l8IW/jhFtUN4CJ41l
	 yoEgzxwfNnNf1NHqkqj4XTPg7OQ6EEky352B9PI4CAoTJVcxRqTnqwSenuRAhE1Mgx
	 rng1gtdfDEicA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65U7pOQz9126317
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 30 Jun 2026 15:51:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 30 Jun 2026 15:51:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 30 Jun 2026 15:51:20 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Tue, 30 Jun 2026 15:51:20 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: fix HE extended capability length check
Thread-Topic: [PATCH] wifi: rtw89: fix HE extended capability length check
Thread-Index: AQHdCGJ4BLcsi3L6jEau+WqrvJTnz7ZWuUHw
Date: Tue, 30 Jun 2026 07:51:20 +0000
Message-ID: <a5160eb1f66f4e15986b1990adba9d09@realtek.com>
References: <2026063009025530.2-ccfa108-0024-wifi-rtw89-fix-HE-extended--pengpeng@iscas.ac.cn>
In-Reply-To: <2026063009025530.2-ccfa108-0024-wifi-rtw89-fix-HE-extended--pengpeng@iscas.ac.cn>
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

UGVuZ3BlbmcgSG91IDxwZW5ncGVuZ0Bpc2Nhcy5hYy5jbj4gd3JvdGU6DQo+IFNlbnQ6IFR1ZXNk
YXksIEp1bmUgMzAsIDIwMjYgMzoyOCBQTQ0KPiBydHc4OV9tYWNfY2hlY2tfaGVfb2Jzc19uYXJy
b3dfYndfcnVfaXRlcigpIHJlYWRzIGV4dGVuZGVkIGNhcGFiaWxpdHkNCj4gYnl0ZSAxMCwgYnV0
IHJlamVjdHMgb25seSBkYXRhbGVuIHZhbHVlcyBiZWxvdyAxMC4gIEJ5dGUgMTAgcmVxdWlyZXMg
YXQNCj4gbGVhc3QgMTEgYnl0ZXMuDQo+IA0KPiBSZXF1aXJlIGRhdGFsZW4gPj0gMTEgYmVmb3Jl
IHJlYWRpbmcgZGF0YVsxMF0uDQo+IA0KDQpJJ2QgYWRkIGEgRml4ZXMgdGFnOg0KDQpGaXhlczog
OGQ1NDBmOWQyOTE2ICgid2lmaTogcnR3ODk6IGRpc2FibGUgMjYtdG9uZSBSVSBIRSBUQiBQUERV
IHRyYW5zbWlzc2lvbnMiKQ0KDQo+IFNpZ25lZC1vZmYtYnk6IFBlbmdwZW5nIEhvdSA8cGVuZ3Bl
bmdAaXNjYXMuYWMuY24+DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVr
LmNvbT4NCg0K
