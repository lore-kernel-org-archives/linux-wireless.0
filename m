Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2BBC46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 08:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 335C12075D
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 08:05:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 335C12075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbeJWQ1e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 12:27:34 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:42492 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbeJWQ1d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 12:27:33 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9N858g8013015, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9N858g8013015
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 23 Oct 2018 16:05:08 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 23 Oct
 2018 16:05:07 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "zhongjiang@huawei.com" <zhongjiang@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: remove set but not used variable 'radiob_array_table' and 'radiob_arraylen'
Thread-Topic: [PATCH] rtlwifi: remove set but not used variable
 'radiob_array_table' and 'radiob_arraylen'
Thread-Index: AQHUapWqnEkjYYfngkGMMsNsCpMpTqUr8siA
Date:   Tue, 23 Oct 2018 08:05:07 +0000
Message-ID: <1540281873.25715.2.camel@realtek.com>
References: <1540273651-64688-1-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1540273651-64688-1-git-send-email-zhongjiang@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3257BDF3BB1DE479E988FED8234E1DF@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE4LTEwLTIzIGF0IDEzOjQ3ICswODAwLCB6aG9uZyBqaWFuZyB3cm90ZToNCj4g
J3JhZGlvYl9hcnJheV90YWJsZScgYW5kICdyYWRpb2JfYXJyYXlsZW4nIGlzIG5vdCB1c2VkIGFm
dGVyIHNldHRpbmcgaXRzDQo+IHZhbHVlLg0KPiBJdCBpcyBzYWZlIHRvIHJlbW92ZSB0aGUgdW51
c2VkIHZhcmlhYmxlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogemhvbmcgamlhbmcgPHpob25namlh
bmdAaHVhd2VpLmNvbT4NCj4gLS0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dGx3aWZpL3J0bDg3MjNhZS9waHkuYyB8IDUgKy0tLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9waHkuYw0KPiBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvcGh5LmMNCj4gaW5kZXggNWNm
MjlmNS4uM2YzMzI3OCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydGx3aWZpL3J0bDg3MjNhZS9waHkuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL3BoeS5jDQo+IEBAIC01MDksMTMgKzUwOSwxMCBAQCBi
b29sIHJ0bDg3MjNlX3BoeV9jb25maWdfcmZfd2l0aF9oZWFkZXJmaWxlKHN0cnVjdA0KPiBpZWVl
ODAyMTFfaHcgKmh3LA0KPiDCoAlpbnQgaTsNCj4gwqAJYm9vbCBydHN0YXR1cyA9IHRydWU7DQo+
IMKgCXUzMiAqcmFkaW9hX2FycmF5X3RhYmxlOw0KPiAtCXUzMiAqcmFkaW9iX2FycmF5X3RhYmxl
Ow0KPiAtCXUxNiByYWRpb2FfYXJyYXlsZW4sIHJhZGlvYl9hcnJheWxlbjsNCj4gKwl1MTYgcmFk
aW9hX2FycmF5bGVuOw0KPiDCoA0KPiDCoAlyYWRpb2FfYXJyYXlsZW4gPSBSVEw4NzIzRVJBRElP
QV8xVEFSUkFZTEVOR1RIOw0KPiDCoAlyYWRpb2FfYXJyYXlfdGFibGUgPSBSVEw4NzIzRV9SQURJ
T0FfMVRBUlJBWTsNCj4gLQlyYWRpb2JfYXJyYXlsZW4gPSBSVEw4NzIzRV9SQURJT0JfMVRBUlJB
WUxFTkdUSDsNCj4gLQlyYWRpb2JfYXJyYXlfdGFibGUgPSBSVEw4NzIzRV9SQURJT0JfMVRBUlJB
WTsNCj4gwqANCj4gwqAJcnRzdGF0dXMgPSB0cnVlOw0KPiDCoA0KDQpJIHRoaW5rIDg3MjNhZSBo
YXMgb25seSBvbmUgYW50ZW5uYSwgc28geW91IGNhbiByZW1vdmUgcmFkaW8gQiBhcnJheSBhcyB3
ZWxsLg0KDQo=
