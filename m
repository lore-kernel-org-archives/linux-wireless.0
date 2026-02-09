Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED49B309DAB
	for <linux-wireless@vger.kernel.org>; Mon,  9 Feb 2026 08:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770625747; cv=none; b=uDgqoPOQ3DRZWXOLwGurjTze8UOZ/EAQ+yRoVte5RkeSKUovN3q0GUUN6YaTNvseHxHwB0RiXGUjMeFpmaHjlpkMHjbfvmmqHT9DnUvSF7Qdf+c0qyYrZ+83ytXQ8Eu5TN/AS8h/ob3WWsAx1bF7jrRnOvrAKoS54eujv+VMQtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770625747; c=relaxed/simple;
	bh=QcBbSmrOSOJYb3BgB6bAwwDETP2JGP3AjH+PQfp0aDg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BqHv4+84MH4xJZm4/hiakCy1VB7GrsltLhCPi1CVGKgFYhSTM/fT6UceQHAN/lLI7WzHwBC7ZVdZSdisWgmEzxZx5BKgods7ne3xpoN6POEAWEnSGcZxFRMr+JBU3KLN49AC9wCXwOWiJa9LL/33UJRpumQtbC6omQ9LQOcBvvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iussEDtP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iussEDtP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6198T3hA41093162, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1770625743; bh=QcBbSmrOSOJYb3BgB6bAwwDETP2JGP3AjH+PQfp0aDg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=iussEDtPw9ZZMu95JpJmWmThWk0nDtg2858t/AWIAk1/Y/Xv+kf4LQJMLjIIWOhSX
	 8FkJZjDm9hb9OYmpP2XGQKRj6jgVLg6qO7YLPcxQVT2JMfTVNNxeP11KYtkXPFfQ+L
	 imXSWeNIIGe5l/XTYHWbKeu06orm05CN9reu5z10BPrmscvV5QucdWmFtDN7hLZ3FE
	 00ktEYFhWIKZLqaPyIZ+6gE5K7vPpD14OtCTvSXmsB99QHC2KLq45cMLmkiG0f67eY
	 lrcZa9jCc8xYSUjItHyE/RpXbsluT98Pe/CyB67Tri9CYNwcQX10Yh4xVGLmj2JKUB
	 Z4p9qRogla64g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 6198T3hA41093162
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Feb 2026 16:29:03 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 9 Feb 2026 16:29:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 9 Feb 2026 16:29:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913%10]) with mapi id
 15.02.1748.010; Mon, 9 Feb 2026 16:29:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw89: Turbo mode for RTL8851BU/RTL8852BU
Thread-Topic: [PATCH rtw-next] wifi: rtw89: Turbo mode for RTL8851BU/RTL8852BU
Thread-Index: AQHcl5KlX2It/2jn+kGuF+7yhWeZbrV6DGuQ
Date: Mon, 9 Feb 2026 08:29:01 +0000
Message-ID: <3bde96d354514c6ebc0a680e9a6f5c28@realtek.com>
References: <88cce107-ff52-496f-bb77-b930e4182b67@gmail.com>
In-Reply-To: <88cce107-ff52-496f-bb77-b930e4182b67@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBSVEw4
ODUxQlUgYW5kIFJUTDg4NTJCVSBjdXJyZW50bHkgaGF2ZSBtdWNoIGxvd2VyIFRYIHNwZWVkIHRo
YW4NCj4gZXhwZWN0ZWQsIH4xMDAgYW5kIH4zMDAgTWJwcywgcmVzcGVjdGl2ZWx5LiBUaGlzIGlz
IGJlY2F1c2UgcGFydCBvZiB0aGUNCj4gY2hpcCdzIG1lbW9yeSBpcyBhbGxvY2F0ZWQgZm9yIHNv
bWUgdW5rbm93biBmaXJtd2FyZSBmZWF0dXJlcyBpbnN0ZWFkIG9mDQo+IHRoZSBUWCBidWZmZXJz
Lg0KPiANCj4gVGhlIHZlbmRvciBkcml2ZXJzIGhhdmUgYSBtb2R1bGUgcGFyYW1ldGVyIGNhbGxl
ZCAicnR3X3F1b3RhX3R1cmJvX2VuIiwNCj4gd2hpY2ggY2FuIGJlIHVzZWQgdG8gY2hvb3NlIGJl
dHdlZW4gZnVsbCBUWCBzcGVlZCBvciB0aGUgdW5rbm93bg0KPiBmaXJtd2FyZSBmZWF0dXJlcy4g
SXQgaXMgb24gYnkgZGVmYXVsdC4NCj4gDQo+IENoYW5nZSB0aGUgcmVsZXZhbnQgY2hpcCBwYXJh
bWV0ZXJzIHRvIGltcGxlbWVudCB0aGUgdHVyYm8gbW9kZS4gRG8gaXQNCj4gb25seSBmb3IgVVNC
IGJlY2F1c2UgUENJIGlzIGFscmVhZHkgZmFzdCBldmVuIHdpdGhvdXQgdGhlIHR1cmJvIG1vZGUu
DQo+IEl0J3MgdW5jbGVhciBpZiBTRElPIHdpbGwgbmVlZCBpdCBvciBub3QuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNvbT4NCg0K
QWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQoNCj4gLS0tDQo+
IA0KPiBXaGF0IGZpcm13YXJlIGZlYXR1cmVzIGFyZSB3ZSBtaXNzaW5nIHdoZW4gd2UgdXNlIHRo
ZSB0dXJibyBtb2RlPw0KPiBJcyBpdCBhbnl0aGluZyBpbXBvcnRhbnQ/DQoNCkkgYXNrZWQgZXhw
ZXJ0cyBpbnRlcm5hbGx5LiBUaGlzIGNoYW5nZSBpcyB0b3RhbGx5IGZpbmUgYW5kIGRvZXNuJ3Qg
YWZmZWN0DQpmaXJtd2FyZSBmZWF0dXJlcy4gRm9yIG5ld2VyIGRyaXZlciwgdHVyYm8gbW9kZSAo
cXVvdGEpIGlzIGFkb3B0ZWQuIA0KDQoNCg==
