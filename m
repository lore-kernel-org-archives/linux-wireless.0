Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFECFECDE44
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 05:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D3B820819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 05:52:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="HqYROc72"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D3B820819
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbeKEPJ6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 10:09:58 -0500
Received: from mail-sn1nam02on0127.outbound.protection.outlook.com ([104.47.36.127]:60736
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbeKEPJ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 10:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyuzGjDL1uuprkTfKxgRYQMc8OGyf2EkNqZ/SVEiTTA=;
 b=HqYROc72HrXnF/QanstxgEgf1Q0gnGjizA31Suyn7z6sNsMR8GSIAV3CuiAJbYkbWN3A9pW1U9FOil/95R9RE67RTcDtgWua8S+iY2RzMtebK6IgvtV49l68D5q2j3aca6ejqN7DSSCWqVR91W2NqQ7FeiiQY8nhod9WSMfzLIY=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4231.namprd06.prod.outlook.com (52.135.238.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Mon, 5 Nov 2018 05:51:59 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.032; Mon, 5 Nov 2018
 05:51:59 +0000
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
Subject: [PATCH v3 2/3] brcmfmac: enable frameburst mode in default firmware
 setting
Thread-Topic: [PATCH v3 2/3] brcmfmac: enable frameburst mode in default
 firmware setting
Thread-Index: AQHUdMuqErtUcTUsu0eaZklfOw1bKw==
Date:   Mon, 5 Nov 2018 05:51:59 +0000
Message-ID: <20181105055137.13333-3-wright.feng@cypress.com>
References: <20181105055137.13333-1-wright.feng@cypress.com>
In-Reply-To: <20181105055137.13333-1-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: OSAPR01CA0165.jpnprd01.prod.outlook.com
 (2603:1096:604:d::33) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4231;6:67OyRpJq61gh1FrFzcQ0i1/AwaRmQf0y0k60J7ATpNV2IHvTHfaPdkt6z6KDaB4MIv/ma9UupXnhWVdSR6ko+nEEdp7gAMIAMTlPIDto5IhE4AQ7Ij/amtSmBVsIPsqxDL/AbDwz9kWIoyxbE64mT8xftzovM46mUtdj3quNwzDzfVa8wRGOR18Dh5z7MlTyR5arv/9dYCokn0W4zr6rKKv4S57P/E4x4BQFqlvEcZLHR6shk32ay4n+ZcRGszqVmfPOgWcswKEEqV9KYnsucZD+f/OtSQ/RrqQOCkAS6fltQa0FQMRk87vC/cpn/bHIuk2uhNChM2GE+tUL3kkqR0IgdKIxaNBLGGn4ApmLrGIGILgdwZRLcnt2gDZXx2nVoTGgSJXUIwBJ93ZHare3Y/RLl8ZFsQ7ValOf5OhnctJRviUiPEWF2kK0zhU7jHl2clNMs3zNBhahe75zLBmqnQ==;5:nIx/39fW8OznBX0lHFLCtg0+Vz3GqRwrXPtY7JfPuTnpKgJfYb94z11PzVzQwZuQF1Tk3thbZ9qEKH4P5f7/Z15+z21j+I+LMMVc+mVwIsvKyoWFRBDYo5+H5Odl/9n6jMZ7Yb9cx1J0eg8KOC+jxoaiKDz0zo60ZBWe/8cFS70=;7:hMM4TC++B6dcy9B/AzMsg22gzKugDWLEAIFQcLBEWSqRZlnUfPBayNgpme/w7c5oEkDEh0771VSddFnxF4SKLrzcBdU1hojDT7AxEnd1TEpPcd1AxJqrG7rutftjKkX/dfW3EVkAqhewtlb62SFS/w==
x-ms-office365-filtering-correlation-id: bb69dbb1-7acd-442c-8605-08d642e2cd0e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4231;
x-ms-traffictypediagnostic: BYAPR06MB4231:
x-microsoft-antispam-prvs: <BYAPR06MB42310451B49472FFEA00D85EFBCA0@BYAPR06MB4231.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4231;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4231;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(346002)(39860400002)(366004)(199004)(189003)(6116002)(3846002)(97736004)(99286004)(1076002)(4326008)(102836004)(71190400001)(71200400001)(76176011)(68736007)(6506007)(386003)(106356001)(36756003)(105586002)(2351001)(6436002)(5640700003)(5660300001)(2906002)(2900100001)(2501003)(53936002)(6486002)(6512007)(72206003)(478600001)(14454004)(6916009)(54906003)(186003)(52116002)(26005)(7736002)(316002)(476003)(11346002)(8936002)(81156014)(81166006)(305945005)(66066001)(256004)(2616005)(446003)(25786009)(44832011)(486006)(8676002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4231;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: oE5zjRh4NGSSSGMp7rcwkNZkuBmOT99m5eCycteYNoHGPAlxkuObaCyo8OgBT6f9sDcBeEsDaoR0nFZ8jcxhuoHyKTuU5IIdkgreBa4hwDEHzeDHl6hlOYFH2R0W17j2raWbK67g1J5En3Ut9mBjY2hQmV0nSoN2DL/5fYX5MEgeeXFfNXi2V2E05bLA01p8g2JICSghl4DJtVcJ5AIdLUfT46T53nLYeX1tSz6M4A5d5QtQ2qlBy9H4vvu9yZRwq9DB85YBDj+u+mRoqeYM/6CnEZfrlAq5Sxrl6Bewv+Z5E2SEZ8I/gDZN4oyU6l+ISHlpEBxT9TCX07Y+YluBFeE0HnlG6QoXCf8ro/5HD4k=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb69dbb1-7acd-442c-8605-08d642e2cd0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 05:51:59.4045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4231
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The frameburst feature can enable per-packet framebursting in firmware
side and get higher TX throughput in High Throughput(HT) mode. To enhance
TX throughput, we enable frameburst mode in default firmware setting.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
v3: Enable frameburst in default instead of being a module parameter
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 ++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h     | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 230a378c26fc..a7361d142a27 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6638,6 +6638,12 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211=
_info *cfg)
=20
 	brcmf_configure_arp_nd_offload(ifp, true);
=20
+	err =3D brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_FAKEFRAG, 1);
+	if (err) {
+		brcmf_err("failed to set frameburst mode\n");
+		goto default_conf_out;
+	}
+
 	cfg->dongle_up =3D true;
 default_conf_out:
=20
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

