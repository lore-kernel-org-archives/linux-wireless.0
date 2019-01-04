Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC19C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DDCD208E3
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfADMsg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 07:48:36 -0500
Received: from mail-oln040092069033.outbound.protection.outlook.com ([40.92.69.33]:11440
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfADMsf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 07:48:35 -0500
Received: from HE1EUR02FT009.eop-EUR02.prod.protection.outlook.com
 (10.152.10.60) by HE1EUR02HT080.eop-EUR02.prod.protection.outlook.com
 (10.152.11.87) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Fri, 4 Jan
 2019 12:48:32 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.10.52) by
 HE1EUR02FT009.mail.protection.outlook.com (10.152.10.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Fri, 4 Jan 2019 12:48:32 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.000; Fri, 4 Jan 2019
 12:48:31 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] rtlwifi: Fix issues with rtl8723ae
Thread-Topic: [PATCH 0/4] rtlwifi: Fix issues with rtl8723ae
Thread-Index: AQHUpCvMg4MWqNxywE621z+Jdf/AFQ==
Date:   Fri, 4 Jan 2019 12:48:31 +0000
Message-ID: <DB7PR07MB5353B3268997A3B1A56970A9E48E0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0201CA0011.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::21) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:1B54264B180A203E01A1FBAEEB98D30374BB930A10A02F9C581C65F8D3A33D1C;UpperCasedChecksum:CDF22793460A466D47AF062618B82DDFFE4B3F13425CDD43F101E5BDC1D5CF34;SizeAsReceived:8723;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [ZAAJYT/6/kmuRUMhQPwfCUXKMi+p0Nee]
x-microsoft-original-message-id: <e89c247e-6ef3-fabf-2924-936d5b07eac8@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR02HT080;6:ivSc8uocwlUwbGy4z4+Lx0c72WirNKFq62FTmSDn++rx1HVoDx4F5YPxDF9v829lyMAV6fY21vNjbjpFNFSwdZXOy/uTSo6i+2EU38s0yISwezFycFdwJkDVKa7bmWVCph2k73M51fLb4MJ3goVA4wCIM8xLFAtisQmJFwFrBPFp9+Anay1sdI5FjRKOo7zf0N10cpMnrPYlI+5JVpChcbb9odeLQBpZBpabJaHVbWQ6iCtdGRV82N7PDrTksYyR9HmGI8l6Mmk4DNkAHxHdYavRfEZV1fmasdRvfs0osVfPOfOF/hZ6Cmr9iVBEuTpXbua+EL/UOAKt1VIr9sPyOBPdRcUsM5O2/Dj7rLB/2CwF0iIoNkUiJPvDM+lW+sC1wkTPUVfmq96LDfLvKnxLb11Ce2eiOeTn/N7M7dXP0iwlxTYGTHUEkiGtBqefCmgG6MlmAuoPfMJPXZEMTFIqxA==;5:wFIyTAm+yZMVkJnLUINva0GIslhCwT2nkmlX+ek6HmGs2eUoIL9uHDmJfnKwA7kVzMsP0JuEYOYLEXPRigGQ9PJv34wKqbppHu9OKxaA4BqKLYZWZX0Q+VL7SoAblYSlZSlVUy8o0cJAtHty7NEYNpaqT0qUVpkN+HrecRQnVso=;7:k1a6wdP6pZdPG0ABgBHUVMI/gnsB31SnnGtqH6TbcEvpSU4shHnGeaI6kwOJgsrv8W5VBFRZu9Uv/UmEQAJ+ampiFr6H4Y9lEFKsN4Jx5C1YGgCqpqywSK8Ai9goLeVW2fW1hQgYfDon2afSSua8ng==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119063)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR02HT080;
x-ms-traffictypediagnostic: HE1EUR02HT080:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR02HT080;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR02HT080;
x-microsoft-antispam-message-info: mE7zwk5wdz5MLqSs3GbaMDzEa2g5M54yYbKIH+0GV+GpBcE1ADr5DytcK2uDdHB7
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B47C024F1AE384CA3FCE7F9EEDCC0BA@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: ab45de1a-c15d-4f4a-3e70-08d67242ee43
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 12:48:30.5452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT080
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Q3VycmVudGx5IHRoZSBydGw4NzIzYWUgZHJpdmVyIGlzIGJyb2tlbiAoc2luY2UgdjQuNykuDQoN
CkNvbm5lY3Rpb24gdG8gQVAgaXMgbG9zdCB2ZXJ5IG9mdGVuLCBlc3BlY2lhbGx5IHdoZW4NCnRo
ZSBzaWduYWwgbGV2ZWwgaXMgbm90IHZlcnkgZ29vZC4NCg0KVGhlIG1haW4gaXNzdWUgaXMgdGhl
IHBvd2VyIHNhdmUgbW9kZSBpcyBiYXNpY2FsbHkNCm5vdCB3b3JraW5nLCBhbmQgc2VlbXMgdG8g
dHJpZ2dlciBhIGZpcm13YXJlIGJ1Zy4NClNvIEkgaGFkIHRvIHJlbW92ZSB0aGF0IGNvZGUuDQoN
CldoaWxlIGRlYnVnZ2luZyB0aGUgZHJpdmVyIEkgZm91bmQgYSBjb3VwbGUgcmVsYXRlZCBpc3N1
ZXMsDQpmb3IgaW5zdGFuY2UgdGhhdCB0aGUgc2lnbmFsIGxldmVsIGluIGRtLnVuZGVjX3NtX3B3
ZGINCmlzIG5vIGxvbmdlciBhY2N1cmF0ZSAobWF5IGJlIGV2ZW4gbXVjaCB0b28gaGlnaCkgd2hl
biBubyBtb3JlDQpwYWNrZXRzIGFyZSByZWNlaXZlZCwgYW5kIGl0IGluY3JlYXNlcyB0aGUgbGlr
ZWxpaG9vZCB0byByZWNlaXZlDQpzb21ldGhpbmcgaWYgdGhlIGlucHV0IGdhaW4gaXMgc2V0IHRv
IG1heGltdW0uDQoNClRoZSBwYXRjaCB3YXMgdGVzdGVkIHdpdGggdGhlIHJ0bDg3MjNhZSBQQ0kg
Y2FyZCBpbiBteSBsYXB0b3ANCmFnYWluc3QgYSBGUklUWiFCb3ggNzU5MCBBUCAtLSB0aGUgV2lG
aSBjb25uZWN0aW9uIHdvcmtzIG5vdw0KdmVyeSByZWxpYWJsZSBmb3IgbWUuDQoNCg0KQmVybmQg
RWRsaW5nZXIgKDQpOg0KICAgcnRsd2lmaTogcnRsODcyM2FlOiBUYWtlIHRoZSBGVyBMUFMgbW9k
ZSBoYW5kbGluZyBvdXQNCiAgIHJ0bHdpZmk6IHJ0bDg3MjNhZTogRG9uJ3QgdXNlIGRtLnVuZGVj
X3NtX3B3ZGIgZm9yIGlucHV0IGdhaW4gY29udHJvbA0KICAgICAgICB3aGVuIG5vIGJlYWNvbiB3
YXMgcmVjZWl2ZWQgaW4gdGhlIGNvbm5lY3RlZCBzdGF0ZS4NCiAgIHJ0bHdpZmk6IHJ0bDg3MjNh
ZTogUmUtaW50cm9kdWNlDQogICAgIHJ0bDg3MjNlX2RtX3JlZnJlc2hfcmF0ZV9hZGFwdGl2ZV9t
YXNrDQogICBydGx3aWZpOiBNb3ZlIHRoZSBjbGVhcmluZyBvZiBydGxwcml2LT5saW5rX2luZm8u
bnVtX3J4X2lucGVyaW9kIGluDQogICAgICBydGxfd2F0Y2hkb2dfd3FfY2FsbGJhY2sgYSBmZXcg
bGluZXMgZG93bi4NCg0KICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYmFz
ZS5jICAgICAgICB8ICA0ICstDQogIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9jb3JlLmMgICAgICAgIHwgIDIgKw0KICAuLi4vbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9ydGw4NzIzYWUvZG0uYyAgICB8IDk1ICsrKysrKysrKysrKysrKysrKysrKy0NCiAgLi4uL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2Z3LmMgICAgfCAyMCAtLS0tLQ0K
ICAuLi4vbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvZncuaCAgICB8ICAx
IC0NCiAgLi4uL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2h3LmMgICAg
fCA1NiArLS0tLS0tLS0tLS0tDQogIDYgZmlsZXMgY2hhbmdlZCwgOTggaW5zZXJ0aW9ucygrKSwg
ODAgZGVsZXRpb25zKC0pDQoNCi0tIA0KMS45LjENCg==
