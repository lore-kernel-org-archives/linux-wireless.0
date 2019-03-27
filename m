Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADB3C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 17:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D1E420651
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 17:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="HDdQPrEB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfC0RtX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 13:49:23 -0400
Received: from mail-eopbgr40074.outbound.protection.outlook.com ([40.107.4.74]:51374
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727405AbfC0RtX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 13:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7PSupg3bT8Jp3/Bru+swsbn8UXj1pntQMPHXBtxOaI=;
 b=HDdQPrEBclkKxIiz9lLVbVvt0rtrjNdYXhxSWd9yvb//G6u0dJ+QCeL1How95Rm7Wd9RYDN6mdv+oWsDn2toiuGgHZuhF2EeEK/SGz6Cy8kpD/3E9ZKrv2Gy9ADuuDR+yBwa+UVXnxU9QFXoKukulVhL0SjoEGNEkj48q9xu53k=
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com (20.179.32.150) by
 AM0PR04MB5092.eurprd04.prod.outlook.com (20.177.40.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.18; Wed, 27 Mar 2019 17:49:19 +0000
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::d0ea:9bdf:7139:b472]) by AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::d0ea:9bdf:7139:b472%6]) with mapi id 15.20.1730.019; Wed, 27 Mar 2019
 17:49:19 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>,
        "kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "yiboz@codeaurora.org" <yiboz@codeaurora.org>
Subject: Re: [PATCH] ath10k: remove iteration in wake_tx_queue
Thread-Topic: [PATCH] ath10k: remove iteration in wake_tx_queue
Thread-Index: AQHU5LpEMcaCu8BM9UyKSOiOnu+lzKYfwVEA
Date:   Wed, 27 Mar 2019 17:49:19 +0000
Message-ID: <ba7a88e5-10ff-2ec2-feee-6d4adf472833@bowerswilkins.com>
References: <20190327162906.6010-1-erik.stromdahl@gmail.com>
In-Reply-To: <20190327162906.6010-1-erik.stromdahl@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0100.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::41) To AM0PR04MB6065.eurprd04.prod.outlook.com
 (2603:10a6:208:139::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.244.182.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25d98cf5-6c92-40f5-290d-08d6b2dc89c7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB5092;
x-ms-traffictypediagnostic: AM0PR04MB5092:
x-microsoft-antispam-prvs: <AM0PR04MB50920B06D2E733E1A297572299580@AM0PR04MB5092.eurprd04.prod.outlook.com>
x-forefront-prvs: 0989A7979C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(136003)(396003)(39850400004)(189003)(199004)(8676002)(81166006)(6512007)(558084003)(86362001)(305945005)(68736007)(229853002)(3846002)(7736002)(25786009)(11346002)(66066001)(81156014)(2616005)(14454004)(446003)(31686004)(6116002)(105586002)(476003)(106356001)(44832011)(31696002)(316002)(386003)(53546011)(110136005)(6506007)(6246003)(5660300002)(2201001)(99286004)(8936002)(36756003)(97736004)(102836004)(6436002)(486006)(6486002)(71200400001)(186003)(76176011)(256004)(53936002)(26005)(2906002)(71190400001)(4326008)(52116002)(478600001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5092;H:AM0PR04MB6065.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lB8Msv0iR6wpNUnmKng4DwWVbdEB24EyyFjg+jUu48F4VHN+Ac1fWSN2TAP+ep5DJXFzGrNfj02o1sG8Gj1n3H+8+EXtX3acLUrR2Yz6kzAB/3HtJbr9aRSentJOdgGqKFGWkc5NftWc4dplBQTaJzFYnmmHGi0+kcCgf8HzO9OSXHvbLLlKS3fvf0deZdN3386JhWSZmjxCw4LCq9VG6CMBhlF9R0VlTVqXuULjKR4PDAzADultjPlTjkwdp3jRhKSuakZhaL/0ASlM5QTow65lTEFOJALI2yeDE5Lw3Drqj9o5z4HxfxHzcEy34v3cWOCXSRWGUidCM0m/PBPZLkkibWei/vH0byBz7zsVU17xHGyQch05y2vpxf6QgVr25yX7ohIpgimKXhEEKvQXrOJk3dGuXxnIeRPywtN/4ik=
Content-Type: text/plain; charset="utf-8"
Content-ID: <414874B7A6CBEB44BDDF7738076C1529@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d98cf5-6c92-40f5-290d-08d6b2dc89c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2019 17:49:19.7826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5092
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDAzLzI3LzIwMTkgMDk6MjkgQU0sIEVyaWsgU3Ryb21kYWhsIHdyb3RlOg0KPiBJdGVy
YXRpbmcgdGhlIFRYIHF1ZXVlIGFuZCB0aGVyZWJ5IGRlcXVldWluZyBhbGwgYXZhaWxhYmxlIHBh
Y2tldHMgaW4gdGhlDQo+IHF1ZXVlIGNvdWxkIHJlc3VsdCBpbiBwZXJmb3JtYW5jZSBwZW5hbHRp
ZXMgb24gc29tZSBTTVAgc3lzdGVtcy4NCj4NClBsZWFzZSBzaGFyZSB0aGUgdGVzdCByZXN1bHRz
IGFuZCBudW1iZXJzIHlvdSd2ZSBydW4gdG8gaGVscCBvdGhlcnMgDQp0aG91Z2h0cy4NCg0KVGhh
bmtzLA0KUGV0ZXINCg==
