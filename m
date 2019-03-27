Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D421C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 05:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 440E32075E
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 05:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfC0FAx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 01:00:53 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:38386 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfC0FAx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 01:00:53 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x2R4xkU6014127, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x2R4xkU6014127
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 27 Mar 2019 12:59:46 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCASV02.realtek.com.tw (172.21.6.19) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 27 Mar 2019 12:59:46 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 27 Mar
 2019 12:59:45 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHU2VNS+GVXIkmks0i6acEtkruVp6Yb92uAgAEiBwCAAIMJgIABZBmA
Date:   Wed, 27 Mar 2019 04:59:44 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17CB940@RTITMBSVM04.realtek.com.tw>
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
 <20190325143611.sjwwjqtrftxntwyk@penguin> <20190326075414.GA8598@redhat.com>
 <CA+ASDXNcCNcBmiHi468p1foWgSOXy9Mt8o+CD17Bd4PqhUXFoA@mail.gmail.com>
In-Reply-To: <CA+ASDXNcCNcBmiHi468p1foWgSOXy9Mt8o+CD17Bd4PqhUXFoA@mail.gmail.com>
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

PiANCj4gT24gVHVlLCBNYXIgMjYsIDIwMTkgYXQgMTI6NTQgQU0gU3RhbmlzbGF3IEdydXN6a2Eg
PHNncnVzemthQHJlZGhhdC5jb20+DQo+IHdyb3RlOg0KPiA+IEkgYWxzbyB0ZXN0ZWQgb24gUlRM
ODgyMkNFIHdlIGdlbmVyb3VzbHkgZ290IGZyb20gVG9ueS4gSSByZXBsYWNlZCB3aWZpDQo+ID4g
Y2FyZCBvbiBteSBsYXB0b3AgYnkgdGhlIDg4MjJDRSBkZXZpY2UuIEkgaGF2ZSB3YXJuaW5nIG9u
IHJlc3VtZSBmcm9tDQo+ID4gc3VzcGVuZCAoc2VlIGJlbG93LCBpdCBjb3VsZCBiZSBtYWM4MDIx
MSBpc3N1ZSB0aG91Z2gpLiBCdXQgbmV0d29yaw0KPiA+IGNvbm5lY3Rpb24gd2FzIGVzdGFibGlz
aGVkIGFmdGVyIHRoZSB3YXJuaW5nIGFuZCBpbiBnZW5lcmFsIGRldmljZQ0KPiA+IHdvcmtzIHN0
YWJsZSBmb3IgMiBkYXlzIG5vdy4NCj4gPg0KPiA+IFRlc3RlZC1ieTogU3RhbmlzbGF3IEdydXN6
a2EgPHNncnVzemthQHJlZGhhdC5jb20+DQo+ID4NCj4gPiBbMTYxNTguODI2ODczXSBydHdfcGNp
IDAwMDA6MDI6MDAuMDogc3RhcnQgdmlmIDAwOmUwOjRjOjA5Ojk0OjBmIG9uIHBvcnQgMA0KPiA+
IFsxNjE1OC44Mjc2OTNdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQ0KPiA+
IFsxNjE1OC44Mjc2OTRdIHdsYW4wOiBpbnZhbGlkIENXX21pbi9DV19tYXg6IDAvMA0KPiANCj4g
SSBkaWRuJ3QgdGVzdCBzeXN0ZW0gc3VzcGVuZC9yZXN1bWUgd2l0aCB0aGlzIGRyaXZlciB5ZXQg
KG9vcHMpLCBidXQNCj4gRldJVyBJJ3ZlIHNlZW4gcmVwb3J0cyBvZiB0aGlzIHdhcm5pbmcgb24g
ZXZlcnkgb3RoZXIgbWFjODAyMTEgZHJpdmVyDQo+IEkndmUgc3VwcG9ydGVkLiBJIGRvbid0IHRo
aW5rIHdlJ3ZlIGV2ZXIgdG90YWxseSByZXNvbHZlZCB0aGVtIGFuZCBJDQo+IGhhdmVuJ3QgbG9v
a2VkIGNsb3NlbHkgaW50byB0aGUgcmVhc29uIGZvciB0aGUgV0FSTklORy4NCj4gDQo+IEJyaWFu
DQo+IA0KDQpBbmQgd2UgaGF2ZW4ndCBzdWJtaXQgcGF0Y2hlcyByZWxhdGVkIHRvIHN1c3BlbmQg
eWV0Lg0KTGlrZSBzb21ldGhpbmcgaW4gQ09ORklHX1BNLg0KU2hvdWxkIGJlIGFkZGVkIGxhdGVy
Lg0KDQpZYW4tSHN1YW4NCg==
