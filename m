Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:58828 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbbHMK3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 06:29:51 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NT0028OYNTMCO70@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Thu, 13 Aug 2015 19:29:46 +0900 (KST)
Date: Thu, 13 Aug 2015 10:29:45 +0000 (GMT)
From: Amit Khatri <amit.khatri@samsung.com>
Subject: [PATCH 3/3] iw: Avoid possible memory leak for cb
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Reply-to: amit.khatri@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1629204510.56471439461785277.JavaMail.weblogic@ep2mlwas02d> (sfid-20150813_122955_425277_A22AC03C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Y2IgZ290IG1lbW9yeSBmcm9tIG5sX2NiX2FsbG9jKCkgYnV0IG5vdCBkb2luZyBmcmVlDQpkdXJp
bmcgZXJyb3IgY2FzZSBhbmQgdXNlIHNhbWUgbGFibGUgdG8gZ28gb3V0IGZyb20gZnVuY3Rpb24u
DQoNClNpZ25lZC1vZmYtYnk6IEFtaXQgS2hhdHJpIDxhbWl0LmtoYXRyaUBzYW1zdW5nLmNvbT4N
ClNpZ25lZC1vZmYtYnk6IFJhaHVsIEphaW4gPHJhaHVsLmphaW5Ac2Ftc3VuZy5jb20+DQotLS0N
CiBpdy5jIHwgOCArKysrLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9pdy5jIGIvaXcuYw0KaW5kZXggZWM1NjczNi4u
YTJjMjc5NSAxMDA2NDQNCi0tLSBhL2l3LmMNCisrKyBiL2l3LmMNCkBAIC00NzYsMTMgKzQ3Niwx
MyBAQCBzdGF0aWMgaW50IF9faGFuZGxlX2NtZChzdHJ1Y3Qgbmw4MDIxMV9zdGF0ZSAqc3RhdGUs
IGVudW0gaWRfaW5wdXQgaWRieSwNCg0KICAgICAgICBlcnIgPSBjbWQtPmhhbmRsZXIoc3RhdGUs
IG1zZywgYXJnYywgYXJndiwgaWRieSk7DQogICAgICAgIGlmIChlcnIpDQotICAgICAgICAgICAg
ICAgZ290byBvdXQ7DQorICAgICAgICAgICAgICAgZ290byBvdXRfZnJlZV9tc2c7DQoNCiAgICAg
ICAgbmxfc29ja2V0X3NldF9jYihzdGF0ZS0+bmxfc29jaywgc19jYik7DQoNCiAgICAgICAgZXJy
ID0gbmxfc2VuZF9hdXRvX2NvbXBsZXRlKHN0YXRlLT5ubF9zb2NrLCBtc2cpOw0KICAgICAgICBp
ZiAoZXJyIDwgMCkNCi0gICAgICAgICAgICAgICBnb3RvIG91dDsNCisgICAgICAgICAgICAgICBn
b3RvIG91dF9mcmVlX21zZzsNCg0KICAgICAgICBlcnIgPSAxOw0KDQpAQCAtNDkzLDkgKzQ5Myw5
IEBAIHN0YXRpYyBpbnQgX19oYW5kbGVfY21kKHN0cnVjdCBubDgwMjExX3N0YXRlICpzdGF0ZSwg
ZW51bSBpZF9pbnB1dCBpZGJ5LA0KDQogICAgICAgIHdoaWxlIChlcnIgPiAwKQ0KICAgICAgICAg
ICAgICAgIG5sX3JlY3Ztc2dzKHN0YXRlLT5ubF9zb2NrLCBjYik7DQotIG91dDoNCi0gICAgICAg
bmxfY2JfcHV0KGNiKTsNCisNCiAgb3V0X2ZyZWVfbXNnOg0KKyAgICAgICBubF9jYl9wdXQoY2Ip
Ow0KICAgICAgICBubG1zZ19mcmVlKG1zZyk7DQogICAgICAgIHJldHVybiBlcnI7DQogIG5sYV9w
dXRfZmFpbHVyZToNCi0tDQoxLjkuMQ0K


