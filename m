Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7CDC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 10:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF9C620663
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 10:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfB0KYC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 05:24:02 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:60124 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfB0KYC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 05:24:02 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1RANvNV013885, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1RANvNV013885
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 27 Feb 2019 18:23:58 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 27 Feb
 2019 18:23:57 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     "David R. Bergstein" <david.r.bergstein@gmail.com>
CC:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Realtek r8822be kernel module does not negotiate 802.11ac connection
Thread-Topic: Realtek r8822be kernel module does not negotiate 802.11ac
 connection
Thread-Index: AQHUzlJcsGthwPPLIUG44IxOn8EK26XzbiOQ
Date:   Wed, 27 Feb 2019 10:23:56 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
In-Reply-To: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PiBUaGlzIG1lc3NhZ2UgaXMgaW4gcmVnYXJkIHRvIGEgYnVnIEkgaGF2ZSBvcGVuIG9uIGJ1Z3Mu
bGF1bmNocGFkLm5ldCwgMTgxMzM3MiwNCj4gbGlua2VkIGJlbG93LsKgIFRoaXMgaXNzdWUsIG9y
aWdpbmFsbHkgaWRlbnRpZmllZCBpbiBhbiBVYnVudHUga2VybmVsLCBoYXMgYmVlbg0KPiBkdXBs
aWNhdGVkIGluIHRoZSBtb3N0IGN1cnJlbnQgbWFpbmxpbmUga2VybmVsLCA1LjAtcmM4LCBhbmQg
aXMgaW4gcmVnYXJkIHRvDQo+IHByb2JsZW1zIGF0dGFpbmluZyBhIHdpcmVsZXNzIGNvbm5lY3Rp
b24gYXQgODAyLjExYWMgc3BlZWRzLg0KPiANCj4gaHR0cHM6Ly9idWdzLmxhdW5jaHBhZC5uZXQv
YnVncy8xODEzMzcyDQo+IA0KPiBBdCB5b3VyIGVhcmxpZXN0IGNvbnZlbmllbmNlLCBwbGVhc2Ug
c2VlIHRoZSBidWcgcmVwb3J0IGFib3ZlLCBhbmQgYWR2aXNlIGlmIGEgZml4DQo+IHdpbGwgYmUg
YXZhaWxhYmxlIGZvciB0aGUgcjg4MjJiZSBrZXJuZWwgbW9kdWxlLg0KPiANCj4gU2luY2VyZWx5
LA0KPiANCj4gRGF2aWQgUi4gQmVyZ3N0ZWluDQo+IA0KDQpIaSwNCg0KSWYgaXQncyBwb3NzaWJs
ZSBJIHdpbGwgc3VnZ2VzdCB0aGF0IHlvdSBjYW4gdXNlIHRoZSBuZXcgZHJpdmVyICJydHc4OCIg
YmVpbmcNCnJldmlld2VkIG5vdy4gcnR3ODggaXMgYmV0dGVyIHN1cHBvcnRlZCBieSBSZWFsdGVr
IGFuZCBoYXMgc2lnbmlmaWNhbnQNCmltcHJvdmVtZW50IGluIGNvbnRyYXN0IHRvIHI4ODIyYmUu
IEFuZCBhbHNvIGl0IGlzIGFpbSB0byBiZXR0ZXIgc3VwcG9ydA0KODAyLjExYWMgc2VyaWVzIElD
cywgc28gaXQgbWF5IGhlbHAgcmVzb2x2ZSB5b3VyIHByb2JsZW0gYWJvdXQgODAyLjExYWMNCmNv
bm5lY3Rpb24gc3BlZWRzLg0KVGhhbmtzIQ0KDQpZYW4tSHN1YW4NCg0K
