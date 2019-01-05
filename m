Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1818FC43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCC8622300
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfAESix (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 13:38:53 -0500
Received: from mail-oln040092071072.outbound.protection.outlook.com ([40.92.71.72]:25012
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726252AbfAESiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 13:38:52 -0500
Received: from DB5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (10.152.20.56) by DB5EUR03HT196.eop-EUR03.prod.protection.outlook.com
 (10.152.20.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Sat, 5 Jan
 2019 18:38:50 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.20.60) by
 DB5EUR03FT031.mail.protection.outlook.com (10.152.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Sat, 5 Jan 2019 18:38:50 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sat, 5 Jan 2019
 18:38:49 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] rtlwifi: Fix issues with rtl8723ae
Thread-Topic: [PATCH v2 0/4] rtlwifi: Fix issues with rtl8723ae
Thread-Index: AQHUpSXmnDVIZlXHb02aL4xoM2TSOg==
Date:   Sat, 5 Jan 2019 18:38:49 +0000
Message-ID: <DB7PR07MB53536F93922110AAB221480AE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:20b::47)
 To DB7PR07MB5353.eurprd07.prod.outlook.com (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:7E387AE77A3FC7D1B76A4E301E25A5EF0A22F39BF4D0B4C355CAD5CDFE585B48;UpperCasedChecksum:24B8EC661CB3A4D7539A2034360E121269D542306F05AC09B65F65E982A9A9B9;SizeAsReceived:8702;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [2CIYr6Y746EZ9z1Zc9yeap+q7MXe2f61]
x-microsoft-original-message-id: <ca8939ef-4656-f6d6-3ee7-1f1e0a442660@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB5EUR03HT196;6:TKztj/OeZ1tHJ0PoaXMxBWMK4z1pAbCDZ9QidaS++2UsAcDdNyz6c+D4n7UgTca2Jxqn5Kt4HemWUUfuEY7KKTZzngu0rbYp3RJJ1RITrnZTT3q7z7qlkJFJC0S84U09pfr99klY0YMD6vU2E4dlanZjBk/cVjyd05rBZ/XYTon5S6Cmq7/8rMULuAQoQbfSuhknA/BOydTuVr5M1jMmB2yO+mWB6Q5SE43ph+KVJoyQScbUlzOpN6BepDPNRCaYjyWGyM4XsUGXYXoA+mb60CNpv7Iu3pArxh+tzdKZNLP/eP29EW7uI+nXuQOX7n11HEiLBk8k8/9wTCPWpojq//nv0qAYcMGHN+SBq18+pyo6SRnfzYzSwlQC/xV3M4ZvWMcToymfT0ul4WZYw2+9fW+twYB8wkr13/1BRS+mV48PhHHn4EZkLMOtuRAJ1mFU8t1xS0Uk3Y3U2IMDUb2n1g==;5:XqxXho6PotrQaXr+fLHU200rBJUXVC6TpZKYipuXmS7sSHT2ZBfoEfRHvtrLGaiy3RydOW6JteBnC6JPn3ROTfgY8K1dqOq7R+YrkbrWzbmjpM5hju/Lo1hQMbltWX1nH9Y1+La0W5N8kpQz17Vct2Ori3qWIg5VvYVoikV+SEE=;7:krL6TgQVl+vkagQ/2mUSo0UdtyGrAmSu7L7BM69TlFXwVnLmrGTIRAOl9EknZqx7/hj1YaFMgIuqbn/msSxAwif7A+f45lu2fVCDlpX25ypeauZv1eLDJwB2wfyk+Wax5D0TTenbpPRTVBcnE/8HAQ==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:DB5EUR03HT196;
x-ms-traffictypediagnostic: DB5EUR03HT196:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:DB5EUR03HT196;BCL:0;PCL:0;RULEID:;SRVR:DB5EUR03HT196;
x-microsoft-antispam-message-info: obUwSwzC3eBZOMvPAtoAkyRa4U/S91kTg0kG+hLH3m4yAHQT2Voo0r0fuGRHcHpv
Content-Type: text/plain; charset="utf-8"
Content-ID: <58D40908D659324FBA3CB3AA92526CE8@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: a78c0f0a-247d-4f2f-c7eb-08d6733d088d
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2019 18:38:48.9306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT196
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Q3VycmVudGx5IHRoZSBydGw4NzIzYWUgZHJpdmVyIGlzIGJyb2tlbiAoc2luY2UgdjQuNykuDQoN
CkNvbm5lY3Rpb24gdG8gQVAgaXMgbG9zdCB2ZXJ5IG9mdGVuLCBlc3BlY2lhbGx5IHdoZW4NCnRo
ZSBzaWduYWwgbGV2ZWwgaXMgbm90IHZlcnkgZ29vZC4NCg0KVGhlIG1haW4gaXNzdWUgaXMgdGhl
IHBvd2VyIHNhdmUgbW9kZSBpcyBiYXNpY2FsbHkNCm5vdCB3b3JraW5nLCBhbmQgc2VlbXMgdG8g
dHJpZ2dlciBhIGZpcm13YXJlIGJ1Zy4NClNvIEkgaGFkIHRvIHRha2Ugb3V0IHRoZSBGVyBMUFMg
bW9kZSBoYW5kbGluZy4NCg0KV2hpbGUgZGVidWdnaW5nIHRoZSBkcml2ZXIgSSBmb3VuZCBhIGNv
dXBsZSByZWxhdGVkIGlzc3VlcywNCmZvciBpbnN0YW5jZSB0aGF0IHRoZSBzaWduYWwgbGV2ZWwg
aW4gZG0udW5kZWNfc21fcHdkYg0KaXMgbm8gbG9uZ2VyIGFjY3VyYXRlIChtYXkgYmUgZXZlbiBt
dWNoIHRvbyBoaWdoKSB3aGVuIG5vIG1vcmUNCnBhY2tldHMgYXJlIHJlY2VpdmVkLCBhbmQgaXQg
aW5jcmVhc2VzIHRoZSBsaWtlbGlob29kIHRvIHJlY2VpdmUNCnNvbWV0aGluZyBpZiB0aGUgaW5w
dXQgZ2FpbiBpcyBzZXQgdG8gbWF4aW11bS4NCg0KVGhlIHBhdGNoIHdhcyB0ZXN0ZWQgd2l0aCB0
aGUgcnRsODcyM2FlIFBDSSBjYXJkIGluIG15IGxhcHRvcA0KYWdhaW5zdCBhIEZSSVRaIUJveCA3
NTkwIEFQIC0tIHRoZSBXaUZpIGNvbm5lY3Rpb24gd29ya3Mgbm93DQp2ZXJ5IHJlbGlhYmxlIGZv
ciBtZS4NCg0KVjIgb2YgdGhlIHBhdGNoIGFkanVzdHMgdGhlIGRlZmF1bHRzIG9mIHN3bHBzIGFu
ZCBmd2xwcyBtb2R1bGUNCnBhcmFtZXRlcnMgdG8gbWF0Y2ggdGhlIGZpcm13YXJlIGNhcGFiaWxp
dGllcyBpbnN0ZWFkIG9mIHJlbW92aW5nDQp0aGUgd2hvbGUgY29kZSwgc28gaXQgY2FuIGJlIGVh
c2lseSByZS1hY3RpdmF0ZWQgb25jZSBhIGZpcm13YXJlDQp1cGRhdGUgaXMgYXZhaWxhYmxlLg0K
DQoNCkJlcm5kIEVkbGluZ2VyICg0KToNCiAgcnRsd2lmaTogcnRsODcyM2FlOiBUYWtlIHRoZSBG
VyBMUFMgbW9kZSBoYW5kbGluZyBvdXQNCiAgcnRsd2lmaTogcnRsODcyM2FlOiBEb24ndCB1c2Ug
ZG0udW5kZWNfc21fcHdkYiBmb3IgaW5wdXQgZ2FpbiBjb250cm9sIA0KICAgICAgIHdoZW4gbm8g
YmVhY29uIHdhcyByZWNlaXZlZCBpbiB0aGUgY29ubmVjdGVkIHN0YXRlDQogIHJ0bHdpZmk6IHJ0
bDg3MjNhZTogUmUtaW50cm9kdWNlDQogICAgcnRsODcyM2VfZG1fcmVmcmVzaF9yYXRlX2FkYXB0
aXZlX21hc2sNCiAgcnRsd2lmaTogTW92ZSB0aGUgY2xlYXJpbmcgb2YgcnRscHJpdi0+bGlua19p
bmZvLm51bV9yeF9pbnBlcmlvZCBpbiAgIA0KICAgICBydGxfd2F0Y2hkb2dfd3FfY2FsbGJhY2sg
YSBmZXcgbGluZXMgZG93bg0KDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZp
L2Jhc2UuYyAgICAgICAgfCAgNCArLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
d2lmaS9jb3JlLmMgICAgICAgIHwgIDIgKw0KIC4uLi9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3
aWZpL3J0bDg3MjNhZS9kbS5jICAgIHwgOTUgKysrKysrKysrKysrKysrKysrKysrLQ0KIC4uLi9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9zdy5jICAgIHwgIDggKy0NCiA0
IGZpbGVzIGNoYW5nZWQsIDEwMSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KDQotLSAN
CjEuOS4xDQo=
