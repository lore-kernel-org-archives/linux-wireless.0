Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE41F1A2545;
	Fri, 11 Sep 2026 00:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789088043; cv=none; b=Vp8lBaHOBV5Rsv2U7cZ43JKv3E9vpwqMBTfeSNqiMOJE60OPGhP5fNrsU4YK8T/CBohN0G6j8QiE4U4oZ4ni5gnvh1cAEGxiciOQoxUjkHxu1snLmyMsEMXrYOwiNNax+KwWBVvj38MNQU0hvTuMPElsYn9lup8IFBcUtSTyLKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789088043; c=relaxed/simple;
	bh=nIWrii8Hy3kZ0ieTJKpQuXM+GrZkmzqfVQg3FrfvB+s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=geT/64yd8tqAp6udtS6jRiJDxqvJsBI88UyWe4gzKu+Udb4NeX+Hhsdl8+ZBlZvXEFHPg5qWeiN60/1DLQ7G9yIeZNR1WRsV4eRZQOu7VqxXjyQjWHvsaecjiRNFvedEGXCusbMKAFolpcbtZpmBiNAkoPOtmPcOGPx7fzz3gEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=gSpr/BES; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="gSpr/BES"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68B0rnCQ31996400, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789088029; bh=nIWrii8Hy3kZ0ieTJKpQuXM+GrZkmzqfVQg3FrfvB+s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=gSpr/BESTT8YaLEiQZW6Um/td0/71mXj3Z9k1Ldehwy4kTZztASTEPfl+TCycPffl
	 Nd/+r7Goe+KId9t3HuQFYZ9Yz/IWV29J2eBaxYQ8H25zzJd/w1kfoVCh0VF28lpowC
	 DClbRuZ7WBxvF4s9CESre4O0rZtOIrROOIRdlXU0GhR7Jx08QTC8xiSCOncLOErLQg
	 gHamOMP3z+X5Cq3jQFI2SLE5z72mnduYo+/eV+PdwY2Q5D8iU0MEMWRECqCe9o4gND
	 l7VasaeB8czzjH92Tp0vRyRIREoMGEWLcwLkU7BksKD6F0Oyu1E1c5sofJ4KEeIxsD
	 MJPsmJeDy8F+w==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68B0rnCQ31996400
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Sep 2026 08:53:49 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 11 Sep 2026 08:53:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 11 Sep 2026 08:53:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Fri, 11 Sep 2026 08:53:49 +0800
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
Thread-Index: AQHdQC9VHG8DgIV+fU6Rc/HoW7uZv7bHFi4ggABMaYCAAA+IAIABFupQgAAGCmA=
Date: Fri, 11 Sep 2026 00:53:49 +0000
Message-ID: <a17a665d7d4c47fbb33e038d122ed200@realtek.com>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
 <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev> <DLBR915C5L0S.1TEYXZ8LADNTH@linux.dev>
 <2294d792e937441fbf4ef8169c03df18@realtek.com>
In-Reply-To: <2294d792e937441fbf4ef8169c03df18@realtek.com>
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

UGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiBMdWthIEdlamFrIDxs
dWthLmdlamFrQGxpbnV4LmRldj4gd3JvdGU6DQo+ID4gbWFjODAyMTEgcmVzZXJ2ZXMgSUVFRTgw
MjExX0VOQ1JZUFRfVEFJTFJPT00sIDE4IGJ5dGVzLCBhbmQgb2ZmZXJzDQo+ID4gbm8gd2F5IGZv
ciBhIGRyaXZlciB0byBhc2sgZm9yIG1vcmUgb24gVFg7IGV4dHJhX3R4X2hlYWRyb29tIGlzIGhl
YWRyb29tDQo+ID4gYW5kIGV4dHJhX2JlYWNvbl90YWlscm9vbSBpcyBiZWFjb25zIG9ubHkuDQo+
IA0KPiBZb3UgY2FuIG1vZGlmeSBtYWM4MDIxMSB0byByZXNlcnZlIGxhcmdlciBuZGV2LT5uZWVk
ZWRfdGFpbHJvb20gdG8NCj4gc2VlIGlmIGl0IGNhbiByZWFsbHkgcmVzb2x2ZSB0aGUgc3ltcHRv
bS4gSWYgc28sIHlvdSBjYW4gcHJvcG9zZQ0KPiB0byBhZGQgZmllbGRzIGZvciB0YWlscm9vbSBs
aWtlIGhlYWRyb29tOg0KPiANCj4gICBzdHJ1Y3QgaWVlZTgwMjExX2h3OjogZXh0cmFfdHhfdGFp
bHJvb20NCj4gICBzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsOjogdHhfaGVhZHJvb20NCj4gDQoNCk5v
dGUgdGhhdCB0aGUgbmRldi0+bmVlZGVkX3RhaWxyb29tIGlzbid0IGd1YXJhbnRlZWQgYnkgY29t
bWVudHMsIHNvIGRvaW5nDQpzb21lIGV4cGVyaW1lbnRzIGJ5IG5vcm1hbCB1c2UgY2FzZSB3b3Vs
ZCBiZSBoZWxwZnVsIHRvIGtub3cgaWYgaXQncyB3b3J0aC4NCg0KICoJQG5lZWRlZF90YWlscm9v
bTogRXh0cmEgdGFpbHJvb20gdGhlIGhhcmR3YXJlIG1heSBuZWVkLCBidXQgbm90IGluIGFsbA0K
ICoJCQkgIGNhc2VzIGNhbiB0aGlzIGJlIGd1YXJhbnRlZWQuIFNvbWUgY2FzZXMgYWxzbyB1c2UN
CiAqCQkJICBMTF9NQVhfSEVBREVSIGluc3RlYWQgdG8gYWxsb2NhdGUgdGhlIHNrYg0KDQpQaW5n
LUtlDQoNCg==
