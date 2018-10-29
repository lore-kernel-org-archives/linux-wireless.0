Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2A4C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C37C20827
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="mqExlnUm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C37C20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbeJ2TPg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 15:15:36 -0400
Received: from mail-bn3nam01on0121.outbound.protection.outlook.com ([104.47.33.121]:15424
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729602AbeJ2TPg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 15:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0aVUu4aYhp4PpaLN/HmUyNAP9gkS7Wzn0G+3+ZktQtY=;
 b=mqExlnUmuDqoxSrvcvhE/NL0dsQgd9oimLA9p3JhzCJE1Jld4/gsHdA/1cCIjyiJIRHKdwq79dwofU8wcchz7z/J6rXO25Wc0u0YwtPXQSTLcbTHZhKYWUkFo7TlxMrIEShT0l8t1qPRKOkrUrVSlQh5LBa4Y6l4NVcbviAxMX8=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4518.namprd06.prod.outlook.com (52.135.233.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.25; Mon, 29 Oct 2018 10:27:28 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::e059:d46e:4de6:4bae]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::e059:d46e:4de6:4bae%2]) with mapi id 15.20.1273.027; Mon, 29 Oct 2018
 10:27:28 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Wright Feng <Wright.Feng@cypress.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: [PATCH 3/3] brcmfmac: make firmware frameburst mode a module
 parameter
Thread-Topic: [PATCH 3/3] brcmfmac: make firmware frameburst mode a module
 parameter
Thread-Index: AQHUb3H+Fs3IQIbeVESAT2P4l9cing==
Date:   Mon, 29 Oct 2018 10:27:28 +0000
Message-ID: <1540808552-28738-4-git-send-email-wright.feng@cypress.com>
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
In-Reply-To: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TYAPR01CA0116.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::32) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4518;6:w3wuN3lkgFHe/uA9X0jCa6eZQH0Cg7K8ML3B7J6QmTLJthLsO74KyI+iaQgZdKPlziT+qn53mJofixeBTqZK/ZZlz4JkZZFO8wWF7HsfrdGSKp/ac2ZqEE0O+3oB43Ptau58Z8CX22Idu/UYwtdZfbmGQSxTvPh49A3PWv4CFx/HnT+HwyeiP1RpGa6DnjOb4+K2BrqYp4wWSUUhhPZItMU9PlNyGRYwMxZb4CRpib+YmSy/EqTD7cyjwac9yl08nK80dse54AB0tdzXK1CioQbgNjBptbPXb0/BWu3KLxglYSKLw4Z+qTp8MyISJGMPhKl0+DPBtaR8qgG/sPj4T7es4lTFs75xbyWDBuvgOlMECoNIbrjyTJCb2tatZoS1dcY3KNOcwBbRSym6HpzSL2XP5QUq8fiazo5GaIHeP9FHM7kjzMy7nfhdFZT1lY/ftR1DzKJY+r5jRaMkfo7YLQ==;5:WZk7L2LZ3hyFBmFvc+JaPLr1SXaqCLghDBzY1VNp6HxoRW66Ofjep0afownGb5onQ9IVLuy5Yez5fjxY3uPXUbauXXQmYeWgYU5sxUKX5fSLFLiZsaWf6h7wTk6AdnqDWynLnt616MpQ2oJkFjFxJ0MMGaWeAS9xyc+lwhKwSRk=;7:F8DCHZsI5jLG82eHoApNgDacdqWm5z5ccaKmhmwmU+wTCWSDo/UeA9RgozgtytdRH58abpVcXr0TYMBggNuOCfcJxkJOM/n+INKZj2zJV3LDzupObLJD85PywQuOTdN0M0gwBNLuynSjP+yahbb2JA==
x-ms-office365-filtering-correlation-id: af094f70-ff2a-4421-0afd-08d63d892079
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4518;
x-ms-traffictypediagnostic: BYAPR06MB4518:
x-microsoft-antispam-prvs: <BYAPR06MB45180E5A434FC03A7B8DCB6EFBF30@BYAPR06MB4518.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4518;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4518;
x-forefront-prvs: 084080FC15
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(376002)(346002)(136003)(366004)(199004)(189003)(478600001)(4326008)(86362001)(305945005)(52116002)(6916009)(71190400001)(6116002)(71200400001)(105586002)(72206003)(3846002)(14454004)(54906003)(102836004)(6506007)(386003)(106356001)(25786009)(7736002)(5660300001)(26005)(36756003)(2351001)(76176011)(476003)(53936002)(2906002)(316002)(11346002)(486006)(2616005)(2501003)(5250100002)(186003)(5640700003)(6436002)(99286004)(8676002)(66066001)(97736004)(81156014)(446003)(68736007)(81166006)(14444005)(8936002)(6486002)(256004)(2900100001)(6512007)(44832011)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4518;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 9na9xIi/GMnABaEtb0hueSajwIS/Xrpo7CXevhgiymFeaxzlLOIhDOtVHEsa4VhPdGv0qXMpsRlugUxXa9MhePhEsaLAVtMLEDlPugEAQtHkU8S48wVl+CU5QjPAHQfMkK539SmoR0/vL4jNsy2dSg/2zymmZN3ay6R9rYlQjnruYHV4tWGzlpFi58A2EuCDJ1e4sSAh2n/2EBJ6Jkm3VuRm3IoDWJLuV4vvlmXroalj40E8QY8KD0X2GCWcENrcOm5lXIkj05sNTDLxt6xzADjB6WhWgkcYnQFLslJk3d+MvfSH2dwdHVgJne4wnaZFHKMLiWrCaAJEnDoFCISWryHNeu61SRhlKUbilu6Ff4E=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af094f70-ff2a-4421-0afd-08d63d892079
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2018 10:27:28.6933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4518
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch is for adding a new module parameter "frameburst".
With setting "frameburst=3D1" in module parameters, firmware frameburst mod=
e
will be enabled. The feature can enable per-packet framebursting in
firmware side and get higher TX throughput in High Throughput(HT) mode.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 +++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c   | 5 +++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h   | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h     | 1 +
 4 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 230a378..4a05d3f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6638,6 +6638,13 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211=
_info *cfg)
=20
 	brcmf_configure_arp_nd_offload(ifp, true);
=20
+	if (ifp->drvr->settings->frameburst) {
+		err =3D brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_FAKEFRAG, 1);
+			if (err)
+				brcmf_info("setting frameburst mode failed\n");
+		brcmf_dbg(INFO, "frameburst mode enabled\n");
+	}
+
 	cfg->dongle_up =3D true;
 default_conf_out:
=20
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/dr=
ivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 94044a7..0ad4c31 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -78,6 +78,10 @@
 module_param_named(iapp, brcmf_iapp_enable, int, 0);
 MODULE_PARM_DESC(iapp, "Enable partial support for the obsoleted Inter-Acc=
ess Point Protocol");
=20
+static int brcmf_frameburst;
+module_param_named(frameburst, brcmf_frameburst, int, 0);
+MODULE_PARM_DESC(frameburst, "Enable firmware frameburst feature");
+
 #ifdef DEBUG
 /* always succeed brcmf_bus_started() */
 static int brcmf_ignore_probe_fail;
@@ -419,6 +423,7 @@ struct brcmf_mp_device *brcmf_get_module_param(struct d=
evice *dev,
 	settings->fcmode =3D brcmf_fcmode;
 	settings->roamoff =3D !!brcmf_roamoff;
 	settings->iapp =3D !!brcmf_iapp_enable;
+	settings->frameburst =3D !!brcmf_frameburst;
 #ifdef DEBUG
 	settings->ignore_probe_fail =3D !!brcmf_ignore_probe_fail;
 #endif
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/dr=
ivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index a34642c..b919752 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -47,6 +47,7 @@ struct brcmf_mp_global_t {
  * @feature_disable: Feature_disable bitmask.
  * @fcmode: FWS flow control.
  * @roamoff: Firmware roaming off?
+ * @frameburst: Firmware frame burst mode.
  * @ignore_probe_fail: Ignore probe failure.
  * @country_codes: If available, pointer to struct for translating country=
 codes
  * @bus: Bus specific platform data. Only SDIO at the mmoment.
@@ -57,6 +58,7 @@ struct brcmf_mp_device {
 	int		fcmode;
 	bool		roamoff;
 	bool		iapp;
+	bool		frameburst;
 	bool		ignore_probe_fail;
 	struct brcmfmac_pd_cc *country_codes;
 	union {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
index 63b1287..b6b183b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
@@ -80,6 +80,7 @@
 #define BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON	201
 #define BRCMF_C_SET_ASSOC_PREFER		205
 #define BRCMF_C_GET_VALID_CHANNELS		217
+#define BRCMF_C_SET_FAKEFRAG			219
 #define BRCMF_C_GET_KEY_PRIMARY			235
 #define BRCMF_C_SET_KEY_PRIMARY			236
 #define BRCMF_C_SET_SCAN_PASSIVE_TIME		258
--=20
1.9.1

