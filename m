Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FCCC28CF8
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C72F20672
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="y9RRYqbo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C72F20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbeKURaq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 12:30:46 -0500
Received: from mail-eopbgr680102.outbound.protection.outlook.com ([40.107.68.102]:59472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728028AbeKURap (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 12:30:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xYa+rLADLiuDpBLow1a1pM9JOcXqYj3lsA0JNSZ0Yg=;
 b=y9RRYqbolWWkE1Yvctau3BjfC6gHmoL1rKxK8reRem5BiE+SlxM9H15qhuAVrf+CDPc+ruVIMQNMtgESQZyWe/2sl1D7GxEdtZ5Kkb95EwYznhlGxK7vMErIENdfjv7tjPHo+BmDxkH/6wZwLF8K3QbvNs2ie4PVHPPjpp9Wtyw=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1349.namprd06.prod.outlook.com (10.161.206.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.15; Wed, 21 Nov 2018 06:57:19 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 06:57:19 +0000
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
Subject: [PATCH 7/8] brcmfmac: 4373 save-restore support
Thread-Topic: [PATCH 7/8] brcmfmac: 4373 save-restore support
Thread-Index: AQHUgWdxWI/iMdOMSU+hf0zmB52JcQ==
Date:   Wed, 21 Nov 2018 06:57:19 +0000
Message-ID: <1542783402-112482-8-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1349;6:q9hKPDBYk5a/CJJ3mhG96iDkMRUuS077jUSgC/cxVO5mPte4jCVM7XMJpAkhAWmPWPjY87T8C3B9Dmk9tY74EzIiBRK5/XtnCeYjjyZv1zLkP4QK+Yctk7pjcaGQ9XpgCnEm5S66sOQ+SUzyWZkw7HXt8NhstAnZNzMc2YbfRfRgzx9+EMcg4JZ2mvebbYunQPkvfXA/JRYZSTRlEYcWnMRg6XCJdKt+wth9xPGcJSmMvcyy6HYJFevVIwlO8XvDqi1MTz5LCPLdYZ/qPBBzowJIYKNJfEJfOP9VA0XWTHjpKEWsHSvgJRzpUOGOSS/DVAGmc4qsOptEAwfQGVzADbuhcFWOnf3xBf4MALJguRkZBoAPfXZtZYNSpSRddzyn9Zd5au7Yct9edrPrvPiJssMHVx2xq0TDKHqY4R/f9o3fHw4s2hRa6wZfOzUy+7H5t9zGdL/rwrJhbWcOBjoy5w==;5:yMc3TKMs9zfnMndf85c38hQDhJxLCv11WcjGMtdi6t1qf2QV9sAEznNvWzQTLOY1Fb7NbuSV+CSLhtcTkFCR7h7zeCI1KKj3HUllGp0PYELeO7ZUeJAYDYhHCOS4su54V5wFChR/SfJeRc+5ZMtrka7oDEAx9HHOxdGFlH11QBk=;7:s1jqiwl4CDF0pPoP6STT5e8U9632gFPvQpwZkrQu/0dpfsnX3JGjP9pQhPjKdOOxGHWqIgEHLbhhmuS8o17QRsomUqxClPDFqGLbR8tCgRGHTVb5Sh9+FnEL+PFTFDEH1jX6HisUzbnPVleUUgJpLw==
x-ms-office365-filtering-correlation-id: 9145d7dc-4987-4da7-b765-08d64f7e93d9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1349;
x-ms-traffictypediagnostic: BY1PR0601MB1349:
x-microsoft-antispam-prvs: <BY1PR0601MB13494836B5C1E333FCD68060BBDA0@BY1PR0601MB1349.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1349;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1349;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(5640700003)(446003)(478600001)(316002)(54906003)(97736004)(6486002)(2351001)(6436002)(6512007)(486006)(5660300001)(86362001)(575784001)(6116002)(256004)(476003)(105586002)(3846002)(72206003)(2906002)(11346002)(106356001)(2616005)(25786009)(305945005)(7736002)(66066001)(2900100001)(76176011)(6916009)(68736007)(107886003)(26005)(36756003)(6506007)(8676002)(186003)(8936002)(2501003)(386003)(4326008)(14454004)(102836004)(81166006)(81156014)(71190400001)(71200400001)(99286004)(53936002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1349;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ypiN+LV+9GOs36Bz3ghsbnrNctyvh8TEZtunppV9klEHN8xfAtdUPrzhxuuvYTvwugX2DrZdW5LxlWtojpov8uaBvI1qlArGA4TTufsdS4+15r83tBAxgI4A0+eqlIjvWpjjQ72fZZWqFZZCEJ8Bo8UYbWE1JlwnLOvyjS4vCaNOO/Tnmcj1rD0oBU4i8UG1K4nhCYavVQaBNwGIzMs4Zkv5cIdhXzyXy3TfEVR8E07SC0xmY/qd4th+h/Rc7HQxgTXMLUFnw0orS0K8HRXuR2F25fnLX6fKQ3pg4snWnFvAf3u1GD/sF7gTA0fF+nUZ7wojT+D7+g0tJVN+rm1xBHMXIQKtIuIXNTheHXv8vMM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9145d7dc-4987-4da7-b765-08d64f7e93d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 06:57:19.0277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1349
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use chipcommon sr_control0 register to check 4373 sr support.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  5 +++++
 .../broadcom/brcm80211/include/chipcommon.h        | 25 ++++++++++++++++++=
++++
 2 files changed, 30 insertions(+)

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
index e1fd499930a0..5b9195d4f073 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/chipcommon.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/chipcommon.h
@@ -269,6 +269,28 @@ struct chipcregs {
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
+#define CC_SR_CTL1_SR_INIT_MASK		0x3FF
+#define CC_SR_CTL1_SR_INIT_SHIFT	0
+
 /* pmucapabilities */
 #define PCAP_REV_MASK	0x000000ff
 #define PCAP_RC_MASK	0x00001f00
@@ -293,6 +315,9 @@ struct chipcregs {
 #define PMU_RCTL_MACPHY_DISABLE_MASK        (1 << 26)
 #define PMU_RCTL_LOGIC_DISABLE_MASK         (1 << 27)
=20
+#define ECI_INLO_PKTDUR_MASK    0x000000f0 /* [7:4] - 4 bits */
+#define ECI_INLO_PKTDUR_SHIFT   4
+
=20
 /*
 * Maximum delay for the PMU state transition in us.
--=20
2.1.0

