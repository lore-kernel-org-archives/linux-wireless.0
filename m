Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C8BC7112C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 01:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC01420674
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 01:24:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC01420674
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbeJWJpa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 05:45:30 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55051 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbeJWJpa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 05:45:30 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9N1O432025981, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9N1O432025981
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 23 Oct 2018 09:24:04 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 23 Oct
 2018 09:24:04 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "gustavo@embeddedor.com" <gustavo@embeddedor.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/20] rtlwifi: rtl8821ae: phy: Mark expected switch fall-through
Thread-Topic: [PATCH 19/20] rtlwifi: rtl8821ae: phy: Mark expected switch
 fall-through
Thread-Index: AQHUakiNjRTzSjAO0U2PXkgqC4Gn3qUrg1UA
Date:   Tue, 23 Oct 2018 01:24:03 +0000
Message-ID: <1540257810.2768.3.camel@realtek.com>
References: <cover.1540239684.git.gustavo@embeddedor.com>
         <0a15ff0a1f238f2868ceefc6440ba9ac03e98a22.1540239684.git.gustavo@embeddedor.com>
In-Reply-To: <0a15ff0a1f238f2868ceefc6440ba9ac03e98a22.1540239684.git.gustavo@embeddedor.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BE827F70F6F5C45B0096D093B9C4C6E@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gTW9uLCAyMDE4LTEwLTIyIGF0IDIyOjQ3ICswMjAwLCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdy
b3RlOg0KPiBJbiBwcmVwYXJhdGlvbiB0byBlbmFibGluZyAtV2ltcGxpY2l0LWZhbGx0aHJvdWdo
LCBtYXJrIHN3aXRjaCBjYXNlcw0KPiB3aGVyZSB3ZSBhcmUgZXhwZWN0aW5nIHRvIGZhbGwgdGhy
b3VnaC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9A
ZW1iZWRkZWRvci5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9ydGw4ODIxYWUvcGh5LmMgfCAxICsNCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVr
L3J0bHdpZmkvcnRsODgyMWFlL3BoeS5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydGx3aWZpL3J0bDg4MjFhZS9waHkuYw0KPiBpbmRleCAxNzZkZWIyLi5hNzU0NTFjIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODgyMWFl
L3BoeS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4
ODIxYWUvcGh5LmMNCj4gQEAgLTM5NCw2ICszOTQsNyBAQCBzdGF0aWMgdm9pZCBfcnRsODgxMmFl
X3BoeV9zZXRfcmZlX3JlZ18yNGcoc3RydWN0DQo+IGllZWU4MDIxMV9odyAqaHcpDQo+IMKgCQkJ
cnRsX3NldF9iYnJlZyhodywgUkJfUkZFX0lOViwgQk1BU0tSRkVJTlYsIDB4MDAwKTsNCj4gwqAJ
CQlicmVhazsNCj4gwqAJCX0NCj4gKwkJLyogZmFsbCB0aHJvdWdoICovDQo+IMKgCWNhc2UgMDoN
Cj4gwqAJY2FzZSAyOg0KPiDCoAlkZWZhdWx0Og0KDQpJZiBCVCBpc24ndCBjb2V4aXN0aW5nIGlu
IHRoZSBjYXNlIDEsIHRoZSBzZXR0aW5ncyB3aWxsIGJlIHRoZSBzYW1lIGFzIGNhc2UgMC8yLg0K
DQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQoNCg0K
