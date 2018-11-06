Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C80C0044C
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 01:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48A4120827
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 01:57:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48A4120827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbeKFLUD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 06:20:03 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:52467 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbeKFLUC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 06:20:02 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID wA61vAVd012008, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id wA61vAVd012008
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 6 Nov 2018 09:57:10 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Tue, 6 Nov 2018 09:57:10 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Subject: Re: [PATCH] rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL information
Thread-Topic: [PATCH] rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL
 information
Thread-Index: AQHUdPpGKgAR2kiS3EaH+4Hng9JbbKVBd/kA
Date:   Tue, 6 Nov 2018 01:57:09 +0000
Message-ID: <1541469426.3804.0.camel@realtek.com>
References: <1541417130-9898-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1541417130-9898-1-git-send-email-zhangshaokun@hisilicon.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9E5ABFD90E10144988F13C9058A09B9@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gTW9uLCAyMDE4LTExLTA1IGF0IDE5OjI1ICswODAwLCBTaGFva3VuIFpoYW5nIHdyb3RlOg0K
PiBSVF9UUkFDRSBzaG93cyBSRUdfTUNVRldETCB2YWx1ZSBhcyBhIGRlY2ltYWwgdmFsdWUgd2l0
aCBhICcweCcNCj4gcHJlZml4LCB3aGljaCBpcyBzb21ld2hhdCBtaXNsZWFkaW5nLg0KPiANCj4g
Rml4IGl0IHRvIHByaW50IGhleGFkZWNpbWFsLCBhcyB3YXMgaW50ZW5kZWQuDQo+IA0KPiBDYzog
UGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+IENjOiBLYWxsZSBWYWxvIDxrdmFs
b0Bjb2RlYXVyb3JhLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogU2hhb2t1biBaaGFuZyA8emhhbmdz
aGFva3VuQGhpc2lsaWNvbi5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnRsd2lmaS9ydGw4MTkyZGUvZncuYyB8IDIgKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmRlL2Z3LmMNCj4gYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmRlL2Z3LmMNCj4gaW5kZXggODVj
ZWRkMC4uNzViZmE5ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydGx3aWZpL3J0bDgxOTJkZS9mdy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnRsd2lmaS9ydGw4MTkyZGUvZncuYw0KPiBAQCAtMTczLDcgKzE3Myw3IEBAIHN0YXRp
YyBpbnQgX3J0bDkyZF9md19pbml0KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0KPiDCoAkJCcKg
cnRsX3JlYWRfYnl0ZShydGxwcml2LCBGV19NQUMxX1JFQURZKSk7DQo+IMKgCX0NCj4gwqAJUlRf
VFJBQ0UocnRscHJpdiwgQ09NUF9GVywgREJHX0RNRVNHLA0KPiAtCQnCoCJQb2xsaW5nIEZXIHJl
YWR5IGZhaWwhISBSRUdfTUNVRldETDoweCUwOHVsXG4iLA0KPiArCQnCoCJQb2xsaW5nIEZXIHJl
YWR5IGZhaWwhISBSRUdfTUNVRldETDoweCUwOHhcbiIsDQo+IMKgCQnCoHJ0bF9yZWFkX2R3b3Jk
KHJ0bHByaXYsIFJFR19NQ1VGV0RMKSk7DQo+IMKgCXJldHVybiAtMTsNCj4gwqB9DQoNCkFja2Vk
LWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KVGhhbmtzIGZvciB5b3Vy
IGZpeC4NCg0K
