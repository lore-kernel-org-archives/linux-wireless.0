Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FDCC43387
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 07:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C9302070C
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 07:46:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="xzT9V91q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbfACHqp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:46:45 -0500
Received: from mail-eopbgr780125.outbound.protection.outlook.com ([40.107.78.125]:10254
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729071AbfACHqp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 02:46:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkRxD/bUi+gbDrwJqBWfcrNTtodfh/5DJz3BkPD9yY4=;
 b=xzT9V91qiugSBfi/Bwo0wK2GvTnYnWj+31GQrbWGr9GNR8flQW0mfy1nC4neEKmbr3sDWrlNYbaCzL2zauRiJ9dGh3t5eTpelYDsoyXnAnBVpqZnGSnCNWMJqdW16WM0sdUzx3YvjOEQK/JepTBZOnwo8MFCfGxemFUgNjUeLF0=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5177.namprd06.prod.outlook.com (20.178.25.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Thu, 3 Jan 2019 07:46:41 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.005; Thu, 3 Jan 2019
 07:46:41 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 2/2] brcmfmac: support wake on ping packet
Thread-Topic: [PATCH 2/2] brcmfmac: support wake on ping packet
Thread-Index: AQHUozh3M9VFXGrUaUCguvwg62VMEg==
Date:   Thu, 3 Jan 2019 07:46:41 +0000
Message-ID: <1546501565-40752-3-git-send-email-chi-hsien.lin@cypress.com>
References: <1546501565-40752-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1546501565-40752-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR01CA0038.prod.exchangelabs.com (2603:10b6:a03:94::15)
 To DM6PR06MB5804.namprd06.prod.outlook.com (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5177;6:HgvDHhoHnJ6iYn45Ci8uAnFG3OGQznkLYVmWdHGjSWbUYsXgt4R+oXQm2FYsO9MLn3e6xpz8VoyqZcCw/gFBHWoxpmZKa6rLrrPBIAXR5T0xuKBjcLizDxFoDchcuKnWXW82w1CALsL243GX3oIPVWVQS8EhOX2G7OXn6b3T0omGv+8G2c/VCYHjCMKzMV+1IqSN/u7XFhh1cj382f8CLyS/OuP2BKMkrtCGex1SmJc1vt+biwf8ZbcWbcwK/4Wr/hTzbLquXR1tJfEavpO2x2zKm3/1VXePakP+vIeB2X1GEtRl4i1FuyjlUmVnW1CRWAuQAIcCTBSyapzsctqTsYsOwu1SiaTPoM4ASq+5FtCLWl/pW6AgYDGCCXJBK6bwQ3lS2ucHVCj7BiUKkUFfdHuRhs7fWnLB8G3c6w+bCpB/ZNTTSdFx+ggsGqYHdsPaB7mMCBN8QnOyB2Usw+7VcQ==;5:Hu4ZegKhfB5JJ3JQ1cx9yeh2E9tvKCLce/bKITxcFE1kQJbMHTbvMLGQy9GvWPmnb+zKxo5C0/wfRWNbNbNbN4+L/QIYX0Yl3f0Z7w2LEJHsrFihJ/D2P69H+wE/AyS5/dnw9oUAcrBZxO4liBzUgMZJQ1cypxD5JymMYXFbBEIo1abIoyBICkHNbTy8BEausv5FNk6b2j4/cgtFW7x/HQ==;7:ZEKiMqCrffQJjBobdDMITHOWk2mgHmRTxBucmPNCjU6iKo/rD5fzm6z1w3UHpL5+K8UQRcgTD+tGD0BEV9u63HHpf+dVbffW4qyXOfqA2we0+fJ9npkwPp/giNzQlLXtFsxoxWXZ/fBhDHgiw2QUFA==
x-ms-office365-filtering-correlation-id: 6d155005-6021-41e0-766a-08d6714f9988
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5177;
x-ms-traffictypediagnostic: DM6PR06MB5177:
x-microsoft-antispam-prvs: <DM6PR06MB51776D6BED232874853CB26FBB8D0@DM6PR06MB5177.namprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(10201501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(6055026)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:DM6PR06MB5177;BCL:0;PCL:0;RULEID:;SRVR:DM6PR06MB5177;
x-forefront-prvs: 0906E83A25
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(366004)(346002)(396003)(199004)(189003)(5024004)(71200400001)(71190400001)(256004)(26005)(186003)(6512007)(478600001)(53936002)(305945005)(105586002)(8936002)(106356001)(2906002)(102836004)(6486002)(8676002)(575784001)(7736002)(72206003)(52116002)(14444005)(81166006)(81156014)(2501003)(99286004)(68736007)(86362001)(2351001)(6506007)(76176011)(14454004)(386003)(4744004)(3846002)(6116002)(486006)(11346002)(446003)(107886003)(54906003)(97736004)(316002)(2616005)(476003)(6916009)(4326008)(5660300001)(6436002)(25786009)(5640700003)(36756003)(66066001)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5177;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rPIM8UzcfXlxLlOFos+On1VbTxS0rZ0t5oP+YjejrxBMuRxp0Ee+G6H8orCimSIFTeAYzO9/MKgh1x1ZtKIE01DO3Qi3vkryufMdw4D/x0X/jbcCwUx5sjPLpz4vQx7r2tmGRauy+MqZNiydbOJyhRKnCxndJl3pcwjqtJfKTZpc5n/NNIJz8s4bjC331JIta6q8aTrv4OrS0JKivnPq8mLvGXlRIIK8K1FB7O3/ek+E+NO0dciuLqCPR8beAa7Ewh3C936skoaw+vdR4nJqgBKcR1IMuSEd2Tlh9kfHKzc2RPr6mWJIvmBjxQqIZJmJ
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d155005-6021-41e0-766a-08d6714f9988
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2019 07:46:41.5698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5177
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lo-Hsiang Lo <double.lo@cypress.com>

Set up wiphy->wowlan_config and a dummy wowlan filter so brcmfmac can
remain connected during suspend. Enable an unicast packet filter during
suspend so ping packets can wake up the system.

Signed-off-by: Lo-Hsiang Lo <double.lo@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  36 ++++-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   7 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 175 +++++++++++++++++=
++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   9 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  13 ++
 6 files changed, 247 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 35301237d435..80ff43554cc3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3593,6 +3593,9 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 					    brcmf_notify_sched_scan_results);
 			cfg->wowl.nd_enabled =3D false;
 		}
+
+		/* disable packet filters */
+		brcmf_pktfilter_enable(ifp->ndev, false);
 	}
 	return 0;
 }
@@ -3651,6 +3654,9 @@ static void brcmf_configure_wowl(struct brcmf_cfg8021=
1_info *cfg,
 	brcmf_fil_iovar_int_set(ifp, "wowl_activate", 1);
 	brcmf_bus_wowl_config(cfg->pub->bus_if, true);
 	cfg->wowl.active =3D true;
+
+	/* enable packet filters */
+	brcmf_pktfilter_enable(ifp->ndev, true);
 }
=20
 static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
@@ -3677,7 +3683,8 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy=
,
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
 		brcmf_abort_scanning(cfg);
=20
-	if (wowl =3D=3D NULL) {
+	if (!wowl || !test_bit(BRCMF_VIF_STATUS_CONNECTED,
+			       &ifp->vif->sme_state)) {
 		brcmf_bus_wowl_config(cfg->pub->bus_if, false);
 		list_for_each_entry(vif, &cfg->vif_list, list) {
 			if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state))
@@ -3697,8 +3704,9 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy=
,
 		brcmf_set_mpc(ifp, 1);
=20
 	} else {
-		/* Configure WOWL paramaters */
-		brcmf_configure_wowl(cfg, ifp, wowl);
+		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL))
+			/* Configure WOWL parameters */
+			brcmf_configure_wowl(cfg, ifp, wowl);
 	}
=20
 exit:
@@ -6471,6 +6479,7 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wip=
hy, struct brcmf_if *ifp)
 #ifdef CONFIG_PM
 	struct brcmf_cfg80211_info *cfg =3D wiphy_to_cfg(wiphy);
 	struct wiphy_wowlan_support *wowl;
+	struct cfg80211_wowlan *brcmf_wowlan_config =3D NULL;
=20
 	wowl =3D kmemdup(&brcmf_wowlan_support, sizeof(brcmf_wowlan_support),
 		       GFP_KERNEL);
@@ -6493,6 +6502,27 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wi=
phy, struct brcmf_if *ifp)
 	}
=20
 	wiphy->wowlan =3D wowl;
+
+	/* wowlan_config structure report for kernels */
+	brcmf_wowlan_config =3D kzalloc(sizeof(*brcmf_wowlan_config),
+				      GFP_KERNEL);
+	if (brcmf_wowlan_config) {
+		brcmf_wowlan_config->any =3D false;
+		brcmf_wowlan_config->disconnect =3D true;
+		brcmf_wowlan_config->eap_identity_req =3D true;
+		brcmf_wowlan_config->four_way_handshake =3D true;
+		brcmf_wowlan_config->rfkill_release =3D false;
+		brcmf_wowlan_config->patterns =3D NULL;
+		brcmf_wowlan_config->n_patterns =3D 0;
+		brcmf_wowlan_config->tcp =3D NULL;
+		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL_GTK))
+			brcmf_wowlan_config->gtk_rekey_failure =3D true;
+		else
+			brcmf_wowlan_config->gtk_rekey_failure =3D false;
+	} else {
+		brcmf_err("Can not allocate memory for brcm_wowlan_config\n");
+	}
+	wiphy->wowlan_config =3D brcmf_wowlan_config;
 #endif
 }
=20
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 9a6287f084a9..d3ec684ddb0d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -86,6 +86,13 @@
=20
 #define BRCMF_VIF_EVENT_TIMEOUT		msecs_to_jiffies(1500)
=20
+/* cfg80211 wowlan definitions */
+#define WL_WOWLAN_MAX_PATTERNS			8
+#define WL_WOWLAN_MIN_PATTERN_LEN		1
+#define WL_WOWLAN_MAX_PATTERN_LEN		255
+#define WL_WOWLAN_PKT_FILTER_ID_FIRST	201
+#define WL_WOWLAN_PKT_FILTER_ID_LAST	(WL_WOWLAN_PKT_FILTER_ID_FIRST + \
+					WL_WOWLAN_MAX_PATTERNS - 1)
 /**
  * enum brcmf_scan_status - scan engine status
  *
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/dr=
ivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 1f1e95a15a17..33b9f36e91f4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -210,7 +210,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	char *ptr;
 	s32 err;
=20
-	/* retreive mac address */
+	/* retrieve mac addresses */
 	err =3D brcmf_fil_iovar_data_get(ifp, "cur_etheraddr", ifp->mac_addr,
 				       sizeof(ifp->mac_addr));
 	if (err < 0) {
@@ -345,6 +345,15 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
=20
 	/* Enable tx beamforming, errors can be ignored (not supported) */
 	(void)brcmf_fil_iovar_int_set(ifp, "txbf", 1);
+
+	/* add unicast packet filter */
+	err =3D brcmf_pktfilter_add_remove(ifp->ndev,
+					 BRCMF_UNICAST_FILTER_NUM, true);
+	if (err)
+		brcmf_info("Add unicast filter error (%d)\n", err);
+
+	/* do bus specific preinit here */
+	err =3D brcmf_bus_preinit(ifp->drvr->bus_if);
 done:
 	return err;
 }
@@ -413,7 +422,7 @@ struct brcmf_mp_device *brcmf_get_module_param(struct d=
evice *dev,
 	if (!settings)
 		return NULL;
=20
-	/* start by using the module paramaters */
+	/* start by using the module parameters */
 	settings->p2p_enable =3D !!brcmf_p2p_enable;
 	settings->feature_disable =3D brcmf_feature_disable;
 	settings->fcmode =3D brcmf_fcmode;
@@ -498,7 +507,7 @@ static int __init brcmfmac_module_init(void)
 	if (err =3D=3D -ENODEV)
 		brcmf_dbg(INFO, "No platform data available.\n");
=20
-	/* Initialize global module paramaters */
+	/* Initialize global module parameters */
 	brcmf_mp_attach();
=20
 	/* Continue the initialization by registering the different busses */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 860a4372cb56..fa7bcac16fe4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1345,3 +1345,178 @@ void __exit brcmf_core_exit(void)
 #endif
 }
=20
+int
+brcmf_pktfilter_add_remove(struct net_device *ndev, int filter_num, bool a=
dd)
+{
+	struct brcmf_if *ifp =3D  netdev_priv(ndev);
+	struct brcmf_pub *drvr =3D ifp->drvr;
+	struct brcmf_pkt_filter_le *pkt_filter;
+	int filter_fixed_len =3D offsetof(struct brcmf_pkt_filter_le, u);
+	int pattern_fixed_len =3D offsetof(struct brcmf_pkt_filter_pattern_le,
+				  mask_and_pattern);
+	u16 mask_and_pattern[MAX_PKTFILTER_PATTERN_SIZE];
+	int buflen =3D 0;
+	int ret =3D 0;
+
+	brcmf_dbg(INFO, "%s packet filter number %d\n",
+		  (add ? "add" : "remove"), filter_num);
+
+	pkt_filter =3D kzalloc(sizeof(*pkt_filter) +
+			(MAX_PKTFILTER_PATTERN_SIZE * 2), GFP_ATOMIC);
+	if (!pkt_filter)
+		return -ENOMEM;
+
+	switch (filter_num) {
+	case BRCMF_UNICAST_FILTER_NUM:
+		pkt_filter->id =3D 100;
+		pkt_filter->type =3D 0;
+		pkt_filter->negate_match =3D 0;
+		pkt_filter->u.pattern.offset =3D 0;
+		pkt_filter->u.pattern.size_bytes =3D 1;
+		mask_and_pattern[0] =3D 0x0001;
+		break;
+	case BRCMF_BROADCAST_FILTER_NUM:
+		//filter_pattern =3D "101 0 0 0 0xFFFFFFFFFFFF 0xFFFFFFFFFFFF";
+		pkt_filter->id =3D 101;
+		pkt_filter->type =3D 0;
+		pkt_filter->negate_match =3D 0;
+		pkt_filter->u.pattern.offset =3D 0;
+		pkt_filter->u.pattern.size_bytes =3D 6;
+		mask_and_pattern[0] =3D 0xFFFF;
+		mask_and_pattern[1] =3D 0xFFFF;
+		mask_and_pattern[2] =3D 0xFFFF;
+		mask_and_pattern[3] =3D 0xFFFF;
+		mask_and_pattern[4] =3D 0xFFFF;
+		mask_and_pattern[5] =3D 0xFFFF;
+		break;
+	case BRCMF_MULTICAST4_FILTER_NUM:
+		//filter_pattern =3D "102 0 0 0 0xFFFFFF 0x01005E";
+		pkt_filter->id =3D 102;
+		pkt_filter->type =3D 0;
+		pkt_filter->negate_match =3D 0;
+		pkt_filter->u.pattern.offset =3D 0;
+		pkt_filter->u.pattern.size_bytes =3D 3;
+		mask_and_pattern[0] =3D 0xFFFF;
+		mask_and_pattern[1] =3D 0x01FF;
+		mask_and_pattern[2] =3D 0x5E00;
+		break;
+	case BRCMF_MULTICAST6_FILTER_NUM:
+		//filter_pattern =3D "103 0 0 0 0xFFFF 0x3333";
+		pkt_filter->id =3D 103;
+		pkt_filter->type =3D 0;
+		pkt_filter->negate_match =3D 0;
+		pkt_filter->u.pattern.offset =3D 0;
+		pkt_filter->u.pattern.size_bytes =3D 2;
+		mask_and_pattern[0] =3D 0xFFFF;
+		mask_and_pattern[1] =3D 0x3333;
+		break;
+	case BRCMF_MDNS_FILTER_NUM:
+		//filter_pattern =3D "104 0 0 0 0xFFFFFFFFFFFF 0x01005E0000FB";
+		pkt_filter->id =3D 104;
+		pkt_filter->type =3D 0;
+		pkt_filter->negate_match =3D 0;
+		pkt_filter->u.pattern.offset =3D 0;
+		pkt_filter->u.pattern.size_bytes =3D 6;
+		mask_and_pattern[0] =3D 0xFFFF;
+		mask_and_pattern[1] =3D 0xFFFF;
+		mask_and_pattern[2] =3D 0xFFFF;
+		mask_and_pattern[3] =3D 0x0001;
+		mask_and_pattern[4] =3D 0x005E;
+		mask_and_pattern[5] =3D 0xFB00;
+		break;
+	case BRCMF_ARP_FILTER_NUM:
+		//filter_pattern =3D "105 0 0 12 0xFFFF 0x0806";
+		pkt_filter->id =3D 105;
+		pkt_filter->type =3D 0;
+		pkt_filter->negate_match =3D 0;
+		pkt_filter->u.pattern.offset =3D 12;
+		pkt_filter->u.pattern.size_bytes =3D 2;
+		mask_and_pattern[0] =3D 0xFFFF;
+		mask_and_pattern[1] =3D 0x0608;
+		break;
+	case BRCMF_BROADCAST_ARP_FILTER_NUM:
+		//filter_pattern =3D "106 0 0 0
+		//0xFFFFFFFFFFFF0000000000000806
+		//0xFFFFFFFFFFFF0000000000000806";
+		pkt_filter->id =3D 106;
+		pkt_filter->type =3D 0;
+		pkt_filter->negate_match =3D 0;
+		pkt_filter->u.pattern.offset =3D 0;
+		pkt_filter->u.pattern.size_bytes =3D 14;
+		mask_and_pattern[0] =3D 0xFFFF;
+		mask_and_pattern[1] =3D 0xFFFF;
+		mask_and_pattern[2] =3D 0xFFFF;
+		mask_and_pattern[3] =3D 0x0000;
+		mask_and_pattern[4] =3D 0x0000;
+		mask_and_pattern[5] =3D 0x0000;
+		mask_and_pattern[6] =3D 0x0608;
+		mask_and_pattern[7] =3D 0xFFFF;
+		mask_and_pattern[8] =3D 0xFFFF;
+		mask_and_pattern[9] =3D 0xFFFF;
+		mask_and_pattern[10] =3D 0x0000;
+		mask_and_pattern[11] =3D 0x0000;
+		mask_and_pattern[12] =3D 0x0000;
+		mask_and_pattern[13] =3D 0x0608;
+		break;
+	default:
+		ret =3D -EINVAL;
+		goto failed;
+	}
+	memcpy(pkt_filter->u.pattern.mask_and_pattern, mask_and_pattern,
+	       pkt_filter->u.pattern.size_bytes * 2);
+	buflen =3D filter_fixed_len + pattern_fixed_len +
+		  pkt_filter->u.pattern.size_bytes * 2;
+
+	if (add) {
+		/* Add filter */
+		ret =3D brcmf_fil_iovar_data_set(ifp, "pkt_filter_add",
+					       pkt_filter, buflen);
+		if (ret)
+			goto failed;
+		drvr->pkt_filter[filter_num].id =3D pkt_filter->id;
+		drvr->pkt_filter[filter_num].enable  =3D 0;
+
+	} else {
+		/* Delete filter */
+		ret =3D brcmf_fil_iovar_int_set(ifp, "pkt_filter_delete",
+					      pkt_filter->id);
+		if (ret =3D=3D -ENOENT)
+			ret =3D 0;
+		if (ret)
+			goto failed;
+
+		drvr->pkt_filter[filter_num].id =3D 0;
+		drvr->pkt_filter[filter_num].enable  =3D 0;
+	}
+
+failed:
+	if (ret)
+		brcmf_err("%s packet filter failed, ret=3D%d\n",
+			  (add ? "add" : "remove"), ret);
+
+	kfree(pkt_filter);
+	return ret;
+}
+
+int brcmf_pktfilter_enable(struct net_device *ndev, bool enable)
+{
+	struct brcmf_if *ifp =3D  netdev_priv(ndev);
+	struct brcmf_pub *drvr =3D ifp->drvr;
+	int ret =3D 0;
+	int idx =3D 0;
+
+	for (idx =3D 0; idx < MAX_PKT_FILTER_COUNT; ++idx) {
+		if (drvr->pkt_filter[idx].id !=3D 0) {
+			drvr->pkt_filter[idx].enable =3D enable;
+			ret =3D brcmf_fil_iovar_data_set(ifp, "pkt_filter_enable",
+						       &drvr->pkt_filter[idx],
+				sizeof(struct brcmf_pkt_filter_enable_le));
+			if (ret) {
+				brcmf_err("%s packet filter id(%d) failed, ret=3D%d\n",
+					  (enable ? "enable" : "disable"),
+					  drvr->pkt_filter[idx].id, ret);
+			}
+		}
+	}
+	return ret;
+}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index dcf6e27cc16f..96c58261a5d8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -23,6 +23,7 @@
=20
 #include <net/cfg80211.h>
 #include "fweh.h"
+#include "fwil_types.h"
=20
 #define TOE_TX_CSUM_OL		0x00000001
 #define TOE_RX_CSUM_OL		0x00000002
@@ -36,7 +37,7 @@
 #define BRCMF_DCMD_MEDLEN	1536
 #define BRCMF_DCMD_MAXLEN	8192
=20
-/* IOCTL from host to device are limited in lenght. A device can only hand=
le
+/* IOCTL from host to device are limited in length. A device can only hand=
le
  * ethernet frame size. This limitation is to be applied by protocol layer=
.
  */
 #define BRCMF_TX_IOCTL_MAX_MSG_SIZE	(ETH_FRAME_LEN+ETH_FCS_LEN)
@@ -144,6 +145,8 @@ struct brcmf_pub {
 	struct brcmf_mp_device *settings;
=20
 	u8 clmver[BRCMF_DCMD_SMLEN];
+	struct brcmf_pkt_filter_enable_le pkt_filter[MAX_PKT_FILTER_COUNT];
+
 };
=20
 /* forward declarations */
@@ -221,5 +224,7 @@ void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk=
_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 int __init brcmf_core_init(void);
 void __exit brcmf_core_exit(void);
-
+int brcmf_pktfilter_add_remove(struct net_device *ndev, int filter_num,
+			       bool add);
+int brcmf_pktfilter_enable(struct net_device *ndev, bool enable);
 #endif /* BRCMFMAC_CORE_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h =
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 39ac1bbb6cc0..a1303efcbb3c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -147,6 +147,19 @@
 #define BRCMF_WOWL_MAXPATTERNS		8
 #define BRCMF_WOWL_MAXPATTERNSIZE	128
=20
+enum {
+	BRCMF_UNICAST_FILTER_NUM =3D 0,
+	BRCMF_BROADCAST_FILTER_NUM,
+	BRCMF_MULTICAST4_FILTER_NUM,
+	BRCMF_MULTICAST6_FILTER_NUM,
+	BRCMF_MDNS_FILTER_NUM,
+	BRCMF_ARP_FILTER_NUM,
+	BRCMF_BROADCAST_ARP_FILTER_NUM,
+	MAX_PKT_FILTER_COUNT
+};
+
+#define MAX_PKTFILTER_PATTERN_SIZE		16
+
 #define BRCMF_COUNTRY_BUF_SZ		4
 #define BRCMF_ANT_MAX			4
=20
--=20
2.1.0

