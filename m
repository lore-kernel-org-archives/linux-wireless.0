Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E20C04EBA
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF56A20672
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="GhFPgwow"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF56A20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbeKURae (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 12:30:34 -0500
Received: from mail-eopbgr680102.outbound.protection.outlook.com ([40.107.68.102]:59472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727949AbeKURae (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 12:30:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOT1SZp1bYYEHLxo+tH5HO0Yy0OR2YwVVbYONHjrNEg=;
 b=GhFPgwoweSmom8AQKxTW+0pkWiTA7VvsE+kq2pqqq4WvhClD85BHpxau02dbW8ru74g71be7hbWvJzl2Ct7IaYg3YR0gFKR1nh4DJ6TslRpzEMwXTniLlLG8HqzDcb9bIL2XpQw94IGgNqxVKWYjDIL8L9w92T1T2nsY+l2QEyc=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1349.namprd06.prod.outlook.com (10.161.206.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.15; Wed, 21 Nov 2018 06:57:11 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 06:57:11 +0000
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
Subject: [PATCH 1/8] brcmfmac: add 4354 raw pcie device id
Thread-Topic: [PATCH 1/8] brcmfmac: add 4354 raw pcie device id
Thread-Index: AQHUgWdtBv/gHKSyW0WdHsc8l/QKzg==
Date:   Wed, 21 Nov 2018 06:57:11 +0000
Message-ID: <1542783402-112482-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR02CA0069.namprd02.prod.outlook.com
 (2603:10b6:a03:54::46) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1349;6:EoucfVGCelQyhKpZaIbH1fITzWJCrso3t0+m4lEM3ku8Z0831tM+VzBObuoET8jGyPdw8ZANUMkuYcoYx0kHyRPXbkcG6OAMbqCKqJXbMBumxzvib3q31qwd2OmMQMfJ+5Y+HhfjZHChGvNpRh5vrTDiqeNVzNtkqfBIdDHM1Y6WhvlkAkevKUaEEhsCf9+8Sxz3R3Wy8RfQpvzyWbo+p1TLM0R/OiS5EqlbLyKM6vLpxoGUpyTHWzlso+HK+TbYvGpHAY+oBZniSE+BgFA7fSKNpNCZFiYvEDjcr4ni3PhRftOn15Db7vQ7zunxydc9egLRQo07LVEdTtJjvIpxnEI7yqVp2M8bZ/llYNWhOY829bGT6yx7K/TlGgk/giY0JmfBh7t8mgbQ+PAyEZruyz8/t34tpXnb7ZdlkPf6+PavgLLRX8nQ0Qw6I0VDg1xuArACOTA9RJxJj6ThxtiFZQ==;5:Cdm8N+QUXLYxEHJWmRZfmm0u+NlIYSGgJE6oUUlWTiSAMlTKWwMKvbibok70ak2JUVlv1VCS428Gei6Aeccrkhdp2+tBpS3SgUDVaHYPbmfl+0CFW2/R1uAh4G21TptrpPMxcPqEIVarHKYNdqJLjtY+DCVU4b67kJ/o4EXL+RM=;7:NLmZtx2P2/ldSqvGYnhYKZGzOJBuo879Y+cVOeY4hErhVpJ5GmAmodPzz2FOYMcDKSIvDki6zyDDg3Y8HHM/bNdRyZ1q9+u5X0F9DCarB/tzMror5f9wxDsPhPz0/70gDoohPMFS1m4HZKU5GSiStg==
x-ms-office365-filtering-correlation-id: a3885a8d-8fb8-4515-f6ab-08d64f7e8f33
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1349;
x-ms-traffictypediagnostic: BY1PR0601MB1349:
x-microsoft-antispam-prvs: <BY1PR0601MB13499111BFC5C2ABB4854F2ABBDA0@BY1PR0601MB1349.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1349;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1349;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(376002)(346002)(136003)(199004)(189003)(26005)(36756003)(107886003)(6506007)(8676002)(386003)(2501003)(4326008)(186003)(8936002)(76176011)(2900100001)(68736007)(6916009)(71190400001)(71200400001)(99286004)(53936002)(52116002)(81156014)(81166006)(14454004)(102836004)(6512007)(6436002)(5660300001)(486006)(5640700003)(446003)(316002)(478600001)(6486002)(2351001)(54906003)(97736004)(86362001)(2616005)(106356001)(66066001)(25786009)(7736002)(305945005)(575784001)(105586002)(2906002)(11346002)(3846002)(72206003)(256004)(476003)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1349;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: DGk1UzY5aec/vyIAogixhUjvjRKeXTvgQifB6F0BccDKhbpez7jv0YujW0wt7jExOnLKSB3Y4I+fkJLaiiNv94cotRcMSjecExBWfBdBQ4rf13j42EE5BrKG59ccEdFQHBMN+cIr8rlqah+pxDgA3EwwPJLDGQbpOh191MucwLWYTlg0wu+VVUnqZ8q1l+8n2TRwEzIQahC7d4e4Xy5V5Uk5uB9/KufaBRUsLbbxn5ZKVrFr0PQnSkAB/T54T2IkXb3CnIvBVVW47g1v+cezrgbiZLcWkl3lcVjZJo61yFLYPGAyKXzVgWzQ3hd4khjc/ljAuwmMXBCrSlWIiDn6m0Cb3+RjdhhOdl9cqKlRnlA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3885a8d-8fb8-4515-f6ab-08d64f7e8f33
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 06:57:11.2306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1349
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
index 956a8b236836..16d7dda965d8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2019,6 +2019,7 @@ static const struct dev_pm_ops brcmf_pciedrvr_pm =3D =
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

