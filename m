Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527A3C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEB63214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:16:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="e9EAVyl6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfAJIQn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:16:43 -0500
Received: from mail-eopbgr710109.outbound.protection.outlook.com ([40.107.71.109]:6162
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726137AbfAJIQn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 03:16:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paxY251Oo1jLZsf0l3TWbRl+1WiFc/46HdehwIwyi5A=;
 b=e9EAVyl6T9si3h5gZ8VbXiypEOn6AW6CZwcM3ZzS9tvBHSOEH0ikOiC4/vYC7CUZc/civ89H9GMh2mTkqlqDqX4wIn38Y8f6Wc0UWOxm++eesdd0t7xgMQIPWxkyxCorGNImOCIwnL5PQz+p2bg+a0bbu/04B32iCwDh/jdeWas=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5068.namprd06.prod.outlook.com (20.176.123.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.7; Thu, 10 Jan 2019 08:16:01 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%5]) with mapi id 15.20.1516.015; Thu, 10 Jan 2019
 08:16:01 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wright Feng <Wright.Feng@cypress.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        John Van Boxtel <John.VanBoxtel@cypress.com>
Subject: Re: [PATCH] brcmfmac: Use request_firmware_direct for the clm_blob
Thread-Topic: [PATCH] brcmfmac: Use request_firmware_direct for the clm_blob
Thread-Index: AQHUpnznZEN0dsuyZUO0UUnIQZWTX6Wjs8KAgAASrYCABGX7AA==
Date:   Thu, 10 Jan 2019 08:16:01 +0000
Message-ID: <55db0ecb-5386-7a10-f26a-fa1e50af9b57@cypress.com>
References: <20190107113401.6824-1-hdegoede@redhat.com>
 <d6dafb19-4e88-c2c7-9547-2ebd5b4bec2e@broadcom.com>
 <5b365baf-99b3-2033-1f8e-6ca38d6daf42@redhat.com>
In-Reply-To: <5b365baf-99b3-2033-1f8e-6ca38d6daf42@redhat.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: HK0PR03CA0086.apcprd03.prod.outlook.com
 (2603:1096:203:72::26) To DM6PR06MB5804.namprd06.prod.outlook.com
 (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5068;6:UVsTiEloCxLquG4tS1x0gG8Z6DfAFvxUBI0RL868dCidfvKpcztvgZGEXTmItGqDtPf+liZn7QqmzYxd+298DzYHBouu4bgU4ygJuIXORHwT40wISsqNCVx0tYHg/0LB2X2FGb0QJvvzNs5D0ZQI+xGs+F3hI05HUu8rqzrxzvB6/xbbBA4/pz67mMoRJ85JfdT/x/m0umU7XowY64LMGPdtoakZd6GKgJTg5xRHUDEimg9fD1gZ64pjjJqxSSNhidQp6o4VxfoGBcMbVqd9tTIvE5RQjbXNbhQnE7wbVPFMjjzg23ax5ZmfG0Km7zb3qNTraAfzIr4HW7R/HszGo7WbEAKfgNUNfGvTXCAVYEb7Dhplqqwrv59i88JUVC3fAshsFoMECqofTnL+aIHnVRrntg3HGGExjas+3Wys324y/cwMABbwA0/X+K759LVDTFUSl6lZn4zXvAUn7au/lA==;5:5FK1KDmWizXyBJBx1Kv5kYrA3pjKKO/U+nSutnc5p/QLsqHJulWRDgfJXZiK9sD/Iwed8SAHU5QetcOkJOOx8dhB8cuuF538s456OAQ7dqzN30oIQpp8aukXORpW18R0qzn7jaGiYHkyQDj4o6OZa/73/VqCZXIWg+xyJSkFMeslHkbeOuIlk66bzvC5SMxkaNn8EsoS+UqIRoaWCADqDA==;7:Nd0c8QSDM7rLsy3wRPLuM5yNqXbjgUrQBdh4rPXxBvwrfcLdTv3FOkw9p040uqGVwTghbkkMN9xKB43kHpwuu6cNw2DdPRXmNITY6rBHUS3aol3lK/1Je2mF1n2rYp8jRcTk/ijH/7+/HmxZquCmMw==
x-ms-office365-filtering-correlation-id: b44cfc85-bc91-4583-dce6-08d676d3db27
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5068;
x-ms-traffictypediagnostic: DM6PR06MB5068:
x-microsoft-antispam-prvs: <DM6PR06MB50681542B76D80FF95342EB5BB840@DM6PR06MB5068.namprd06.prod.outlook.com>
x-forefront-prvs: 0913EA1D60
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(25786009)(68736007)(6636002)(65806001)(71190400001)(107886003)(66066001)(6246003)(65826007)(4326008)(43066004)(5660300001)(54906003)(305945005)(7736002)(58126008)(316002)(64126003)(65956001)(76176011)(8936002)(81156014)(8676002)(256004)(6512007)(186003)(6306002)(31686004)(53936002)(81166006)(966005)(99286004)(486006)(102836004)(105586002)(53546011)(106356001)(386003)(6506007)(110136005)(31696002)(229853002)(72206003)(476003)(2616005)(478600001)(6116002)(3846002)(446003)(6436002)(52116002)(2906002)(11346002)(26005)(6486002)(3450700001)(97736004)(36756003)(71200400001)(14444005)(14454004)(86362001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5068;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JdUCy9PBJdqLjihZQO2qLgz4lh3L9AIJPghQhXesz4GCES4eHmh2JxkN+DfNOumIC8k6kLEwYcrKKXbpi95IiMj4J6hnEIB0IZBYFfAgq3HMOtatPL1WkbDYmbDYCTVlYgQ4gGJvgnygUanZe96mp1QXVD1HPNWbNs+32aFaQiBOU/iWt9UnsYCSI09Hcq2ZyvhJBBk9mW8pPlWzpP4st6yM7UQDRQNWo0YN/qX18KIm/JX09lA9MnGLa4KGgIlz05cIUomPoohIs8MWUSjoffyVk+ulfao/zUMjvT8ukTSo+i9HkGSXDgn+CThwHM5v
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <41F895B2B523754D85861F9314956A39@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b44cfc85-bc91-4583-dce6-08d676d3db27
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2019 08:16:01.1887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5068
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

KCtKb2huKQ0KDQpPbiAwMS8wNy8yMDE5IDk6MDUsIEhhbnMgZGUgR29lZGUgd3JvdGU6DQo+IEhp
LA0KPiANCj4gT24gMDctMDEtMTkgMTI6NTgsIEFyZW5kIFZhbiBTcHJpZWwgd3JvdGU6DQo+PiBP
biAxLzcvMjAxOSAxMjozNCBQTSwgSGFucyBkZSBHb2VkZSB3cm90ZToNCg0KPiANCj4gQ3lwcmVz
cyBpcyBhY3R1YWxseSBkb2luZyBib3RoIHRoZSBvbGQgKGVtYmVkZGVkIGluZm8pIGFuZCB0aGUg
bmV3DQo+IChzZXBhcmF0ZSBjbG1fYmxvYikgbW9kZWwgZm9yIHRoZSBmaXJtd2FyZXMgd2hpY2gg
dGhleSBhcmUgbm93IG1haW50YWluaW5nLA0KPiB0aGV5IGFyZSBzdGlsbCBwcm92aWRpbmcgdXBk
YXRlcyAqd2l0aCB0aGUgZW1iZWRkZWQgaW5mbywgc2VlIGUuZy46DQo+IGh0dHBzOi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Zpcm13YXJlL2xpbnV4LWZpcm13YXJl
LmdpdC9jb21taXQvYnJjbT9pZD0yNTNhNTczOTM2ZWUyMDc4ZDIwNjUyN2YzYWU4NDViNGRjNjgx
MjY5IA0KDQpIaSBIYW5zLA0KDQo0MzM2MiBpcyBhIHZlcnkgb2xkIGNoaXAgdGhhdCBpdCBkb2Vz
bid0IHN1cHBvcnQgdGhlIGNsbV9ibG9iIG1vZGVsLiBGb3IgDQpuZXdlciBjaGlwcyAoc29tZSBp
biBuZXdlciBidWlsZHMpIHdlIHVzZSBjbG1fYmxvYiBieSBkZWZhdWx0Lg0KDQpUaGUgY2xtX2Js
b2Igc2hvdWxkIGJlIGFuIG9wdGlvbmFsIGZpbGUgYW5kIHRoZSBkZXNpcmVkIGJlaGF2aW9yIGlz
IHRvIA0KZmFsbCB0aHJvdWdoIGV2ZW4gd2hlbiB0aGUgZmlsZSBpcyBub3QgdGhlcmUuIEFzIEth
bGxlIGFuZCBBcmVuZCANCm1lbnRpb25lZCwgdXNpbmcgcmVxdWVzdF9maXJtd2FyZV9ub3dhcm4o
KSBpcyBtb3JlIGFwcHJvcHJpYXRlLiBUaGFua3MgDQpmb3IgcG9zdGluZyB0aGlzIGVuaGFuY2Vt
ZW50Lg0KDQoNCj4gQ3lwcmVzcyBkb2VzIHRoZSBudWxsLXRhYmxlICsgc2VwYXJhdGUgY2xtX2Js
b2IgZmlsZSB0aGluZyBhbmQgZm9yIHJlYXNvbnMNCj4gd2hpY2ggdGhleSBoYXZlIG5ldmVyIGV4
cGxhaW5lZCB0aGV5IGluc2lzdCBvbiB0aGUgbGludXgtZmlybXdhcmUgZmlsZXMgYW5kDQo+IHRo
ZWlyIG93biBmaWxlcyBiZWluZyBkaWZmZXJlbnQuDQoNClRoZSBiaW5hcnkgZmlsZXMgaW4gbGlu
dXgtZmlybXdhcmUgYXJlIHRha2VuIGZyb20gdGhlIHJlbGVhc2UgcGFja2FnZXMuIA0KVGhlIGxh
dGVzdCBiaW5hcnkgd2l0aCBlbWJlZGRlZCBjbG0gKGhpc3RvcmljYWwgbW9kZSkgd2VyZSB1cHN0
cmVhbWVkLiANCldpbGwgZXhwbGFpbiBtb3JlIGFib3V0IHRoZSBjbG1fYmxvYnMgaW4gdGhlIFYy
IGNvbW1lbnQuDQoNCg0KPiBBICJGaXJtd2FyZSBjcmFzaCBmaXgiIHRvIG1lIHNvdW5kcyBsaWtl
IGEgcG90ZW50aWFsIHNlY3VyaXR5IGlzc3VlLCB5ZXQgDQoNCkl0IGlzIGEgZnVuY3Rpb25hbCBi
dWcgdGhhdCBjYXVzZXMgd2lmaSB0byBzdG9wIHdvcmtpbmcgY29ycmVjdGx5LiBOb3QgYSANCnNl
Y3VyaXR5IGhvbGUuIFdlIGRpZCB1cHN0cmVhbSBmaXJtd2FyZSBmb3Igc2VjdXJpdHkgaXNzdWVz
Lg0KDQoNCj4gQW5vdGhlciBleGFtcGxlIGlzIHRoZSBmaXJtd2FyZSBmb3IgdGhlIHdpZmkgb24g
dGhlIFJhc3BiZXJyeSBQaSAzQisgd2hpY2gNCj4gaXMgKnllYXJzKiBvbGRlciBpbiBsaW51eC1m
aXJtd2FyZS4NCg0KQ291bGQgeW91IHBsZWFzZSBzcGVjaWZ5IHRoZSBzb3VyY2UgKGxpbmspIG9m
IHRoZSBmaXJtd2FyZSB5b3UncmUgDQpyZWZlcnJpbmcgdG8/DQoNCg0KPiANCj4gSSBtdXN0IHNh
eSB0aGVzZSB3aG9sZSBzaGVuYW5pZ2FucyB3aXRoIHRoZSBmaXJtd2FyZSBjYXVzaW5nIA0KPiBs
aW51eC1maXJtd2FyZSB0bw0KPiBoYXZlIHdheSB0b28gb2xkIGZpcm13YXJlIHZlcnNpb25zIG1h
a2VzIG1lIHZlcnkgdW5oYXBweS4gSSdtIGF0IHRoZSBwb2ludA0KPiB3aGVyZSBJJ20gdGVsbGlu
ZyBmcmllbmRzIHRvIG5vdCBidXkgYW55IGhhcmR3YXJlIHdpdGggQ3lwcmVzcyB3aWZpIGluIA0K
PiB0aGVyZQ0KPiBiZWNhdXNlIG9mIHRoaXMgYW5kIGJlY2F1c2Ugb2YgdGhlICpjb21wbGV0ZSog
bGFjayBvZiBibHVldG9vdGggZmlybXdhcmUuDQoNCldlIGRpZCB3b3JrIHdpdGggSFRDIHRvIHVw
c3RyZWFtIHRoZWlyIGJsdWV0b290aCBmaXJtd2FyZSB0byANCmxpbnV4LWZpcm13YXJlLCBhbHRo
b3VnaCBJIGFkbWl0IHRoYXQgbW9zdCBvZiB0aGUgYmx1ZXRvb3RoIGZpcm13YXJlIGFyZSANCm9u
bHkgYXZhaWxhYmxlIHRocm91Z2ggaGFyZHdhcmUgdmVuZG9ycy4NCg0KQmx1ZXRvb3RoIGZpcm13
YXJlIGZpbGVzIGFyZSBzcGVjaWZpYyB0byB2ZW5kb3IgYm9hcmQgZGVzaWducy4gV2hlbiANCnRo
ZXJlIGlzIGFuIHVwZGF0ZSwgdGhlIGhhcmR3YXJlIChkZXZpY2UvYm9hcmQpIHZlbmRvciBxdWFs
aWZpZXMgdGhlIA0KZmlybXdhcmUgYW5kIHJlbGVhc2UgdGhyb3VnaCB0aGVpciBwcmVmZXJyZWQg
Y2hhbm5lbCAoaW4gSFRDJ3MgY2FzZSB0aGV5IA0KY2hvc2UgdG8gdXBzdHJlYW0gaXQpLg0KDQoN
ClJlZ2FyZHMsDQpDaGktaHNpZW4gTGluDQo=
