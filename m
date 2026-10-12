Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00B5157A5A;
	Mon, 12 Oct 2026 05:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784505; cv=none; b=o/tN5uUX8aBBKCSb7wkeoTvrxiZ6L8bOCaABzi7yabtsawfz5c0gyZTcwLGI6s9prH+dA7SNVZqUyr2GhxO2rqZIdMdmRQhfYuupQwsX6AFy87EQaZpjMGVTn9fyyLeoNsInEmCY21E6bQOygXlcod0BWaXd4mAIIpVUmvTMUUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784505; c=relaxed/simple;
	bh=p02FscryJiW9Nb4efQBPUGm5mg/Pr+oA61GvH69VUDg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JmFSyF1m4KnJQLtA6nxZyeNVJ+g88wc7fXDDqeQQeXy4gBEt6WsGcngJslzV4WfCOZIOiTptHvm9CbTUj8SOCETqlnGtmehVjM/tA4Sbtluw86WT1TuDng6CqJNjy5O1n4yTND8tzzgUxC5iM5xRl2e2nIwCUkia4Ys2myr3k6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=b5p7C5t9; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="b5p7C5t9"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C5sr5rB3577792, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791784493; bh=p02FscryJiW9Nb4efQBPUGm5mg/Pr+oA61GvH69VUDg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=b5p7C5t9Eqq5Pa3a6xMXQYxb7IAFuQJ3L9t6BxnUC19jwFYsjYrHqvScGJHEiXTn9
	 kZ06aaU5KkSn3grgFa+0/T8QmnRfxDtfTg1v6xd03AdEeLvLJLnl8dbDPdwJ06umzB
	 58pGfZbpL06l4Mp2BmCOMJ9zc3PjZB937/nu5/EKHgEJA6QYz9+OvFj/ufDLnjEzM1
	 pWCmEVg+H7iDmSRBVyya2nWYJNfRCZ8mZEqbfnhvANWhxxXEtD23vu+aX8r0+MCqx6
	 LUQff/0uluYgNhlzpuyt65FpKd4anB6BAjIuTDok+rFpPBOq7+e9VhLi2GlK4rBzpd
	 UDS2ghlnrFocg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C5sr5rB3577792
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 13:54:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 13:55:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 13:55:00 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Hungyu Lin <dennylin0707@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>,
	"straube.linux@gmail.com" <straube.linux@gmail.com>, Hungyu Lin
	<dennylin0707@gmail.com>
Subject: RE: [PATCH v2] wifi: rtw88: 8723b: avoid converting RX SNR twice
Thread-Topic: [PATCH v2] wifi: rtw88: 8723b: avoid converting RX SNR twice
Thread-Index: AQHdWKTbqYoCscnsH0e4fposeQSB3rb2GaYAgANQe0A=
Date: Mon, 12 Oct 2026 05:55:00 +0000
Message-ID: <f2237c8130b047e4b212318c1b40bf75@realtek.com>
References: <3c89d2ac770c659eacd532134c89b4725be9ab97.1791627615.git.dennylin0707@gmail.com>
 <ce5a3b408acc48642aa31866df39630aec7792f6@linux.dev>
In-Reply-To: <ce5a3b408acc48642aa31866df39630aec7792f6@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiA+DQo+ID4gcnR3ODcy
M2JfcXVlcnlfcGh5X3N0YXR1c19vZmRtKCkgZGl2aWRlcyB0aGUgU05SIHJlcG9ydCBieSB0d28g
d2hlbg0KPiA+IGZpbGxpbmcgcGt0X3N0YXQtPnJ4X3NuciwgdGhlbiBzaGlmdHMgaXQgYWdhaW4g
d2hlbiB1cGRhdGluZw0KPiA+IGRtX2luZm8tPnJ4X3Nuci4gVGhpcyBoYWx2ZXMgdGhlIFNOUiB1
c2VkIGZvciBkaWFnbm9zdGljcyBhbmQgYXZlcmFnZQ0KPiA+IHN0YXRpc3RpY3MuDQo+ID4NCj4g
PiBTdG9yZSB0aGUgcmF3IHJlcG9ydCBpbiBwa3Rfc3RhdC0+cnhfc25yIGFuZCBjb252ZXJ0IGl0
IG9ubHkgd2hlbg0KPiA+IHVwZGF0aW5nIGRtX2luZm8tPnJ4X3NuciwgYXMgdGhlIG90aGVyIGNo
aXAgZHJpdmVycyBkby4NCj4gPg0KPiA+IEZpeGVzOiBkNzI2YzcwY2UwODIgKCJ3aWZpOiBydHc4
ODogODcyM2I6IGFkZCB0aGUgUlRMODcyM0IgY2hpcCBkcml2ZXIiKQ0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEh1bmd5dSBMaW4gPGRlbm55bGluMDcwN0BnbWFpbC5jb20+DQoNCkFja2VkLWJ5OiBQaW5n
LUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KPiANCj4gUGluZy1LZSBzaG91bGQgZml4
ZXMgdGFnIGJlIHByZXNlbnQgaGVyZSBpZiB0aGlzIGNvbW1pdCBpc24ndCBpbg0KPiBtYWlubGlu
ZSB5ZXQ/DQoNCk15IHB1bGwtcmVxdWVzdCBpbmNsdWRpbmcgdGhlIHBhdGNoIHdhcyBtZXJnZWQs
IHNvIHRoZSBTSEExIHdpbGwgYmUgY29uc3RhbnQuIA0KDQpQaW5nLUtlDQoNCg==
