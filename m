Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F9C7263B
	for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2026 02:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776132640; cv=none; b=q5bOuF+RUOWVtzS57ZQv5cuibepQjzVHW7BzLAfWrcZsohl0vSdM/Onr3K6zzlIOW6LUpVomPnQ8s2iIMsi2JrQg5Yd9Yv35tiR4OhgCyNzfdLfP6by6ZEwdBU7kLgABHutUkhFmzAK/8tIgRS2MFxN+5YI8ozNfrIV3ogNmhnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776132640; c=relaxed/simple;
	bh=Z+23heCOufPV2812j3DB2q+3sANuEUIs0aYXAfDYb0k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DsAizY7FjKYYX9BTSs5v/eWRuA/9p/uqh+5WINwM9FeuUElV5wTUWQYsjkBpHWpt+xNbKNYRr6NHR+hFppzDqWkTH0P8dfrKHc0a6JM45N/swugPq70d7C6UgJyEM0vOv4nQ+Fsl2UZB4EgusCYrktD8PPXLRr/XZYgJWOB4Qlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=cmxgNx3V; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="cmxgNx3V"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63E2AZpZ41144617, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776132635; bh=Z+23heCOufPV2812j3DB2q+3sANuEUIs0aYXAfDYb0k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=cmxgNx3Vj3jnXuDMDNLV1LV+lhpkmkOB3Jl8vyek8tcyHY48NIqQJ7L8fuk4Xd7jC
	 nWkebN+hUUKll7L24NX+5OQ3OuV/LG7rFCjxu4BU0X2LO2jXaIDk9Nei1qzgya8bEx
	 Of26gwfkkiTUxE3P78eEZfOcaA/BNxKyJ0SiGhtnaNfQS1Hq9S9Ta6HCHachYcrXxW
	 2cOqJTnYQjEq03vwEDvIL7vlF7oc4e02aICcoRVoQHcrXbYP+qwfwcAB3UcvB9C/nh
	 InEaHj7NPhBhZry54A3GuWLR2VgVJjC5rZIOj+sck8WR7ypPGxsJLcymcdQLlOPYjp
	 AteMd7XZna0iA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63E2AZpZ41144617
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 10:10:35 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 14 Apr 2026 10:10:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 14 Apr 2026 10:10:34 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458%10]) with mapi id
 15.02.1748.010; Tue, 14 Apr 2026 10:10:34 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: LB F <goainwo@gmail.com>,
        Panagiotis Petrakopoulos
	<npetrakopoulos2003@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: Add NULL check for chip->edcca_th
Thread-Topic: [PATCH] wifi: rtw88: Add NULL check for chip->edcca_th
Thread-Index: AQHcyyzTY+6cVUzujkaEJSe4anaYQrXcZ3YAgAFoHXA=
Date: Tue, 14 Apr 2026 02:10:34 +0000
Message-ID: <1e73055da16b40b59f20cdf63b82cb30@realtek.com>
References: <20260413100249.28618-1-npetrakopoulos2003@gmail.com>
 <CALdGYqRLsPs8+kyAYphmKxfN9qF=1aGgn0O1LaASmjkDSUup_A@mail.gmail.com>
In-Reply-To: <CALdGYqRLsPs8+kyAYphmKxfN9qF=1aGgn0O1LaASmjkDSUup_A@mail.gmail.com>
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

SGkgT2xla3NhbmRyLA0KDQpMQiBGIDxnb2FpbndvQGdtYWlsLmNvbT4gd3JvdGU6DQo+IFBpbmct
S2UsIGNvdWxkIHlvdSBwbGVhc2UgdGFrZSBhIGxvb2sgYXQgdGhpcyBwYXRjaCB3aGVuIHlvdSBo
YXZlIGENCj4gY2hhbmNlPyBJZiB5b3UgYXBwcm92ZSB0aGUgYXBwcm9hY2gsIEknbGwgYmUgaGFw
cHkgdG8gdGVzdCBpdCBhbmQNCj4gcHJvdmlkZSBhIFRlc3RlZC1ieS4NCg0KSSByZW1lbWJlciBC
aXR0ZXJibHVlIGlzIHN0aWxsIG1ha2luZyBhIHRlc3QgcGF0Y2gsIGFuZCB0aGlzIHBhdGNoIGlz
IG9uZQ0KdG8gYXZvaWQgZ2FyYmFnZSBSWC4gSWYgd2UgY2FuIHZhbGlkYXRlIHNpemUgb3Igb3Ro
ZXIgY2x1ZXMgYXQgZWFybGllciBvZg0KUlggZGF0YSBwYXRoLCB0aGlzIG1hbGZvcm1lZCBwYWNr
ZXQgbWlnaHQgbm90IGdvIGludG8gdGhpcyBmdW5jdGlvbi4NCg0KVGhpcyByZW1pbmRzIG1lLCB0
aGUgcGF0Y2ggZ2V0dGluZyBtZXJnZWQgdG8gY2hlY2tpbmcgVkhUIHJhdGUgc2VlbXMgdG8NCmJl
IGFub3RoZXIgY2x1ZSBvZiBtYWxmb3JtZWQgcGFja2V0cy4gTWF5YmUsIHdlIHNob3VsZCBqdXN0
IGRyb3AgdGhlDQpwYWNrZXRzIGluc3RlYWQsIHdoaWNoIHRoZSBjb250ZW50IG1pZ2h0IGJlIGp1
c3QgYSBnYXJiYWdlLiANCg0KUGluZy1LZQ0KDQo=
