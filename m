Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CF120D4E9;
	Fri, 14 Aug 2026 05:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786686784; cv=none; b=ZUrxRj7pf3aRaHW0Mc0y9sMBwC3YzDpk/GdRFHHpuNErPOaZ1/toklswuC7my0mWi8yeKPURN19TlsricFf5fuvZ9cu+vv+y7QLXVF+NJEQ1B6gwUBfuqL/TI+tYhRYT86wE6KFcgG6T5rin8ysNUaQU9lasiSHPAHpphAC0AKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786686784; c=relaxed/simple;
	bh=AX5eUTv7aQf5vRSwjdITMeIk+hlNoHXL7WoEbJKLN6k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IUjR60bWU6SuiMf6iPCfaEpOB+ix28eY/DAEFhZOf1j1s78Z4cwltCMAFrF7fA13D73OWLc8R455gQf+GV7w3ydeyrErg8qpoDT+++o+jhL/Y0NpDyfeNCUbEdOMH8lersDX9VJJynrSPCE02ChAumbwBQN8Gy2xcjT7PgTT4FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=EM6//9wG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="EM6//9wG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E5qjFT31000950, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786686766; bh=AX5eUTv7aQf5vRSwjdITMeIk+hlNoHXL7WoEbJKLN6k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=EM6//9wGqLxy8tPkgddgyV3vfhInboZLGx2NrRuHJYDPpoPgXKTVfKX5DLM47qAhz
	 tb4vTvJo4N64/fHVo66U9dks7LkjLxIv6nQRJTfKwSpZ05b8S7JhEjes4ZasHs9N/6
	 IonXL0ObRvskLNnXd0YyJsQdLJVPxN67donxeXAAlmDLRwYMKnAkRJJmfEehqD8Y7H
	 plAInz3d5OVJhk6BbUI+ZdacDCcyWGrV0butrAMkZnJzD6szJCLac0QfAycgVACFLw
	 Q4v1Bt/W0lRunCzN5+2c1FTrqVJp0ti6AR4mYeNWijM5uRUzOx5LLk7Vs0/PFZXfNQ
	 1YO8p5S8ChuTA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E5qjFT31000950
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 13:52:45 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 13:52:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 13:52:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 13:52:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>, "luka.gejak@linux.dev"
	<luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v4 4/7] wifi: rtw88: fw: handle the RTL8723BS management
 TX reports
Thread-Topic: [PATCH v4 4/7] wifi: rtw88: fw: handle the RTL8723BS management
 TX reports
Thread-Index: AQHdKXGpVmV17JbF2ESxt7taM5p15raYNBSAgATavAA=
Date: Fri, 14 Aug 2026 05:52:43 +0000
Message-ID: <db559be3670b4d1691c0a225a283570b@realtek.com>
References: <20260811091203.26841-1-luka.gejak@linux.dev>
 <20260811091203.26841-5-luka.gejak@linux.dev>
 <4a6f14e0-1daa-4ac6-af10-988a38b14317@gmail.com>
In-Reply-To: <4a6f14e0-1daa-4ac6-af10-988a38b14317@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBPbiAx
MS8wOC8yMDI2IDEyOjEyLCBsdWthLmdlamFrQGxpbnV4LmRldiB3cm90ZToNCj4gPiBGcm9tOiBM
dWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4NCj4gPg0KPiA+IFRoZSB2ZW5kb3IgZmly
bXdhcmUgdXNlZCBieSB0aGUgUlRMODcyM0JTIGRvZXMgbm90IHJlcG9ydCBtYW5hZ2VtZW50DQo+
ID4gZnJhbWUgdHJhbnNtaXNzaW9uIHRocm91Z2ggQzJIX0NDWF9UWF9SUFQuIEl0IHVzZXMgZXZl
bnQgMHgxMiwgYW5kDQo+ID4gcmV1c2VzIDB4MzIgZm9yIHNjYW4gcHJvYmUgcmVwb3J0cywgd2hp
Y2ggcnR3ODggb3RoZXJ3aXNlIHRyZWF0cyBhcyBhDQo+ID4gV0xBTl9SRk9OIGV2ZW50IGFuZCBj
b21wbGV0ZXMgdGhlIExQUyBsZWF2ZSBjaGVjayB3aXRoLg0KPiA+DQo+ID4gUm91dGUgYm90aCBl
dmVudHMgdG8gdGhlIGV4aXN0aW5nIFRYIHJlcG9ydCBoYW5kbGVyIGZvciB0aGlzIGNoaXAsIGFu
ZA0KPiA+IGRlZmVyIDB4MzIgdG8gdGhlIHdvcmtlciBpbnN0ZWFkIG9mIGNvbnN1bWluZyBpdCBp
biB0aGUgaW50ZXJydXB0IHBhdGgsDQo+ID4gc28gdGhlIHJlcG9ydHMgYXJlIGRlY29kZWQgYW5k
IHRoZSBMUFMgaGFuZHNoYWtlIGlzIGxlZnQgYWxvbmUuIFRoZQ0KPiA+IHBheWxvYWQgbGF5b3V0
IGlzIHRoZSBzYW1lIGFzIEMySF9DQ1hfVFhfUlBULCBzbyBubyBzZXBhcmF0ZSBkZWNvZGUgaXMN
Cj4gPiBuZWVkZWQuDQo+ID4NCj4gPiBXaXRob3V0IHRoaXMsIHRlc3RlcnMgb24gQVJNIFNESU8g
Ym9hcmRzIHNlZSAiZmFpbGVkIHRvIGdldCB0eCByZXBvcnQNCj4gPiBmcm9tIGZpcm13YXJlIiBh
bmQgImZpcm13YXJlIGZhaWxlZCB0byBsZWF2ZSBscHMgc3RhdGUiIG9uY2UgcG93ZXIgc2F2ZQ0K
PiA+IGVuZ2FnZXMgdW5kZXIgbG9hZC4NCj4gPg0KPiANCj4gUGxlYXNlIHNlZSB5b3VyIHJlcGx5
IGZyb20gSnVseSAzMCByZWdhcmRpbmcgdGhpcyBzdWJqZWN0Og0KPiANCj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtd2lyZWxlc3MvMjAyNjA3MzAwNjA5MDMuMzAxODctMi1sdWthLmdl
amFrQGxpbnV4LmRldi8NCg0KRm9yIHRoZSByZWNvcmQsIHRoaXMgcGF0Y2ggaXMgcGxhbm5lZCB0
byByZW1vdmUgYnkgdjUuIFsxXSBbMl0uDQoNClsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9s
aW51eC13aXJlbGVzcy81NzcxOUNFNC1CRUU0LTRBMUUtQjc2MC1ERkZEMDRGRjg2NUNAbGludXgu
ZGV2Lw0KWzJdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXdpcmVsZXNzLzIwMjYwODEz
MDU1NjU3LjEzNTA2LTEtbHVrYS5nZWpha0BsaW51eC5kZXYvDQoNCg0K
