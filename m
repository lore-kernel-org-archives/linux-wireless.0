Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12B62EBB8D;
	Fri, 11 Sep 2026 07:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112733; cv=none; b=l+gsSK4ifscINq/YuyGUCKMEcNHe8wxfMobaTHwtOjoQrCoiH5cPumD6Kc4ZwUceFwaQC2DdUBTcvMwpifogTvaIp+hxJBWpXebrxw57CtNT+L8o0wV2VSwknPvN6F+FDbx44kDtL3Ph23e4pxWTyI2Hce6yykEDDxMGiGRaobg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112733; c=relaxed/simple;
	bh=9QHXloPcoJ8/HsR3fj8mFTdatj987DdRw9j+axEn/aI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gu8Oa1C4UpDeVE0YRG+usdo8i5jHAusDOvtpk0cJ5PXTLdMo6VOaKpjRNypQbJvN9VXkDNMZiwyYGy9ZOiwesGqQrT4Lv3YSI7we8NOmHKA6u/9gurqkvD/kpFII0HW51JP464RR+JiQlkhCO8gaFlKw/idUD057O1SfkYFY/oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tDlJY8Cw; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tDlJY8Cw"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68B7jJ4S12205436, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789112720; bh=9QHXloPcoJ8/HsR3fj8mFTdatj987DdRw9j+axEn/aI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=tDlJY8Cw1h7FrzLS2UvVD2Cv1AWxm4BI1y4xNVkvqY1ivkMg63Xr1Cl3k4/0UnFgP
	 dyZ9FaNiqXiysc5Gexmp+OJrpH8Sjuigw0bNX1mPuuPCweT1huHcnE8V9MjK0EthpD
	 kPqujAOKgn1b2vPiV+X81qxJo/A76/9bP88v/lRt99sI6Ppkzce+G5Nov4Qye1/w1k
	 rMh2GvXUVTIik2OjIvnWuWb/ivQeA7GvPAfHMDNDh7ousXe0ogfZRTxT79DsR3hhP3
	 f5NlFeR4+oziqn4Ru7lqXEBgdQXCh+8dHWRM+YM97VZTf4I+sIhRQlXGxSlWOMUlJR
	 Ugn+a18gxYKrw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68B7jJ4S12205436
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Sep 2026 15:45:20 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 11 Sep 2026 15:45:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Fri, 11 Sep 2026 15:45:19 +0800
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
Thread-Index: AQHdQC9VHG8DgIV+fU6Rc/HoW7uZv7bHFi4ggABMaYCAAA+IAIABFupQgAAGCmD//+wzgIAAhxzg
Date: Fri, 11 Sep 2026 07:45:18 +0000
Message-ID: <a0a617f1b7e34b979a801e7c10ad98f3@realtek.com>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
 <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev> <DLBR915C5L0S.1TEYXZ8LADNTH@linux.dev>
 <2294d792e937441fbf4ef8169c03df18@realtek.com>
 <a17a665d7d4c47fbb33e038d122ed200@realtek.com>
 <DLCBFNKN09SW.2SIEDXTB4PGJD@linux.dev>
In-Reply-To: <DLCBFNKN09SW.2SIEDXTB4PGJD@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiANCj4gSSBjYW4gd3Jp
dGUgdGhhdCB1cCBmb3IgSm9oYW5uZXMgYXMgYSBzZXBhcmF0ZSBtYWM4MDIxMSBwYXRjaCwgd2l0
aCB0aGUNCj4gcnR3ODggc2lkZSBhcyBhIGZvbGxvdyB1cC4gSXQgaXMgaW5kZXBlbmRlbnQgb2Yg
dGhpcyBzZXJpZXMsIGJ1dCBjb25zaWRlcmluZw0KPiB5b3VyIHF1ZXN0aW9uIHdhcyBhYm91dCBD
UFUgdXNhZ2UgYW5kIHRoaXMgY2hhbmdlIGRvZXNuJ3Qgb3ZlcmFsbCByZWR1Y2UgaXQsDQo+IGl0
IGlzIHByb2JhYmx5IG5vdCB3b3J0aCBpdC4NCg0KVGhhbmtzIGZvciB0aGUgZXhwZXJpbWVudHMu
IEkgdGhpbmsgaXQgaXMgbm90IHdvcnRoLi4uIA0KDQo=
