Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2225830C608;
	Thu, 11 Jun 2026 09:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168753; cv=none; b=Gmuhbif49VbvJd6+YTbarmWZqaguWajJ3aps8eNG8HfDk0FzuDv0d20CILTHpE/LaKEUh0Iw8HC2KYMgoTYjLZ/cUr5CtLIA9lvwAUa8Q1RZFmH4Qxlut2ZUXhEvuTXOzJnPiTVdjG0JISQ7Jd3/s5SMM+3me8V2TujURFF/AzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168753; c=relaxed/simple;
	bh=F5hRDTkC0Ock/u9PUMO4HJRWBDGefZZd7wQVDck4lCw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IovcedPxMIba/it5L0ZCdYx4ikfd+ZdI6U5cehnbBR5MHER8N2xn2q/Vwj110RNdd7IWa2yYofRt4oja0DhKzhLY8d6VqpkdGAUmt644dSGC8c1NZJDEA6Z09N+K8K33TUwrWPmZlC2xy3q57bGGenK4ncE6ENKkaObhFsXamYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jiMe1Gwf; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jiMe1Gwf"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65B95llV61822619, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1781168747; bh=F5hRDTkC0Ock/u9PUMO4HJRWBDGefZZd7wQVDck4lCw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=jiMe1GwfuHldAHdj0gwTPMpaLCBfJK3WZQDOVbjOnbQZdxUMGCsZAO2mv5VCb8Jm7
	 p/85VuYWx76Jt8xnrE95yklKl73SrJ9rqiIAcM/rIsl+yj1FSPJhMl62n0HvGPTs2p
	 azNsgaAypAjTvqLSQ9JHMdixtg2e382sTljhGODHYd3nwTwZAMAlWipyNrFLMQxy8q
	 HyqhiXcYdvWtC2Jil+pLTzzJCDFYeNYcRnWN3oe1Co1MsuXT/uNcHcHlHtLFfl1qCt
	 tz6b+pn0oLI67fnvoZXPNHLSz/swzV0zIDB2mCvP5rz6KZ9gJc0Cv4VTmqGzGpQkjG
	 2X+VeA1PbZFeQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65B95llV61822619
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 11 Jun 2026 17:05:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Jun 2026 17:05:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Thu, 11 Jun 2026 17:05:48 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Wentao Guan <guanwentao@uniontech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	=?big5?B?RGF2aWQgWWFuZyi3qKjlsGEp?= <dian_syuan0116@realtek.com>,
	"zhanjun@uniontech.com" <zhanjun@uniontech.com>, "niecheng1@uniontech.com"
	<niecheng1@uniontech.com>
Subject: RE: [PATCH] wifi: rtw89: fw: correct
 rtw89_fw_h2c_default_cmac_tbl_be()
Thread-Topic: [PATCH] wifi: rtw89: fw: correct
 rtw89_fw_h2c_default_cmac_tbl_be()
Thread-Index: AQHc+XtFIorFAI00TU+w0k4KkSb5drY5D8rA
Date: Thu, 11 Jun 2026 09:05:48 +0000
Message-ID: <60dbac65771f46ae85efb922dd9f319e@realtek.com>
References: <20260611082021.46650-1-guanwentao@uniontech.com>
In-Reply-To: <20260611082021.46650-1-guanwentao@uniontech.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

V2VudGFvIEd1YW4gPGd1YW53ZW50YW9AdW5pb250ZWNoLmNvbT4gd3JvdGU6DQo+IEJFX0NDVExf
SU5GT19XMl9QUkVMT0FEX0VOQUJMRSBpcyBmb3IgaDJjLT53Miwgbm90IGgyYy0+dzEuDQo+IFRo
ZXNlIHdpbGwgY2F1c2UgaDJjLT53MSB3cm9uZyBvdmVybGFwIGJ5IHcyIGFuZCB3MiBub3QgaW5p
dGlhbGl6ZWQuDQoNClRoYW5rcyBmb3IgdGhlIGNhdGNoLg0KDQo+IA0KPiBGaXhlczogYzczNjA3
YjNhOGVmICgid2lmaTogcnR3ODk6IGZ3OiBhZGQgQ01BQyBIMkMgY29tbWFuZCB0byBpbml0aWFs
aXplIGRlZmF1bHQgdmFsdWUgZm9yIFJUTDg5MjJEIikNCj4gU2lnbmVkLW9mZi1ieTogV2VudGFv
IEd1YW4gPGd1YW53ZW50YW9AdW5pb250ZWNoLmNvbT4NCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hp
aCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQoNCg==
