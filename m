Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3F5C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 02:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C89A92183E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 02:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfCTCbl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 22:31:41 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:35488 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbfCTCbl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 22:31:41 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x2K2VPfF031868, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x2K2VPfF031868
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Wed, 20 Mar 2019 10:31:25 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Wed, 20 Mar
 2019 10:31:25 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "chongguiguzi@gmail.com" <chongguiguzi@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net:rtlwifi:move spin_lock_bh to spin_lock in tasklet
Thread-Topic: [PATCH] net:rtlwifi:move spin_lock_bh to spin_lock in tasklet
Thread-Index: AQHU3mBt7wTMcSoJ60SEBke6L1fM0KYTRygA
Date:   Wed, 20 Mar 2019 02:31:24 +0000
Message-ID: <1553049084.13542.2.camel@realtek.com>
References: <1553005870-28018-1-git-send-email-chongguiguzi@gmail.com>
In-Reply-To: <1553005870-28018-1-git-send-email-chongguiguzi@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.114]
Content-Type: text/plain; charset="utf-8"
Content-ID: <24F7DAF16D7F7E4C9757AD47B5DBB1DB@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE5LTAzLTE5IGF0IDIyOjMxICswODAwLCBKZWZmIFhpZSB3cm90ZToNCj4gSXQg
aXMgdW5uZWNlc3NhcnkgdG8gY2FsbCBzcGluX2xvY2tfYmggaW4gYSB0YXNrbGV0Lg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogSmVmZiBYaWUgPGNob25nZ3VpZ3V6aUBnbWFpbC5jb20+DQo+IA0KPiAt
LS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcGNpLmMgfCA2ICsr
Ky0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZp
L3BjaS5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3BjaS5jDQo+
IGluZGV4IDQ4Y2E1MjEuLjQwNTVlMGEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnRsd2lmaS9wY2kuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0bHdpZmkvcGNpLmMNCj4gQEAgLTQ5OSwxNiArNDk5LDE2IEBAIHN0YXRpYyB2b2lk
IF9ydGxfcGNpX3R4X2Noa193YWl0cShzdHJ1Y3QgaWVlZTgwMjExX2h3DQo+ICpodykNCj4gwqAN
Cj4gwqAJCQltZW1zZXQoJnRjYl9kZXNjLCAwLCBzaXplb2Yoc3RydWN0IHJ0bF90Y2JfZGVzYykp
Ow0KPiDCoA0KPiAtCQkJc3Bpbl9sb2NrX2JoKCZydGxwcml2LT5sb2Nrcy53YWl0cV9sb2NrKTsN
Cj4gKwkJCXNwaW5fbG9jaygmcnRscHJpdi0+bG9ja3Mud2FpdHFfbG9jayk7DQo+IMKgCQkJaWYg
KCFza2JfcXVldWVfZW1wdHkoJm1hYy0+c2tiX3dhaXRxW3RpZF0pICYmDQo+IMKgCQkJwqDCoMKg
wqAocmluZy0+ZW50cmllcyAtIHNrYl9xdWV1ZV9sZW4oJnJpbmctPnF1ZXVlKSA+DQo+IMKgCQkJ
wqDCoMKgwqDCoHJ0bGhhbC0+bWF4X2Vhcmx5bW9kZV9udW0pKSB7DQo+IMKgCQkJCXNrYiA9IHNr
Yl9kZXF1ZXVlKCZtYWMtPnNrYl93YWl0cVt0aWRdKTsNCj4gwqAJCQl9IGVsc2Ugew0KPiAtCQkJ
CXNwaW5fdW5sb2NrX2JoKCZydGxwcml2LT5sb2Nrcy53YWl0cV9sb2NrKTsNCj4gKwkJCQlzcGlu
X3VubG9jaygmcnRscHJpdi0+bG9ja3Mud2FpdHFfbG9jayk7DQo+IMKgCQkJCWJyZWFrOw0KPiDC
oAkJCX0NCj4gLQkJCXNwaW5fdW5sb2NrX2JoKCZydGxwcml2LT5sb2Nrcy53YWl0cV9sb2NrKTsN
Cj4gKwkJCXNwaW5fdW5sb2NrKCZydGxwcml2LT5sb2Nrcy53YWl0cV9sb2NrKTsNCj4gwqANCj4g
wqAJCQkvKiBTb21lIG1hY2FkZHIgY2FuJ3QgZG8gZWFybHkgbW9kZS4gbGlrZQ0KPiDCoAkJCcKg
KiBtdWx0aWNhc3QvYnJvYWRjYXN0L25vX3FvcyBkYXRhDQoNClRoZSBtYWlsIHN1YmplY3Qgc2hv
dWxkIGJlICdydGx3aWZpOiBtb3ZlIC4uLi4nLCBhbmQgdGhlIG90aGVyIGxvb2tzIGdvb2QgdG8g
bWUuDQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KDQo=
