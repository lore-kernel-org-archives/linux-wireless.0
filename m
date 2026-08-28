Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125F7370D61
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 09:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909503; cv=none; b=iEDArdrmOc2/4Bf3zU4qwzXrUh9lg1fMP0Y5x/hB4jd6FYl6r8UqGmULvY+glLvzHsIm7OgLLzgCUGmxK47toENevOHuLXb98AMRXQ50bG9UlWRj9UK6neTbCb/WSy5vNtG2cVT0PxPray9Wxr5EzOHFvMkIzsMRKIyDCygcKrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909503; c=relaxed/simple;
	bh=f+Bz4wyj9y1qCK6ZOWrdxVRRuVa/ccwbMt/+twZ6mwM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a1IwSgfwCBtdVQdgxUMtaGFAGvRe8bwGizqxZTSGdtn1gGrMgG9DdzfZKrPJ4aJs6nC7OR3xF/gQxB/SgMlJBFeYNqYBBXEvOcGVK6CGXDzLWw/ztnvEXON8ris2ozlLcUOWvH3Kz70dyFzNkHV9OkpB/FpB55gqSsdusJCiIKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IQCBZOJj; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IQCBZOJj"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67S9VGk342326314, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787909477; bh=f+Bz4wyj9y1qCK6ZOWrdxVRRuVa/ccwbMt/+twZ6mwM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=IQCBZOJj7gdg9P/z3w7RquK/l1HmCnK1XvKHNe3K84qxqjMgp35pYY6iRMxJ4xXlq
	 XGFH8jLvOudX24ERbDzzDiQGF6HVZQyVPBGkMDl/fc0T0ocO9uTiDa3z0sdURhc95z
	 Qyady3u/Ir+Y0BqHN6fMrAeR/aGWS/6I+hPurv8764jW7O0tj6adg3DlqTKWxNWZSG
	 p9TjepRxOdKPrthGgDAohnw0Qg2idHvcukE0Ey0Iu2Cqcqpu+c0ngFI3AVr/JQzUn+
	 yKsU+CIedlOPIF09w7YoHdszaMjpYLdDfHaYjUkuR+Lnipck6TNleUTOhHIHYMJ3Dl
	 34empj5yIzekg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67S9VGk342326314
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 28 Aug 2026 17:31:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 17:31:17 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 28 Aug 2026 17:31:17 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: =?utf-8?B?QWJkdXJyYWhtYW4gS2FyYWRhxJ8=?= <abdurrahmankaradag19@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>, "kvalo@kernel.org"
	<kvalo@kernel.org>, "briannorris@chromium.org" <briannorris@chromium.org>
Subject: RE: [PATCH v2 wireless] wifi: rtw88: debugfs: don't vzalloc(0) when
 rsvd_page is read unconfigured
Thread-Topic: [PATCH v2 wireless] wifi: rtw88: debugfs: don't vzalloc(0) when
 rsvd_page is read unconfigured
Thread-Index: AQHdNiXQ2DSQRW3iuUeeies1MedeQrayn1VA//9vFQCAASTwsA==
Date: Fri, 28 Aug 2026 09:31:17 +0000
Message-ID: <9044f78515f842dcb33e26b06f0d42ea@realtek.com>
References: <20260827124837.14370-1-abdurrahmankaradag19@gmail.com>
 <20260827131244.35623-1-abdurrahmankaradag19@gmail.com>
 <bd7176af6556460882d032f7da593d6f@realtek.com>
 <CA+tD5P_CN_g6eFzbYW9AvgCDZ8z4dieahFAOScXssC_HY1XDOg@mail.gmail.com>
In-Reply-To: <CA+tD5P_CN_g6eFzbYW9AvgCDZ8z4dieahFAOScXssC_HY1XDOg@mail.gmail.com>
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

KGNvbnZlcnQgdG8gcGxhaW4gdGV4dCBtb2RlKQ0KDQpBYmR1cnJhaG1hbiBLYXJhZGHEnyA8YWJk
dXJyYWhtYW5rYXJhZGFnMTlAZ21haWwuY29tPiB3cm90ZToNCj4gVGhhbmsgeW91ISBOb3RlZCBm
b3IgZnV0dXJlIHBhdGNoZXMg4oCUIEknbGwgdGFyZ2V0IHJ0dy1uZXh0L3J0dyBmb3INCj4gUmVh
bHRlayBkcml2ZXJzLiBMZXQgbWUga25vdyBpZiB5b3UnZCBsaWtlIGEgcmVzZW5kIHdpdGggdGhl
IGNvcnJlY3RlZA0KPiBzdWJqZWN0OyBvdGhlcndpc2UgaGFwcHkgZm9yIGl0IHRvIGdvIGluIGFz
LWlzLg0KDQpObyBuZWVkLiBKdXN0IEZZSS4NCg0K
