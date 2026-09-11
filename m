Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB2D288B2;
	Fri, 11 Sep 2026 00:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086624; cv=none; b=uFXNHAiDXSo7iNilOVfJ1SxLyDZnurXDk8PnThJhmyyH2UbS9xyfb+GGHZQYW+ljGIoYBynLg9+Wt1SHKx6ucIZba0s/v1JLFkYBmHtISwitBUcd43W/tIpHdF/OIF9ClHpHcNjCLG2NwdHyG9lSF+UOlYFBOHnblpYK7ufR+C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086624; c=relaxed/simple;
	bh=U+V9976xfbh+qA+hgjpjtWhxnFDYuCM74I98vjZ0dRU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TfiGpYzyE67NT36qRFLp0t2VwdetTQE+Ah1coFq0nj2cvNV8dAJotbmTu08huvvxHukMwiQp+kk6Va0mZpOIku2YReEPm9ZDuaYLvC/1dZ4ImhWCkTUU9RcZFXEjRhQVuTs6eFq/MXPaUfChv0i168n/ZrYCkLd4R9bmkrnTi1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=vkMYsePH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="vkMYsePH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68B0U9Np81984521, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789086609; bh=U+V9976xfbh+qA+hgjpjtWhxnFDYuCM74I98vjZ0dRU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=vkMYsePHWMOpireTGf4yJZ9WCvctQU5fv9R3vXpjL+VGguTyqzVWGZ1WjvUcV+uhj
	 UIbounUdq+tq4pQGIdNlqeFhhetT20VQjbviAPrE1RtjF+zMiny8YDnNiGe3yCtRps
	 8UARLTZJy+m/OA+cOexKlexXRruO7z+eSKUQAZGmVB8KH2TwiQ7nOxQNJLh7JjkSm8
	 fpkJNgq4Rpv5lvV99RGy9hhLAoJAzrh6bnVgOOb2UMiTryhGgErD4eWAs6i1juLKvw
	 wMQnUP27JrY2Pu3R/7xL4hACyhB5xIet6fpgH1WM7PElzrHjSfyjjdLhnzUEB+23ob
	 cOvXI50RRrgvA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68B0U9Np81984521
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Sep 2026 08:30:09 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 11 Sep 2026 08:30:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 11 Sep 2026 08:30:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Fri, 11 Sep 2026 08:30:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a TX
 transfer
Thread-Topic: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a
 TX transfer
Thread-Index: AQHdQC9VHG8DgIV+fU6Rc/HoW7uZv7bHFi4ggABMaYCAASR2kA==
Date: Fri, 11 Sep 2026 00:30:08 +0000
Message-ID: <f139980a5614454cac50517a5b602cd5@realtek.com>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
 <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev>
In-Reply-To: <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+DQo+IA0KPiBPbmUgdGhpbmcgdG8gZGVj
aWRlLCB0aG91Z2guIFRoZSBjb21taXQgbWVzc2FnZSBzYXlzIHRoZSBwYWRkaW5nICJjb3N0cw0K
PiBub3RoaW5nIG9ic2VydmFibGUiLCB3aGljaCBpcyB0b28gc3Ryb25nIGdpdmVuIHRoZSBudW1i
ZXJzIGluIHRoYXQgc2FtZQ0KPiBwYXJhZ3JhcGguIERvIHlvdSB0aGluayBpdCBuZWVkcyByZXdv
cmRpbmc/IElmIHNvLCB3b3VsZCB5b3UgYmUgd2lsbGluZw0KPiB0byBhbWVuZCBpdCB5b3Vyc2Vs
ZiB3aGVuIGFwcGx5aW5nPyBUaGF0IHNlZW1zIGJldHRlciB0aGFuIGEgcmVzZW5kIG9mDQo+IHNl
dmVuIHBhdGNoZXMgZm9yIG9uZSBsaW5lLg0KDQpJIGNhbiBhbWVuZCBpdCBteXNlbGYgYXMNCg0K
Ii4uLiBwYWRkaW5nIHRoZSB0cmFuc2ZlciBjb3N0cyBhYm91dCAyJSBvYnNlcnZhYmxlIG92ZXIg
dHJhbnNmZXIuIg0KDQpPciB5b3UgY2FuIGhlbHAgdG8gcmV3b3JkIHRoZSBwYXJhZ3JhcGguIEkg
Y2FuIGNvcHkgJiBwYXN0ZSBpdC4NCg0KUGluZy1LZQ0KDQo=
