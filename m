Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55534 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751263AbdGQDMM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 23:12:12 -0400
From: Xinming Hu <huxm@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>
Subject: Re: [PATCH] mwifiex: usb: unlock on error in
 mwifiex_usb_tx_aggr_tmo()
Date: Mon, 17 Jul 2017 03:12:08 +0000
Message-ID: <f30cbe024e584abea4b67d453b171450@SC-EXCH02.marvell.com> (sfid-20170717_051217_194711_BE9C9DF6)
References: <20170710072115.2y4ukbl7x4rk4bac@mwanda>
In-Reply-To: <20170710072115.2y4ukbl7x4rk4bac@mwanda>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuIENhcnBlbnRl
ciBbbWFpbHRvOmRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbV0NCj4gU2VudDogMjAxN8TqN9TCMTDI
1SAxNToyMQ0KPiBUbzogQW1pdGt1bWFyIEthcndhcjsgWGlubWluZyBIdQ0KPiBDYzogTmlzaGFu
dCBTYXJtdWthZGFtOyBHYW5hcGF0aGkgQmhhdDsgS2FsbGUgVmFsbzsNCj4gbGludXgtd2lyZWxl
c3NAdmdlci5rZXJuZWwub3JnOyBrZXJuZWwtamFuaXRvcnNAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IFtFWFRdIFtQQVRDSF0gbXdpZmlleDogdXNiOiB1bmxvY2sgb24gZXJyb3IgaW4NCj4g
bXdpZmlleF91c2JfdHhfYWdncl90bW8oKQ0KPiANCj4gRXh0ZXJuYWwgRW1haWwNCj4gDQo+IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4gV2UgbmVlZCB0byB1bmxvY2sgaWYgbXdpZmlleF91c2JfcHJlcGFyZV90
eF9hZ2dyX3NrYigpIGZhaWxzLg0KPiANCj4gRml4ZXM6IGEyY2E4NWFkNzIxZCAoIm13aWZpZXg6
IHVzYjogYWRkIHRpbWVyIHRvIGZsdXNoIGFnZ3JlZ2F0aW9uIHBhY2tldHMiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+DQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3VzYi5jDQo+
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3VzYi5jDQo+IGluZGV4IGNi
MTc1M2U0M2VmNC4uODgwZWYxY2I0MDg4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9tYXJ2ZWxsL213aWZpZXgvdXNiLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bWFydmVsbC9td2lmaWV4L3VzYi5jDQo+IEBAIC0xMTEyLDcgKzExMTIsNyBAQCBzdGF0aWMgdm9p
ZCBtd2lmaWV4X3VzYl90eF9hZ2dyX3Rtbyh1bnNpZ25lZCBsb25nDQo+IGNvbnRleHQpDQo+ICAJ
aWYgKGVycikgew0KPiAgCQltd2lmaWV4X2RiZyhhZGFwdGVyLCBFUlJPUiwNCj4gIAkJCSAgICAi
cHJlcGFyZSB0eCBhZ2dyIHNrYiBmYWlsZWQsIGVycj0lZFxuIiwgZXJyKTsNCj4gLQkJcmV0dXJu
Ow0KPiArCQlnb3RvIHVubG9jazsNCj4gIAl9DQo+IA0KPiAgCWlmIChhdG9taWNfcmVhZCgmcG9y
dC0+dHhfZGF0YV91cmJfcGVuZGluZykgPj0gQEAgLTExMzMsNiArMTEzMyw3DQo+IEBAIHN0YXRp
YyB2b2lkIG13aWZpZXhfdXNiX3R4X2FnZ3JfdG1vKHVuc2lnbmVkIGxvbmcgY29udGV4dCkNCj4g
IGRvbmU6DQo+ICAJaWYgKGVyciA9PSAtMSkNCj4gIAkJbXdpZmlleF93cml0ZV9kYXRhX2NvbXBs
ZXRlKGFkYXB0ZXIsIHNrYl9zZW5kLCAwLCAtMSk7DQo+ICt1bmxvY2s6DQo+ICAJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmcG9ydC0+dHhfYWdncl9sb2NrLCBmbGFncyk7ICB9DQo+IA0KDQpDaGFu
Z2UgbG9va3MgZmluZSB0byBtZS4gVGhhbmtzLg0KDQpSZWdhcmRzLA0KU2ltb24NCg==
