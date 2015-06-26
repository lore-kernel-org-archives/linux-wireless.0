Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:44299 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbFZJKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 05:10:39 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NQJ02HZ0O5PXX00@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Fri, 26 Jun 2015 18:10:37 +0900 (KST)
Date: Fri, 26 Jun 2015 09:10:37 +0000 (GMT)
From: Amit Khatri <amit.khatri@samsung.com>
Subject: [PATCH 2/4] iw: Avoid possible memory leak for cb. cb got memory from
 nl_cb_alloc() but not doing free
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Reply-to: amit.khatri@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <2034214352.309341435309836730.JavaMail.weblogic@ep2mlwas06c> (sfid-20150626_111045_907460_4AE4D623)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNClN1YmplY3Q6IFtQQVRDSCAyLzRdIGl3OiBBdm9pZCBwb3NzaWJsZSBt
ZW1vcnkgbGVhayBmb3IgY2IuIGNiIGdvdCBtZW1vcnkgZnJvbQ0KIG5sX2NiX2FsbG9jKCkgYnV0
IG5vdCBkb2luZyBmcmVlDQoNClNpZ25lZC1vZmYtYnk6IEFtaXQgS2hhdHJpIDxhbWl0LmtoYXRy
aUBzYW1zdW5nLmNvbT4NClNpZ25lZC1vZmYtYnk6IFJhaHVsIEphaW4gPHJhaHVsLmphaW5Ac2Ft
c3VuZy5jb20+DQotLS0NCiBpdy5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvaXcuYyBiL2l3LmMNCmluZGV4IGRj
OTk1NjYuLjFlOTEzYjYgMTAwNjQ0DQotLS0gYS9pdy5jDQorKysgYi9pdy5jDQpAQCAtNDc3LDgg
KzQ3Nyw4IEBAIHN0YXRpYyBpbnQgX19oYW5kbGVfY21kKHN0cnVjdCBubDgwMjExX3N0YXRlICpz
dGF0ZSwgZW51bSBpZF9pbnB1dCBpZGJ5LA0KIAl3aGlsZSAoZXJyID4gMCkNCiAJCW5sX3JlY3Zt
c2dzKHN0YXRlLT5ubF9zb2NrLCBjYik7DQogIG91dDoNCi0JbmxfY2JfcHV0KGNiKTsNCiAgb3V0
X2ZyZWVfbXNnOg0KKwlubF9jYl9wdXQoY2IpOw0KIAlubG1zZ19mcmVlKG1zZyk7DQogCXJldHVy
biBlcnI7DQogIG5sYV9wdXRfZmFpbHVyZToNCi0tIA0KMS45LjE=


