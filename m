Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E76FC3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 09:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5080722D6D
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 09:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfICJS5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 05:18:57 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:42558 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfICJS5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 05:18:57 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x839ImAN028943, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x839ImAN028943
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 3 Sep 2019 17:18:48 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Tue, 3 Sep 2019
 17:18:48 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>
Subject: RE: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
Thread-Topic: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft
 IRQ
Thread-Index: AQHVYYiSKHM1M02ZmUe7DBCiQj9296cYujYAgADzjqA=
Date:   Tue, 3 Sep 2019 09:18:47 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D18C363B@RTITMBSVM04.realtek.com.tw>
References: <F7CD281DE3E379468C6D07993EA72F84D18A5786@RTITMBSVM04.realtek.com.tw>
 <20190826070827.1436-1-jian-hong@endlessm.com>
 <F7CD281DE3E379468C6D07993EA72F84D18AE2DA@RTITMBSVM04.realtek.com.tw>
 <875zmarivz.fsf@kamboji.qca.qualcomm.com>
 <CAPpJ_efAxQN4pRdpVmT5Pdkp-6Y-QVOQdJR4iY4A-PXZokLGtA@mail.gmail.com>
In-Reply-To: <CAPpJ_efAxQN4pRdpVmT5Pdkp-6Y-QVOQdJR4iY4A-PXZokLGtA@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.183]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PiBGcm9tOiBKaWFuLUhvbmcgUGFuIFttYWlsdG86amlhbi1ob25nQGVuZGxlc3NtLmNvbV0NCj4g
DQo+ID4NCj4gPiBUb255IENodWFuZyA8eWhjaHVhbmdAcmVhbHRlay5jb20+IHdyaXRlczoNCj4g
Pg0KPiA+ID4+IEZyb206IEppYW4tSG9uZyBQYW4NCj4gPiA+PiBTdWJqZWN0OiBbUEFUQ0ggdjRd
IHJ0dzg4OiBwY2k6IE1vdmUgYSBtYXNzIG9mIGpvYnMgaW4gaHcgSVJRIHRvIHNvZnQNCj4gSVJR
DQo+ID4gPj4NCj4gPiA+PiBUaGVyZSBpcyBhIG1hc3Mgb2Ygam9icyBiZXR3ZWVuIHNwaW4gbG9j
ayBhbmQgdW5sb2NrIGluIHRoZSBoYXJkd2FyZQ0KPiA+ID4+IElSUSB3aGljaCB3aWxsIG9jY3Vw
eSBtdWNoIHRpbWUgb3JpZ2luYWxseS4gVG8gbWFrZSBzeXN0ZW0gd29yayBtb3JlDQo+ID4gPj4g
ZWZmaWNpZW50bHksIHRoaXMgcGF0Y2ggbW92ZXMgdGhlIGpvYnMgdG8gdGhlIHNvZnQgSVJRIChi
b3R0b20gaGFsZikgdG8NCj4gPiA+PiByZWR1Y2UgdGhlIHRpbWUgaW4gaGFyZHdhcmUgSVJRLg0K
PiA+ID4+DQo+ID4gPj4gU2lnbmVkLW9mZi1ieTogSmlhbi1Ib25nIFBhbiA8amlhbi1ob25nQGVu
ZGxlc3NtLmNvbT4NCj4gPiA+DQo+ID4gPiBOb3cgaXQgd29ya3MgZmluZSB3aXRoIE1TSSBpbnRl
cnJ1cHQgZW5hYmxlZC4NCj4gPiA+DQo+ID4gPiBCdXQgdGhpcyBwYXRjaCBpcyBjb25mbGljdGlu
ZyB3aXRoIE1TSSBpbnRlcnJ1cHQgcGF0Y2guDQo+ID4gPiBJcyB0aGVyZSBhIGJldHRlciB3YXkg
d2UgY2FuIG1ha2UgS2FsbGUgYXBwbHkgdGhlbSBtb3JlIHNtb290aGx5Pw0KPiA+ID4gSSBjYW4g
cmViYXNlIHRoZW0gYW5kIHN1Ym1pdCBib3RoIGlmIHlvdSdyZSBPSy4NCj4gDQo+IFRoZSByZWJh
c2Ugd29yayBpcyBhcHByZWNpYXRlZC4NCj4gDQoNClJlYmFzZWQgYW5kIHNlbnQuIFBsZWFzZSBj
aGVjayBpdCBhbmQgc2VlIGlmIEkndmUgZG9uZSBhbnl0aGluZyB3cm9uZyA6KQ0KaHR0cHM6Ly9w
YXRjaHdvcmsua2VybmVsLm9yZy9jb3Zlci8xMTEyNzQ1My8NCg0KVGhhbmtzLA0KWWFuLUhzdWFu
DQo=
