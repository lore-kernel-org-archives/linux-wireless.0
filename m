Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44034C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 02:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DE0E2184D
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 02:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfCTCch (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 22:32:37 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:35744 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfCTCch (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 22:32:37 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x2K2WSRD032265, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x2K2WSRD032265
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 20 Mar 2019 10:32:28 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Wed, 20 Mar 2019 10:32:28 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] rtl8723ae: Make rtl8723e_dm_refresh_rate_adaptive_mask static
Thread-Topic: [PATCH] rtl8723ae: Make rtl8723e_dm_refresh_rate_adaptive_mask
 static
Thread-Index: AQHU3mculwHhatiGhEap5VNent6MSaYTR2aA
Date:   Wed, 20 Mar 2019 02:32:26 +0000
Message-ID: <1553049147.13542.3.camel@realtek.com>
References: <20190319151927.19392-1-yuehaibing@huawei.com>
In-Reply-To: <20190319151927.19392-1-yuehaibing@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.114]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EBD4942B32CDF4F805CBE795DAC48ED@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE5LTAzLTE5IGF0IDIzOjE5ICswODAwLCBZdWUgSGFpYmluZyB3cm90ZToNCj4g
RnJvbTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KPiANCj4gRml4IHNwYXJz
ZSB3YXJuaW5nOg0KPiANCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0
bDg3MjNhZS9kbS5jOjY2Njo2Og0KPiDCoHdhcm5pbmc6IHN5bWJvbCAncnRsODcyM2VfZG1fcmVm
cmVzaF9yYXRlX2FkYXB0aXZlX21hc2snIHdhcyBub3QgZGVjbGFyZWQuDQo+IFNob3VsZCBpdCBi
ZSBzdGF0aWM/DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBZdWVIYWliaW5nIDx5dWVoYWliaW5nQGh1
YXdlaS5jb20+DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4N
Cg0KVGhlIG1haWwgc3ViamVjdCBzaG91bGQgYmUgJ3J0bHdpZmk6IHJ0bDg3MjNhZTogLi4uLicu
DQoNCg0KPiAtLS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRs
ODcyM2FlL2RtLmMgfCAyICstDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jDQo+IGluZGV4IDUxNDg5MWUuLmQ4MjYwYzcgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIz
YWUvZG0uYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRs
ODcyM2FlL2RtLmMNCj4gQEAgLTY2Myw3ICs2NjMsNyBAQCB2b2lkIHJ0bDg3MjNlX2RtX2luaXRf
cmF0ZV9hZGFwdGl2ZV9tYXNrKHN0cnVjdA0KPiBpZWVlODAyMTFfaHcgKmh3KQ0KPiDCoA0KPiDC
oH0NCj4gwqANCj4gLXZvaWQgcnRsODcyM2VfZG1fcmVmcmVzaF9yYXRlX2FkYXB0aXZlX21hc2so
c3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQo+ICtzdGF0aWMgdm9pZCBydGw4NzIzZV9kbV9yZWZy
ZXNoX3JhdGVfYWRhcHRpdmVfbWFzayhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCj4gwqB7DQo+
IMKgCXN0cnVjdCBydGxfcHJpdiAqcnRscHJpdiA9IHJ0bF9wcml2KGh3KTsNCj4gwqAJc3RydWN0
IHJ0bF9oYWwgKnJ0bGhhbCA9IHJ0bF9oYWwocnRsX3ByaXYoaHcpKTsNCg0KDQoNCg0K
