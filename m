Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AE6C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 779ED20818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="V20aBvkd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 779ED20818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbeKFNN2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:13:28 -0500
Received: from mail-eopbgr810101.outbound.protection.outlook.com ([40.107.81.101]:25243
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729015AbeKFNN2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:13:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyqkN6F8DB1OZjt9Om43c2nrMAs2BCfxiXjpPq/uFi4=;
 b=V20aBvkdy/0Ow5+XXv9HXi2t2SkrY2g1WBnDirMfZDXM1CxazgppiDTHc4nosBZoCtpYTunNkkI8ZqPbWH2FhsGS79ckRhNfgQenmwhZoXwvHrKt4239ntkGhBCEvsFLaZ8F42ClicNIwxMJSPQeAt2Cd9O+iXOFQj2/P8IfRWE=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:15 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:15 +0000
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
Subject: [PATCH 01/11] brcmfmac: add 4354 raw pcie device id
Thread-Topic: [PATCH 01/11] brcmfmac: add 4354 raw pcie device id
Thread-Index: AQHUdYPTvo0SK1/quUWwYFxyaP3qAQ==
Date:   Tue, 6 Nov 2018 03:50:15 +0000
Message-ID: <1541476188-75475-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:EUH1dqZn1/saXGDWvPJReuEAwnJUZDAXMZi9/YeoJcTZllpObmluiftTSKWg1W1tqVY6IImbmKDzbKwgZAoKscw5q6HtlGRJU+zo9Sl0vYDEu/lV46X6i52c3DdPnC3B1LBrTH9Xfn+bGywOC8UwXTk4y9p13AEZl/3sK8vdswxUiX4C4ua2pwZwxHK35nPgjrQneK88HbMWIlvdGrTYFTGcH5TXcLekhHgXjz5cJGwdZgoG2peSHcoob+OXufiUwdBTl1w5VDsQ6hXxnlbIRfzElsGOErArkF21jCGUFCvE046lcVtyLwuUnQdzV4mBn5O2MqsG6U6GPBJq8w9xw3zyh4oJd0XOu2UBQRUD2zBUGxy26O5vkAPRtzt1I4GyUvBdfB6cTM6qo4x/pAIdK+oRDe6s0e9xHTStZ7SP/0evLKd26vnM7mwFFc14h4M+hfnDpj8CICintlNdVK3NxA==;5:hqTs48EMXL3fkrku4bc7OQQA2Xc9uejP8g4SqwSu3hMzHBdH9xQ42YK+2Boq/fpEPSwF1Ql7yaX1w+1/GB/wzlRVSZrvEpLMnHHwNtecP+aAp3wnHtBrOOGQ9Z09fVgb86mpEOTkabr1WVehxT8JHSaGdWfoQIBndS28/qGml+c=;7:Kbh3OUrxJTVHK8TKFNIphfQIIkZ9vMBdaaBwR6UGvBThcHO2nGQnHTXVf7VeZ7R5XReLaNmsOsDYYAbiOQzxWzT6f4pMXubegr1mnEQg09/UY/phs38sq3jSTVC/lIu82xv3RFr/s8Bg0L8dIw25/g==
x-ms-office365-filtering-correlation-id: a973ecd4-a6ce-4784-6baf-08d6439af5d0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB114291E980FE45DFE4F9C3FEBBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(575784001)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: e0g79PPABJq+XopMPvy09s3pHr6VKVegQZxaqzRR+qPjVscMJqXoda8AQBoazV3Aeb7E5lY+yYJmlPByBzooVe8V0PWj3LxVGjIcnlwE89Ez1QwZmxXGvmF+Im3ADzUttRGpGJ6b6IZbpt4DCKb3Lbl+rKTygLOBmAY4O43b/iwZiHS80cKUwk4LhTY6XiVzccNkb2yNKdsWKTJSqhDp7XCipqVSYnJ8vL3oLoZCy2WPhl9SO4gv4jD5e2gw68pcSvcr7Ne04++PJe6wvJnrzhYfIpMpVaPvj0LLznix0HeWMcTn2Mzy3kCqldoGU/ot+UZYq1BNG0ftDGvzpx4PUTwkun5ZKT/xhR5JCHObU4A=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a973ecd4-a6ce-4784-6baf-08d6439af5d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:15.2929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Winnie Chang <winnie.chang@cypress.com>

Add the raw 4354 PCIe device ID.

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

