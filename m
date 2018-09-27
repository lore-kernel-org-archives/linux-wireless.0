Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2FFECE561
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 14:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6486A216F4
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 14:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="vt50Zli9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6486A216F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbeI0VQy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:16:54 -0400
Received: from mail-eopbgr690105.outbound.protection.outlook.com ([40.107.69.105]:40893
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727603AbeI0VQy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XaxIVRB0+bTU8zuYMUh8sSu1Q7j664nbDn5nsqdZuo=;
 b=vt50Zli9YdrI6yWV6Mux/zLgpyNM+csIeB3fegZEgvuREnhp2B8egW46SC/eF5Zw6b+FrUvosUSw7PP/uiy9mB/qK42wYoSybNXomywa3xdun0tImMbKw2GOylQ+NLqlgEQC16LyIGyICkFlg1Chj1/krbIyZ/PSxx+9C6qwevo=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1530.namprd06.prod.outlook.com (10.162.112.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.20; Thu, 27 Sep 2018 14:58:10 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac%5]) with mapi id 15.20.1164.024; Thu, 27 Sep 2018
 14:58:10 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Josh Boyer <jwboyer@kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>
Subject: Re: [PATCH 0/2] WFA p2p certification fixes
Thread-Topic: [PATCH 0/2] WFA p2p certification fixes
Thread-Index: AQHUVkarF8wH9OrDD0Kc4dw/WW3Dd6UEOGwA
Date:   Thu, 27 Sep 2018 14:58:10 +0000
Message-ID: <4abbbee7-768d-cd6a-04e9-7f2247cc5510@cypress.com>
References: <1538041427-115758-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1538041427-115758-1-git-send-email-chi-hsien.lin@cypress.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
x-clientproxiedby: CY4PR19CA0042.namprd19.prod.outlook.com
 (2603:10b6:903:103::28) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1530;6:GAnisEjsrKvzZHYGpBJRD/2Nn/4CNdnbyDMlyqcYwHIICmpTo9bAPaRfjc9S7OZjZ0acZ9JyRO7IB3Qmy7z77/P/B+Pi1Y+J3F9XpnHFydZPr3UMnAaf9/SqR/UjFbgIy5S5VXgaYK0Bc3Xh5KAMTS10ck7dJkyB38wdXnLg4e/fAspCFQZA3y11Nt3ssKxNnKtLD8AKnshxbCc1uBsCeWSklJ+yy5u973qCo4MTQnWKtIJ9RWPJt7oJi7XUONj27Lu2aXu0OUy5Gbe0GEN6g4uctpVPY1fD5GzOVWTLlbCAKqG/024TUlc/nLha0wPEH8q6mCmcybWx0ZM1XNKSsUV9S+HaySgzYfCsvJZWYxHAm9o+I7XAaW3CbxaVJ2ZtXe5MV5ADPNHffSGP6OY2zAJn+qHHfkYqetNQvdYMtisgg6olUzV9Kqaufh716T1n76LmGv1ytx8JkSPB+6nuDA==;5:NubYg9jpGxpnOxFUSpje5S4gKxstSQiSs8Pms/oN6yZ6sNQ60iJyBNbFgt18WRs1HXzQ6SlpCDVBgXEgnnnwTMbXALev202ymhkPJiQNTUmWFCvfMPBn3hZPZhnlOKQ91LvqDnZOxZozgGmS6CPIx+Nc19ilSDSG9U8r4Pg443U=;7:wd8azGuISBVZaUsFx2RccB1pFiaFbbHjXpwJ+DuOEiE2qkFIf9ao76u1htVon14qmi/rEC7ysb+XFMYLpHUD4gnogb8/Ug3Ehxydu+uVTN5KTtm03dElEbsQ6YBdjqVLiJ75LPozQR+OQ4uIsFYRwt1ftuCNGSM4Odxm6ORnsVnxrA2WR9GQQ2dq6iefYqT+SzNVBjDEzp4hH++QabNwdQZlCPSSuBZjVrMhAf1nngd0ID0KXDqYvXAFFRKX8quX
x-ms-office365-filtering-correlation-id: 987efff4-b450-43f4-a27e-08d62489a39a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1530;
x-ms-traffictypediagnostic: BY1PR0601MB1530:
x-microsoft-antispam-prvs: <BY1PR0601MB15306220452E23F45D17EF01BB140@BY1PR0601MB1530.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(6055026)(149066)(150057)(6041310)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(201708071742011)(7699051);SRVR:BY1PR0601MB1530;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1530;
x-forefront-prvs: 0808323E97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(366004)(396003)(136003)(189003)(199004)(486006)(2501003)(43066004)(52116002)(4326008)(99286004)(6486002)(186003)(6436002)(5640700003)(6512007)(5250100002)(107886003)(7736002)(316002)(6506007)(305945005)(106356001)(8676002)(105586002)(81166006)(86362001)(2900100001)(76176011)(8936002)(64126003)(2906002)(53546011)(81156014)(25786009)(31696002)(386003)(6246003)(14454004)(256004)(2616005)(54906003)(65826007)(5660300001)(446003)(476003)(58126008)(102836004)(3450700001)(11346002)(66066001)(65956001)(6116002)(3846002)(72206003)(478600001)(31686004)(2351001)(6916009)(36756003)(53936002)(26005)(68736007)(65806001)(71190400001)(34290500001)(97736004)(229853002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1530;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 2GN7WVGgTNAJtvJ/rcSM9iI9MwEkvsDDvq5URw+teycN/QMXVh46/fYfBA7xNumA9lgKPpYk7di3EENchzGqeqi76T5BMNS/JdgGtQdWkyqGTAPC9ivOdHE/rGcB8ZNSwJ44Kxur/XXbJa9bt0bppX/WNyeLAPlpChcBY6FGY5xj6nK33bu50mYCIc5Q50TXIJ52bfUeoEd5LzS0lpAnVOP7l0UJBA9LkN7Fv2y9LJ1ueKwdmPlHabsyTwaMswIZmNKB/ocP7itU6bXvdOK/Vc7HCFjfkVTrnDJCGc4tPsy4AfaigMEyQuY5IprZxLJ3stE8Yj1f6leVKwgPFCg4Fsy2ZG8gXnT82VuLrrlc3Jg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <02A91CF8E639AE4F9A9C267A5C6A73C1@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 987efff4-b450-43f4-a27e-08d62489a39a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2018 14:58:10.5475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1530
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

VGhpcyBpcyBzdWJtaXR0ZWQgdG8gbGludXgtZmlybXdhcmUgYnkgbWlzdGFrZS4gSXQgc2hvdWxk
IGhhdmUgYmVlbiBzZW50IA0KdG8gbGludXgtd2lyZWxlc3Mgb25seS4gUGxlYXNlIGRpc2NhcmQg
aXQuIFNvcnJ5IGZvciB0aGUgaW5jb252ZW5pZW5jZS4NCg0KSSdsbCBzdWJtaXQgdjIgdG8gbGlu
dXgtd2lyZWxlc3MgbGlzdCBvbmx5Lg0KDQpPbiAwOS8yNy8yMDE4IDU6NDQsIENoaS1Ic2llbiBM
aW4gd3JvdGU6DQo+IEZpeGVzIGZvciBXRkEgcDJwIGNlcnRpZmljYXRpb24gNS4xLjE5IGFuZCA1
LjEuMjAgZmFpbHVyZXMuDQo+IA0KPiBDaHVuZy1Ic2llbiBIc3UgKDIpOg0KPiAgICBicmNtZm1h
YzogcmVkdWNlIHRpbWVvdXQgZm9yIGFjdGlvbiBmcmFtZSBzY2FuDQo+ICAgIGJyY21mbWFjOiBm
aXggZnVsbCB0aW1lb3V0IHdhaXRpbmcgZm9yIGFjdGlvbiBmcmFtZSBvbi1jaGFubmVsIHR4DQo+
IA0KPiAgIC4uLi9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3AycC5j
IHwgMjYgKysrKysrKysrKysrKysrKy0tLS0tLQ0KPiAgIC4uLi9uZXQvd2lyZWxlc3MvYnJvYWRj
b20vYnJjbTgwMjExL2JyY21mbWFjL3AycC5oIHwgIDIgKysNCj4gICAyIGZpbGVzIGNoYW5nZWQs
IDIxIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+IA0K
