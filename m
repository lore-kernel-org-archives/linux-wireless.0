Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1E03FE352;
	Thu, 30 Jul 2026 09:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403333; cv=none; b=R2g0FZu0PBdHnp3nj+axETvwehCPvSGRPzr2DDg7quXR7kun4brNvy94KNrYbn06dzFoj5N3zLTOsfLNOa3Thi32Zx5MvM95DnxrfeazTAhwI0EtrjbAkI5VFovQNvW9I/18S8MyhZospLr7PpK0Jw0iiOU0W7ueOW+aWN0h6Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403333; c=relaxed/simple;
	bh=gEX0tAwtd6hVVrhKOZCogKqfE9zejW/4sI4OsWz6+L8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gFuuOMu9GPHd1zefiLBVf+bBx033vRU9soDXvodR8WWh4YavZJHbcR73hbPi/+98ljVVI3KfgrnC4iRPWPouGqCi0xC4TdGiUWaLp9Mp/H9neSysiewLAJpOmRRKe503+ms3B4kdgmMZ3d7KAxsIlf5Rjhw+8VjggWJNRL2aAB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=I67lqqaV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="I67lqqaV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U9LvC921075352, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785403317; bh=gEX0tAwtd6hVVrhKOZCogKqfE9zejW/4sI4OsWz6+L8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=I67lqqaVnH5H4J7DF5jGub58t2fzuh+fKAyM96bKAV2MwT0RPwTlA0ifhrzc9JHEW
	 4J2DfITZJtV+FCw0UY3qiVvrK9Y4O9SyUWWZ1VhdJBQcse8tIFpKTUTbljiIgmQqLC
	 wKvgqy+clbHQTuocqflP5p0ROO7y+YclyFCPyq5Gy9aX1pSrtX+x/WPO9OlzsbdZeb
	 c3EjSplAsrPj7tNPWgI7n/BN7Bz4TeyEitkJTY/FCc70BSH0RjFiSl2IY0nJU63OKB
	 iGAamAC3A45S6iPBLAIFnkynIBCtLwXM27NziZWYmspzEy6p0F9IrpUyA/aMlx13Xk
	 v2GFJbGbSvxbw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U9LvC921075352
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 30 Jul 2026 17:21:57 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 17:21:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 17:21:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Thu, 30 Jul 2026 17:21:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>, "johannes.goede@oss.qualcomm.com"
	<johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and SDIO
 helper
Thread-Topic: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and
 SDIO helper
Thread-Index: AQHdHEb43bJAs6El90WByPxHzpdzD7aA9VHg///is4CABEJVAIAAtbgA
Date: Thu, 30 Jul 2026 09:21:55 +0000
Message-ID: <1d1b3430b11e4d9aa26c73e5b27aa95c@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-2-luka.gejak@linux.dev>
 <774407603bef4fd38290f6b5d4b4a26c@realtek.com>
 <2b742bc6c2a247888b3df630183b85e367f8ffbd@linux.dev>
 <60C071BE-7D15-4AA4-8FC1-D55AD04C7F19@linux.dev>
In-Reply-To: <60C071BE-7D15-4AA4-8FC1-D55AD04C7F19@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9y
IHBhdGllbnRseSB3YWl0aW5nIGFuZCBzb3JyeSBmb3IgdGhlDQo+IGRlbGF5IGFuZCBob3BlZnVs
bHkgdGhlcmUgd2lsbCBiZSBubyBzdWNoIGRlbGF5cyBhbnltb3JlLg0KDQpIb25lc3RseSwgSSdt
IG5vdCB3b3JraW5nIHNvIGZhc3QuIDspDQoNCkEgbGFyZ2UgcGF0Y2hzZXQgbGlrZSB0aGlzLCBJ
IG5lZWQgdG8gYXJyYW5nZSBteSBmcmVlIHRpbWUsIHNvIHlvdSBtaWdodCB3YWl0DQptZSBmb3Ig
b25lIG9yIHR3byB3ZWVrcy4gDQoNClBpbmctS2UNCg0K
