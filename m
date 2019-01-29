Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C7DAC282CD
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 02:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B632085B
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 02:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfA2CyB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 21:54:01 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44488 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfA2CyB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 21:54:01 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0T2riF6001947, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0T2riF6001947
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Tue, 29 Jan 2019 10:53:45 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 29 Jan
 2019 10:53:44 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUtsz0oGWsIdSZ5km8koIDZ4UJzKXEpEWAgADdk7D//4KcAIAAhthg
Date:   Tue, 29 Jan 2019 02:53:43 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D179808E@RTITMBSVM04.realtek.com.tw>
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
 <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
 <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
 <CA+ASDXM=+_U+SrXhm3pq4Zd7gkvHwkRAZw+OGmzg=6+0+=iZGg@mail.gmail.com>
In-Reply-To: <CA+ASDXM=+_U+SrXhm3pq4Zd7gkvHwkRAZw+OGmzg=6+0+=iZGg@mail.gmail.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCcmlhbiBOb3JyaXMgW21haWx0
bzpicmlhbm5vcnJpc0BjaHJvbWl1bS5vcmddDQo+IFNlbnQ6IFR1ZXNkYXksIEphbnVhcnkgMjks
IDIwMTkgMTA6NDEgQU0NCj4gVG86IFRvbnkgQ2h1YW5nDQo+IENjOiBMYXJyeSBGaW5nZXI7IFBr
c2hpaDsgQW5keSBIdWFuZzsgc2dydXN6a2FAcmVkaGF0LmNvbTsNCj4gbGludXgtd2lyZWxlc3NA
dmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjMgMDAvMTNdIHJ0dzg4OiBt
YWM4MDIxMSBkcml2ZXIgZm9yIFJlYWx0ZWsgODAyLjExYWMNCj4gd2lyZWxlc3MgbmV0d29yayBj
aGlwcw0KPiANCj4gT24gTW9uLCBKYW4gMjgsIDIwMTkgYXQgNjoxNSBQTSBUb255IENodWFuZyA8
eWhjaHVhbmdAcmVhbHRlay5jb20+DQo+IHdyb3RlOg0KPiA+IFRoaXMgTlVMTCBwb2ludGVyIHdh
cyBmb3VuZCBtb250aHMgYWdvIGFuZCBoYXMgYmVlbiBmaXhlZCBhbHJlYWR5Lg0KPiA+IFRoYW5r
cyBmb3IgeW91ciB0ZXN0IDopLg0KPiA+IEkgYW0gaG9sZGluZyB0aGUgcGF0Y2ggdG8gZml4IGl0
IGZvciB0aGUgbmV4dCBwYXRjaHNldHMuDQo+ID4NCj4gPiBCVFcsIHNpbmNlIHJ0dzg4IGhhcyBu
b3QgYmVlbiBhY2NlcHRlZCwgY291bGQgSSBzZW5kIG5leHQgcGF0Y2ggc2V0IGJhc2VkIG9uDQo+
ID4gdGhpcyBwYXRjaCBzZXQgYXMgbG9uZyBhcyBJIGV4cGxpY2l0bHkgbWFyayB0aGF0IHRoZSBu
ZXh0IHBhdGNoIGlzIGJhc2VkIG9uIHRoZQ0KPiBwcmV2aW91cyBvbmU/DQo+IA0KPiBJJ2Qgbm9y
bWFsbHkgZXhwZWN0IHRoYXQgaWYgeW91IGZpbmQgbWFqb3IgYnVncyBpbiB5b3VyIGluaXRpYWwg
ZHJpdmVyDQo+IHN1Ym1pc3Npb24gdGhhdCBzdGlsbCBpc24ndCByZXZpZXdlZC9tZXJnZWQsIHlv
dSBtaWdodCBhcyB3ZWxsIGp1c3QNCj4gcm9sbCB0aGUgZml4IGludG8gbGF0ZXN0IHZlcnNpb24g
YW5kIGRlc2NyaWJlIGl0IGluIHRoZQ0KPiBjb3Zlci1sZXR0ZXIvY2hhbmdlbG9nLiBUaGlzIHBh
cnRpY3VsYXIgY2hhbmdlIGlzIHNvIHRyaXZpYWwgaXQNCj4gZG9lc24ndCByZWFsbHkgc2VlbSB0
byBkZXNlcnZlIGEgc2VwYXJhdGUgcGF0Y2guDQo+IA0KPiAoSXQgd291bGQgYWxzbyBoZWxwIHBl
b3BsZSBsaWtlIG1lLCB3aG8gbWF5IHZlcnkgd2VsbCBydW4gaW50byB0aGUNCj4gc2FtZSBidWcg
d2hlbiB0aGV5IGdldCBhcm91bmQgdG8gdGVzdGluZy9yZXZpZXdpbmcgdGhlIGRyaXZlci4pDQo+
IA0KPiBJIGFsc28gZG9uJ3Qga25vdyB3aGF0IHRoZSBjb250ZW50cyBvZiB0aGUgIm5leHQgcGF0
Y2ggc2V0IiBpcyAtLSBpZg0KPiBpdCdzIGEgbG90IG9mIG5ldyBmZWF0dXJlcywgbWF5YmUgdGhl
eSBkb24ndCBkZXNlcnZlIHRvIGNsdXR0ZXIgdGhlDQo+IGluaXRpYWwgc3VibWlzc2lvbiwgYnV0
IGlmIHRoZXkncmUgYnVnZml4ZXMgbGlrZSB0aGlzLCBpdCBzZWVtcyBsaWtlDQo+IHlvdSBjb3Vs
ZCBqdXN0IGZpeCB0aGUgb3JpZ2luYWwgcGF0Y2ggc2V0Lg0KDQoNCkl0IGlzIGJlY2F1c2UgdGhh
dCB0aGUgbmV4dCBwYXRjaCBzZXQgY29udGFpbnMgc2V2ZXJhbCBtYWpvciBmaXhlcy4NCkFuZCBJ
IGRvbid0IGtub3cgaWYgaXQgd2lsbCBib3RoZXIgdGhlIHJldmlld2VycyBpZiBJIGFwcGx5IHRo
ZW0gaW50bw0KdGhlIG9yaWdpbmFsIHBhdGNoIHNldC4NCg0KQW5kIEkgZG9uJ3Qga25vdyBpZiBJ
IGNhbiBzZW5kIHRoZSBuZXh0IHBhdGNoIHNldCB0aGF0IGlzIGJhc2VkIG9uIHRoZQ0KcGF0Y2gg
c2V0IGhhdmUgbm90IGJlZW4gYWNjZXB0ZWQuIEp1c3Qgd29uZGVyIHdoaWNoIHdheSBpcyBiZXR0
ZXIuDQoNClNvLCBpZiBpdCBpcyBob3cgdGhpbmdzIHdvcmsgSSBjYW4gZG8gdGhpcyBhbmQgcmVz
ZW5kIHdpdGggdGhvc2UgZml4ZXMuDQpJdCBpcyBhY3R1YWxseSBiZXR0ZXIgZm9yIG1lIHRvIGZp
eCB0aGVtIGluIHRoZSBvcmlnaW5hbCBwYXRjaCBzZXQuDQpPciBzZW5kIHRoZSBuZXh0IHBhdGNo
IHNldCBub3cgYW5kIG1hcmsgaXQgaXMgYmFzZWQgb24gdGhlIG9yaWdpbmFsDQpwYXRjaCBzZXQg
dW5kZXIgcmV2aWV3aW5nLg0KDQoNCj4gDQo+IEJ1dCB0aGF0J3MganVzdCBteSBvcGluaW9uLg0K
DQpZb3VyIG9waW5pb24gaXMgaGVscGZ1bC4NClRoYW5rcyBmb3IgeW91ciBzdWdnZXN0aW9uLg0K
DQo+IA0KPiBCcmlhbg0KPiANCg0KWWFuLUhzdWFuDQo=
