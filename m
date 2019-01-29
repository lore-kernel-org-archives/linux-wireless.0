Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125D1C282C7
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 04:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7F5220869
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 04:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfA2EDU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 23:03:20 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:49999 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfA2EDU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 23:03:20 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0T434VO025248, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0T434VO025248
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Tue, 29 Jan 2019 12:03:04 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 29 Jan
 2019 12:03:04 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>
CC:     Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUtsz0oGWsIdSZ5km8koIDZ4UJzKXEpEWAgADdk7D//46KAIAAjKhQ
Date:   Tue, 29 Jan 2019 04:03:03 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17981EA@RTITMBSVM04.realtek.com.tw>
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
 <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
 <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
 <8d92c20f-a72f-6ea8-d4c8-61c3c8c9adc9@lwfinger.net>
In-Reply-To: <8d92c20f-a72f-6ea8-d4c8-61c3c8c9adc9@lwfinger.net>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtd2lyZWxlc3Mt
b3duZXJAdmdlci5rZXJuZWwub3JnDQo+IFttYWlsdG86bGludXgtd2lyZWxlc3Mtb3duZXJAdmdl
ci5rZXJuZWwub3JnXSBPbiBCZWhhbGYgT2YgTGFycnkgRmluZ2VyDQo+IFNlbnQ6IFR1ZXNkYXks
IEphbnVhcnkgMjksIDIwMTkgMTE6MjQgQU0NCj4gVG86IFRvbnkgQ2h1YW5nDQo+IENjOiBQa3No
aWg7IEFuZHkgSHVhbmc7IGJyaWFubm9ycmlzQGNocm9taXVtLm9yZzsgc2dydXN6a2FAcmVkaGF0
LmNvbTsNCj4gbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjMgMDAvMTNdIHJ0dzg4OiBtYWM4MDIxMSBkcml2ZXIgZm9yIFJlYWx0ZWsgODAyLjEx
YWMNCj4gd2lyZWxlc3MgbmV0d29yayBjaGlwcw0KPiANCj4gT24gMS8yOC8xOSA4OjE1IFBNLCBU
b255IENodWFuZyB3cm90ZToNCj4gPj4gVG9ueSwNCj4gPj4NCj4gPj4gSSBoYWQgbm90IHRlc3Rl
ZCBydHc4OCBmb3Igc29tZSB0aW1lLCBzbyBJIGJ1aWx0IGEga2VybmVsIHdpdGggdGhlIFYzIHBh
dGNoZXMNCj4gYW5kDQo+ID4+IGZvdW5kIHRoYXQgcnR3ODggY3Jhc2hlZCB3aXRoIGEgTlVMTCBw
b2ludGVyIGRlcmVmZXJlbmNlLiBJIGRpZCBzb21lDQo+ID4+IGRlYnVnZ2luZyBhbmQgZm91bmQg
dGhhdCB0aGUgcHJvYmxlbSB3YXMgaW4gcm91dGluZQ0KPiBydHdfY2hpcF9lZnVzZV9lbmFibGUo
KQ0KPiA+PiB3aGVyZSBmdy0+ZmlybXdhcmUgd2FzIE5VTEwuDQo+ID4+DQo+ID4NCj4gPiBIaSBM
YXJyeSwNCj4gPg0KPiA+IFRoaXMgTlVMTCBwb2ludGVyIHdhcyBmb3VuZCBtb250aHMgYWdvIGFu
ZCBoYXMgYmVlbiBmaXhlZCBhbHJlYWR5Lg0KPiA+IFRoYW5rcyBmb3IgeW91ciB0ZXN0IDopLg0K
PiA+IEkgYW0gaG9sZGluZyB0aGUgcGF0Y2ggdG8gZml4IGl0IGZvciB0aGUgbmV4dCBwYXRjaHNl
dHMuDQo+ID4NCj4gPiBCVFcsIHNpbmNlIHJ0dzg4IGhhcyBub3QgYmVlbiBhY2NlcHRlZCwgY291
bGQgSSBzZW5kIG5leHQgcGF0Y2ggc2V0IGJhc2VkIG9uDQo+ID4gdGhpcyBwYXRjaCBzZXQgYXMg
bG9uZyBhcyBJIGV4cGxpY2l0bHkgbWFyayB0aGF0IHRoZSBuZXh0IHBhdGNoIGlzIGJhc2VkIG9u
IHRoZQ0KPiBwcmV2aW91cyBvbmU/DQo+ID4gVGhhbmtzIQ0KPiANCj4gWW91IG5lZWQgdG8gaGF2
ZSB0aGF0IHBhdGNoIGluIHdoYXRldmVyIHZlcnNpb24gaXMgbWVyZ2VkIGludG8gdGhlIHdpcmVs
ZXNzDQo+IHRyZWUuIEl0IHdvdWxkIG5vdCBsb29rIHZlcnkgZ29vZCBmb3IgdGhlIGluaXRpYWwg
dmVyc2lvbiB0byBjcmFzaCBldmVyeSB1c2Vycw0KPiBjb21wdXRlci4NCj4gDQo+IFllcywgSSB3
b3VsZCBtZXJnZSBFVkVSWSBwYXRjaCB0aGF0IHlvdSBoYXZlIHBlbmRpbmcgaW50byB0aGUgc291
cmNlIGFuZA0KPiBzdWJtaXQgVjQuDQoNCkhpIExhcnJ5LA0KDQpCdXQgaGVyZSBJIGFtIGhvbGRp
bmcgYWxtb3N0IDQwIHBhdGNoZXMsIHNvbWUgb2YgdGhlbSBhcmUgY29tbW9uIG1ham9yIGZpeGVz
Lg0KVGhlIHJlc3Qgb2YgdGhlbSBhcmUgdG8gZW5oYW5jZSBhbmQgc3RhYmlsaXplIDg4MjJDLg0K
DQpGcm9tIHRoZSBpbml0aWFsIHN1Ym1pdCB0byBub3csIDg4MjJDIGhhcyBtYW55IGZpeGVzLiBC
ZWNhdXNlIHdlIHRlc3RlZA0KYSBsb3QgZm9yIGRldmVsb3BpbmcgODgyMkMgYW5kIHdlIGhhdmUg
bWFueSBwYXJhbWV0ZXIgY2hhbmdlcyBmb3IgaXQuDQpJIGFtIG5vdCBzdXJlIHNob3VsZCBJIG1l
cmdlIGV2ZXJ5IHBhdGNoIGludG8gdGhlIG9yaWdpbmFsIHBhdGNoIHNldC4gV2Ugd2lsbA0KaGF2
ZSBodWdlIGRpZmZlcmVuY2UgdG8gdGhlIG9yaWdpbmFsIHBhdGNoIHNldCwgbWVhbnMgZXh0cmEg
ZWZmb3J0IGZvciByZXZpZXcuDQoNCkJ1dCBJIGNhbiBmaWx0ZXIgb3V0IHRoZSBsZXNzIGltcG9y
dGFudCBwYXRjaGVzICh3aWxsIGJlIGxpa2UgYXJvdW5kIDIwLCBzdGlsbCBtYW55KS4NCkhvdyBk
byB5b3UgdGhpbms/DQpUaGFua3MuDQoNCllhbi1Ic3Vhbg0K
