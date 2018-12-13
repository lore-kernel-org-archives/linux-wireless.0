Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DFCC67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 00:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C27E720851
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 00:36:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C27E720851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbeLMAgB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 19:36:01 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:41662 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbeLMAgB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 19:36:01 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID wBD0Zmpp016330, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id wBD0Zmpp016330
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 13 Dec 2018 08:35:48 +0800
Received: from RTITMBSVM02.realtek.com.tw ([fe80::9150:f9a6:a910:df93]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Thu, 13 Dec 2018 08:35:48 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kai.heng.feng@canonical.com" <kai.heng.feng@canonical.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: Fix non-working BSS STA mode
Thread-Topic: [PATCH] rtlwifi: Fix non-working BSS STA mode
Thread-Index: AQHUkdl2d+IRD9YiqUGI3cgkd+Pb7aV7TcMA
Date:   Thu, 13 Dec 2018 00:35:47 +0000
Message-ID: <1544661346.2548.2.camel@realtek.com>
References: <20181212051335.22580-1-kai.heng.feng@canonical.com>
In-Reply-To: <20181212051335.22580-1-kai.heng.feng@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F68BADFFDE478E4984F15FA97748EF5E@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gV2VkLCAyMDE4LTEyLTEyIGF0IDEzOjEzICswODAwLCBLYWktSGVuZyBGZW5nIHdyb3RlOg0K
PiBPbmNlIEJTUyBTVEEgbW9kZSBnZXRzIHN0YXJ0ZWQsIGl0IGNhbiBiZSBzY2FubmVkIGJ5IG90
aGVyIGNsaWVudHMgYnV0DQo+IGNhbm5vdCBlbnRhYmxpc2ggYSBjb25uZWN0aW9uLg0KwqAgwqAg
wqAgwqAgwqBeXl4gdHlwbzogZXN0YWJsaXNoDQo+IA0KPiBUdXJucyBvdXQgdGhlIHNldF9iY25f
cmVnKCkgYW5kIGl0cyAqX3NldF9iZWFjb25fcmVsYXRlZF9yZWdpc3RlcnMoKQ0KPiBjYWxsYmFj
a3MgbmV2ZXIgZ2V0IGNhbGxlZCBzbyBpdCBoYXMgcHJvYmxlbSBiZWFjb25pbmcuDQo+IA0KPiBF
bmFibGUgdGhlIGZ1bmN0aW9uIGluIHJ0bF9vcF9ic3NfaW5mb19jaGFuZ2VkKCkgY2FuIG1ha2Ug
QlNTIFNUQSBtb2RlDQo+IHN0YXJ0IHRvIHdvcmsuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLYWkt
SGVuZyBGZW5nIDxrYWkuaGVuZy5mZW5nQGNhbm9uaWNhbC5jb20+DQo+IC0tLQ0KPiDCoGRyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3JlLmMgfCAyICstDQo+IMKgMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuYw0KPiBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3JlLmMNCj4gaW5kZXggNGJmNzk2NzU5
MGNhLi4xMWQyN2E1Y2M1NzYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnRsd2lmaS9jb3JlLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydGx3aWZpL2NvcmUuYw0KPiBAQCAtMTA1NCw3ICsxMDU0LDcgQEAgc3RhdGljIHZvaWQgcnRs
X29wX2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odw0KPiAqaHcsDQo+IMKgCQkJ
CQnCoCJCU1NfQ0hBTkdFRF9CRUFDT05fRU5BQkxFRFxuIik7DQo+IMKgDQo+IMKgCQkJCS8qc3Rh
cnQgaHcgYmVhY29uIGludGVycnVwdC4gKi8NCj4gLQkJCQkvKnJ0bHByaXYtPmNmZy0+b3BzLT5z
ZXRfYmNuX3JlZyhodyk7ICovDQo+ICsJCQkJcnRscHJpdi0+Y2ZnLT5vcHMtPnNldF9iY25fcmVn
KGh3KTsNCj4gwqAJCQkJbWFjLT5iZWFjb25fZW5hYmxlZCA9IDE7DQo+IMKgCQkJCXJ0bHByaXYt
PmNmZy0+b3BzLT51cGRhdGVfaW50ZXJydXB0X21hc2soaHcsDQo+IMKgCQkJCQkJcnRscHJpdi0+
Y2ZnLT5tYXBzDQoNCldoaWNoIHdpZmkgY2hpcCBkbyB5b3UgdXNlPyBBbmQsIHBsZWFzZSBzaGFy
ZSB5b3VyIHRlc3Qgc2NlbmFyaW8uDQoNClRoYW5rcw0KDQo=
