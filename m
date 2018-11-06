Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33ECDC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B814C20818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Emb/mz+U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B814C20818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbeKFNN0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:13:26 -0500
Received: from mail-eopbgr810101.outbound.protection.outlook.com ([40.107.81.101]:25243
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728971AbeKFNN0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:13:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRYuPBq1Poc5SQFkkH1M/kHF50R1w/BTkRBLUSzFC2E=;
 b=Emb/mz+U71Vk+YzAAFyqn4hCC5v1lvH3MSI7gyfsxapG3EZvj5JYBbqCBUtXvGgLodyN7dk3Z5AFNB5BIRduxdDKKbtfh5jD40FzyOWEZUvVpHRzKO7I4X/WsI6SlyB7YpSmB1YtVXtUuEIJIoBD+cVmKJ7v7boQgEKni9RzUgk=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:13 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:13 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 00/11] chip related changes
Thread-Topic: [PATCH 00/11] chip related changes
Thread-Index: AQHUdYPSht2IvH9cLk22wDFsAUXnXA==
Date:   Tue, 6 Nov 2018 03:50:13 +0000
Message-ID: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR2201CA0082.namprd22.prod.outlook.com
 (2603:10b6:301:5e::35) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:zhflKAOq1ne0+JPsW9dzer1IyOSoJPa9gjH4WHHTavYjJR5gbSULcUF0MrCmA0suj2XlLD7whY10iiFXM/JNqyntFqQAHomy3m1kXtev2NHOQpmyo/UL370R+3yyVcCbefGs2/3QgIOKUOE4DbzZHuXP0lJ39TOnJWowtwkcivRd9zCoNf6upIMdBClaeh7EJLfLK+k2JdUs1mxXNrD4zugMrI2ZwJj7vhYRflvqaOBYoxtC87LcppdBNAnsAw47bM1vN+WYeFYic3L+ptNaHv463GWlmMc0Q4+MXNtcTPXVYi17kZb9zK9Z/5VYswQggMm9/HHJFt86e4+EuH0jmEFokoZsPRxlD9shCp+UL1lgNA3YEb8maxisBUKGXeVJ3f74rCNYTQ5Vj4hrgD4Bj2CQU8ZyKKlyaMYf98Pn/au4XHM+3nh0E5nFF1TlzCVan1dfOtXsacTxjFXcXyDBTA==;5:t8v6LZkeNGyY+MOOFdyu9Uo3MmBE3OGud6eDjZdXARiiVOl3lvRk9yWLZzB1Wfq1I1kc9hmYnzHdzTzd9ZLNZ0Grkcjs8Nx+3Pqu4hoXn/BanpastELYsEfNlNgqulE3sGKTXoWIR4uEM2OaP/DP5ork2jl0dT3uA4IFl3dhN/8=;7:kfQJkoojp32lGvIq1nzAaUViYCi2HGACbji+mgmyzqErxkk12aL0FFx63Jdl9wKPe0dyvy1BYAFeR3uH+3jMusq0Nf27vQI2lzeqMjcyPXgNuScRRXpKSzdr/GtkvJqIe3H/+VjWA6ttBcugQOJfAQ==
x-ms-office365-filtering-correlation-id: 1996d285-f837-4e69-3678-08d6439af478
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB1142C3D0D4C65CCC30E3F21CBBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(97736004)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(14444005)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(66066001)(2501003)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 8PAOZVcjetCAJLV0wHCHqN30dQkXyI4v6y6UjpBu5MjW/5JeuCleAAwFhQGNmo0LfWJ/So4WbpOG4cGHLJ9z7F6GyZU2TMkEnRauB36GJzou0/lSc3/fPw4WHnBR6j+j9chuefeTijUkrLhdrskPNIcG+O7Wr153XrZJ+SnHjanV3o3FKSmgnCI5FAcwZIX0mnD+KW02H8zx18/85lrguGyU5DuG49UedqQUD6Rhp+NB0uS7/jJzBmlfvPym2Mzlk0Do36FwK8bTIF7D0IWsBa8gnDZjBzY4YnpxHWTU36yc7MRpPWKYjsUn+MOKTid1gVAwTAFBodrCXh2PSFZ2c+SJiJCF19rctLYGdJAEaWQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1996d285-f837-4e69-3678-08d6439af478
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:13.4595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch series includes various chip-related changes:
* 43012 support
* 4373 saverestore support
* SDIO bus settings
* 4354 raw chipid

Chi-Hsien Lin (3):
  brcmfmac: add support for CYW43012 SDIO chipset
  brcmfmac: allow GCI core enumuration
  brcmfmac: 4373 save-restore support

Double Lo (1):
  brcmfmac: disable command decode in sdio_aos for 4354

Madhan Mohan R (2):
  brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
  brcmfmac: disable command decode in sdio_aos for 4373

Naveen Gupta (1):
  brcmfmac: update 43012 F2 watermark setting to fix DMA Error during
    UDP RX Traffic

Praveen Babu C (1):
  brcmfmac: saverestore support changes for 43012

Winnie Chang (1):
  brcmfmac: add 4354 raw pcie device id

Wright Feng (2):
  brcmfmac: set F2 watermark to 256 for 4373
  brcmfmac: disable command decode in sdio_aos for 43012/4339/4345

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  36 +++++--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 110 +++++++++++++++++=
+---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   3 +
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +
 include/linux/mmc/sdio_ids.h                       |   1 +
 7 files changed, 133 insertions(+), 21 deletions(-)

--=20
2.1.0

