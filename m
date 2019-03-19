Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F217C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 20:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2E602146E
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 20:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="RlRjK+5Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfCSUpU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 16:45:20 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:43301
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbfCSUpU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 16:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AO/H0Tv/nfm1ZsTn6TtktMlO7eqRJ/T+py3n2HGJTcs=;
 b=RlRjK+5ZtAc4gXbjPKr++mSDaTkrpivgjHkMf+aKCuJtmdnKrZ9pcK7l0b5zp+hHMXjb5Olvu67PtVQgcBQ3aTWxdu2CuZ4a7xzR6xgE8Vrj7NHhrxw+SP0Sb5OTqqORJeMVgzxOKQN0FDuEXk4WrVQwlr0asppP025Z7EDfubg=
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com (20.179.32.150) by
 AM0PR04MB4980.eurprd04.prod.outlook.com (20.177.40.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.14; Tue, 19 Mar 2019 20:45:16 +0000
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::d0ea:9bdf:7139:b472]) by AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::d0ea:9bdf:7139:b472%6]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 20:45:16 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     =?utf-8?B?VG9taXNsYXYgUG/FvmVnYQ==?= <pozega.tomislav@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: Re: [PATCH] ath10k: Fix ASPM L1 state on QCA988X
Thread-Topic: [PATCH] ath10k: Fix ASPM L1 state on QCA988X
Thread-Index: AQHU3o5Q1hQMf6Ilf0ONyGfK5ozX0KYTbCuA
Date:   Tue, 19 Mar 2019 20:45:16 +0000
Message-ID: <0851502b-be6d-7947-ac7e-908065f2b330@bowerswilkins.com>
References: <1553025580-6118-1-git-send-email-pozega.tomislav@gmail.com>
In-Reply-To: <1553025580-6118-1-git-send-email-pozega.tomislav@gmail.com>
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
x-ms-office365-filtering-correlation-id: 8354426b-ebff-4e52-9cc3-08d6acabcacd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4980;
x-ms-traffictypediagnostic: AM0PR04MB4980:
x-microsoft-antispam-prvs: <AM0PR04MB49800EDDC2D73EE001DC9E9F99400@AM0PR04MB4980.eurprd04.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39850400004)(396003)(136003)(376002)(366004)(199004)(189003)(53936002)(229853002)(6486002)(26005)(186003)(486006)(97736004)(478600001)(14454004)(316002)(54906003)(44832011)(2906002)(110136005)(25786009)(68736007)(305945005)(6436002)(81156014)(6512007)(8676002)(8936002)(81166006)(66066001)(2501003)(11346002)(106356001)(6246003)(7736002)(476003)(256004)(86362001)(446003)(52116002)(6506007)(558084003)(5660300002)(31686004)(2616005)(76176011)(105586002)(4326008)(3846002)(6116002)(102836004)(99286004)(71190400001)(71200400001)(386003)(53546011)(36756003)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4980;H:AM0PR04MB6065.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R7CHAfkCElOPn3qUi6tpaFh8+6lWBoOJonq9Q4ZOEnh5rPJ0ja7caZ3NoYjhJsS8WgGFX3csvDFowO0U7OdoHgio/DtxOD8L0DneG5d9KWc8OMh4e0Pf6E16rW5zHTNIpOt8werM7AWmmckbJwRNIK4iuANvUgQQCBs2GQF8ObN0BDhzxbG3nzFUZW+yGHiS1ua8UvPdxQfYxuyTonq/zfUeHj8K5oHh1dXgWW9LZiMI4kHsRVovWQaiNTk56h5XtiVe7qtgBSYDnjtHJcAj5xsx7uy9CXNayGRGHuA3Wsz4xNBuyxhYa2HVNkXfyMgZZeZs/0sXW42R3pkptTZYAszEX9dC5jLu+tKQYiF3sVJ/CZLDWWOJV5lhd04bxC95Ds1/gSg+vtVFBAnVvTTcJEb2Koo0yNobrKwOqJDRmng=
Content-Type: text/plain; charset="utf-8"
Content-ID: <93A0F80A49448646A89693870E9E535D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8354426b-ebff-4e52-9cc3-08d6acabcacd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 20:45:16.3973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4980
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMDMvMTkvMjAxOSAxMjo1OSBQTSwgVG9taXNsYXYgUG/FvmVnYSB3cm90ZToNCg0KPiBPbiBz
b21lIHN5c3RlbXMgdGhlcmUgYXJlIGhlYXZ5IGNyYXNoZXMgaWYgdGhlIGtlcm5lbCBjb25maWcN
Cj4gb3B0aW9uIENPTkZJR19QQ0lFQVNQTV9QRVJGT1JNQU5DRSBpcyBub3Qgc2V0LiBQYXRjaCBw
cm92aWRlZCBieQ0KPiBTdWppdGggZm9yIGF0aDlrIGZpeGVzDQphdGgxMGs/DQoNClBldGVyDQo=
