Return-Path: <SRS0=ZZIE=OB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08765C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Nov 2018 06:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E51B20685
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Nov 2018 06:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="NW35FkVo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E51B20685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732955AbeKVRMG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Nov 2018 12:12:06 -0500
Received: from mail-eopbgr700139.outbound.protection.outlook.com ([40.107.70.139]:1392
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbeKVRMG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Nov 2018 12:12:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONnRhl6uzo0+s9AaJNgP4RQPjEpPWfDivAkj/Uw/KQ4=;
 b=NW35FkVooomOO+FJW1pnk5Nf25iylyJZcWhUJl5xrppHz3RCOJmNmX6zfVT6yRIP1QhAV0+RfBDcLM1j6AL8akd+ipFmG5L/oO2n7+pIpPzZMTWtJC3BI39ieFiYetczE5ms3lJU4aGx/IziOngOr+L8f7TYXT6NGgjO0fSCoVg=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1063.namprd06.prod.outlook.com (10.160.194.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Thu, 22 Nov 2018 06:34:01 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Thu, 22 Nov 2018
 06:34:01 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>
Subject: Re: [PATCH 0/8] brcmfmac: chip related changes
Thread-Topic: [PATCH 0/8] brcmfmac: chip related changes
Thread-Index: AQHUgWdsCKxqRYAzHkSyCSO6j1JarqVaXGaygAD7cIA=
Date:   Thu, 22 Nov 2018 06:34:01 +0000
Message-ID: <edab7a29-c417-5dd0-d7aa-57e31bfbd1ee@cypress.com>
References: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
 <87ftvubg2x.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87ftvubg2x.fsf@kamboji.qca.qualcomm.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
x-clientproxiedby: TYAPR01CA0160.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::28) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1063;6:S+SPrlg4vAX8aHEoDkaeFUewPJO0/fzF/IWbBiOlmTp4H1ghH26df9v9MeXtN4Icvv+o60jc05yHi9Z8fDLjbDTx4UVHxDe2g35+xahZ91FvCxcWfjL/zgGRKYn0aR6sqXPUSa8SoOGP3HsHDDDHuFF6MGJYI+eCmBSvNXdxRdrCh+5LMUsk8C6A41YbMUhi2k+89y7yIp+qOGJTQmnwwsNuFEWLVq0FNpxLIlSYpy5iTQQk0NWkCpiCdMuj0aB0oh8s9oTPOFzIBSYijkfuWiyDe0A2l3BNy/YAKi9e6DVVjvM2KdyHMfg+ELmc2w9R3fo+HUJtkIpHDvLlv1iAVZ8KvnP2E7lGpFB8wtpXWvkjK5YgpqEcajxDqzSmQ0CpFw/yfe+9NRGNSvfIHViBrvX2FNi9JrPnmAwFUWgXV+xbafUcTp3fSA9itAHfYNnTbU+v2EqDmeP5mI8eRx6FWg==;5:S8Bloo+gdBl/zlJ5B5RylxaGwQROv/7zF2DkOE2BCaqgu+8BQXthNOXNbZwNLrDSsbe9VxAQiEWdWIFG/hGj6O7oAwfTruyZScYPkKIXyTg6cmSN+wWxwKNf5yCm3UjYEWaBN8V8Na4Oc1CYz/4Wrmfkb06waTGK51tb7QNFmxE=;7:V3MSQQUPhZyoaHvy3DaAjkssxyL+lb3uQwtGee8b1q65kpCYu7b6EPUhiFh4j4iboEYotjNhDBON18cybIderCW+Tiji+Aj2lwmwHP39b+aV5kDJor7PTH7UR/pAdVjdIPLCSujlXt1Z0C8z0+dyKw==
x-ms-office365-filtering-correlation-id: d0380f14-33c7-4b3a-24f0-08d650447d4a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1063;
x-ms-traffictypediagnostic: BY1PR0601MB1063:
x-microsoft-antispam-prvs: <BY1PR0601MB1063EA770697B1AD7D8A7178BBDB0@BY1PR0601MB1063.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231442)(944501410)(52105112)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1063;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1063;
x-forefront-prvs: 0864A36BBF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(39860400002)(366004)(346002)(376002)(136003)(54534003)(199004)(189003)(6116002)(66066001)(305945005)(97736004)(14454004)(6512007)(65826007)(7736002)(68736007)(3846002)(229853002)(81166006)(14444005)(81156014)(107886003)(5660300001)(6486002)(64126003)(71190400001)(256004)(52116002)(71200400001)(8676002)(6246003)(53936002)(8936002)(6436002)(105586002)(76176011)(25786009)(36756003)(99286004)(54906003)(43066004)(3450700001)(2900100001)(65806001)(58126008)(106356001)(26005)(2616005)(478600001)(446003)(476003)(316002)(6916009)(386003)(72206003)(4326008)(65956001)(102836004)(2906002)(31696002)(86362001)(11346002)(53546011)(31686004)(6506007)(486006)(186003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1063;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: rTFGrXAdTZlLSRXINcmi81dpDL9TjP8wCfT+frMV3bQdTPSoSa3j0xmz1BzT6obBL9x7eqJc/F7qvuEJZo56WpL/w77piBsVDDjLwNkhvMQsRkbvEgc2Tc3TSLkpinThGdezkWNUJuxyxLNsH07AV+NsVQ4S3DCC4t6d3m1xoDe3jrJB76mkQMoXaAyKQa3oDHAwgWRxfOJTeYSnBGejkG2YJPdfmPxLUxIfFXnNFEJ9SDEmtLsZMvUVRHxuxAH59KIavY02Th8gwH8LPPx+iozsiDiQWOAHfg4D9N4hZLQH4nKbZJzgJSAVUBbDweYXqqEVQCgON7QTlfu+UWGrsqpzwymivl2A3fPnZCTMj4g=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <C161BA062A823C4DA8447E3D88C30EC9@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0380f14-33c7-4b3a-24f0-08d650447d4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2018 06:34:01.6545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1063
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDExLzIxLzIwMTggMTE6MzMsIEthbGxlIFZhbG8gd3JvdGU6DQo+IENoaS1Ic2llbiBM
aW4gPENoaS1Ic2llbi5MaW5AY3lwcmVzcy5jb20+IHdyaXRlczoNCj4gDQo+PiBUaGlzIHBhdGNo
IHNlcmllcyBpbmNsdWRlcyB2YXJpb3VzIGNoaXAtcmVsYXRlZCBjaGFuZ2VzOg0KPj4gKiA0MzAx
MiBzdXBwb3J0DQo+PiAqIDQzNzMgc2F2ZXJlc3RvcmUgc3VwcG9ydA0KPj4gKiBTRElPIGJ1cyBz
ZXR0aW5ncw0KPj4gKiA0MzU0IHJhdyBjaGlwaWQNCj4+DQo+PiBDaGFuZ2Vsb2c6DQo+PiBWMzoN
Cj4+ICAgLSBVcGRhdGUgY29tbWVudHMgZm9yIHBhdGNoIDMuDQo+PiAgIC0gQWRkIGRlZmluZXMg
Zm9yIHNyX2NvbnRyb2wwIHJlZ2lzdGVyIGJpdHMgaW4gcGF0Y2ggNy4NCj4+IFYyOg0KPj4gICAt
IFVwZGF0ZSBjb21taXQgbWVzc2FnZSBmb3IgcGF0Y2ggMS4NCj4+ICAgLSBVcGRhdGUgY29tbWVu
dHMgZm9yIHBhdGNoIDIuDQo+PiAgIC0gUmVtb3ZlIENZXzQzNzNfRjFfTUVTQlVTWUNUUkwgZnJv
bSBwYXRjaCAzLg0KPj4gICAtIENvbGxhcHNlIHBhdGNoIDYgKDQzMTAyIHNyIHN1cHBvcnQpIGlu
IDQgKDQzMDEyIHN1cHBvcnQpLiBBZGQgaGVscGVyIGZ1bmN0aW9ucy4NCj4+ICAgLSBSZW1vdmUg
c3JfZW5nX2VuIHZhcmlhYmxlIGZyb20gcGF0Y2ggOC4NCj4+ICAgLSBDb2xsYXBzZSBwYXRjaCAx
MCBhbmQgMTEgaW4gOSAoc2Rpb19hb3MgZGlzYWJsZSkuDQo+IA0KPiBBcyB5b3Ugc3VibWl0dGVk
IHY0IGFuIGhvdXIgbGF0ZXIgSSBhc3N1bWUgdGhpcyBvbmUgd2FzIGEgbWlzdGFrZSBhbmQNCj4g
SSdsbCBkcm9wIGl0Lg0KDQpZZXMsIHRoaXMgb25lIGlzIGEgbWlzdGFrZS4gVGhhbmtzIGZvciBo
YW5kbGluZyBpdC4NCg0KPiANCj4gLS0NCj4gS2FsbGUgVmFsbw0KPiANCj4gDQo+IC0tLS0tLS0t
LS0NCj4gDQo+IFlvdSdyZSByZWNlaXZpbmcgdGhpcyBtZXNzYWdlIGJlY2F1c2UgeW91J3JlIGEg
bWVtYmVyIG9mIHRoZSBicmNtODAyMTEtZGV2LWxpc3QgZ3JvdXAuDQo+IC4NCj4gDQo=
