Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6135C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 07:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54F692080F
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 07:39:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54F692080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbeLMHjo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 02:39:44 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:56372 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbeLMHjo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 02:39:44 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID wBD7dUAX002667, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id wBD7dUAX002667
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 13 Dec 2018 15:39:30 +0800
Received: from RTITMBSVM02.realtek.com.tw ([fe80::9150:f9a6:a910:df93]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Thu, 13 Dec
 2018 15:39:29 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kai.heng.feng@canonical.com" <kai.heng.feng@canonical.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: Fix non-working BSS STA mode
Thread-Topic: [PATCH] rtlwifi: Fix non-working BSS STA mode
Thread-Index: AQHUkdl2d+IRD9YiqUGI3cgkd+Pb7aV7TcMAgABT8QCAACJwgA==
Date:   Thu, 13 Dec 2018 07:39:29 +0000
Message-ID: <1544686767.21783.3.camel@realtek.com>
References: <20181212051335.22580-1-kai.heng.feng@canonical.com>
         <1544661346.2548.2.camel@realtek.com>
         <A95FEB12-29C5-404D-9C4E-04D1900C4E88@canonical.com>
In-Reply-To: <A95FEB12-29C5-404D-9C4E-04D1900C4E88@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8C07F1567786B4298DCFCECEE071F09@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVGh1LCAyMDE4LTEyLTEzIGF0IDEzOjM2ICswODAwLCBLYWkgSGVuZyBGZW5nIHdyb3RlOg0K
PiA+IE9uIERlYyAxMywgMjAxOCwgYXQgMDg6MzUsIFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29t
PiB3cm90ZToNCj4gPsKgDQo+ID4gT24gV2VkLCAyMDE4LTEyLTEyIGF0IDEzOjEzICswODAwLCBL
YWktSGVuZyBGZW5nIHdyb3RlOg0KPiA+PiBPbmNlIEJTUyBTVEEgbW9kZSBnZXRzIHN0YXJ0ZWQs
IGl0IGNhbiBiZSBzY2FubmVkIGJ5IG90aGVyIGNsaWVudHMgYnV0DQo+ID4+IGNhbm5vdCBlbnRh
Ymxpc2ggYSBjb25uZWN0aW9uLg0KPiA+wqDCoMKgwqDCoMKgwqDCoMKgwqBeXl4gdHlwbzogZXN0
YWJsaXNoDQo+ID4+wqANCj4gPj4gVHVybnMgb3V0IHRoZSBzZXRfYmNuX3JlZygpIGFuZCBpdHMg
Kl9zZXRfYmVhY29uX3JlbGF0ZWRfcmVnaXN0ZXJzKCkNCj4gPj4gY2FsbGJhY2tzIG5ldmVyIGdl
dCBjYWxsZWQgc28gaXQgaGFzIHByb2JsZW0gYmVhY29uaW5nLg0KPiA+PsKgDQo+ID4+IEVuYWJs
ZSB0aGUgZnVuY3Rpb24gaW4gcnRsX29wX2Jzc19pbmZvX2NoYW5nZWQoKSBjYW4gbWFrZSBCU1Mg
U1RBIG1vZGUNCj4gPj4gc3RhcnQgdG8gd29yay4NCj4gPj7CoA0KPiA+PiBTaWduZWQtb2ZmLWJ5
OiBLYWktSGVuZyBGZW5nIDxrYWkuaGVuZy5mZW5nQGNhbm9uaWNhbC5jb20+DQo+ID4+IC0tLQ0K
PiA+PsKgwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvY29yZS5jIHwgMiAr
LQ0KPiA+PsKgwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cj4gPj7CoA0KPiA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dGx3aWZpL2NvcmUuYw0KPiA+PiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9jb3JlLmMNCj4gPj4gaW5kZXggNGJmNzk2NzU5MGNhLi4xMWQyN2E1Y2M1NzYgMTAwNjQ0DQo+
ID4+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3JlLmMNCj4g
Pj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuYw0KPiA+
PiBAQCAtMTA1NCw3ICsxMDU0LDcgQEAgc3RhdGljIHZvaWQgcnRsX29wX2Jzc19pbmZvX2NoYW5n
ZWQoc3RydWN0DQo+IGllZWU4MDIxMV9odw0KPiA+PiAqaHcsDQo+ID4+wqDCoAkJCQkJwqAiQlNT
X0NIQU5HRURfQkVBQ09OX0VOQUJMRURcbiIpOw0KPiA+PsKgwqANCj4gPj7CoMKgCQkJCS8qc3Rh
cnQgaHcgYmVhY29uIGludGVycnVwdC4gKi8NCj4gPj4gLQkJCQkvKnJ0bHByaXYtPmNmZy0+b3Bz
LT5zZXRfYmNuX3JlZyhodyk7ICovDQo+ID4+ICsJCQkJcnRscHJpdi0+Y2ZnLT5vcHMtPnNldF9i
Y25fcmVnKGh3KTsNCj4gPj7CoMKgCQkJCW1hYy0+YmVhY29uX2VuYWJsZWQgPSAxOw0KPiA+PsKg
wqAJCQkJcnRscHJpdi0+Y2ZnLT5vcHMtDQo+ID51cGRhdGVfaW50ZXJydXB0X21hc2soaHcsDQo+
ID4+wqDCoAkJCQkJCXJ0bHByaXYtPmNmZy0+bWFwcw0KPiA+wqANCj4gPiBXaGljaCB3aWZpIGNo
aXAgZG8geW91IHVzZT8gQW5kLCBwbGVhc2Ugc2hhcmUgeW91ciB0ZXN0IHNjZW5hcmlvLg0KPiAN
Cj4gSXTigJlzIFJlYWx0ZWsgODcyM0RFLCB3aGljaCBpcyBjdXJyZW50bHkgbm90IHN1cHBvcnRl
ZCBpbiBtYWlubGluZSBzbyBJIHVzZQ0KPiBydGw4NzIzZGUgaW4gcnRsd2lmaV9uZXcgWzFdIHRv
IHRlc3QgaXQgb3V0Lg0KPiANCj4gVGhlIHRlc3Qgc2NlbmFyaW8gaXMgc2ltcGx5IGVuYWJsZSBo
b3RzcG90IHRocm91Z2ggbmV0d29yayBtYW5hZ2VyLCB3aGljaCB1c2VzDQo+IHdwYV9zdXBwbGlj
YW50IHRvIGRvIHRoZSB3b3JrLg0KPiANCj4gWzFdIGh0dHBzOi8vZ2l0aHViLmNvbS9sd2Zpbmdl
ci9ydGx3aWZpX25ldw0KPiANCg0KU2luY2UgcnRsODcyM2RlIGlzbid0IHN1cHBvcnRlZCB5ZXQs
IHRoaXMgcGF0Y2ggd291bGQgYmUgcGVuZGluZy4NCkknbGwgdGFrZSB0aW1lIHRvIGNoZWNrIHdo
ZXRoZXIgaXQgd29ya3Mgb24gZXhpc3RpbmcgY2hpcHMuDQoNClRoYW5rcw0KUEsNCg==
