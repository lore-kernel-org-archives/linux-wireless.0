Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621E5C5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14D4920811
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:22:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="R4iXqrX6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14D4920811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=bowerswilkins.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbeLKTWn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 14:22:43 -0500
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:35680
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726340AbeLKTWm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 14:22:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyK6C4Mi0+EP0VuBE2K5w3Whxr16EORXLhyloFEigRM=;
 b=R4iXqrX6I0VqWI5y8QTzv/wU2HibC19dXLNyC1bflMlsLZ99xQwTUgK0RtLLHUw4ApdGO9ZD6GwVSyyBLm5Tk4GTELNR/P79ejXq3JFAbG+5GgAKJkJ68EztpGNNpzeJB7qLKkgDGew95cNriJG8OXuQy2anzppLrulXNVBWTds=
Received: from DB7PR04MB4154.eurprd04.prod.outlook.com (52.135.130.151) by
 DB7PR04MB5516.eurprd04.prod.outlook.com (20.178.106.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.22; Tue, 11 Dec 2018 19:22:38 +0000
Received: from DB7PR04MB4154.eurprd04.prod.outlook.com
 ([fe80::f9f8:c841:2a7a:5763]) by DB7PR04MB4154.eurprd04.prod.outlook.com
 ([fe80::f9f8:c841:2a7a:5763%2]) with mapi id 15.20.1404.026; Tue, 11 Dec 2018
 19:22:38 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Zhi Chen <zhichen@codeaurora.org>
Subject: Re: [PATCH] ath10k: fix incorrect multicast/broadcast rate setting
Thread-Topic: [PATCH] ath10k: fix incorrect multicast/broadcast rate setting
Thread-Index: AQHUkQ3dtb5WIiXdk02f8eGXhyM9ZqV565sA
Date:   Tue, 11 Dec 2018 19:22:38 +0000
Message-ID: <6a59f346-5c9b-190c-feef-39393d17933b@bowerswilkins.com>
References: <1544504171-19810-1-git-send-email-pradeepc@codeaurora.org>
In-Reply-To: <1544504171-19810-1-git-send-email-pradeepc@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR2101CA0033.namprd21.prod.outlook.com
 (2603:10b6:302:1::46) To DB7PR04MB4154.eurprd04.prod.outlook.com
 (2603:10a6:5:26::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.244.182.62]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB7PR04MB5516;6:urWen0dUvhTh1jcVxsCXwe7Ear3o3VOr35qfTQXxPPtIv95rmUHcN0gYMeRuNFyfEpGaIgJap8Y/cmUWsUNQxALcClW7IVqxepeXqgx2DT292yA4+rYMm4bKsaAgBU4tshS7hksJxLk9TwxgaC80/mg60WoY+gHZLqNrITlgkDPOKteABVcRWnLd7bsxwiOJJ00cdEzgYhvA/Asl2FLEXS5SdmcihB0JAoew4PpmTEKCHxA/VBQg2gQD6E+65cB6G5OJ/Z4+6M8DUNteDdf8t5sLpPwrBj/ttzBlKyISCYhfCw94s7BpldTiGWEV6BcPJGx9gjPa1olbPvHwj2C+tmoFIt08gZkvIgmKaaMDtzTo6ABB14HWDys7NAw6OEo2CzwyxlAm75AUnXOigCmIgHaoQqPsKzs8/PO8pMsJ9eMnGco+DKf7+ZIdXt9MTcMc7hW3bl3IfpLNN1DtGzvP7g==;5:Cgc7PDeTxeU07hS8jLz6Hzwgdf/lKwTXrCwRgwE16t1vNXyZXcopP5Ib8g2Q/BGn3G01CjB99HkI635OUVQ9WjzxM3bmyesLDb66gQn2nNJgO5rTA90a05pOJkXToi004YivAosk2rN0eAFrTTF4gHZqAXgMS6ZQPzLX5wZK1qU=;7:pOo8Kto5wB1aHx5MS27CJJEwiZ/u4kgQTcel94ycudQCG+MdedfnHPPxzyf/CxcYTaoWOxbRxBZAn/r6Jljd8Z7xkiUF6DCKjf7oLsfT+YNvuA4OX/dStvZpgehcVwWjAiR9ttGNCWMRn0+rcGZt1g==
x-ms-office365-filtering-correlation-id: 3fca60a9-5b9c-4d01-bc90-08d65f9e02d3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB5516;
x-ms-traffictypediagnostic: DB7PR04MB5516:
x-microsoft-antispam-prvs: <DB7PR04MB551617D265CA26C7D643431F99A60@DB7PR04MB5516.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(10201501046)(3002001)(93006095)(93001095)(3231455)(999002)(944501520)(52105112)(148016)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DB7PR04MB5516;BCL:0;PCL:0;RULEID:;SRVR:DB7PR04MB5516;
x-forefront-prvs: 08831F51DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39850400004)(376002)(396003)(366004)(136003)(189003)(199004)(476003)(25786009)(6506007)(53546011)(36756003)(6436002)(3846002)(6116002)(2906002)(105586002)(31696002)(71190400001)(31686004)(106356001)(44832011)(478600001)(316002)(97736004)(11346002)(71200400001)(2616005)(8676002)(446003)(229853002)(14454004)(68736007)(66066001)(7736002)(86362001)(486006)(52116002)(54906003)(8936002)(81156014)(81166006)(2501003)(186003)(110136005)(14444005)(76176011)(102836004)(256004)(6512007)(53936002)(6486002)(99286004)(5660300001)(386003)(305945005)(26005)(6246003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5516;H:DB7PR04MB4154.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-microsoft-antispam-message-info: yQ5jD9dbgpTmQrk19tlX5fHVvbzz8h+QchJbB8qvrGB7yggOu1icaz/LmQ4OVfmOI0EKkXG3NMnGBFmvJD18r20IDb3ipsHdGRGA9NJqOcBD1Q2mZ3HvVNlAyeZEKWnc4uYjMvH+o79B1sdWikni3f/505nfs1A8gXJ+kN7gbmdkL9vp1jDFFwqdXR9ZfRvjEYdVagzgJ24bXIQ9jx/560R1OOBqpYHUySWTx6KihnWACoGFnZPqkafWCBik0OjqRnUw/ic3kW3C2KYeENO0Gz2DoY2A+AJb6/ZJcAlSVnixMPDKjL/Q7plyLGQXQl4e
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EED4595D1C9BF4DB0B027139814A88F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fca60a9-5b9c-4d01-bc90-08d65f9e02d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2018 19:22:38.1789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5516
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEyLzEwLzIwMTggMDg6NTYgUE0sIFByYWRlZXAgS3VtYXIgQ2hpdHJhcHUgd3JvdGU6
DQo+IEZyb206IFByYWRlZXAga3VtYXIgQ2hpdHJhcHUgPHByYWRlZXBjQGNvZGVhdXJvcmEub3Jn
Pg0KPg0KPiBJbnZhbGlkIHJhdGUgY29kZSBpcyBzZW50IHRvIGZpcm13YXJlIHdoZW4gbXVsdGlj
YXN0IHJhdGUgdmFsdWUgb2YgMCBpcw0KPiBzZW50IHRvIGRyaXZlciBpbmRpY2F0aW5nIGRpc2Fi
bGVkIGNhc2UsIGNhdXNpbmcgYnJva2VuIG1lc2ggcGF0aC4NCj4gc28gZml4IHRoYXQuDQo+DQo+
IFRlc3RlZCBvbiBRQ0E5OTg0IHdpdGggZmlybXdhcmUgMTAuNC0zLjYuMS0wMDgyNw0KPg0KVGVz
dCBkYXRhIGlzIHRvbyBzbWFsbC4gWW91IG5lZWQgdG8gcHJvdmlkZSBhdCBsZWFzdCBRQ0E5ODgw
IGFuZCBRQ0E0MDE5IA0KZGF0YSB0b2dldGhlciB3aGljaCBzaGFyZSBhdGgxMGsgZm9yIG1lc2gu
DQoNClRoYW5rcywNClBldGVyDQo=
