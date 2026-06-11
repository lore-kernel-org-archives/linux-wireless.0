Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727AE35893
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2026 00:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781139502; cv=none; b=un5BERxqA61Rs17F4COodDM0iccTQfWK0DRQNJ21BoD1CUBfF3LCW4LMYWjHAgGS5ldRfszqql0bAZiaSNN9twTvwL6QD8B1OL+JZBfHVcF/ofC9dbIB7+c6gTubkoxpXxAypMumx2SLZjq1KUn1fdYst8tlLJJmqgFVfckQf0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781139502; c=relaxed/simple;
	bh=0zaxIiB2SsBHCQV2pACYWwjSYi8Qlqwgyj7G/Zrp9Ck=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tz5AV/L2td4YF3cPbvG1jsRePMIPVFMSMSzXdqFytv4e3LYw0I8jowUOc2pFH5wNsZQNAQelglKb6gWdURW7viowkDdcQJpjSajrXLUYdiABaXFsAP9CDGrnY4dJPc04qGMpgNYGEJ0zgqpRBvSAfPdnD8RBgJ9qtOGBkM1jVto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=GebO+4O7; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="GebO+4O7"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65B0wFD411496963, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1781139495; bh=0zaxIiB2SsBHCQV2pACYWwjSYi8Qlqwgyj7G/Zrp9Ck=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=GebO+4O7wdHMf+tYDkMAg/RtraXrQdaURatp35GlBGogS2jalD54/qp2ugRqJ5V3c
	 5BBpyXKGcCKu2e1uY6uzNxN5Us0YmIE8U0VCkr+lFEmU/G58wTGI9rmGK1kjXNjL6e
	 VUohv8V1Qiqbl4rZXDsAy0YTq17/cCz4Sl14SO1x8Y7XLnYcRzkckfa7an5Kq845bh
	 NXDDaFThMHHYjzSNMuTiqlrIcjrd28MQROB51bqu5HG+EFNn9VZtpbuCR6km5SWmMf
	 ONk9ApGDbEcjOzOM1S0RZtumbnTAQABCRO4s8LsW8nB0HJreqX5Cghht9byads6Hnj
	 SFXqN2tjB1X0w==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65B0wFD411496963
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 11 Jun 2026 08:58:15 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Jun 2026 08:58:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Jun 2026 08:58:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Thu, 11 Jun 2026 08:58:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next 1/2] wifi: rtw88: 8822c: Don't process RF path C
 in query_phy_status_page{0,1}
Thread-Topic: [PATCH rtw-next 1/2] wifi: rtw88: 8822c: Don't process RF path C
 in query_phy_status_page{0,1}
Thread-Index: AQHc+NlIBbceEAuLBkKiaLeBIwZl5bY4iNmg
Date: Thu, 11 Jun 2026 00:58:15 +0000
Message-ID: <2916142fe261429c9351e9513c49474a@realtek.com>
References: <ee30b95f-bc68-4711-9b15-cf5fd23c3c48@gmail.com>
In-Reply-To: <ee30b95f-bc68-4711-9b15-cf5fd23c3c48@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBSZXBs
YWNlIDw9IHdpdGggPCBpbiB0aGUgbG9vcHMgaW4gcXVlcnlfcGh5X3N0YXR1c19wYWdlezAsMX0o
KS4gVGhleQ0KPiB3ZXJlIHByb2Nlc3NpbmcgZGF0YSByZWxhdGVkIHRvIFJGIHBhdGggQywgd2hp
Y2ggdGhpcyBjaGlwIGRvZXNuJ3QgaGF2ZS4NCj4gVGhlIG9ubHkgYmFkIGVmZmVjdCBzZWVtcyB0
byBiZSB0aGF0IHRoZSBwaHlfaW5mbyBmaWxlIGluIGRlYnVnZnMgd2FzDQo+IHByaW50aW5nIHVu
ZXhwZWN0ZWQgdmFsdWVzIGZvciBSRiBwYXRoIEMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCaXR0
ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IFBpbmct
S2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQoNCg==
