Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F694C10F05
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0E142184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Z5a4dHvs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfCTKFT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:19 -0400
Received: from mail-eopbgr750054.outbound.protection.outlook.com ([40.107.75.54]:62253
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfCTKFT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yuT2DHQUjWj7VRCsaVZmXbR4BwkXQV7uGsfwQMXmfM=;
 b=Z5a4dHvsVde+lfwjkkV6jLaUXQAfdazuGtHo3kh3FJDBjTYsRutA5dUIPH6B3dotTZSm8Xw2tsddhey2z71ZLcd8HgjUI7ktVF3sgXHHpKtfxc1YrGHe09lnquMPSfgZyEHR0o+O6nbeMOqCe4ZZj8ZVCQetbUf+pwme2JmK+0Y=
Received: from BN7PR05MB5796.namprd05.prod.outlook.com (20.176.29.139) by
 BN7PR05MB4545.namprd05.prod.outlook.com (52.135.248.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.14; Wed, 20 Mar 2019 10:04:57 +0000
Received: from BN7PR05MB5796.namprd05.prod.outlook.com
 ([fe80::711a:3708:5a24:9603]) by BN7PR05MB5796.namprd05.prod.outlook.com
 ([fe80::711a:3708:5a24:9603%3]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:57 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5661.namprd05.prod.outlook.com (52.135.111.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:03:57 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:03:57 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 06/14] qtnfmac: allow each MAC to specify its own regulatory
 rules
Thread-Topic: [PATCH 06/14] qtnfmac: allow each MAC to specify its own
 regulatory rules
Thread-Index: AQHU3wQ7y4SLl+vxMUCg0Is8vL8Mnw==
Date:   Wed, 20 Mar 2019 10:03:57 +0000
Message-ID: <20190320100340.14168-7-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0fd1d40c-4c38-4dec-7acb-08d6ad1b5d96
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5661;
x-ms-traffictypediagnostic: SN6PR05MB5661:|BN7PR05MB4545:
x-moderation-data: 3/20/2019 10:04:55 AM
x-microsoft-antispam-prvs: <BN7PR05MB45454853A476BFCFFA2D3301A3410@BN7PR05MB4545.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(396003)(346002)(136003)(376002)(189003)(199004)(6506007)(71200400001)(1076003)(256004)(6512007)(8936002)(71190400001)(476003)(68736007)(97736004)(11346002)(446003)(30864003)(2501003)(52116002)(99286004)(25786009)(81166006)(8676002)(486006)(7736002)(50226002)(54906003)(316002)(2616005)(305945005)(86362001)(36756003)(6916009)(103116003)(5640700003)(53946003)(107886003)(4326008)(6486002)(6436002)(14444005)(53936002)(81156014)(2906002)(105586002)(6116002)(106356001)(14454004)(386003)(76176011)(478600001)(15650500001)(436003)(2351001)(26005)(3846002)(66066001)(186003)(102836004)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR05MB4545;H:BN7PR05MB5796.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bxODmoy3eRZblhshnhBVGdo/8a0f7Q3Mu0b1ud7ArZiXx5kQmMfFxIKrGXBBeBCvR8tpcqStJorNaSTQgyA8ZjX7H9Ns8C6uqJIvKBmIHEDz0NwRQlbF++GGBol7XcFWh9tLt/K73X1LvzYiCD1NDHoV/hDbc6lvDixiBjZ3u143JVXQjzqy4vOLrJrM/YkU0LbDCjaNwbgdVe3hfZgb7WIfIPi7IEfFc2SkARa9hnega1tsaWh2HjQDGOMaRVtsLHxKXa868oSRsgdR5JQDvcM/iY7/AbiNgz/1WZEc7HWjC16fu8aTlbSDlQUdLyxixIwJoZJNi/nTnQxNuUsw4XppasThIADQ0NLokgQ3Yi3ZZhKI8VdFjxxi0bHpVipBB48eJJStboxubgY2rl613owjlsteJgtHjFYMLwOgXcI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd1d40c-4c38-4dec-7acb-08d6ad1b5d96
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:04:57.7366
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR05MB4545
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Currently driver uses the same regulatory rules to register all wiphy
instances. This is not logically correct since each wiphy may have
different capabilities (different supported bands, EIRP etc).
Allow firmware to pass regulatory rules for each MAC separately.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  13 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 186 +++++++----------=
----
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   5 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   2 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  42 ++---
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |  62 +++++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   2 +
 7 files changed, 156 insertions(+), 156 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 3131ced8801f..cea948466744 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1145,17 +1145,16 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_inf=
o, struct qtnf_wmac *mac)
 		wiphy->wowlan =3D macinfo->wowlan;
 #endif
=20
-	regdomain_is_known =3D isalpha(hw_info->rd->alpha2[0]) &&
-		isalpha(hw_info->rd->alpha2[1]);
+	regdomain_is_known =3D isalpha(mac->rd->alpha2[0]) &&
+				isalpha(mac->rd->alpha2[1]);
=20
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_REG_UPDATE) {
 		wiphy->reg_notifier =3D qtnf_cfg80211_reg_notifier;
=20
-		if (hw_info->rd->alpha2[0] =3D=3D '9' &&
-		    hw_info->rd->alpha2[1] =3D=3D '9') {
+		if (mac->rd->alpha2[0] =3D=3D '9' && mac->rd->alpha2[1] =3D=3D '9') {
 			wiphy->regulatory_flags |=3D REGULATORY_CUSTOM_REG |
 				REGULATORY_STRICT_REG;
-			wiphy_apply_custom_regulatory(wiphy, hw_info->rd);
+			wiphy_apply_custom_regulatory(wiphy, mac->rd);
 		} else if (regdomain_is_known) {
 			wiphy->regulatory_flags |=3D REGULATORY_STRICT_REG;
 		}
@@ -1181,9 +1180,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
 struct qtnf_wmac *mac)
 		goto out;
=20
 	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
-		ret =3D regulatory_set_wiphy_regd(wiphy, hw_info->rd);
+		ret =3D regulatory_set_wiphy_regd(wiphy, mac->rd);
 	else if (regdomain_is_known)
-		ret =3D regulatory_hint(wiphy, hw_info->rd->alpha2);
+		ret =3D regulatory_hint(wiphy, mac->rd->alpha2);
=20
 out:
 	return ret;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index e61bec7c5d8a..1a248d9f2e4c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -831,55 +831,6 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
 	return ret;
 }
=20
-static u32 qtnf_cmd_resp_reg_rule_flags_parse(u32 qflags)
-{
-	u32 flags =3D 0;
-
-	if (qflags & QLINK_RRF_NO_OFDM)
-		flags |=3D NL80211_RRF_NO_OFDM;
-
-	if (qflags & QLINK_RRF_NO_CCK)
-		flags |=3D NL80211_RRF_NO_CCK;
-
-	if (qflags & QLINK_RRF_NO_INDOOR)
-		flags |=3D NL80211_RRF_NO_INDOOR;
-
-	if (qflags & QLINK_RRF_NO_OUTDOOR)
-		flags |=3D NL80211_RRF_NO_OUTDOOR;
-
-	if (qflags & QLINK_RRF_DFS)
-		flags |=3D NL80211_RRF_DFS;
-
-	if (qflags & QLINK_RRF_PTP_ONLY)
-		flags |=3D NL80211_RRF_PTP_ONLY;
-
-	if (qflags & QLINK_RRF_PTMP_ONLY)
-		flags |=3D NL80211_RRF_PTMP_ONLY;
-
-	if (qflags & QLINK_RRF_NO_IR)
-		flags |=3D NL80211_RRF_NO_IR;
-
-	if (qflags & QLINK_RRF_AUTO_BW)
-		flags |=3D NL80211_RRF_AUTO_BW;
-
-	if (qflags & QLINK_RRF_IR_CONCURRENT)
-		flags |=3D NL80211_RRF_IR_CONCURRENT;
-
-	if (qflags & QLINK_RRF_NO_HT40MINUS)
-		flags |=3D NL80211_RRF_NO_HT40MINUS;
-
-	if (qflags & QLINK_RRF_NO_HT40PLUS)
-		flags |=3D NL80211_RRF_NO_HT40PLUS;
-
-	if (qflags & QLINK_RRF_NO_80MHZ)
-		flags |=3D NL80211_RRF_NO_80MHZ;
-
-	if (qflags & QLINK_RRF_NO_160MHZ)
-		flags |=3D NL80211_RRF_NO_160MHZ;
-
-	return flags;
-}
-
 static int
 qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 			   const struct qlink_resp_get_hw_info *resp,
@@ -887,7 +838,6 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 {
 	struct qtnf_hw_info *hwinfo =3D &bus->hw_info;
 	const struct qlink_tlv_hdr *tlv;
-	const struct qlink_tlv_reg_rule *tlv_rule;
 	const char *bld_name =3D NULL;
 	const char *bld_rev =3D NULL;
 	const char *bld_type =3D NULL;
@@ -898,19 +848,8 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 	const char *calibration_ver =3D NULL;
 	const char *uboot_ver =3D NULL;
 	u32 hw_ver =3D 0;
-	struct ieee80211_reg_rule *rule;
 	u16 tlv_type;
 	u16 tlv_value_len;
-	unsigned int rule_idx =3D 0;
-
-	if (WARN_ON(resp->n_reg_rules > NL80211_MAX_SUPP_REG_RULES))
-		return -E2BIG;
-
-	hwinfo->rd =3D kzalloc(struct_size(hwinfo->rd, reg_rules,
-					 resp->n_reg_rules), GFP_KERNEL);
-
-	if (!hwinfo->rd)
-		return -ENOMEM;
=20
 	hwinfo->num_mac =3D resp->num_mac;
 	hwinfo->mac_bitmap =3D resp->mac_bitmap;
@@ -919,30 +858,11 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 	hwinfo->total_tx_chain =3D resp->total_tx_chain;
 	hwinfo->total_rx_chain =3D resp->total_rx_chain;
 	hwinfo->hw_capab =3D le32_to_cpu(resp->hw_capab);
-	hwinfo->rd->n_reg_rules =3D resp->n_reg_rules;
-	hwinfo->rd->alpha2[0] =3D resp->alpha2[0];
-	hwinfo->rd->alpha2[1] =3D resp->alpha2[1];
=20
 	bld_tmstamp =3D le32_to_cpu(resp->bld_tmstamp);
 	plat_id =3D le32_to_cpu(resp->plat_id);
 	hw_ver =3D le32_to_cpu(resp->hw_ver);
=20
-	switch (resp->dfs_region) {
-	case QLINK_DFS_FCC:
-		hwinfo->rd->dfs_region =3D NL80211_DFS_FCC;
-		break;
-	case QLINK_DFS_ETSI:
-		hwinfo->rd->dfs_region =3D NL80211_DFS_ETSI;
-		break;
-	case QLINK_DFS_JP:
-		hwinfo->rd->dfs_region =3D NL80211_DFS_JP;
-		break;
-	case QLINK_DFS_UNSET:
-	default:
-		hwinfo->rd->dfs_region =3D NL80211_DFS_UNSET;
-		break;
-	}
-
 	tlv =3D (const struct qlink_tlv_hdr *)resp->info;
=20
 	while (info_len >=3D sizeof(*tlv)) {
@@ -956,37 +876,6 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 		}
=20
 		switch (tlv_type) {
-		case QTN_TLV_ID_REG_RULE:
-			if (rule_idx >=3D resp->n_reg_rules) {
-				pr_warn("unexpected number of rules: %u\n",
-					resp->n_reg_rules);
-				return -EINVAL;
-			}
-
-			if (tlv_value_len !=3D sizeof(*tlv_rule) - sizeof(*tlv)) {
-				pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
-					tlv_type, tlv_value_len);
-				return -EINVAL;
-			}
-
-			tlv_rule =3D (const struct qlink_tlv_reg_rule *)tlv;
-			rule =3D &hwinfo->rd->reg_rules[rule_idx++];
-
-			rule->freq_range.start_freq_khz =3D
-				le32_to_cpu(tlv_rule->start_freq_khz);
-			rule->freq_range.end_freq_khz =3D
-				le32_to_cpu(tlv_rule->end_freq_khz);
-			rule->freq_range.max_bandwidth_khz =3D
-				le32_to_cpu(tlv_rule->max_bandwidth_khz);
-			rule->power_rule.max_antenna_gain =3D
-				le32_to_cpu(tlv_rule->max_antenna_gain);
-			rule->power_rule.max_eirp =3D
-				le32_to_cpu(tlv_rule->max_eirp);
-			rule->dfs_cac_ms =3D
-				le32_to_cpu(tlv_rule->dfs_cac_ms);
-			rule->flags =3D qtnf_cmd_resp_reg_rule_flags_parse(
-					le32_to_cpu(tlv_rule->flags));
-			break;
 		case QTN_TLV_ID_BUILD_NAME:
 			bld_name =3D (const void *)tlv->val;
 			break;
@@ -1019,17 +908,8 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 		tlv =3D (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
 	}
=20
-	if (rule_idx !=3D resp->n_reg_rules) {
-		pr_warn("unexpected number of rules: expected %u got %u\n",
-			resp->n_reg_rules, rule_idx);
-		kfree(hwinfo->rd);
-		hwinfo->rd =3D NULL;
-		return -EINVAL;
-	}
-
-	pr_info("fw_version=3D%d, MACs map %#x, alpha2=3D\"%c%c\", chains Tx=3D%u=
 Rx=3D%u, capab=3D0x%x\n",
+	pr_info("fw_version=3D%d, MACs map %#x, chains Tx=3D%u Rx=3D%u, capab=3D0=
x%x\n",
 		hwinfo->fw_ver, hwinfo->mac_bitmap,
-		hwinfo->rd->alpha2[0], hwinfo->rd->alpha2[1],
 		hwinfo->total_tx_chain, hwinfo->total_rx_chain,
 		hwinfo->hw_capab);
=20
@@ -1085,9 +965,12 @@ qtnf_parse_wowlan_info(struct qtnf_wmac *mac,
 	}
 }
=20
-static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
-					const u8 *tlv_buf, size_t tlv_buf_size)
+static int
+qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
+			     const struct qlink_resp_get_mac_info *resp,
+			     size_t tlv_buf_size)
 {
+	const u8 *tlv_buf =3D resp->var_info;
 	struct ieee80211_iface_combination *comb =3D NULL;
 	size_t n_comb =3D 0;
 	struct ieee80211_iface_limit *limits;
@@ -1105,6 +988,38 @@ static int qtnf_parse_variable_mac_info(struct qtnf_w=
mac *mac,
 	u8 ext_capa_len =3D 0;
 	u8 ext_capa_mask_len =3D 0;
 	int i =3D 0;
+	struct ieee80211_reg_rule *rule;
+	unsigned int rule_idx =3D 0;
+	const struct qlink_tlv_reg_rule *tlv_rule;
+
+	if (WARN_ON(resp->n_reg_rules > NL80211_MAX_SUPP_REG_RULES))
+		return -E2BIG;
+
+	mac->rd =3D kzalloc(sizeof(*mac->rd) +
+			  sizeof(struct ieee80211_reg_rule) *
+			  resp->n_reg_rules, GFP_KERNEL);
+	if (!mac->rd)
+		return -ENOMEM;
+
+	mac->rd->n_reg_rules =3D resp->n_reg_rules;
+	mac->rd->alpha2[0] =3D resp->alpha2[0];
+	mac->rd->alpha2[1] =3D resp->alpha2[1];
+
+	switch (resp->dfs_region) {
+	case QLINK_DFS_FCC:
+		mac->rd->dfs_region =3D NL80211_DFS_FCC;
+		break;
+	case QLINK_DFS_ETSI:
+		mac->rd->dfs_region =3D NL80211_DFS_ETSI;
+		break;
+	case QLINK_DFS_JP:
+		mac->rd->dfs_region =3D NL80211_DFS_JP;
+		break;
+	case QLINK_DFS_UNSET:
+	default:
+		mac->rd->dfs_region =3D NL80211_DFS_UNSET;
+		break;
+	}
=20
 	tlv =3D (const struct qlink_tlv_hdr *)tlv_buf;
 	while (tlv_buf_size >=3D sizeof(struct qlink_tlv_hdr)) {
@@ -1225,6 +1140,23 @@ static int qtnf_parse_variable_mac_info(struct qtnf_=
wmac *mac,
 			mac->macinfo.wowlan =3D NULL;
 			qtnf_parse_wowlan_info(mac, wowlan);
 			break;
+		case QTN_TLV_ID_REG_RULE:
+			if (rule_idx >=3D resp->n_reg_rules) {
+				pr_warn("unexpected number of rules: %u\n",
+					resp->n_reg_rules);
+				return -EINVAL;
+			}
+
+			if (tlv_value_len !=3D sizeof(*tlv_rule) - sizeof(*tlv)) {
+				pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
+					tlv_type, tlv_value_len);
+				return -EINVAL;
+			}
+
+			tlv_rule =3D (const struct qlink_tlv_reg_rule *)tlv;
+			rule =3D &mac->rd->reg_rules[rule_idx++];
+			qlink_utils_regrule_q2nl(rule, tlv_rule);
+			break;
 		default:
 			pr_warn("MAC%u: unknown TLV type %u\n",
 				mac->macid, tlv_type);
@@ -1253,6 +1185,12 @@ static int qtnf_parse_variable_mac_info(struct qtnf_=
wmac *mac,
 		return -EINVAL;
 	}
=20
+	if (rule_idx !=3D resp->n_reg_rules) {
+		pr_warn("unexpected number of rules: expected %u got %u\n",
+			resp->n_reg_rules, rule_idx);
+		return -EINVAL;
+	}
+
 	if (ext_capa_len > 0) {
 		ext_capa =3D kmemdup(ext_capa, ext_capa_len, GFP_KERNEL);
 		if (!ext_capa)
@@ -1663,7 +1601,7 @@ int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
=20
 	resp =3D (const struct qlink_resp_get_mac_info *)resp_skb->data;
 	qtnf_cmd_resp_proc_mac_info(mac, resp);
-	ret =3D qtnf_parse_variable_mac_info(mac, resp->var_info, var_data_len);
+	ret =3D qtnf_parse_variable_mac_info(mac, resp, var_data_len);
=20
 out:
 	qtnf_bus_unlock(mac->bus);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wi=
reless/quantenna/qtnfmac/core.c
index ee1b75fda1dd..f04f4e1f7d68 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -499,6 +499,8 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus, =
unsigned int macid)
 	qtnf_mac_iface_comb_free(mac);
 	qtnf_mac_ext_caps_free(mac);
 	kfree(mac->macinfo.wowlan);
+	kfree(mac->rd);
+	mac->rd =3D NULL;
 	wiphy_free(wiphy);
 	bus->mac[macid] =3D NULL;
 }
@@ -665,9 +667,6 @@ void qtnf_core_detach(struct qtnf_bus *bus)
 		destroy_workqueue(bus->workqueue);
 	}
=20
-	kfree(bus->hw_info.rd);
-	bus->hw_info.rd =3D NULL;
-
 	qtnf_trans_free(bus);
 }
 EXPORT_SYMBOL_GPL(qtnf_core_detach);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wi=
reless/quantenna/qtnfmac/core.h
index a31cff46e964..1b983ec9afcc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -112,6 +112,7 @@ struct qtnf_wmac {
 	struct cfg80211_scan_request *scan_req;
 	struct mutex mac_lock;	/* lock during wmac speicific ops */
 	struct delayed_work scan_timeout;
+	struct ieee80211_regdomain *rd;
 };
=20
 struct qtnf_hw_info {
@@ -120,7 +121,6 @@ struct qtnf_hw_info {
 	u8 mac_bitmap;
 	u32 fw_ver;
 	u32 hw_capab;
-	struct ieee80211_regdomain *rd;
 	u8 total_tx_chain;
 	u8 total_rx_chain;
 	char fw_version[ETHTOOL_FWVERS_LEN];
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index ca84684a1a93..6951f6370985 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -6,7 +6,7 @@
=20
 #include <linux/ieee80211.h>
=20
-#define QLINK_PROTO_VER		14
+#define QLINK_PROTO_VER		15
=20
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -771,6 +771,18 @@ struct qlink_resp {
 } __packed;
=20
 /**
+ * enum qlink_dfs_regions - regulatory DFS regions
+ *
+ * Corresponds to &enum nl80211_dfs_regions.
+ */
+enum qlink_dfs_regions {
+	QLINK_DFS_UNSET	=3D 0,
+	QLINK_DFS_FCC	=3D 1,
+	QLINK_DFS_ETSI	=3D 2,
+	QLINK_DFS_JP	=3D 3,
+};
+
+/**
  * struct qlink_resp_get_mac_info - response for QLINK_CMD_MAC_INFO comman=
d
  *
  * Data describing specific physical device providing wireless MAC
@@ -785,6 +797,10 @@ struct qlink_resp {
  * @bands_cap: wireless bands WMAC can operate in, bitmap of &enum qlink_b=
and.
  * @max_ap_assoc_sta: Maximum number of associations supported by WMAC.
  * @radar_detect_widths: bitmask of channels BW for which WMAC can detect =
radar.
+ * @alpha2: country code ID firmware is configured to.
+ * @n_reg_rules: number of regulatory rules TLVs in variable portion of th=
e
+ *	message.
+ * @dfs_region: regulatory DFS region, one of @enum qlink_dfs_region.
  * @var_info: variable-length WMAC info data.
  */
 struct qlink_resp_get_mac_info {
@@ -798,23 +814,14 @@ struct qlink_resp_get_mac_info {
 	__le16 radar_detect_widths;
 	__le32 max_acl_mac_addrs;
 	u8 bands_cap;
+	u8 alpha2[2];
+	u8 n_reg_rules;
+	u8 dfs_region;
 	u8 rsvd[1];
 	u8 var_info[0];
 } __packed;
=20
 /**
- * enum qlink_dfs_regions - regulatory DFS regions
- *
- * Corresponds to &enum nl80211_dfs_regions.
- */
-enum qlink_dfs_regions {
-	QLINK_DFS_UNSET	=3D 0,
-	QLINK_DFS_FCC	=3D 1,
-	QLINK_DFS_ETSI	=3D 2,
-	QLINK_DFS_JP	=3D 3,
-};
-
-/**
  * struct qlink_resp_get_hw_info - response for QLINK_CMD_GET_HW_INFO comm=
and
  *
  * Description of wireless hardware capabilities and features.
@@ -826,11 +833,7 @@ enum qlink_dfs_regions {
  * @mac_bitmap: Bitmap of MAC IDs that are active and can be used in firmw=
are.
  * @total_tx_chains: total number of transmit chains used by device.
  * @total_rx_chains: total number of receive chains.
- * @alpha2: country code ID firmware is configured to.
- * @n_reg_rules: number of regulatory rules TLVs in variable portion of th=
e
- *	message.
- * @dfs_region: regulatory DFS region, one of @enum qlink_dfs_region.
- * @info: variable-length HW info, can contain QTN_TLV_ID_REG_RULE.
+ * @info: variable-length HW info.
  */
 struct qlink_resp_get_hw_info {
 	struct qlink_resp rhdr;
@@ -844,9 +847,6 @@ struct qlink_resp_get_hw_info {
 	u8 mac_bitmap;
 	u8 total_tx_chain;
 	u8 total_rx_chain;
-	u8 alpha2[2];
-	u8 n_reg_rules;
-	u8 dfs_region;
 	u8 info[0];
 } __packed;
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/=
net/wireless/quantenna/qtnfmac/qlink_util.c
index 8cae9d8d1ab6..1a972bce7b8b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -237,3 +237,65 @@ u32 qlink_utils_chflags_cfg2q(u32 cfgflags)
=20
 	return flags;
 }
+
+static u32 qtnf_reg_rule_flags_parse(u32 qflags)
+{
+	u32 flags =3D 0;
+
+	if (qflags & QLINK_RRF_NO_OFDM)
+		flags |=3D NL80211_RRF_NO_OFDM;
+
+	if (qflags & QLINK_RRF_NO_CCK)
+		flags |=3D NL80211_RRF_NO_CCK;
+
+	if (qflags & QLINK_RRF_NO_INDOOR)
+		flags |=3D NL80211_RRF_NO_INDOOR;
+
+	if (qflags & QLINK_RRF_NO_OUTDOOR)
+		flags |=3D NL80211_RRF_NO_OUTDOOR;
+
+	if (qflags & QLINK_RRF_DFS)
+		flags |=3D NL80211_RRF_DFS;
+
+	if (qflags & QLINK_RRF_PTP_ONLY)
+		flags |=3D NL80211_RRF_PTP_ONLY;
+
+	if (qflags & QLINK_RRF_PTMP_ONLY)
+		flags |=3D NL80211_RRF_PTMP_ONLY;
+
+	if (qflags & QLINK_RRF_NO_IR)
+		flags |=3D NL80211_RRF_NO_IR;
+
+	if (qflags & QLINK_RRF_AUTO_BW)
+		flags |=3D NL80211_RRF_AUTO_BW;
+
+	if (qflags & QLINK_RRF_IR_CONCURRENT)
+		flags |=3D NL80211_RRF_IR_CONCURRENT;
+
+	if (qflags & QLINK_RRF_NO_HT40MINUS)
+		flags |=3D NL80211_RRF_NO_HT40MINUS;
+
+	if (qflags & QLINK_RRF_NO_HT40PLUS)
+		flags |=3D NL80211_RRF_NO_HT40PLUS;
+
+	if (qflags & QLINK_RRF_NO_80MHZ)
+		flags |=3D NL80211_RRF_NO_80MHZ;
+
+	if (qflags & QLINK_RRF_NO_160MHZ)
+		flags |=3D NL80211_RRF_NO_160MHZ;
+
+	return flags;
+}
+
+void qlink_utils_regrule_q2nl(struct ieee80211_reg_rule *rule,
+			      const struct qlink_tlv_reg_rule *tlv)
+{
+	rule->freq_range.start_freq_khz =3D le32_to_cpu(tlv->start_freq_khz);
+	rule->freq_range.end_freq_khz =3D le32_to_cpu(tlv->end_freq_khz);
+	rule->freq_range.max_bandwidth_khz =3D
+		le32_to_cpu(tlv->max_bandwidth_khz);
+	rule->power_rule.max_antenna_gain =3D le32_to_cpu(tlv->max_antenna_gain);
+	rule->power_rule.max_eirp =3D le32_to_cpu(tlv->max_eirp);
+	rule->dfs_cac_ms =3D le32_to_cpu(tlv->dfs_cac_ms);
+	rule->flags =3D qtnf_reg_rule_flags_parse(le32_to_cpu(tlv->flags));
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/=
net/wireless/quantenna/qtnfmac/qlink_util.h
index 9d10a2098ca7..f873beed2ae7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -82,5 +82,7 @@ void qlink_acl_data_cfg2q(const struct cfg80211_acl_data =
*acl,
 enum qlink_band qlink_utils_band_cfg2q(enum nl80211_band band);
 enum qlink_dfs_state qlink_utils_dfs_state_cfg2q(enum nl80211_dfs_state st=
ate);
 u32 qlink_utils_chflags_cfg2q(u32 cfgflags);
+void qlink_utils_regrule_q2nl(struct ieee80211_reg_rule *rule,
+			      const struct qlink_tlv_reg_rule *tlv_rule);
=20
 #endif /* _QTN_FMAC_QLINK_UTIL_H_ */
--=20
2.11.0

