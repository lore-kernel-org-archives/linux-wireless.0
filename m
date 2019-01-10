Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E5FC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 09:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC25A214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 09:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="heuyM82Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfAJJph (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 04:45:37 -0500
Received: from mail-eopbgr680127.outbound.protection.outlook.com ([40.107.68.127]:42825
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727863AbfAJJpg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 04:45:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzEoLWCAsRK5k5oI+YGOOe2V38HtFZXfQieaZt1BjR8=;
 b=heuyM82ZSpCLSOnr2gI+42U0ZV89+w1pNGJvGnRXgqjJUAuclKTcBiuIVikYH+JfwP4qEvZaUGRqeQbn5hkUAnBg5mYsxUHzqc/1NxhdHivNxASFvT77Ro1EDwBd9vNHkUzdTGgIrcwSuKv8d3SQqTkorzAoyhRfMxTnJJgxpEs=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB4409.namprd06.prod.outlook.com (20.176.108.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.13; Thu, 10 Jan 2019 09:45:34 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%5]) with mapi id 15.20.1516.015; Thu, 10 Jan 2019
 09:45:34 +0000
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
Thread-Index: AQHUpnznZEN0dsuyZUO0UUnIQZWTX6Wjs8KAgAASrYCABGX7AIAACZ0AgAAPZIA=
Date:   Thu, 10 Jan 2019 09:45:34 +0000
Message-ID: <2c8efe58-0c13-8dfd-6d5a-17965f65a71d@cypress.com>
References: <20190107113401.6824-1-hdegoede@redhat.com>
 <d6dafb19-4e88-c2c7-9547-2ebd5b4bec2e@broadcom.com>
 <5b365baf-99b3-2033-1f8e-6ca38d6daf42@redhat.com>
 <55db0ecb-5386-7a10-f26a-fa1e50af9b57@cypress.com>
 <d0bdf1d9-afa1-2eb7-b308-a6ea5278d0f6@redhat.com>
In-Reply-To: <d0bdf1d9-afa1-2eb7-b308-a6ea5278d0f6@redhat.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: TY2PR01CA0021.jpnprd01.prod.outlook.com
 (2603:1096:404:a::33) To DM6PR06MB5804.namprd06.prod.outlook.com
 (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB4409;6:C71LeMjNTzk8g+XZLB07VnmZIr6eecuLyrJmZBgu0VYXVeODdaPjR56Rs8lHdCzNQUTuIiBMYWM12iSZlic8nutnH1NZOzwK3W2XuGzzEEXbQmdvWI5bKyssS4GRMxpye7FKBeafVWTPMdTdYq9WQh499IXueKQ/b5VCDKetVdg+KziFEiAixJHQHbvMrvvuzCt75BToGNd+Doxt0cwH1AWTfScAxjyHoWWeJ9zvmnFW/UgjmJWe8koKyiC4h03Zsr3WisAlMbNVeghV/8eWGIMmziLV3yvKYl+nSgrAxGMcuQS3IKnd492R1MVL5ASNmxS5uoR9ZGQecrHScAVXa0cB2OXGllfJIS81dOsnuXuWuZktESNT/FRPy5UtAOv9E4mbYSZG9CRhjc9cCgkbTfVemxXbno3RpsNu1vO1NiOum1/C557wbeJWZ+qbiRmRb1IQ9QzYIsZGSFuAeQ5hrg==;5:QsRf6SJZr2iX4HjIWq9tEFJC0fFbeg+FQnKFXsjemADkbxJZbw7Y4u8V/nGTG7jOm7zwjcLJzyikx/0F232AOz2c4YEg31xKmnRgdOKDvxLFVm9NyzuJf3UUGtUYGvJVqRd0Q8DIX/y0nafT34IK3I+Qd9t1n9+JzxW6611sVpn5WpRqqW1JvKjjbGtza8Om2xorikGIU5N3E6ihjiKFGg==;7:INETywTZLdkJPgb1L++OtTCFeIonhU38ZJkDeVxYQFoJi5P3uNgM7uCxH5e/BigYGHFoSYr6bQSpLAWrPRLnS9O3bjPCOABt3fsAGOSbwJCq2lfzFlBERFbZuutEINbFoFCs5eSuLxpdGvfR0u3RhQ==
x-ms-office365-filtering-correlation-id: 6cf58329-e85a-4295-d505-08d676e05d76
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB4409;
x-ms-traffictypediagnostic: DM6PR06MB4409:
x-microsoft-antispam-prvs: <DM6PR06MB44092B6B293D9C971C2849A3BB840@DM6PR06MB4409.namprd06.prod.outlook.com>
x-forefront-prvs: 0913EA1D60
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(366004)(39860400002)(346002)(189003)(199004)(256004)(5660300001)(14444005)(97736004)(102836004)(446003)(52116002)(14454004)(53546011)(386003)(6506007)(99286004)(6436002)(486006)(26005)(93886005)(64126003)(229853002)(6636002)(65826007)(76176011)(478600001)(72206003)(2906002)(106356001)(4326008)(6486002)(186003)(3846002)(25786009)(81166006)(8676002)(71190400001)(71200400001)(107886003)(105586002)(81156014)(68736007)(43066004)(6246003)(8936002)(476003)(6116002)(11346002)(2616005)(54906003)(316002)(305945005)(53936002)(110136005)(58126008)(7736002)(31696002)(3450700001)(86362001)(36756003)(31686004)(6512007)(65956001)(66066001)(65806001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB4409;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H60WDiEQm2Z5rCkSYCbaYVaKZOTcK5H3po23ImSvJhlQ5Z5NDmowk7LW62HMrGzyCM/Re9csX3jzMC9BelRcLMNOM3wAEm3n6DnSGiMDy+k1yBOxnv09gyPvzxGBXJ+JYJJaQeZhKlynMxZvCASMruHYoJgnu3lhE5tCrYdxRQuMrWZhJbfewYcGhYX1EGG5KyuvUibdotdKzh51aRR8+45ISdFNcO2xeAQ8eA83iMVOumDefHctqU6sSH9qWMXEdIq3DUrFmZPjCeXuxfvC5UwGBs/mVa7vX5jBlBKa8lopAozoDRTsy5cr8SQEgWxP
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB92FE1D57D73942AF1FA4A586F6375B@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf58329-e85a-4295-d505-08d676e05d76
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2019 09:45:34.1050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB4409
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDAxLzEwLzIwMTkgNDo1MCwgSGFucyBkZSBHb2VkZSB3cm90ZToNCj4gSGksDQo+IA0K
PiBPbiAxMC0wMS0xOSAwOToxNiwgQ2hpLUhzaWVuIExpbiB3cm90ZToNCj4gU28gdGhlIGxpbnV4
IGZpcm13YXJlIHZlcnNpb24gaXMgKnRocmVlIGFuZCBhIGhhbGYqIHllYXJzIG91dCBvZiBkYXRl
IQ0KDQpUaGFua3MgYSBsb3QgZm9yIHRoZSByZWZlcmVuY2UuIFRoaXMgZGlzY3Vzc2lvbiBjb3Vs
ZCBiZSBtb3ZlZCB0byB0aGUgVjIgDQp0aHJlYWQuDQoNCg0KPiBXZSBhcmUgbm90IGFza2luZyB5
b3UgdG8gZG8gc3BlY2lhbCBMaW51eCBidWlsZHMsIExpbnV4IGNhbiB1c2UgdGhlIHBlcg0KPiBi
b2FyZCBXaW5kb3dzIGZpbGVzIGp1c3QgZmluZSwgYWxsIHdlIG5lZWQgaXMgcGVybWlzc2lvbiB0
byBkaXN0cmlidXRlIHRoaXMNCj4gYW5kIHRoZW4gTGludXggdXNlcnMgd2lsbCBydW4gdGhlaXIg
Ym9hcmRzIHdpdGggdGhlIHNhbWUgcXVhbGlmaWVkIGZpcm13YXJlDQo+IGZpbGVzIGFzIGFyZSBi
ZWluZyB1c2VkIHVuZGVyIFdpbmRvd3MuDQoNCkkgcmVtZW1iZXIgdGhhdCB0aGlzIGhhcyBiZWVu
IGJyb3VnaHQgdXAgYSB3aGlsZSBiYWNrIGFuZCBJIGRpZCBjaGVjayANCndpdGggdGhlIEN5cHJl
c3MgYmx1ZXRvb3RoIHRlYW0gYWJvdXQgaXQuIFRoZSBhbnN3ZXIgSSBnb3QgaXMgdGhhdCB0aGUg
DQpmaWxlcyB3ZXJlIGNvbW1pdHRlZCBiZWZvcmUgdGhlIEN5cHJlc3MgYWNxdWlzaXRpb24gYW5k
IG91ciBibHVldG9vdGggDQp0ZWFtIGNvdWxkbid0IGV2ZW4gbG9jYXRlIHRoZXNlIGZpbGVzIGlu
IG91ciBzZXJ2ZXIuIFNvLCB1bmZvcnR1bmF0ZWx5IA0Kd2UgY2Fubm90IG1vZGlmeSB0aGUgbGlj
ZW5zZSBmb3IgZmlybXdhcmUgZmlsZXMgdGhhdCBhcmUgbm90IHJlbGVhc2VkIGJ5IHVzLg0KDQoN
Cg0KPiANCj4gQWN0dWFsbHkgYnkgbm90IGFsbG93aW5nIHVzIHRvIHByb3ZpZGUgdGhlc2UgZmls
ZXMgeW91IHJ1biB0aGUgcmlzayBvZiANCj4gdXNlcnMNCj4gZ3JhYmJpbmcgYSByYW5kb20gZmls
ZSBmcm9tIHNvbWV3aGVyZSBhbmQgcmVuYW1pbmcgaXQsIHBvdGVudGlhbGx5IA0KPiBoYXZpbmcg
aXQNCj4gbm90IG1hdGNoIHRoZSBib2FyZCB0aGUgdXNlciBpcyB1c2luZy4NCj4gDQo+IFJlZ2Fy
ZHMsDQo+IA0KPiBIYW5zDQo+IA0KPiAuDQo+IA0K
