Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010031.outbound.protection.outlook.com [52.101.84.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A230D3FD
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 05:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179089; cv=fail; b=dBNWca/J5lM//qfvqaoH1HkZH1fiSgF1+ea2e7EduoiwxR5yTmJTOhsRlQuSbzgJtuSpF18BPfZ7Zrb8q6hOGQzjIu/jbelM6BrbVM0g7RKLaryzjEduDWLWoOfZ9njS166ZLhkix/b46iMYMhk8gL9Zrqgv3+jgoWAlC6rRqps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179089; c=relaxed/simple;
	bh=6DXv6zYZJepTSWo3x6LXOqho5dJDVsL8i0YOdjZ2eTw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EEQgAHiWKfujCfmXxGX/k/sJG9JXVA6ofjXbjWrJd5Hirq+tzCV0hepJDcF5pZbuiN0d4B47owX6d6mFJzzOOLtoOqZvUHuWDKAnyeNXOPyDGDBRp5d6oNedJJme7oifZi6R9B5rhGqySBmkoZqiGNWAh5IqFJwueV1f2B5VRvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=db+h+gg9; arc=fail smtp.client-ip=52.101.84.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="db+h+gg9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PpYtiUJBenglj5AQty35yG9o0yMU0Mm9Be9UYGEnv9dxGNi3LaWPS8X6H6Sbi1QgoSMAyw/GOjm3scpw9Dz1kBV6QSxE3JE8D8nNa+2WCZGNHPnsH+y//CbmsHB5nii8St9fSXuWinoUsTQ7ZYEnHIDWr6FEgTJFSJtYDGysqMVoKJW0IcLAQDcdt2pFUud5H+RHWscO6bmIb+/3zQ67AV0al4zIdvXIeRnBcZiCeJyDXw+5zdW5X+Tzji+xhu4+SlrbrvMDdFhkh2yPEj32FqKr3W1C57/eOI9JyWMPin63gcgppxthCbEhr9FMhKEteG7o5i4cRGd9XFeVGgEVyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2RTORvXwR4N76mCr5wYOgUR/AaEXMEF91gBrs1IQR8=;
 b=kTWs0WWCL70kyYO0r23bfDF+tpgI/VPThn1McDMbkAiAik9VkgPu+Cp2XH5aVuVJqg7nzNMMbYq0yw2UEXfbKiT4oJwdpWKdsSYCrwRZxZFmbh9h4YeW+nbRVSO0IAsDW1XTc/XqAotDn+i4zfBk9Xfuz9tyZYvFLYf5PbJJZ3PU3HRcYPjoMNfw2qsCuHduqga8Rf48ihLcHJOF6XB245VZghlnd0kne8KkmspGhsc2xbVXHBqnuFGy0+bmxRIKnJ+uaMoLNNCvHDc7btAkN6tSmJ3Qg+qNxuN+aGbXAs06KveBgwFqo4nbGAN2grh02b3iz5SAGUmmn9RLWGAKPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2RTORvXwR4N76mCr5wYOgUR/AaEXMEF91gBrs1IQR8=;
 b=db+h+gg9iIp6eZ7AZNcScNO7uzseuews84r5gEZhMMwzymgdEVuy98H/6UT6TVLAopC/bEl5xp7Ob3A7gljEu3zaCXPp3D8GCiZTosl7wAAoYrK7SPbkh3/fzbw9qzPMYHUZDos7Zboy3vnjEnqo7FRlVqwL6i/GAUZ/k3O5+GtyLZNCWhZvWURLObrbBrNz6+fzlPLZVab1IRm8cL9HlsGB6sjCAaXw2Pbs0rz2Brj9JZ7FQhIAqzB//Xr0s2ypVEuzpZfmuZQ3JreR92nORV+b+TOemsNqgxn8XTuLvRmxNGN914lH0f2clHvA56vT8cbk5sFTvk0yvDrA3CF/7g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by OSMPR04MB11293.eurprd04.prod.outlook.com (2603:10a6:e10:93::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 05:44:45 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Mon, 5 Oct 2026
 05:44:45 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	kees+treewide@kernel.org,
	arend.vanspriel@broadcom.com,
	benjamin.berg@intel.com,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next v3 3/3] wifi: nxpwifi: add netlink vendor command for TX power limits
Date: Mon,  5 Oct 2026 13:44:14 +0800
Message-Id: <20261005054414.2874415-4-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261005054414.2874415-1-jeff.chen_1@oss.nxp.com>
References: <20261005054414.2874415-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR5P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::17) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|OSMPR04MB11293:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d7d5e39-e6a5-49ab-ab0b-08df22a3c29f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|11063799006|6133799003|10067099003|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	KwoyQ5mWbU9MAiAYhueDzM6sr9DSHcXl5Dn3DAeV9nTgY+S+yGzvTfCZb9yGcgmvJSDo0aumWkUx49mn0NlqY3IOocn+L3imx6KJTkT49iAAGzqhu976/hXTiJ+I7Yfr6CNzpL51SyWRScQ5DD9musPX4neymxA+X0rTuqUGpZYexD5Sk3qkRJ+XDHt5d4jSZtQXA76ODQ8nUAfcEyD9O6fR0LEubozxHs4ZOX6ILP79UTiQ4O60nh80CGAD3w7NZ4bM3r8yolohRfwamyZ1565fjSIxJOb4z7Z3DYK3XZp+A1o41/LYiV/40YB3DCLTbqiz8w3i4Kqbp38TDLjUWF1yQEwIo/YbD84cWbenq3oIkjm+zpA7NeIFReoStfUMqPdQcbDiUB9HH7LY7bTopFIJsxR/YEfIPGpE/hOKTdXe7lZjMi5D16/3p/b2AgykUpuLoOlvK/sFZHnmoBWGKtmCyC1ffhPJrXwb9qjisBUcuWOl05Anu5c96OoaOzs3Hj3VbBYF2OT2QV0aDjEkE2P0/yj62RPiPjgmiF6mAsGhfaiq5R44t67Ayt8/rNbMnQGQWpV22gpgHV4BDcRHtGsm2HHKFa/v4WSFkWBotDkhZ1TwWtdms2v/g98bCi4zIrFeKsA7k43soeYaiMeOFzeKzpeJRjMlnY7KMiOqL3g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(11063799006)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ANB1ljTGMyXNYrk1cECU3lgEWMQFJ4FDOWIDk8Il5weAav1NQP6QSNPmid+w?=
 =?us-ascii?Q?a8qsKCvdV2roPM3KWFfmxQBlUNrlknJqOMECXaj9tIU7y+h4y660KxNoaiRP?=
 =?us-ascii?Q?HsNMdULEG3t/+ZtJ8n3hxm85c25St7isUjbkvtimXhvddS68wUCJXLa6EZ9Y?=
 =?us-ascii?Q?MIYsDGqZwxpAgM54lJmpjudcCl3bN8YFnzWtqfiZJbZMhQokLyw2p8CXrN9n?=
 =?us-ascii?Q?xIsGCDo189tKmv6Wdt3UyEDsWR67ABppEeacB636n480aTGcRqk+T1id2KKx?=
 =?us-ascii?Q?OpK24EmrX329pc6CcmMrgNjh2r8s5hxLneRjwpjM4gLK7j9Sz6UQlfBdc8p1?=
 =?us-ascii?Q?4H76z0qrErBPRknnLuAQxXI8NqoXOM/gRBQ4bCAHaVTbkwbD/eRDjXV1TI6d?=
 =?us-ascii?Q?hy6rB/cM/2+qTN+6ve63IFCsjsViMC6o+LcI/6ogcWcpE/Ed0foFTgCR0QoJ?=
 =?us-ascii?Q?R/tVHEyny3DV4KgRvPgWQQTM7jUg2WfKJKzDROQm16p4cNQBTiBb8otB4cKo?=
 =?us-ascii?Q?3HSmzmfsyfec7zisleZDkDmOKX364B4Q7BhqOy1bhhaKBmtZeVLs7M73UJH6?=
 =?us-ascii?Q?ZnLu5jQ2VL8ypz6Oo6ktYNVjZ7osfLpnxTWg/6bI4h5Z1oALf4WIr3Tb7yR+?=
 =?us-ascii?Q?Catwkti1u6OJLsJ9JzgiyRFNGdM+fPNPsS332YyopmUDTc/YyYQ+WDgsH0MT?=
 =?us-ascii?Q?HQkbH3v9dfkd9yHZbotsI78nv4JKNbgzc52LbtTaC8SFOpoohTAOCdoAKjgD?=
 =?us-ascii?Q?3OwgqK8L2grxBHU+NcDZmSQGntfD9fYAg/xYIENR0Tl43ohQTjJiYeqsGuQX?=
 =?us-ascii?Q?UBT5vNN3nQ2OWMF2JdPZHE5uAQqVTlQJzvfeAW5F9Q7q+RrnBU+Q1gOZfzgn?=
 =?us-ascii?Q?RxNPp0qKFMBVhKaPRq2H+P5X5nkFuwa7kCoa6Q1llV9e+9KMBkG6a3xHI2VI?=
 =?us-ascii?Q?p+bUBBC1iWffL6xjqyi/PULGRgm2yoB2UuubQUescrSDOqZZZdB54MJQU4T5?=
 =?us-ascii?Q?L2S4ORsKDlJFnx4sTk44Bv6SA9fZISptxnWQDG+tEnOVehqhc1kJUlftHy4G?=
 =?us-ascii?Q?FPZiCRqaXhbVLLwHZEhMoHoQkRE9QrO43RZR6LLmuJe1+CEDR1Ctn01eiKHl?=
 =?us-ascii?Q?GwOXF/9Cpio9lEjL3hjFvkFJ6eRpwOY9leuw8sZyUoSAgrWhC6djlBc5JDz9?=
 =?us-ascii?Q?EefCeZu/+RyxOfmQrJoTUI2/wIWqwXuCncAQbO782GXcUh/QuPFChaqTty5r?=
 =?us-ascii?Q?CB4yOdYZSGVz2RO9XTcv2c5x6aXxQnpRIiazqfdwW326K39ZAJJDUGF6gGTW?=
 =?us-ascii?Q?CEn2X1q+PzD7a3GOV2+D1Q0GObmf7mWWIQkIiNfi3Th3+sgMGdMAMTRQoW60?=
 =?us-ascii?Q?2gx2uSevin3g8XKDAB7vF199nogGOW19F8ktOUyzouYkaRE6PhUK2nZ38oEt?=
 =?us-ascii?Q?Dhyj7QfziH6ZJs0FQa3wDvhrrvbo7ZWVgHq7Pt+ss5qAShsYE3erNgsLRVgy?=
 =?us-ascii?Q?xod9Uf7sncLW3ZoTNcHbXdva1OiChhdvQBE3Aa5i+UKXzMH7UODcdHV3Eyj7?=
 =?us-ascii?Q?jQ67HlHjgU8BytX0DfPaAOp3bZTj11BXjgMWUmvB/FzJlsBMc3nH2r79mVPq?=
 =?us-ascii?Q?JPMW/0sCP565Q1MRQcFkQ8zvVZMOluU59nm6XlVoWR7bhIq33HAUwnqw90F2?=
 =?us-ascii?Q?+EGHltKsegQidIW0/tx0UMIBeiEgeW6VpQgZjYSmS/gvn0c97TalbeDvjaZT?=
 =?us-ascii?Q?YdP7ZSs0rBkMeEXMN2U2U6IBIDG1TW9Ez3aDLtWV5ulwJW1I6f+0?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7d5e39-e6a5-49ab-ab0b-08df22a3c29f
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 05:44:45.1439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYy9nJy7DyjCMjs+e+/q/Uasi5FMzzChukwdM+A29Q2OR/egALzbRjFYM2e/mQmahFuEJPqS5HO+r0iu5Eh9U49mDvlopGK4Ukny+3Xt8hG3ohdOdSky4mF5cMbFmrGa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSMPR04MB11293

From: Jeff Chen <jeff.chen_1@nxp.com>

Add support for the NXP TX power limit vendor command.

The command provides userspace access to firmware Transmit Rate-based
Power Control (TRPC) configuration through NL80211_CMD_VENDOR.

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/Makefile   |   1 +
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c |   5 +-
 drivers/net/wireless/nxp/nxpwifi/main.h     |   1 +
 drivers/net/wireless/nxp/nxpwifi/vendor.c   | 152 ++++++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/vendor.h   |  14 ++
 5 files changed, 172 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/vendor.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/vendor.h

diff --git a/drivers/net/wireless/nxp/nxpwifi/Makefile b/drivers/net/wireless/nxp/nxpwifi/Makefile
index 8f581429f28d..f82435253a72 100644
--- a/drivers/net/wireless/nxp/nxpwifi/Makefile
+++ b/drivers/net/wireless/nxp/nxpwifi/Makefile
@@ -28,6 +28,7 @@ nxpwifi-y += sta_tx.o
 nxpwifi-y += sta_rx.o
 nxpwifi-y += uap_txrx.o
 nxpwifi-y += cfg80211.o
+nxpwifi-y += vendor.o
 nxpwifi-y += ethtool.o
 nxpwifi-y += 11h.o
 nxpwifi-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 8805439c0b4b..16b970227e9c 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -10,6 +10,7 @@
 #include "cmdevt.h"
 #include "11n.h"
 #include "wmm.h"
+#include "vendor.h"
 
 static const struct ieee80211_iface_limit nxpwifi_ap_sta_limits[] = {
 	{
@@ -91,7 +92,7 @@ u8 nxpwifi_get_chan_type(struct nxpwifi_private *priv)
 }
 
 /* Retrieve the driver private data from the wiphy */
-static void *nxpwifi_cfg80211_get_adapter(struct wiphy *wiphy)
+void *nxpwifi_cfg80211_get_adapter(struct wiphy *wiphy)
 {
 	return (void *)(*(unsigned long *)wiphy_priv(wiphy));
 }
@@ -3834,6 +3835,8 @@ int nxpwifi_register_cfg80211(struct nxpwifi_adapter *adapter)
 	wiphy->cipher_suites = nxpwifi_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(nxpwifi_cipher_suites);
 
+	nxpwifi_set_vendor_commands(wiphy);
+
 	if (adapter->regd) {
 		wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
 					   REGULATORY_DISABLE_BEACON_HINTS |
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.h b/drivers/net/wireless/nxp/nxpwifi/main.h
index 9ae017bdc6ca..bbfc4266c48d 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.h
+++ b/drivers/net/wireless/nxp/nxpwifi/main.h
@@ -1435,4 +1435,5 @@ void nxpwifi_dev_debugfs_remove(struct nxpwifi_private *priv);
 int nxpwifi_reinit_sw(struct nxpwifi_adapter *adapter);
 void nxpwifi_shutdown_sw(struct nxpwifi_adapter *adapter);
 bool nxpwifi_is_valid_region_code(enum nxpwifi_region_code code);
+void *nxpwifi_cfg80211_get_adapter(struct wiphy *wiphy);
 #endif /* !_NXPWIFI_MAIN_H_ */
diff --git a/drivers/net/wireless/nxp/nxpwifi/vendor.c b/drivers/net/wireless/nxp/nxpwifi/vendor.c
new file mode 100644
index 000000000000..3f1834cf8844
--- /dev/null
+++ b/drivers/net/wireless/nxp/nxpwifi/vendor.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * NXP Wireless LAN device driver: vendor command interface
+ *
+ * Copyright 2026 NXP
+ */
+
+#include <net/mac80211.h>
+#include <net/netlink.h>
+#include "vendor.h"
+#include "main.h"
+
+/* Attributes for NXP_VENDOR_CMD_TXPOWER_LIMIT. */
+static const struct nla_policy
+nxpwifi_txpwrlimit_policy[NXP_ATTR_TXPWRLIMIT_MAX + 1] = {
+	[NXP_ATTR_TXPWRLIMIT_ACTION] =
+		NLA_POLICY_MAX(NLA_U8, NXP_TXPWRLIMIT_ACTION_SET),
+	[NXP_ATTR_TXPWRLIMIT_SUBBAND] = { .type = NLA_U8 },
+	[NXP_ATTR_TXPWRLIMIT_DATA] = { .type = NLA_BINARY,
+				       .len  = NXPWIFI_MAX_TRPC_BUF },
+};
+
+static bool nxpwifi_txpwrlimit_subband_valid(u8 subband)
+{
+	switch (subband) {
+	case NXP_TXPWRLIMIT_SUBBAND_2G:
+	case NXP_TXPWRLIMIT_SUBBAND_5G_0:
+	case NXP_TXPWRLIMIT_SUBBAND_5G_1:
+	case NXP_TXPWRLIMIT_SUBBAND_5G_2:
+	case NXP_TXPWRLIMIT_SUBBAND_5G_3:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int nxpwifi_vendor_txpower_limit(struct wiphy *wiphy,
+					struct wireless_dev *wdev,
+					const void *data, int data_len)
+{
+	struct nxpwifi_adapter *adapter = nxpwifi_cfg80211_get_adapter(wiphy);
+	struct nlattr *tb[NXP_ATTR_TXPWRLIMIT_MAX + 1];
+	struct nxpwifi_ds_chan_trpc_cfg *ch_trpc;
+	struct nxpwifi_private *priv;
+	struct sk_buff *resp;
+	u8 action, subband = 0;
+	u16 tlv_len = 0;
+	int ret;
+
+	ret = nla_parse(tb, NXP_ATTR_TXPWRLIMIT_MAX, data, data_len,
+			nxpwifi_txpwrlimit_policy, NULL);
+	if (ret)
+		return ret;
+
+	if (!tb[NXP_ATTR_TXPWRLIMIT_ACTION])
+		return -EINVAL;
+	action = nla_get_u8(tb[NXP_ATTR_TXPWRLIMIT_ACTION]);
+
+	if (tb[NXP_ATTR_TXPWRLIMIT_SUBBAND]) {
+		subband = nla_get_u8(tb[NXP_ATTR_TXPWRLIMIT_SUBBAND]);
+		if (!nxpwifi_txpwrlimit_subband_valid(subband))
+			return -EINVAL;
+	} else if (action == NXP_TXPWRLIMIT_ACTION_GET) {
+		/* A subband selector is required for GET operations. */
+		return -EINVAL;
+	}
+
+	if (action == NXP_TXPWRLIMIT_ACTION_SET) {
+		if (!tb[NXP_ATTR_TXPWRLIMIT_DATA])
+			return -EINVAL;
+		tlv_len = nla_len(tb[NXP_ATTR_TXPWRLIMIT_DATA]);
+	}
+
+	priv = nxpwifi_get_priv(adapter, NXPWIFI_BSS_ROLE_STA);
+	if (!priv)
+		return -ENODEV;
+
+	/* Reserve space for the returned TRPC table on GET requests. */
+	ch_trpc = kzalloc_flex(*ch_trpc, tlvbuffer,
+			       (action == NXP_TXPWRLIMIT_ACTION_SET) ?
+			       tlv_len : NXPWIFI_MAX_TRPC_BUF, GFP_KERNEL);
+	if (!ch_trpc)
+		return -ENOMEM;
+
+	ch_trpc->action = (action == NXP_TXPWRLIMIT_ACTION_SET) ?
+			  HOST_ACT_GEN_SET : HOST_ACT_GEN_GET;
+	ch_trpc->subband = subband;
+
+	if (tlv_len)
+		memcpy(ch_trpc->tlvbuffer,
+		       nla_data(tb[NXP_ATTR_TXPWRLIMIT_DATA]), tlv_len);
+
+	ch_trpc->len = sizeof(ch_trpc->action) + sizeof(ch_trpc->subband) +
+		       tlv_len;
+
+	ret = nxpwifi_chan_trpc_cfg(priv, NXPWIFI_SYNC_CMD, ch_trpc);
+	if (ret)
+		goto done;
+
+	if (action == NXP_TXPWRLIMIT_ACTION_GET) {
+		u16 hdr_len = sizeof(ch_trpc->action) +
+			      sizeof(ch_trpc->subband);
+		u16 resp_len, skb_len;
+
+		if (ch_trpc->len < hdr_len ||
+		    ch_trpc->len > hdr_len + NXPWIFI_MAX_TRPC_BUF) {
+			ret = -EIO;
+			goto done;
+		}
+
+		resp_len = ch_trpc->len - hdr_len;
+		skb_len = nla_total_size(resp_len);
+
+		resp = cfg80211_vendor_cmd_alloc_reply_skb(wiphy, skb_len);
+		if (!resp) {
+			ret = -ENOMEM;
+			goto done;
+		}
+
+		if (nla_put(resp, NXP_ATTR_TXPWRLIMIT_DATA, resp_len,
+			    ch_trpc->tlvbuffer)) {
+			kfree_skb(resp);
+			ret = -ENOBUFS;
+			goto done;
+		}
+
+		ret = cfg80211_vendor_cmd_reply(resp);
+	}
+
+done:
+	kfree(ch_trpc);
+	return ret;
+}
+
+static const struct wiphy_vendor_command nxpwifi_vendor_commands[] = {
+	{
+		.info = {
+			.vendor_id = NXP_OUI,
+			.subcmd = NXP_VENDOR_CMD_TXPOWER_LIMIT,
+		},
+		.flags = 0,
+		.doit = nxpwifi_vendor_txpower_limit,
+		.policy = nxpwifi_txpwrlimit_policy,
+		.maxattr = NXP_ATTR_TXPWRLIMIT_MAX,
+	},
+};
+
+void nxpwifi_set_vendor_commands(struct wiphy *wiphy)
+{
+	wiphy->vendor_commands = nxpwifi_vendor_commands;
+	wiphy->n_vendor_commands = ARRAY_SIZE(nxpwifi_vendor_commands);
+}
diff --git a/drivers/net/wireless/nxp/nxpwifi/vendor.h b/drivers/net/wireless/nxp/nxpwifi/vendor.h
new file mode 100644
index 000000000000..fdde8e1a7a40
--- /dev/null
+++ b/drivers/net/wireless/nxp/nxpwifi/vendor.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * NXP Wireless LAN device driver: vendor command interface
+ *
+ * Copyright 2026 NXP
+ */
+
+#ifndef __NXPWIFI_VENDOR_H__
+#define __NXPWIFI_VENDOR_H__
+
+#include <uapi/linux/nl80211-vnd-nxp.h>
+
+void nxpwifi_set_vendor_commands(struct wiphy *wiphy);
+#endif /* __NXPWIFI_VENDOR_H__ */
-- 
2.34.1

