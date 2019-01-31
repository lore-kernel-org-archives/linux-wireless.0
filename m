Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236FDC282D7
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 02:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E494E20989
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 02:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfAaCzR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 21:55:17 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:35264 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfAaCzR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 21:55:17 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0V2slAL019210, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0V2slAL019210
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 10:54:47 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCASV02.realtek.com.tw (172.21.6.19) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 31 Jan 2019 10:54:47 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0435.000; Thu, 31 Jan
 2019 10:54:46 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC:     Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v4 01/13] rtw88: main files
Thread-Topic: [PATCH v4 01/13] rtw88: main files
Thread-Index: AQHUuFC2cuenuOQLLEKK24SdaGQZEaXHeQ2AgAE2a8A=
Date:   Thu, 31 Jan 2019 02:54:45 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D179A6C4@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-2-git-send-email-yhchuang@realtek.com>
 <143e9b9f-f8fb-aa45-8403-a498cfb7a5e9@lwfinger.net>
In-Reply-To: <143e9b9f-f8fb-aa45-8403-a498cfb7a5e9@lwfinger.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PiBGcm9tOiBMYXJyeSBGaW5nZXIgW21haWx0bzpsYXJyeS5maW5nZXJAZ21haWwuY29tXSBPbiBC
ZWhhbGYgT2YgTGFycnkgRmluZ2VyDQo+IA0KPiBPbiAxLzI5LzE5IDEwOjAyIFBNLCB5aGNodWFu
Z0ByZWFsdGVrLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBZYW4tSHN1YW4gQ2h1YW5nPHloY2h1YW5n
QHJlYWx0ZWsuY29tPg0KPiA+DQo+ID4gbWFpbiBmaWxlcyBmb3IgUmVhbHRlayA4MDIuMTFhYyB3
aXJlbGVzcyBuZXR3b3JrIGNoaXBzDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZYW4tSHN1YW4g
Q2h1YW5nPHloY2h1YW5nQHJlYWx0ZWsuY29tPg0KPiA+IC0tLQ0KPiANCj4gVGhpcyBwYXRjaCBp
cyBjb3JydXB0ZWQsIGFuZCB3aWxsIG5vdCBhcHBseS4NCj4gDQo+IEl0IHNob3VsZCBiZSBPSyB0
byByZXNlbmQgb25seSB0aGlzIG9uZS4NCj4gDQo+IExhcnJ5DQo+IA0KDQpLYWxsZSwNCg0KVGhp
cyBwYXRjaCBpcyBjb3JydXB0ZWQsIHBsZWFzZSBkcm9wIGl0LCBhbmQgSSB3aWxsIHJlc2VuZC4N
ClRoYW5rcy4NCg0KWWFuLUhzdWFuDQo=
