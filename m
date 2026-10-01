Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010033.outbound.protection.outlook.com [52.101.84.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B1D4DEC10
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 10:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790849245; cv=fail; b=G1gR+pyoQyBzzalHwIzATUqdj15LNfSb/W+AudJSM0Qmjqy9BmuHxQPW/TJnhfylqkGfixF35lzVrpYLp1wecH53CuAPwftCzGbjLnuIQVgHnxuIFbSCL0ajONLZhuPc0vAwr5DUtG95svvh3WsVx9FN+8/zScIreOxQxXfXP9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790849245; c=relaxed/simple;
	bh=eYj0rx6gafLmJs6xud1u/A6BnADBHhrOYWOFZkofJcc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z1RZB0ZlMoxVaSqT5IUEjIV8ncoZUGqOXacYimCQimdnz68gD22whw7OD8hgFCUd+JgI/hoxHykeS4uatvEym2mtHDeKqSQrz15YG06zRxZwymuvb2JqOWL7tYhdUMJmvi4zjsFGEO8UhKUHNTesQWfLxY9SmPxCBszZQykfBhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=FdPRozL+; arc=fail smtp.client-ip=52.101.84.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="FdPRozL+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xEFOdHvsX9MLcxHMQOcpIgYoB4x16TO3kxP8O/sRHjXRo7L2zWhHu6iBcXZCKaUI6+z2zpPShU+mJQYBj0zrHag3A3pgQ8F7uk4gUoywBSL4JBJuKHrEFm8JvjzbncpgpspIFmqWYvPPEd5xu+HOXUcVx50p+ag8NJdFF+Csk3Yl3dL2oHZF2TLfXIO6diVbrPIL+eug7z17ght6FOajh/yqE7aWBIQMT9DsXkIgt8xgeBzbSai50zY2xIKK7TvGaFjZBQoOR2PhZ3qQAVnaUBz4YG5DjZxlkgA/85CE7rRFK8NPm7zEn+y08mxlFPKjkP2eB0s+5tmr+OeFPJTx5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grdG8p6BMqbADLD0kfQQhwD3PivV8C6dgEt0b0avA3w=;
 b=U1de1i7ttfdXpHsdgfxwiXWAKDiyD1Zaf2zTUOwNo337iQDi2a+j79dh8S5vssKws3NQbStZHg97tUupkclycDNRen+8JDS/V8VufxkhJBr+uZvCjuCj9Ay6mQQXUiHekhtXNrRshbMDpRtf7jR+1qh3L5OscfckkXi6/eGwtA2a254iagMtXItT2bAARkIuiGd5rATvGeEbV1vwl9GpdVfZFPJKv3oXXS2AiHmgg6CjPv5loBtCm91x4N6MHs8SMDpx9dkCDvvPk8n/x1QgQqOuMu4kbMNcgX+urcOjaMAAoUEOFfO7FyP61wnrsn8uO/r+9lF6HlT8m84hyt6imQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grdG8p6BMqbADLD0kfQQhwD3PivV8C6dgEt0b0avA3w=;
 b=FdPRozL+/hV6PO1NMNayYT1HmehcYDNVxHiJ1ryKxGwRP8Eq65r5rg+3xG6Eq/KGSD6sNMbWhs8HP7cFUSGEEg4sHZiI/7oM0ugLYaCj7wCO6SWIysTJegygbWWygR0wJMRrgh8+s4f2ZCpvKzMjmziZB04O66za2DAlSfeSeNj680p+nIuOTBNYhL8OiER+vnf5g2KmuYZOcAc+UFYHmm52a0gZvZ6q0O9luLXk5IviHTGYe3isyQIBBjPezzNU1AlYcHiSZVl8sW8RdC7dpuFvjkyFtN9u961/7nUzyo1w15W/VuCDoZGbEwamIos9CjnQUW9oPE2CBgv6YPAa9Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by FRWPR04MB11282.eurprd04.prod.outlook.com (2603:10a6:d10:19e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Thu, 1 Oct
 2026 10:07:16 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Thu, 1 Oct 2026
 10:07:16 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH 2/2] wifi: nxpwifi: add netlink vendor command for TX power limits
Date: Thu,  1 Oct 2026 18:06:40 +0800
Message-Id: <20261001100640.2829946-3-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001100640.2829946-1-jeff.chen_1@oss.nxp.com>
References: <20261001100640.2829946-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:295::6) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|FRWPR04MB11282:EE_
X-MS-Office365-Filtering-Correlation-Id: 2902cebf-aa47-4031-a55d-08df1fa3c595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|23010399003|6133799003|22082099003|18002099003|10067099003|3023799007|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	uE8sKYr8iWB/iCdN/QJHdNX/Mjg7I0IrDQ/nyA0o3TdJ5Er3pJWY96OgH3on/f3gAM75avVELDfaisVzUw39Kdfj5oI1PfUbgDuFWt0Hm7u56T9wFMf9tgojh3+vz5/Gz3aLBPIdcpfRLc1yxpfNCHugWZ8X1gH+xAdYfZzkVCJzfI3R3tg7SbZeAQfGhjSYw//BPCLpu8cLwwkgxhka5tZnenPxdTsX3SCnrWQbFUed8/MNBMuRgJISGlcAJ+BTBX8vgVPaJ2Ljc4snJXzpAgUS1NBHkiGI8PodDSdosmipBz+FU1f3N5sggRCdAp99bPpVH58mz+f7g9bnImrdaA4DEOgLezKjr015ki86CDFmY4+KhbL6jBIyWuYeLo/PDdVZNMbtJdVA+nlAOrkKzucwniP4p1qQtLlYhgORY9oUjpubqp2q4mFa3/CD2k8UTPz+0aB/Te4+kffVmv2u8E+VJGPoUh2nJeKURM/+NycpMVdOz3gTNVoM68R0GFc6GZj/EM8m9GVzVEjAZ0TlQftFX3uuwGuQIzCvSF/pRVqgRAoKRHEq8bnEpAxS89z90KoCpjBvyjSPnK4z4bsDpJfVnAtQXkwGY5+1P8siFQDgIOPEx6gVGCXxbF2RoV0bSalWrwx9HPH7vjp0lr0YSTDedYnzsDZUR3FDI4wXSmM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(23010399003)(6133799003)(22082099003)(18002099003)(10067099003)(3023799007)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D6TOGNli1zwNykyVhM+u6uDW/61D2j2tHuCe1++k551vgfrWuYtJsJL8gtzg?=
 =?us-ascii?Q?EImErCcw5HkZcr/GOH/d5lb0bjYqg7Aw2CWXa+R3DapJMq2BaKAKpSCPmTTM?=
 =?us-ascii?Q?n/rJcbXrNrTrn7+LpjFlcqweM8MR5KBup+5XAgWD62VF07WwH3xEq5MzmFBa?=
 =?us-ascii?Q?yjwaTYGzsHVGS/zQjxIAkc9Kui6Xsv4KbwckCUtayGn18fCNkZtAepn7b0Vo?=
 =?us-ascii?Q?s3pF9KEbxTu23y5nx347POdBvu+oS8QRfSUEqQFI/01gUtZaPLxC0xNnNr4u?=
 =?us-ascii?Q?3nnmEvz8/W5NqKBpxF4oBL6ihDvRrEVXTvPis6sB+rdYJ59IHFG3aeAHd7ew?=
 =?us-ascii?Q?+KjJHCuj/PwCDhpNcjqbk80XiELdhY4dDE1Gdnpn+2Y29ju5VDDtjvMS2/KI?=
 =?us-ascii?Q?CkHAEslzXaqp3TY9DdhLRO44+IxoSb8a/Fn1xDiWyRufSVqCkuDxJh692drf?=
 =?us-ascii?Q?WuzQKKooG6fGlGioX6ol5F9w9QUuUvzvjnQFnU4PgeYH42DPVL0zzgBKGRj7?=
 =?us-ascii?Q?/rwisFw92OcEaManwlhFhCju+J27/LOn3Bvmpa84A55kKIgB5YsfhiNjC/K+?=
 =?us-ascii?Q?VSrITAAsm2Q35K6EIVZEXZbG/AH/9N+qTRUB56DGpENnc7rqdFSetwnFn3xS?=
 =?us-ascii?Q?2LnRA1S9A/ubfxRC5UG4GxLgruf+KPH+fBSjNzGfs17pS1rPOAm/WnhYlLgS?=
 =?us-ascii?Q?yf11kcE6GjeRgImKO+DbEmgtPX0NTTXbOyBDgtoGZh2+DxwI1ECzeqdQ6ugN?=
 =?us-ascii?Q?f94v6R0ljHSatGFZys8Phl/yKcmDvceMxgV6+OrPR+q/4lIcyvhkf4+7rnMD?=
 =?us-ascii?Q?B6tiMlu2OGFCCYMXwi6c78bUNQXoUdB1GAzs9IepsPGue2TIGorGCriGp10q?=
 =?us-ascii?Q?M1XSg4QjqMuuxRrEwAQ0I3RF9ALtcjH0bEFlhBktecvFxAR7QsvXKGiGC1U3?=
 =?us-ascii?Q?VN3vduwEj4GdjsreqG0T/S9zAvs3U5YxwJeNNxEKhjhEbZMxMxzeJk+nexD5?=
 =?us-ascii?Q?7JLLNmUsu4JTn36iHIYUDCF9HAkqz/bPyIsJe+bX5NpbmefUi9QBHSgIKDeB?=
 =?us-ascii?Q?GOEYTIMlZ2AbC2qFKGyyis7qVtd0BBqO9zbdiUTCu2cyHyEmsO83hdRGaOkx?=
 =?us-ascii?Q?ePl8DEHzXr65RhmYgbGI809xxoQYUsd/p6JY01VXJPSnrqp6KjXwlxmm3ZlQ?=
 =?us-ascii?Q?Q8wAkQyU+q3G0ZXbedG2ipWlJt7nsndzRvr+xiogoVUQKhx7m1XidVH0u5rb?=
 =?us-ascii?Q?rtq47OnOHgEwupWP3al3f40eHmg+5+IT1iw4CN0HiHd56s2LGXy+lY1p0Klb?=
 =?us-ascii?Q?wiKvkAeYZ++DbdgOlH7/qZMaFwqyc2P5dDXsMvU7I8Xg32TGaNE7DC+1VqQv?=
 =?us-ascii?Q?1BTFjRoxCystzZEO6pw+72IKhANDOhMtHMoBJSU1mIH+20b38FFYYxEL9q7a?=
 =?us-ascii?Q?IayfOSFNIwyeWhQEVvpt7j44CEeCDGdaWMyRrfOsKu3P//Dy7uyIRLyDXQox?=
 =?us-ascii?Q?iR5jo/VsTV1/v0hPfNpbNcBEK4CINY8n3EwkuzsBzlmeLi26EOfd8GA+Fbrn?=
 =?us-ascii?Q?6GBKP8d03piHoxe22t6yX/NDQWC/yhPZvPBKDOBRVGNJp2Q+n0lWYrprJELz?=
 =?us-ascii?Q?JyV+7572cDLHRFxzT82aoW+yV2CFk9UzXj9pIA9YKypHFq/dSb/WxP5tkr2q?=
 =?us-ascii?Q?js7EDXAWMREJC7SsF/458WSboOetapcw5REfj+6ahhkE0G6sQ2mHWA2LURNT?=
 =?us-ascii?Q?xp6HHXbzzNoG+t6MSphJo3YCAXdj9H9mWuc1CzScSds86aJ/segD?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2902cebf-aa47-4031-a55d-08df1fa3c595
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 10:07:16.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYb3pKKdhfqYzsT20q/pOjeyQrJDXe8L695vpJYEfvArktKmR+q0JOIS8Tr2eNhdBRrA9gGk9OolhdQkjR8YKxSruJfDL9LK7Gl1t8miXljUd32DhmAuBJ3ZmxpKZ2rR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRWPR04MB11282

From: Jeff Chen <jeff.chen_1@nxp.com>

Add a cfg80211 vendor command that allows user space to retrieve and
update firmware TX power limit data through a stable netlink interface.

The firmware exposes TX power limits through the channel TRPC command.
The associated payload is a firmware-defined, chipset-specific table
containing TX power limit information.

The table format is part of the firmware ABI and has no equivalent
representation in the generic nl80211 TX power interface. Therefore,
the payload is carried as an opaque binary attribute through a vendor
command.

The driver forwards the firmware-defined payload between user space and
the firmware without interpreting its contents.

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/Makefile   |   1 +
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c |   5 +-
 drivers/net/wireless/nxp/nxpwifi/main.h     |   1 +
 drivers/net/wireless/nxp/nxpwifi/vendor.c   | 164 ++++++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/vendor.h   |  46 ++++++
 5 files changed, 216 insertions(+), 1 deletion(-)
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
index 000000000000..11cc2d123d3f
--- /dev/null
+++ b/drivers/net/wireless/nxp/nxpwifi/vendor.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * NXP Wireless LAN device driver: vendor command interface
+ *
+ * Copyright 2011-2026 NXP
+ */
+
+#include <net/mac80211.h>
+#include <net/netlink.h>
+#include "vendor.h"
+#include "main.h"
+
+static const struct nla_policy
+nxpwifi_txpwr_policy[NXPWIFI_ATTR_TXPWR_MAX + 1] = {
+	[NXPWIFI_ATTR_TXPWR_ACTION]  = NLA_POLICY_MAX(NLA_U8,
+						      NXPWIFI_TXPWR_ACTION_SET),
+	[NXPWIFI_ATTR_TXPWR_SUBBAND] = { .type = NLA_U8 },
+	[NXPWIFI_ATTR_TXPWR_DATA]    = { .type = NLA_BINARY,
+					 .len  = NXPWIFI_MAX_TRPC_BUF },
+};
+
+/* The subband selector is not a contiguous range: 0x00 selects the 2.4 GHz
+ * band and 0x10..0x13 select the four 5 GHz subbands. Validate it explicitly
+ * instead of relying on a simple min/max policy bound.
+ */
+static bool nxpwifi_txpwr_subband_valid(u8 subband)
+{
+	switch (subband) {
+	case NXPWIFI_TXPWR_SUBBAND_2G:
+	case NXPWIFI_TXPWR_SUBBAND_5G_0:
+	case NXPWIFI_TXPWR_SUBBAND_5G_1:
+	case NXPWIFI_TXPWR_SUBBAND_5G_2:
+	case NXPWIFI_TXPWR_SUBBAND_5G_3:
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
+	struct nlattr *tb[NXPWIFI_ATTR_TXPWR_MAX + 1];
+	struct nxpwifi_ds_chan_trpc_cfg *ch_trpc;
+	struct nxpwifi_private *priv;
+	struct sk_buff *resp;
+	u8 action, subband = 0;
+	u16 tlv_len = 0;
+	int ret;
+
+	ret = nla_parse(tb, NXPWIFI_ATTR_TXPWR_MAX, data, data_len,
+			nxpwifi_txpwr_policy, NULL);
+	if (ret)
+		return ret;
+
+	if (!tb[NXPWIFI_ATTR_TXPWR_ACTION])
+		return -EINVAL;
+	action = nla_get_u8(tb[NXPWIFI_ATTR_TXPWR_ACTION]);
+
+	if (tb[NXPWIFI_ATTR_TXPWR_SUBBAND]) {
+		subband = nla_get_u8(tb[NXPWIFI_ATTR_TXPWR_SUBBAND]);
+		if (!nxpwifi_txpwr_subband_valid(subband))
+			return -EINVAL;
+	} else if (action == NXPWIFI_TXPWR_ACTION_GET) {
+		/* A GET selects which per-subband table to read back, so the
+		 * subband selector is mandatory for a GET.
+		 */
+		return -EINVAL;
+	}
+
+	if (action == NXPWIFI_TXPWR_ACTION_SET) {
+		if (!tb[NXPWIFI_ATTR_TXPWR_DATA])
+			return -EINVAL;
+		tlv_len = nla_len(tb[NXPWIFI_ATTR_TXPWR_DATA]);
+	}
+
+	priv = nxpwifi_get_priv(adapter, NXPWIFI_BSS_ROLE_STA);
+	if (!priv)
+		return -ENODEV;
+
+	/* A SET only needs room for the supplied TLVs; a GET needs room for
+	 * the firmware to write back the full per-subband table.
+	 */
+	ch_trpc = kzalloc_flex(*ch_trpc, tlvbuffer,
+			       (action == NXPWIFI_TXPWR_ACTION_SET) ?
+			       tlv_len : NXPWIFI_MAX_TRPC_BUF, GFP_KERNEL);
+	if (!ch_trpc)
+		return -ENOMEM;
+
+	ch_trpc->action = (action == NXPWIFI_TXPWR_ACTION_SET) ?
+			  HOST_ACT_GEN_SET : HOST_ACT_GEN_GET;
+	ch_trpc->subband = subband;
+	if (tlv_len)
+		memcpy(ch_trpc->tlvbuffer,
+		       nla_data(tb[NXPWIFI_ATTR_TXPWR_DATA]), tlv_len);
+	/* Firmware payload is action + subband followed by the TLV table. */
+	ch_trpc->len = sizeof(ch_trpc->action) + sizeof(ch_trpc->subband) +
+		       tlv_len;
+
+	ret = nxpwifi_chan_trpc_cfg(priv, NXPWIFI_SYNC_CMD, ch_trpc);
+	if (ret)
+		goto done;
+
+	if (action == NXPWIFI_TXPWR_ACTION_GET) {
+		u16 hdr_len = sizeof(ch_trpc->action) +
+			      sizeof(ch_trpc->subband);
+		u16 resp_len, skb_len;
+
+		/* Guard against a malformed firmware response before using
+		 * ch_trpc->len to size the reply.
+		 */
+		if (ch_trpc->len < hdr_len ||
+		    ch_trpc->len > hdr_len + NXPWIFI_MAX_TRPC_BUF) {
+			ret = -EIO;
+			goto done;
+		}
+		resp_len = ch_trpc->len - hdr_len;
+		skb_len = nla_total_size(resp_len);
+
+		resp = cfg80211_vendor_cmd_alloc_reply_skb(wiphy, skb_len);
+		if (!resp) {
+			ret = -ENOMEM;
+			goto done;
+		}
+
+		if (nla_put(resp, NXPWIFI_ATTR_TXPWR_DATA, resp_len,
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
+			.subcmd = NXPWIFI_VENDOR_CMD_TXPOWER_LIMIT,
+		},
+		/* TX power limits are a configuration/calibration setting and
+		 * can be programmed while the interface is down, so no
+		 * WIPHY_VENDOR_CMD_NEED_RUNNING flag is required.
+		 */
+		.flags = 0,
+		.doit = nxpwifi_vendor_txpower_limit,
+		.policy = nxpwifi_txpwr_policy,
+		.maxattr = NXPWIFI_ATTR_TXPWR_MAX,
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
index 000000000000..f962ea520af0
--- /dev/null
+++ b/drivers/net/wireless/nxp/nxpwifi/vendor.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * NXP Wireless LAN device driver: vendor command interface
+ *
+ * Copyright 2011-2026 NXP
+ */
+
+#ifndef __NXPWIFI_VENDOR_H__
+#define __NXPWIFI_VENDOR_H__
+
+#define NXP_OUI	0x006037
+
+enum nxpwifi_vendor_commands {
+	NXPWIFI_VENDOR_CMD_TXPOWER_LIMIT,
+};
+
+/* Actions for NXPWIFI_ATTR_TXPWR_ACTION. */
+enum nxpwifi_txpwr_action {
+	NXPWIFI_TXPWR_ACTION_GET,
+	NXPWIFI_TXPWR_ACTION_SET,
+};
+
+/* Subband selectors for NXPWIFI_ATTR_TXPWR_SUBBAND: 0x00 is the 2.4 GHz
+ * band and 0x10..0x13 are the four 5 GHz subbands.
+ */
+enum nxpwifi_txpwr_subband {
+	NXPWIFI_TXPWR_SUBBAND_2G	= 0x00,
+	NXPWIFI_TXPWR_SUBBAND_5G_0	= 0x10,
+	NXPWIFI_TXPWR_SUBBAND_5G_1	= 0x11,
+	NXPWIFI_TXPWR_SUBBAND_5G_2	= 0x12,
+	NXPWIFI_TXPWR_SUBBAND_5G_3	= 0x13,
+};
+
+/* Attributes for NXPWIFI_VENDOR_CMD_TXPOWER_LIMIT. */
+enum nxpwifi_txpwr_attrs {
+	NXPWIFI_ATTR_TXPWR_UNSPEC,
+	NXPWIFI_ATTR_TXPWR_ACTION,	/* u8, enum nxpwifi_txpwr_action */
+	NXPWIFI_ATTR_TXPWR_SUBBAND,	/* u8, subband selector for GET */
+	NXPWIFI_ATTR_TXPWR_DATA,	/* binary, per-subband TRPC TLVs */
+
+	__NXPWIFI_ATTR_TXPWR_AFTER_LAST,
+	NXPWIFI_ATTR_TXPWR_MAX = __NXPWIFI_ATTR_TXPWR_AFTER_LAST - 1
+};
+
+void nxpwifi_set_vendor_commands(struct wiphy *wiphy);
+#endif /* __NXPWIFI_VENDOR_H__ */
-- 
2.34.1

