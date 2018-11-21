Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1BEC04EBA
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 526082145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Gj1qjB2N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 526082145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbeKUS13 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:27:29 -0500
Received: from mail-eopbgr730138.outbound.protection.outlook.com ([40.107.73.138]:59712
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728322AbeKUS13 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FkKHbpAK2cksWMWQ7eme0yEGOzDdYoc5GCIVVD/vCk=;
 b=Gj1qjB2N0bMdC0v4AU2zlVpULAF2kLbi8SQPHNn6UoWH243YAbiZ+2Cvky3QYcSqE8rBCuiwehpTRuIO2A7tWhmpyF9VWiNZvpkno2RCiQU7m4vCju31qsZlLK4tcWICNxXidzK5xI46A3iZqOsbRph4FvS3hH9kxWfxx2w3fxk=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1174.namprd06.prod.outlook.com (10.160.195.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Wed, 21 Nov 2018 07:53:51 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 07:53:50 +0000
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
Subject: [PATCH V4 7/8] brcmfmac: 4373 save-restore support
Thread-Topic: [PATCH V4 7/8] brcmfmac: 4373 save-restore support
Thread-Index: AQHUgW9XUP/iZ2f0WE+y9MzjRqaUHg==
Date:   Wed, 21 Nov 2018 07:53:50 +0000
Message-ID: <1542786800-146083-8-git-send-email-chi-hsien.lin@cypress.com>
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1174;6:VrRrH1aQWP9qcJsWTVzZ+sjJis7hETYDO6DZQMnlvv58hFNjRoAlkNaRMHj/eH/mwXcXd9+HxIocRpCxu4ZmEmVLtYHUzYzuyZbxFujwmj7I0/x9UYTgA0pc65DC6WGm9/iqAxusFqtosQN+Dk5Mtuj4yUKtMVzq5Sh9eztXMJez3PdVzhC4OjSikmmVKygSnGJT763oykbTS8pUn4eQPM99zfOXmOr1aAAlvbZs/B7io1rbscA1R/reS7SrvM3EYixiF31Jecab/Z3VdkWbfFPuFAMQLAAEAnU8km7QEEnFpgiHri0UqiX0MhjCXlHnH7S846qLZKfk3CfY7+2aiaMZngZZ+tvjYqDYiPydWw7NF8TyoP0BRTO3JetJHT9koaR4vX2HvwijvVvf8syoq04z6UKWJudkBFtCqnxF9Ovb4+m+09fz9s+zKVZiuu6x7Juxea0X7QziLGTjJ5utrA==;5:jRMvnFk49nO1jw7RQve9dOKeiecnBBw3AvDo/NukNB9f/0mXsCi6CSd0n1rGYjB48cRcuF3/y8KGnBnqMI43AoMMB2Z6mLyfzld9FpBvwJcB4tvtSKHwyOLidIHl7ROD45SFWyYEm4b/N8+0mVgshzsabGW71a0VLFS0kxn59KY=;7:xyoR5l1ucIhF3Ea6QDF9ex2RL5VvNCqewpZKkSYcE6QvRqRU3ABtlNa1SAmD8VcChuCYaHXcY0QUI5bzwv3pBF88MDcSu8MQcol+ttzqLNEEX6S7VQ/9w9CyIfFEbVkF53z7Mz/QAnhaXmfew+jcFA==
x-ms-office365-filtering-correlation-id: 01f9c471-2dbb-49d1-4d33-08d64f86798c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1174;
x-ms-traffictypediagnostic: BY1PR0601MB1174:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-microsoft-antispam-prvs: <BY1PR0601MB11747C2645E98254257D44EABBDA0@BY1PR0601MB1174.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1174;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1174;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(107886003)(478600001)(36756003)(72206003)(97736004)(8676002)(81166006)(81156014)(186003)(68736007)(6916009)(8936002)(71190400001)(54906003)(2906002)(316002)(25786009)(2501003)(71200400001)(6116002)(3846002)(99286004)(6436002)(2351001)(256004)(305945005)(6486002)(76176011)(7736002)(105586002)(6506007)(4326008)(386003)(52116002)(5640700003)(102836004)(66066001)(2616005)(106356001)(476003)(14454004)(486006)(26005)(11346002)(86362001)(53936002)(2900100001)(446003)(6512007)(5660300001)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1174;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 9YXYV57soXvdVkQw/ktq/JZYs99aHvKHAbwYk3VP0i7Weny2tvXp7DmOUzgOufLGH3mdmqmFqAE47OBk15edlh1zuLunFU2/hEEJTG5wLoRJ/tYHzlLOcJX3/L+UUtNKw4T1jsxVTW3U7674lzd2hsZGfnSo19SueyWuoj5hK3wtC0pllifPQkZVV0HGbEALPbyZUuHF/Hlbn30CW0oXmdfEPff/jzlwdMLPT28Ep0BNHeUWImo0GMtOe6AXG8mhaW5GH8tapiT+gdGg+QT3XzMF+fSNNBwbI7Xu9ApLLQiLLuraZ9UOwofO+x1ZCSoOrndscYDUvoxaMJu7XAqkA2COqpmBz77gquRwe+qaSHE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f9c471-2dbb-49d1-4d33-08d64f86798c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 07:53:50.9360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1174
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use chipcommon sr_control0 register to check 4373 sr support.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/chip.c   |  5 +++++
 .../wireless/broadcom/brcm80211/include/chipcommon.h  | 19 +++++++++++++++=
++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index a8d3b96b727f..22534bf2a90c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1365,6 +1365,11 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		addr =3D CORE_CC_REG(base, sr_control1);
 		reg =3D chip->ops->read32(chip->ctx, addr);
 		return reg !=3D 0;
+	case CY_CC_4373_CHIP_ID:
+		/* explicitly check SR engine enable bit */
+		addr =3D CORE_CC_REG(base, sr_control0);
+		reg =3D chip->ops->read32(chip->ctx, addr);
+		return (reg & CC_SR_CTL0_ENABLE_MASK) !=3D 0;
 	case CY_CC_43012_CHIP_ID:
 		addr =3D CORE_CC_REG(pmu->base, retention_ctl);
 		reg =3D chip->ops->read32(chip->ctx, addr);
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/chipcommon.h b=
/drivers/net/wireless/broadcom/brcm80211/include/chipcommon.h
index e1fd499930a0..de8225e6248b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/chipcommon.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/chipcommon.h
@@ -269,6 +269,25 @@ struct chipcregs {
 /* GSIO (spi/i2c) present, rev >=3D 37 */
 #define	CC_CAP2_GSIO		0x00000002
=20
+/* sr_control0, rev >=3D 48 */
+#define CC_SR_CTL0_ENABLE_MASK			BIT(0)
+#define CC_SR_CTL0_ENABLE_SHIFT		0
+#define CC_SR_CTL0_EN_SR_ENG_CLK_SHIFT	1 /* sr_clk to sr_memory enable */
+#define CC_SR_CTL0_RSRC_TRIGGER_SHIFT	2 /* Rising edge resource trigger 0 =
to
+					   * sr_engine
+					   */
+#define CC_SR_CTL0_MIN_DIV_SHIFT	6 /* Min division value for fast clk
+					   * in sr_engine
+					   */
+#define CC_SR_CTL0_EN_SBC_STBY_SHIFT		16
+#define CC_SR_CTL0_EN_SR_ALP_CLK_MASK_SHIFT	18
+#define CC_SR_CTL0_EN_SR_HT_CLK_SHIFT		19
+#define CC_SR_CTL0_ALLOW_PIC_SHIFT	20 /* Allow pic to separate power
+					    * domains
+					    */
+#define CC_SR_CTL0_MAX_SR_LQ_CLK_CNT_SHIFT	25
+#define CC_SR_CTL0_EN_MEM_DISABLE_FOR_SLEEP	30
+
 /* pmucapabilities */
 #define PCAP_REV_MASK	0x000000ff
 #define PCAP_RC_MASK	0x00001f00
--=20
2.1.0

