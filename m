Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6611C43610
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 08:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CE0E2075B
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 08:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="MOz5z6BW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CE0E2075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbeKTTTc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 14:19:32 -0500
Received: from mail-eopbgr730103.outbound.protection.outlook.com ([40.107.73.103]:18336
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725851AbeKTTTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 14:19:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6KOKL9JrGkk+z9MZDh+pWGd0Ov+RdGJR+4roLPHkeM=;
 b=MOz5z6BWYjP2dAYcqTvicSxKyxz1uewxDXJ6VTQnsP1tPL+5AOtfwh02xn7pJXoLK+PWwfdEo1/p/kUPrtl7H4jB7ZCOGVqh+g8U6BIRGzWCd7peoZSORiUpQTqkSPc4lUm+0gZpfrZ2W48evejDjfhn58kxGCRROCTnJ8UXO0g=
Received: from BL0PR06MB4356.namprd06.prod.outlook.com (10.167.181.213) by
 BL0PR06MB4611.namprd06.prod.outlook.com (20.177.145.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.21; Tue, 20 Nov 2018 08:50:56 +0000
Received: from BL0PR06MB4356.namprd06.prod.outlook.com
 ([fe80::e468:676e:f17c:7b63]) by BL0PR06MB4356.namprd06.prod.outlook.com
 ([fe80::e468:676e:f17c:7b63%2]) with mapi id 15.20.1339.027; Tue, 20 Nov 2018
 08:50:56 +0000
From:   Madhan Mohan R <MadhanMohan.R@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
CC:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH V2 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Topic: [PATCH V2 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Index: AQHUell27YgOaOPIa02NnIpm+Ru2HaVL2yaAgAyMbQA=
Date:   Tue, 20 Nov 2018 08:50:55 +0000
Message-ID: <20181120085049.GB1563@aremote02.aus.cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-4-git-send-email-chi-hsien.lin@cypress.com>
 <0925038a-a767-351d-5b03-f8fa10b8aad1@broadcom.com>
In-Reply-To: <0925038a-a767-351d-5b03-f8fa10b8aad1@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0048.prod.exchangelabs.com (2603:10b6:a03:94::25)
 To BL0PR06MB4356.namprd06.prod.outlook.com (2603:10b6:208:4e::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=MadhanMohan.R@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.110.209.245]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR06MB4611;6:iC8U8rr0Hktjm/+woWDWDan56GuUujwuXMg1U/+w2lcC+tmwAkC1pXsbHRIKiV9w/gMMILEAAsdnPC5bqx1r+KkfY87SHQFyooH+FjQwmtxjlGYZhWKKzRbSQdbRnk49ydie/+Sa1g1QAR/26dXfrt6wHSpWQNx8OcZ75yi7yWe8rVpEc3hTQa6ELPdemAxxVaHnqM9ESlSZsQLQB8h9Aayn7vdsGqpR53CuxbnFNsxzmUiEhrBz3CFMt0IJtDJ1tSjQYqQlcaCHqnru9odT3lr1l9wy1n44YshChcHtkGbV0Q2l9DMhgez9IU2bTh30SS0t1LExdiW+9fhd0YxqM8D2QvbcoHd71FS+0Fb9SEandNSD4lRX56m4Yv/RYA0ie9+rHGzg0iuZ56ZxygUibPYkHz2liqZWi0wCs72TaGw58B+QGwbi2msp/b3VCKiLFos/yl8PSOzNDzO841RN5Q==;5:J2x/hxYYyhKh2+a/GQWMYJmssTcnrlk+GkM9yn12+/YhwWe673XDEao984mn5xA3tDVrnQg1LZ7mB1Nc4HrYS1pD+ypEQUvzF68WxXSralwQwxzeovUiCoRAZRFILcXOtdZg4ODT9fQ+2tkyxNmogx9Xt4rMJUVHTB16LZQ7Yqo=;7:QWQWb6ryiK+h+Dif6FWZYoQWbQMTLdD0Im81s29/vNzr9AvASK1pTFda4QpNxbnMBFFL1aj0sCkLiGN+juYYdqZi9nknhkmihnTB96dTsJ5iJ97jy7YU/djM638abNpACmU7wIT5pO0uSji4HwfAVA==
x-ms-office365-filtering-correlation-id: 6fc389e5-3f97-4f3e-96c0-08d64ec54887
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR06MB4611;
x-ms-traffictypediagnostic: BL0PR06MB4611:
x-microsoft-antispam-prvs: <BL0PR06MB4611D99600007A4D4FAED7DAFED90@BL0PR06MB4611.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(3002001)(6055026)(148016)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BL0PR06MB4611;BCL:0;PCL:0;RULEID:;SRVR:BL0PR06MB4611;
x-forefront-prvs: 08626BE3A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(396003)(346002)(39860400002)(189003)(199004)(6506007)(25786009)(8676002)(316002)(105586002)(256004)(72206003)(86362001)(14444005)(106356001)(6246003)(81156014)(81166006)(68736007)(53936002)(14454004)(478600001)(5660300001)(6512007)(6116002)(1076002)(26005)(102836004)(186003)(3846002)(476003)(2906002)(11346002)(71190400001)(6916009)(71200400001)(446003)(66066001)(7736002)(4326008)(99286004)(97736004)(6436002)(486006)(54906003)(33656002)(8936002)(305945005)(53546011)(6486002)(386003)(52116002)(2900100001)(229853002)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR06MB4611;H:BL0PR06MB4356.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: edX5m1p5jOThx2h2mO6pSLUOipdbIeCKUh8+YBsm9kym+xj3vwKTObMmXT9z0iE5pW5+0gGOEBTU5Ibb9nsiobMpi7ZzIxqmQ1yK8y5FCqE7lctIyXcab64ti+zuIKRPXyVbPfAXSI0LoMR5y3DnZxSM3H93kQlwi8vujdsR7HclOwCyrEwFrSw+lohCpIckqEksMAJDMOKe+cNhO8w5H9WUVSHmHXGeqbhnoM3lxv6Rf396d9/P68qCVY02uSyDx6+BuaUR8J4Fn7wVcX9dwVu4RAcvtqvGglzq4MkY/x3nUKpsd/vbhGuptJ5bHMCTzSlWdfL2CJIwHy0NziMIwS5ExggBTNVkRPEjc7srXIs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25BAA796B42E9448BDD91500CDCF273A@namprd06.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc389e5-3f97-4f3e-96c0-08d64ec54887
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2018 08:50:55.9428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR06MB4611
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Nov 12, 2018 at 10:13:07AM +0100, Arend van Spriel wrote:
> On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
> >From: Madhan Mohan R <MadhanMohan.R@cypress.com>
> >
> >Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
> >should be enabled & configured to avoid overflow errors.
>=20
> I am a bit confused. Why is it necessary to program the watermark in
> both SBSDIO_WATERMARK (0x10008) and SDSDIO_FUNC1_MESBUSYCTRL
> (0x1001D).
> Looks suspicious to me.
>=20
> Regards,
> Arend

Hi Arend,

Register SDSDIO_FUNC1_MESBUSYCTRL(0x1001D) Bits [6:0] is programmed with
SDIO RX path watermark whereas the register SBSDIO_WATERMARK(0x10008) is
for the SDIO TX path.

Regards,
Madhan
