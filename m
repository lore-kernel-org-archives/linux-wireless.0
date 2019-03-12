Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00154C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC23E2147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfCLJE1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:04:27 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49654 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfCLJE0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 05:04:26 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x2C93grR019438, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x2C93grR019438
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 12 Mar 2019 17:03:42 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Tue, 12 Mar
 2019 17:03:42 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kjlu@umn.edu" <kjlu@umn.edu>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "pakki001@umn.edu" <pakki001@umn.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] net: rtl8192c: fix a potential NULL pointer dereference
Thread-Topic: [PATCH] net: rtl8192c: fix a potential NULL pointer dereference
Thread-Index: AQHU2KmXrjPvinAiN0WrkKdotGttEqYHLYEA
Date:   Tue, 12 Mar 2019 09:03:41 +0000
Message-ID: <1552381414.27421.2.camel@realtek.com>
References: <20190312075948.1569-1-kjlu@umn.edu>
In-Reply-To: <20190312075948.1569-1-kjlu@umn.edu>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.114]
Content-Type: text/plain; charset="utf-8"
Content-ID: <279208A04EF82A42A66D47A928DD58E2@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE5LTAzLTEyIGF0IDAyOjU5IC0wNTAwLCBLYW5namllIEx1IHdyb3RlOg0KPiBJ
biBjYXNlIGRldl9hbGxvY19za2IgZmFpbHMsIHRoZSBmaXggc2FmZWx5IHJldHVybnMgdG8gYXZv
aWQNCj4gcG90ZW50aWFsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEthbmdqaWUgTHUgPGtqbHVAdW1uLmVkdT4NCj4gLS0tDQo+IMKgZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjL2Z3X2NvbW1vbi5jIHwgMyArKysNCj4g
wqAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjL2Z3X2NvbW1vbi5jDQo+
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjL2Z3X2NvbW1v
bi5jDQo+IGluZGV4IDE4Yzc2OTkwYTA4OS4uOTA0MmZjMDQ0YzdlIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmMvZndfY29tbW9uLmMN
Cj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjL2Z3
X2NvbW1vbi5jDQo+IEBAIC02MjMsNiArNjIzLDkgQEAgdm9pZCBydGw5MmNfc2V0X2Z3X3JzdmRw
YWdlcGt0KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KPiDCoAkJwqDCoMKgwqDCoMKgdTFyc3Zk
cGFnZWxvYywgMyk7DQo+IMKgDQo+IMKgCXNrYiA9IGRldl9hbGxvY19za2IodG90YWxwYWNrZXRs
ZW4pOw0KPiArCWlmICghc2tiKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gwqAJc2tiX3B1dF9kYXRh
KHNrYiwgJnJlc2VydmVkX3BhZ2VfcGFja2V0LCB0b3RhbHBhY2tldGxlbik7DQo+IMKgDQo+IMKg
CWlmIChjbWRfc2VuZF9wYWNrZXQpDQoNClRoZSBzdWJqZWN0IHByZWZpeCBzaG91bGQgYmUgJ3J0
bHdpZmk6IC4uLicuDQoNCllvdXIgZml4IGlzIG9rLCBidXQgSSB3b3VsZCBsaWtlIHRvIGZpeCBh
bGwgZmFpbGVkIGNhc2VzIG9mwqBkZXZfYWxsb2Nfc2tiKCkuDQpJIHdpbGwgc2VuZCBhbm90aGVy
IHBhdGNoIHRvIGZpeCBhbGwgb2YgdGhlbS4NCg0KVGhhbmtzDQpQSw0KDQo=
