Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0048EC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 08:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B15C52081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 08:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="ggojDXYQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B15C52081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbeKBRbE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 13:31:04 -0400
Received: from mail-eopbgr700138.outbound.protection.outlook.com ([40.107.70.138]:27443
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726713AbeKBRbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 13:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Matm4AYvkxOgPCSjlVbBFLRFWR0p+YT66eoj+NBtkhY=;
 b=ggojDXYQLDbOSvu82LcesAHbB0RkQ2/e8N4deDvQTqHQssyjqjZC6L0nhvuPa89ABcvn3czuJiycY7SPHgjLbOFCzcnsxGSygwcBB4mf3M4pxAU+8AUxireoPihUX8I//q++dJOwq8jYAcFuRD/MkTGaWy/i6GWC67rxXfBj1UA=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB5062.namprd06.prod.outlook.com (20.177.186.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Fri, 2 Nov 2018 08:24:40 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.024; Fri, 2 Nov 2018
 08:24:40 +0000
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
Subject: [PATCH v2 2/2] brcmfmac: make firmware frameburst mode a module
 parameter
Thread-Topic: [PATCH v2 2/2] brcmfmac: make firmware frameburst mode a module
 parameter
Thread-Index: AQHUcoV/WIxtZ0hPo0CVXdK0lG3H5g==
Date:   Fri, 2 Nov 2018 08:24:40 +0000
Message-ID: <20181102082403.11676-3-wright.feng@cypress.com>
References: <20181102082403.11676-1-wright.feng@cypress.com>
In-Reply-To: <20181102082403.11676-1-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TYAPR01CA0075.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::15) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB5062;6:wcWkgMC3QhkkBk7F23jbYeVFYqOTg40HF/gQzIofYU+QcgXC4Q4pNKhQ+vQIw+mGVSiWFoVS2o5wW9PrYtSmka+xsSd+N+DIMgm7Db4Os8BA9yvFewfnXDZXLHLroUV0OdDBr9v5yV8+ZT5zC8OJpU6/e75XLN63yEF+fdbgNgJzdrZ4YvT1NjO3nkMnFQP7cB3D2LurC44lWgCWpivpiXAiE+HFHyQkwTos4DryManKjbn1TXnAn9OfScxF7n5RSBXOQK7zThsLPFkBBMW2ZdT7/zhWrI+GCC+eOny+nUF8P3nuAEzzkXtfFML7fIb+QpJUGg4ve63A7er4AdKHjpuneB+vnkEl5Ht4iqg1XkcbK1/Oyt2/JBmP/pLVwwnaIP43FirE+aUfL0dcKEaLUivB17thgUJAaXvGbZbSOok0utQn19uSzxikVnZFM4Br4F3fy4f5BeoHBuaOzcx5Yg==;5:Mcx7zxHu1HTVjuKvjbvKpd22Idezter+Ip2ThfstT7N3Rp83AunQRjs9DetAp/g5SOY0jdmd6E9K1hCwDoFwg0nXx5WREvAv9O2ro1ssuioWMQpzYIwOOdxbYzwGJWZsrAScgUm+9Ibs+Z8OQ3MEQNUC5FYUlZ6leWKdosfs3oc=;7:SZvT9BzrDzXg3w/uvFMFPl4FhX2WLrf/QVqk53a2Xk+20qq9eaxx2QCA+B9q1RdzthapdtaMB7A0g+Ne5mxA2MH/w/pFH38/CEQZRrr6/48MAR959vDXGQR3JKreT4ql8pUsPMMpB0hLoKmirUFeSA==
x-ms-office365-filtering-correlation-id: f3b9e2d1-7bb2-4c9c-a795-08d6409ca23c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB5062;
x-ms-traffictypediagnostic: BYAPR06MB5062:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-microsoft-antispam-prvs: <BYAPR06MB5062B22A0F2AFAE4D0DB2C8BFBCF0@BYAPR06MB5062.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(3231382)(944501410)(52105095)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB5062;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB5062;
x-forefront-prvs: 08444C7C87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(366004)(376002)(346002)(189003)(199004)(7736002)(6436002)(256004)(71200400001)(8936002)(14444005)(71190400001)(97736004)(66066001)(316002)(3846002)(81156014)(5660300001)(76176011)(81166006)(6116002)(25786009)(8676002)(476003)(102836004)(446003)(478600001)(99286004)(2501003)(11346002)(26005)(106356001)(2351001)(105586002)(44832011)(6506007)(386003)(4326008)(52116002)(2900100001)(54906003)(305945005)(2616005)(486006)(2906002)(6486002)(86362001)(72206003)(5640700003)(186003)(14454004)(36756003)(1076002)(53936002)(68736007)(6916009)(6512007)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB5062;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: SFz6wD/vVfaRMUau2uSPRY7RyaVxIxmdyX3WDXaTiAR8MhwK4xx0ipltIX/TztDmzrjhZHB+7VdA9Xgcxo7UKxpzhvUVxvelQg+rIqEIGsJ1Oa4ZalWEQ6tawiP0YgAMe12IikMxYOvoeBJI4AWPjbarMrr6mR46Dnp+AYwNCURjoW2b1UvLVQ1evw1WZ2BgHt7HjydFKdvgvLC3amMXxZ7GPdbQZP2WuwyYnHE2Vzg1IPIZGTFMCIVM6j9AvwhxZ9+2+yb1/mHu/NNClOB0ETsD2X1r6ng1PKgN2WOTlFzlBW0i1jwFAHiPCGUBAOt3hM5U7pVU1t+bT5vC2+QQQr0EKL3eGKx95o7hw5iEnDs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b9e2d1-7bb2-4c9c-a795-08d6409ca23c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2018 08:24:40.3276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB5062
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
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 7 +++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c  | 5 +++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h  | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h    | 1 +
 4 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 230a378c26fc..4a05d3f50cff 100644
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
index 94044a7a6021..0ad4c3196e5d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -78,6 +78,10 @@ static int brcmf_iapp_enable;
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
index a34642cb4d2f..b91975258a68 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -47,6 +47,7 @@ extern struct brcmf_mp_global_t brcmf_mp_global;
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
index 63b1287e2e6d..b6b183b18413 100644
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
2.19.1

