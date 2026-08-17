Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C61712CDA5
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 03:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786937918; cv=none; b=H/5l8JEr7YgSvNFn/Xx89rxax/Nr/4ipm/hDNRmUK+kyV9WRjUJ5Dv+GOMI0EC64uvrJqpEjoRBoW98orUWjZR1p3DLQSxA8kV34gOHa3wPdzvEMCDFG6a3+IPDj2McR8VyqBuAoJtJlnnxnq4VDCRlrYzWO3l2qJe/xXKcM9lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786937918; c=relaxed/simple;
	bh=TQM7sOHxKprXJDsaDocT/SegnyPe3t2D7wBYwMXTQa8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HniqM+saIAFhUwAOXx1a1GRH8/xg4XSWyU4tGTPkRgkPyC2GNuRyyknltybaEBbJbwCIizoOGqzw8Zjee2hstnkfwN5hM+mwIOeRozElUKdfaB5EVRfmNfy9qGaq4M89hkLioCrywlVuX4rOSrwebr+fz0uzAXittULNYJH+7Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KELAvQmq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KELAvQmq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67H3cWlE53586249, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786937912; bh=TQM7sOHxKprXJDsaDocT/SegnyPe3t2D7wBYwMXTQa8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=KELAvQmqKhpZ0PU4u6Mo58Yv4PCnNvBC1M07inBJYzqMnK7yrdb6InzVpQELYd2MZ
	 Ga5Fos905eZQ93MsXSlLmM+ZCMrBYK/wVpCw4VfsSuHZ7/l1AnAOWMbS8+KcPp4TMe
	 h8osSyqDANu785OUfEJ47PYkRNRv6pNIHxidlTFGw6yX0hkkL3eZgwGK9uYs5kik2X
	 bVUhRm8oD5sH68ueSs16/eSAqBEMNexA0JWMK+E47rZGIdSAYe1Z2fTxGrDxJmDfQT
	 t/edx+jkyKPUCEmw6sPvh4e441I5I6ZwWGMx0TpUCqtc658vG/Fb+iEDE45mr/Hb5K
	 57W1ScuCktZmQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67H3cWlE53586249
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 11:38:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 11:38:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 17 Aug 2026 11:38:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw89: usb: Avoid crash with dynamically
 added device ID
Thread-Topic: [PATCH rtw-next] wifi: rtw89: usb: Avoid crash with dynamically
 added device ID
Thread-Index: AQHdLavwRacpcOysC0eJvQrfIU1w6bahlZRw
Date: Mon, 17 Aug 2026 03:38:32 +0000
Message-ID: <84fa3f2903224073a3c5a9514d3f082a@realtek.com>
References: <eb6870f7-79f0-4fa8-9148-5e48366d6672@gmail.com>
In-Reply-To: <eb6870f7-79f0-4fa8-9148-5e48366d6672@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBBZGRp
bmcgYSBkZXZpY2UgSUQgdmlhIHN5c2ZzIGNhdXNlcyBhIGNyYXNoIHdoZW4gdGhlIGRldmljZSBp
cyBwbHVnZ2VkDQo+IGluLCBiZWNhdXNlIHRoZSBkcml2ZXJfaW5mbyBwb2ludGVyIGlzIG51bGwu
DQoNCkkgZG9uJ3Qga25vdyBhYm91dCB0aGlzIGJlZm9yZS4gRG9lcyBpdCBsb29rcyBsaWtlPw0K
DQogICBlY2hvICIxMjM0IDU2NzgiIHwgc3VkbyB0ZWUgL3N5cy9idXMvdXNiL2RyaXZlcnMvbXlf
ZHJpdmVyL25ld19pZA0KDQo+IA0KPiBBZGQgYSB3cmFwcGVyIGFyb3VuZCBydHc4OV91c2JfcHJv
YmUoKSBpbiBlYWNoIGRyaXZlciB0byBjaGVjayBpZg0KPiBkcml2ZXJfaW5mbyBpcyBudWxsIGFu
ZCBwcm92aWRlIGEgcmVhc29uYWJsZSBkZWZhdWx0IHZhbHVlIGZvciBpdC4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IEJpdHRlcmJsdWUgU21pdGggPHJ0bDg4MjFjZXJmZTJAZ21haWwuY29tPg0KDQpB
Y2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQoNCkknZCBnaXZlIG15
IGFja2VkLWJ5IGluIGFkdmFuY2UuIEJ1dCB5b3Ugc3RpbGwgY2FuIGNvbnNpZGVyIG15IG9waW5p
b24gYmVsb3cuDQoNCj4gLS0tDQo+IFRoZSBQQ0kgc2lkZSBoYXMgdGhlIHNhbWUgcHJvYmxlbSwg
YnV0IG5ldyBkZXZpY2UgSURzIGFyZSBhIGxvdCBsZXNzDQo+IGxpa2VseSB0aGVyZS4NCg0KVGhh
bmtzIGZvciB0aGUgaW5mby4NCg0KWy4uLl0NCg0KPiArc3RhdGljIGludCBydHc4ODUxYnVfcHJv
YmUoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYsDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkICppZCkNCj4gK3sNCj4gKyAgICAgICBjb25z
dCBzdHJ1Y3QgcnR3ODlfZHJpdmVyX2luZm8gKmluZm87DQo+ICsNCj4gKyAgICAgICBpZiAoaWQt
PmRyaXZlcl9pbmZvKQ0KPiArICAgICAgICAgICAgICAgaW5mbyA9IChjb25zdCBzdHJ1Y3QgcnR3
ODlfZHJpdmVyX2luZm8gKilpZC0+ZHJpdmVyX2luZm87DQo+ICsgICAgICAgZWxzZQ0KPiArICAg
ICAgICAgICAgICAgaW5mbyA9ICZydHc4OV84ODUxYnVfaW5mbzsNCj4gKw0KPiArICAgICAgIHJl
dHVybiBydHc4OV91c2JfcHJvYmUoaW50ZiwgaW5mbyk7DQo+ICt9DQo+ICsNCg0KSWYgeW91IHdh
bnQgdG8gc2ltcGx5IHNwZWNpZmljIHByb2JlKCksIGhlcmUgbWlnaHQgYmUgDQoNCnN0YXRpYyBp
bnQgcnR3ODg1MWJ1X3Byb2JlKHN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRmLA0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgKmlkKQ0Kew0KICAg
ICAgICByZXR1cm4gcnR3ODlfdXNiX3Byb2JlKGludGYsIGlkLCAmcnR3ODlfODg1MWJ1X2luZm8p
Ow0KfQ0KDQpUaGVuDQoNCmludCBydHc4OV91c2JfcHJvYmUoc3RydWN0IHVzYl9pbnRlcmZhY2Ug
KmludGYsDQogICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkICpp
ZCwNCiAgICAgICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0IHJ0dzg5X2RyaXZlcl9pbmZvICpk
ZWZhdWx0X2luZm8pDQp7DQogICAgICAgIC4uLg0KDQogICAgICAgIGluZm8gPSAoY29uc3Qgc3Ry
dWN0IHJ0dzg5X2RyaXZlcl9pbmZvICopaWQtPmRyaXZlcl9pbmZvOw0KICAgICAgICBpZiAoIWlu
Zm8pDQogICAgICAgICAgICAgICAgaW5mbyA9IGRlZmF1bHRfaW5mbzsNCn0NCg0KDQo=
