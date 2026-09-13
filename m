Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5035950;
	Sun, 13 Sep 2026 02:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789268048; cv=none; b=saxJuCaj/lyAiuT830PQ944H4D/ciZIrFhXfvR/FFUpAXLA4GXAVcAEAVebEhO0a9ziSA67TTnRsMXs2F84NcXIC9vV27ApbeeI+4KoNecxXSN86XwngRzCraeHEt70WMBFyKUYjb9F0f2sp53+36W8mu1B6xOLM6hfJt7/4Mmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789268048; c=relaxed/simple;
	bh=dHI11/TI5fzZelbUvf/t1tvscaO1BD1SxK08WCsT+uU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uIF2EFc9ZFLuikaM57FxtkZ2GWNIg4MbbA9CBkHcwpOOuU89OSi7UvHFOgRzaUFGa7pSDvQoRoQxdwuI/pJqhV8xDvITzml0UwvvyzYv8Qb/EFvlycf5AmHP3XQW9FVR+Fj+wNTnd1HWYfQJ/h8kIPeI6W8hCHBusCURzgWOaRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Y96BzZyk; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Y96BzZyk"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68D2rrd273609071, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789268033; bh=dHI11/TI5fzZelbUvf/t1tvscaO1BD1SxK08WCsT+uU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Y96BzZykI+tCQGB2oEvNzNq3gPIhRSBHrWY6/T2Jdhu5lHN4c3u4FTKOd2q51zuF8
	 ZHAihzIJvF/Iw0UWCT3cBazucEOiNOBupduuhRHWm7Xs3uQHs57BOqavqV1JOkKJvV
	 Zk80RJO0sM+Wgb2ZvQNODaT3gv4tYJJGUg8vvW//FtdkEANygCv+ZR6otPxoZ9Dc55
	 O2z3Orxtc/jgMVhEmPbDWrwvj2pTdMrLFKI+5EyrBM/uNo2AasU4WUvfnHh30PnbQ3
	 Jo6sHHyflGoTPHVbAZzDIxQKiqKDuG+x3vgZypRyo1UWr9CJ+/TwF02etIwSWxifmZ
	 ojl1cSaQsN+nQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68D2rrd273609071
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 13 Sep 2026 10:53:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 10:53:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 10:53:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 13 Sep 2026 10:53:53 +0800
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
Thread-Index: AQHdQC9VHG8DgIV+fU6Rc/HoW7uZv7bHFi4ggABMaYCAAA+IAIABFupQgAAGCmD//+wzgIAAhxzg//+KBICAA0g6YA==
Date: Sun, 13 Sep 2026 02:53:53 +0000
Message-ID: <e9ff5a0c9d7a41ecb0fa1c4c37031ed0@realtek.com>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
 <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev> <DLBR915C5L0S.1TEYXZ8LADNTH@linux.dev>
 <2294d792e937441fbf4ef8169c03df18@realtek.com>
 <a17a665d7d4c47fbb33e038d122ed200@realtek.com>
 <DLCBFNKN09SW.2SIEDXTB4PGJD@linux.dev>
 <a0a617f1b7e34b979a801e7c10ad98f3@realtek.com>
 <108d4da2ab381d6e22d4f84f1c1254aa59b20d88@linux.dev>
In-Reply-To: <108d4da2ab381d6e22d4f84f1c1254aa59b20d88@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBTZXB0ZW1iZXIgMTEs
IDIwMjYgYXQgOTo0NSBBTSwgIlBpbmctS2UgU2hpaCIgPHBrc2hpaEByZWFsdGVrLmNvbQ0KPiBt
YWlsdG86cGtzaGloQHJlYWx0ZWsuY29tP3RvPSUyMlBpbmctS2UlMjBTaGloJTIyJTIwJTNDcGtz
aGloJTQwcmVhbHRlay5jb20lM0UgPiB3cm90ZToNCj4gDQo+IA0KPiA+DQo+ID4gTHVrYSBHZWph
ayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiA+DQo+ID4gPg0KPiA+ID4gSSBjYW4g
d3JpdGUgdGhhdCB1cCBmb3IgSm9oYW5uZXMgYXMgYSBzZXBhcmF0ZSBtYWM4MDIxMSBwYXRjaCwg
d2l0aCB0aGUNCj4gPiA+ICBydHc4OCBzaWRlIGFzIGEgZm9sbG93IHVwLiBJdCBpcyBpbmRlcGVu
ZGVudCBvZiB0aGlzIHNlcmllcywgYnV0IGNvbnNpZGVyaW5nDQo+ID4gPiAgeW91ciBxdWVzdGlv
biB3YXMgYWJvdXQgQ1BVIHVzYWdlIGFuZCB0aGlzIGNoYW5nZSBkb2Vzbid0IG92ZXJhbGwgcmVk
dWNlIGl0LA0KPiA+ID4gIGl0IGlzIHByb2JhYmx5IG5vdCB3b3J0aCBpdC4NCj4gPiA+DQo+ID4g
VGhhbmtzIGZvciB0aGUgZXhwZXJpbWVudHMuIEkgdGhpbmsgaXQgaXMgbm90IHdvcnRoLi4uDQo+
ID4NCj4gDQo+IEkgYWdyZWUsIGp1c3QgbGV0IG1lIGtub3cgd2hlbiB0aGUgc2VyaWVzIGlzIG1l
cmdlZCBzbyBJIGNhbiBzZW5kIGRyaXZlciBzZXJpZXMuDQoNCkknbGwgbWVyZ2UgdGhpcyBzZXJp
ZXMgaW4gY29taW5nIGRheXMuIEJhc2VkIG9uIHJldmlldyBleHBlcmllbmNlIG9mIHRoaXMgc2Vy
aWVzLA0KeW91IGNhbiByZXZpZXcgdGhlbSB5b3Vyc2VsZiBhZ2FpbiBiZWZvcmUgc2VuZGluZyBk
cml2ZXIgc2VyaWVzLg0KDQpQaW5nLUtlDQoNCg==
