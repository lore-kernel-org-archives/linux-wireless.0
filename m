Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46707 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbHZDq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 23:46:58 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NTO01NT37U8SJ10@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Wed, 26 Aug 2015 12:46:56 +0900 (KST)
Date: Wed, 26 Aug 2015 03:46:49 +0000 (GMT)
From: Amit Khatri <amit.khatri@samsung.com>
Subject: [PATCH V2] iw: Avoid possible memory leak for cb
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>
Reply-to: amit.khatri@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <422132231.154501440560808536.JavaMail.weblogic@ep2mlwas09b> (sfid-20150826_054701_702337_174FEAD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Y2IgZ290IG1lbW9yeSBmcm9tIG5sX2NiX2FsbG9jKCkgYnV0IG5vdCBkb2luZyBmcmVlDQpkdXJp
bmcgZXJyb3IgY2FzZSBhbmQgdXNlIHNhbWUgbGFibGUgdG8gZ28gb3V0IGZyb20gZnVuY3Rpb24u
DQoNClNpZ25lZC1vZmYtYnk6IEFtaXQgS2hhdHJpIDxhbWl0LmtoYXRyaUBzYW1zdW5nLmNvbT4N
ClNpZ25lZC1vZmYtYnk6IFJhaHVsIEphaW4gPHJhaHVsLmphaW5Ac2Ftc3VuZy5jb20+DQotLS0N
CiBpdy5jIHwgMTAgKysrKysrLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyks
IDQgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9pdy5jIGIvaXcuYw0KaW5kZXggZWM1Njcz
Ni4uMTM4NTQ0MSAxMDA2NDQNCi0tLSBhL2l3LmMNCisrKyBiL2l3LmMNCkBAIC00NzYsMTMgKzQ3
NiwxMyBAQCBzdGF0aWMgaW50IF9faGFuZGxlX2NtZChzdHJ1Y3Qgbmw4MDIxMV9zdGF0ZSAqc3Rh
dGUsIGVudW0gaWRfaW5wdXQgaWRieSwNCiANCiAJZXJyID0gY21kLT5oYW5kbGVyKHN0YXRlLCBt
c2csIGFyZ2MsIGFyZ3YsIGlkYnkpOw0KIAlpZiAoZXJyKQ0KLQkJZ290byBvdXQ7DQorCQlnb3Rv
IG91dF9mcmVlX21zZzsNCiANCiAJbmxfc29ja2V0X3NldF9jYihzdGF0ZS0+bmxfc29jaywgc19j
Yik7DQogDQogCWVyciA9IG5sX3NlbmRfYXV0b19jb21wbGV0ZShzdGF0ZS0+bmxfc29jaywgbXNn
KTsNCiAJaWYgKGVyciA8IDApDQotCQlnb3RvIG91dDsNCisJCWdvdG8gb3V0X2ZyZWVfbXNnOw0K
IA0KIAllcnIgPSAxOw0KIA0KQEAgLTQ5Myw5ICs0OTMsMTEgQEAgc3RhdGljIGludCBfX2hhbmRs
ZV9jbWQoc3RydWN0IG5sODAyMTFfc3RhdGUgKnN0YXRlLCBlbnVtIGlkX2lucHV0IGlkYnksDQog
DQogCXdoaWxlIChlcnIgPiAwKQ0KIAkJbmxfcmVjdm1zZ3Moc3RhdGUtPm5sX3NvY2ssIGNiKTsN
Ci0gb3V0Og0KLQlubF9jYl9wdXQoY2IpOw0KICBvdXRfZnJlZV9tc2c6DQorCWlmKCFjYikNCisJ
CW5sX2NiX3B1dChjYik7DQorCWlmKCFzX2NiKQ0KKwkJbmxfY2JfcHV0KHNfY2IpOw0KIAlubG1z
Z19mcmVlKG1zZyk7DQogCXJldHVybiBlcnI7DQogIG5sYV9wdXRfZmFpbHVyZToNCi0tIA0KMS45
LjE=


