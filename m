Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CEEC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93D4E21722
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="tUngLae9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93D4E21722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbeKLRV1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:21:27 -0500
Received: from mail-eopbgr760099.outbound.protection.outlook.com ([40.107.76.99]:33182
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbeKLRV1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 12:21:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOAgOE9O5OsqbBTQRoE3HCmSsjleg39+ravDkPzJJu8=;
 b=tUngLae9vgwHB5U/si5qinpd8t6fXihL/6jv/oA0ciCcx8A2FF67IEXRuKZnGYFbdG4AOn/WnEsrgMFNhnVfZeixZeDTW2c6Ml/zV4glXD0YhrPq3QOy0uOrjPysszHV6d2tGFecnFhlNnt3UysQvpQEbZ5bPt0o9UGExMVO8Ag=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1126.namprd06.prod.outlook.com (10.160.196.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.29; Mon, 12 Nov 2018 07:29:25 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 07:29:25 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Winnie Chang <Winnie.Chang@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH V2 1/8] brcmfmac: add 4354 raw pcie device id
Thread-Topic: [PATCH V2 1/8] brcmfmac: add 4354 raw pcie device id
Thread-Index: AQHUellwYNF0950nbUG3XD8v/WIxSw==
Date:   Mon, 12 Nov 2018 07:29:25 +0000
Message-ID: <1542007730-47284-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: HK0PR03CA0084.apcprd03.prod.outlook.com
 (2603:1096:203:72::24) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1126;6:tjYAYPeSDwQgT1yctZFF3XUv1rnQwI8jEM7cHL7YkENRI2qFKXTZH4xtVoBtIh4ZECGhz1MAphgISP/S0t6Vy65reP75QaY2UmEAWs3Zzb4Rd0/sf10H6Js65pZ2ovBGNCFVcbKoAP/v8fkqqSivDOzvUWeJ2SQF67wPTrKYuizuiciu3sriE3v2g+ev8toaZA+vlyZhGRE3b4Kfbj/dZ/CgkYT65Xwm6eRZ7J1ZaYa/007ZklqhFo9n7SjD7Z7fb21mMs4sdVh/m+01V0zzgE6dkjPRZhb1lVVIfBPtWPETwPaGJFfE2+tdplxuZohIbZr8A/lvO9puB6T9nVdPQrjStILYjKhdcv+lBZYXMyWohiOAYlOE3ORpDwUtxD7ULFG+iUGYkHQD+Vj8ttsRmnYK4bdDTxjCnFTiwns5CHSGmmPNQzhTzg/6BPNHinhOYTpIfLv+6g0Ymml5K34cuQ==;5:1SKl/4o1+SStQ00oVa2qsUNQXyoppTauSjFb/+xeDpI6LexcFD69AezMdLtSbn5ehckYmyMPg5mpVgJcVwD058SxyfKts5S7WmF/+BQKZRdX1++nd165KP3h64XF6XWue16gr0NlPDG4fIzMRvlzfooTYe8jQcqFdrK6CPwHwow=;7:iqqZHlv5JIzLYNAnvLdqyrJtCAxyHw+AMTCgz0X1fBulxuJzNoxbMczzT7w0kk/52e9YrRT90oKe7+WGp8hLMvrRUyDsGpYS6TuXT4hn9Y5Q/QcrsgmAhV44LUEOFytKeK6dmElNEU7Laa/ZhrirSg==
x-ms-office365-filtering-correlation-id: 0ea487c1-9803-4c9f-464a-08d64870922a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1126;
x-ms-traffictypediagnostic: BY1PR0601MB1126:
x-microsoft-antispam-prvs: <BY1PR0601MB1126D3439F4E040247B1A966BBC10@BY1PR0601MB1126.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985)(208715162771679);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231382)(944501410)(52105112)(93006095)(93001095)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1126;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1126;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39850400004)(136003)(189003)(199004)(25786009)(4326008)(2906002)(76176011)(3846002)(6116002)(99286004)(52116002)(81156014)(81166006)(478600001)(68736007)(8676002)(6486002)(14454004)(66066001)(5640700003)(6436002)(72206003)(8936002)(256004)(386003)(102836004)(6506007)(106356001)(105586002)(54906003)(6916009)(2351001)(575784001)(86362001)(305945005)(2616005)(5660300001)(36756003)(7736002)(316002)(2900100001)(186003)(71200400001)(446003)(11346002)(476003)(486006)(71190400001)(53936002)(6512007)(2501003)(97736004)(26005)(107886003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1126;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: Dqbvcx0nK3BRGlrbzq5BWz8WB1ToKw1ZbnjvoeKduRa6Uvhxz/9xmStRPA6NvQe3Hnj2r/BpTQfRfXo6s0PJk82NeqHBV45e72X0G9fBnoJFygZc6xzmQ8Eqx5IcrhBjh0KhDl/cS0LNONQiz0//ulKjomXMR+nJ236a6Cpr//cSM7NJtzW3jYs6FhFbqGZh1ZNaY7PiGor5FE35qkWVcDIPtnCJl87+gNGmSFxv3IXcnD2OBQoJ9fcVh03FDUfQat6CYvDZXgauqUAnsGsAZGsWO1hMtCReTAqS2kgPSkqLZNJaRN9vMn38C66/DujbSt/OKbzVO/wvjQ6Go9xKJ0OrUnbnSJNgzryNoR5XAsc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea487c1-9803-4c9f-464a-08d64870922a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 07:29:25.1680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1126
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Winnie Chang <winnie.chang@cypress.com>

Add the raw 4354 PCIe device ID for unprogrammed Cypress boards.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 1 +
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 5dea569d63ed..8887bbc0084f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2018,6 +2018,7 @@ static const struct dev_pm_ops brcmf_pciedrvr_pm =3D =
{
 static const struct pci_device_id brcmf_pcie_devid_table[] =3D {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4350_DEVICE_ID),
 	BRCMF_PCIE_DEVICE_SUB(0x4355, BRCM_PCIE_VENDOR_ID_BROADCOM, 0x4355),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4354_RAW_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID),
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h =
b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 686f7a85a045..acb87238922f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -74,6 +74,7 @@
 /* PCIE Device IDs */
 #define BRCM_PCIE_4350_DEVICE_ID	0x43a3
 #define BRCM_PCIE_4354_DEVICE_ID	0x43df
+#define BRCM_PCIE_4354_RAW_DEVICE_ID	0x4354
 #define BRCM_PCIE_4356_DEVICE_ID	0x43ec
 #define BRCM_PCIE_43567_DEVICE_ID	0x43d3
 #define BRCM_PCIE_43570_DEVICE_ID	0x43d9
--=20
2.1.0

