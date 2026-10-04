Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010009.outbound.protection.outlook.com [52.101.69.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B7B29A9C3
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132472; cv=fail; b=UfoSaxjOwKwCLz1cB3QNpPKVmmd5cKZLCFc/fI2eN5pq/R4CI+SgV6OnGr4bVjdXv8e+DUGrW4hl+xQNmvydLmtmpo+SSx6LFStZP4nMmRT3W+whI2yjlEqZq0A7HqzQYy7GfO/Z7KQrFKDETEyoK+tpEY0zK6Jr16e/TIThz3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132472; c=relaxed/simple;
	bh=onrEISrFf563bMI7wNpZQxgoxdSW8Ir62pdu9akYAu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SJc3sGZTaWuP5qFBxozzLen0YTdbseb1PHKD0UwkFg2DrwFoS3zkpJJdhq77bC61NytBJkEDcJwQAWqL3QyC6AiRo1sQ9bPSjr+7h6Nc9ncWFywQ9VCmGV2bjy3XWhSBr6TUcgG2JH5mDJk7W6EC7tyPdXFnidKQ0QAl9/45i/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=ShJYq0H+; arc=fail smtp.client-ip=52.101.69.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ShJYq0H+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bpPZxPtBUq9fc8LL7G8ImqWX9z5yUT5cq74+T/Wp302QCDQwEQ3j2zQUci0S6RdZNPF0yavLMr6Va8ZJX2B2K9jy8JV8gMBYDAzK/ZosqGmhVhmWHt7/s/O04s6RmBtGDPggIw1DIiWnmjqLwfQzLeiUAuQxtHrnFDA4k1viCdB6qmfxBXHLxypV+GlpAajhmCMFB7wCa9tUJ8Ez1NfgnN2OOi0yigs3e+8FflfhRi3RvnFJhDDlLL2wV1f00/AsuFSSW30S46z6VujOZEJ6h1802E0+RFOb38NpxLpDp0880+lbZTBe4PUdpdFE0hl6Qymv3kh2XDgUkUMd5t6m6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjXdFbLD/218uvl9+bL+O06Kgc7oIY0YVviQrVI3nwA=;
 b=py8ldKDGNGynO+zxb40jTSJ/uyMqpyNL8ILohQfYfF7/SqkEtOfw16gQED2QPvpHUK6pOXhLDTkb50cB/A5aR+wv03ZfaUV8SsyEKSVOQmjxjCrCQd4BI6kmOTefv6LMHNg8/4V+u+2VFn7seFAvOzp4JVgWO/+Q+bb+l6qCVnadbXecZdnVnSCoxEEkyu5z4dWCrrA7TkXTATOoHkNg8Zbc7JWtw2ttIyysh1qcCPnjFBD98VL+ZJlsqYVypSPCQHjdv4msst+gpCOLz6FHXcU5/er7cB5xPmodEGJ602UVpWfHM5Nv8r24QV5KNWR8AKjWnySsnncByq3jPT4bQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjXdFbLD/218uvl9+bL+O06Kgc7oIY0YVviQrVI3nwA=;
 b=ShJYq0H+eAboV94HA0/KZ7QWsXUt80nTsOVGHUiEJfETaQfS79hYP1xiUwEP4mPYHa4pbWIoh5ZUTqq68iUB6uPgHGWEtchaX/4cgtR/dbfOKO1vO2kD2xAIYcmgyFgrDhYPBgffNl7ho1ZqtDz4+sMf+kIr+qgLps2378xV2jGrf4OHT9V/vUjEWS609QwhAioLtxyuhwzsp/Y6YwytGBi1jVYQ9oi0NYN5Fl4rlCmOctLsMYq88/ZFeeG1hi1ttEV7sCf7HAf7UI/YxOf7y0phyL2lDRNreLkjfCsPaThnJ25l98fJNCFooTEKulDmR/6MEiSTNfGnrSlT/IZh+A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AS8PR04MB7637.eurprd04.prod.outlook.com (2603:10a6:20b:29d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 16:47:47 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Sun, 4 Oct 2026
 16:47:47 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	kees+treewide@kernel.org,
	arend.vanspriel@broadcom.com,
	benjamin.berg@intel.com,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next v2 3/3] wifi: nxpwifi: add netlink vendor command for TX power limits
Date: Mon,  5 Oct 2026 00:46:29 +0800
Message-Id: <20261004164629.2860677-4-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261004164629.2860677-1-jeff.chen_1@oss.nxp.com>
References: <20261004164629.2860677-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0001.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::15) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AS8PR04MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: aab28966-38f9-49da-908b-08df22373873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|19092799006|1800799024|376014|18002099003|22082099003|6133799003|3023799007|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	YcH9FTzEVRF+2SIVULEShuawP+/mMktHk6b9YVI3HGwNW+OPKvuzkpMhAs7/LpHOuR6bGw2rmIduqE7na6x1vyG2MCjRjx0h3HsUYVKFUIiyAhtxBYdeE25s7pMVS5c4TXElWb5c22bNbkt1OlDaJvw+py+ReC7QpmfzMA99KHb3qOkvKxg9kCgKqsM5UE4L/V5RZTg941DiaMN0OYR0e3nCQHOxcyd5hlFpJQSXoQBqssZrXRWQ8KukMHY7D64j9bmf1QxO6FmVty+qFzFw7QRNdqFblD1KXNuO45tZMPIZUq7A1sSA5wCx8imi6Vwl/EPW3a/Z/mSf3LPwmkyfQmLL3MM0hW/zb/i0QTdjEoyEEtxXJhiwCP6QXnQEODJxgG8V5BsQbkVk9uMasfWGy3ySRngE50kgx7EpebwRJJ0i2XHm5ATDEImYGPzq/zoInM7aSyabbfeb5JP8AepGB3TvAxuIqNNS5Xj9y0X5a6TnyTPcDbDuGZZiZUzOf63yOQsWr9rFGY/pSOr/fwiVjAooQ2MZhCU33V6oG3BHcN+X8l6QqxRyqIXIReIGMSjL5aBgxD4n+M2kYP87HbbCxCIZ1gxcEg4+z91TCa6Yyk2Lhxr852Wwljz54Y9trS+BMtshB7yaky7CrksZvPw1eeET+YIzqHKhela+FS69RMI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9wAnNA4QJnsLelTltKm5Kpb4e48M6OxaCAousIgPqrg91CYisfv60bxGpPfX?=
 =?us-ascii?Q?GKeWw/He/NyrWBTF2+84fbYKyGooh+ejB3djtntkGuWjQ4tL6CMXFGGb15u8?=
 =?us-ascii?Q?IkN1jvqs2e8K2tx2iHPHNfjwXKlgYJndmtTidQa852GHxdpF7rjgxGjQex8q?=
 =?us-ascii?Q?21Yk8ZLhLBT0/jKYOerfJd4R7b04Gfo4dpQKs0q0quHONk+XBNA8Nn5zrEde?=
 =?us-ascii?Q?g62oJjkiq6ZW8ARFe191H5fumjdQ7MZwAxqLLmPAL/ptpY/Q2+1IiKT4ZXkx?=
 =?us-ascii?Q?mVmXU1k6/atgFn0gfBB3MI9WPQlUJNbeqP8Y53pYPPTPp27pCJ/BtPHLX4QC?=
 =?us-ascii?Q?4WNJ155U73JzkhABY2QZ+9M+p8v7sl0iVCtVVA+B1e+dqR2VCRJUD8Gvw07g?=
 =?us-ascii?Q?c+QUs/fNaxh9Nj5neJx9jFY7S8xPj+I/iolvT79zF8gzolOU6MCxNsqJJxPN?=
 =?us-ascii?Q?0XGGahfEyur7qcxmtvoyTKvsOqipDHJV4J5cV3BwUpxjby3Iowq3QlsZHkMl?=
 =?us-ascii?Q?Nn2Q5M+Ab07+W8kFlnHXRTfnK9foqvKfnj7rWQEACcCbN7IjuiEzyZsSHjGw?=
 =?us-ascii?Q?2O81NfUq2A1xL7+J6zU8s7Ka+dneYgyiSe1vmU68XhSlQEFdD1eWJygzZzv7?=
 =?us-ascii?Q?c+bBP0cQTypvm+3x22Mspg2S/nZG//4ZKsg59ApTBDTrtUiekBpYiSdWuDt1?=
 =?us-ascii?Q?649HSQir12BQkyu9IW9kl6m35rBdhj34U4+D1WqG8NCO4lPWMrrIyWMHqRjF?=
 =?us-ascii?Q?ONF7s4lgWYpMgFgnPQ3WiSl4P9GJE2z6+fQjO6EZMpqrGKt2Wb+Hvs8yUVV/?=
 =?us-ascii?Q?QgB02vA7ZF0YYp7FUoUfjz5Eq9zLVxwTBBM85y2TKjf5tcUSbhE8paM8+KUJ?=
 =?us-ascii?Q?E1FDzEL+ASbfS2yNCIl2Z2eZXztazVEgTN7SyXREeSWiqRE8SShhIjv7AjPD?=
 =?us-ascii?Q?ZcF9eKTjmE+Bnca2y/RW6jUcOyumAFHxZ3B9QSzZflHcbMYrCL2tAF1XqnEl?=
 =?us-ascii?Q?V3Q8gtp/kwOlXrMng6wqrR+QFrkGh0Le3fZWZ6NCga83xLgOBMklfnJKw8lc?=
 =?us-ascii?Q?HqdYMAxM8rS6UEKNAuRt25/mB4nrDtOByA2Yal/GvR4hA+9iSwii2xVqskki?=
 =?us-ascii?Q?wIamJK4PT9/3ywV140uHzZ29AHPQcnOUlFvjZEXBmZiKw2G2yfW99ieUbmMk?=
 =?us-ascii?Q?Mqb/fxVAS3PU6BkzrGeiIDuJVohySYfwdEEg9+Eg9i2zLYN7bNX/nArpr5Cz?=
 =?us-ascii?Q?AT9CRWK+lLeTBoYG2j6x9QvBDMb6T0DM8Z1nywJFmGXQ1Tg6Otn36xxmJylX?=
 =?us-ascii?Q?/T16gFQ3pLOS7Y9hLWif1H1MJpVEU00k1pHShE+9TG60yu09T5F1t3lTQVu0?=
 =?us-ascii?Q?ORSea9vdTx7qjjtICDknfrqKj+dz1H9XVDsGpGc0x6Ee4rRPREnWa9kfkUM4?=
 =?us-ascii?Q?qCyw3AbGI58K8SPQvhOP3RkZEgJ1nw3c9Eql+v7DVozNA50hYdYkCEGWaoXo?=
 =?us-ascii?Q?oRnKtdpPn3bX7yKU5T1ode6x/jV/Lv+KpzBon+9CiLgNsnD/hZjpNLYW085+?=
 =?us-ascii?Q?IVNtOrikNCqMj88z+JfXndB0UVZ1sdTkwFrtEq8jJ79vuYaTmAjqhbLQE/T1?=
 =?us-ascii?Q?JjwdKU8U+YvDBocEHWydisKwH4Cw5pj10KPW1CJBjfmG88HrKbRv4pohsXp/?=
 =?us-ascii?Q?A8h9yfnN8B9i+lQu4EtvOSadjBYcvzKiJQ0WKXRpQ6mVjd0KXX8C7ahHdd6K?=
 =?us-ascii?Q?mL2sXjpz2QYueDWjKrgifykO6EbxQpEFWNhDEtBtHve09IYjn/9k?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab28966-38f9-49da-908b-08df22373873
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 16:47:47.8782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CUZ/VN0symD3WKmhUMIgVNtrR5lRH82h57/XiBegJUxlqz57n/EqBsK7CSYmvxtrKIFfuNWLBG8R+AfgxDi7or0ZTgx6NiKCtRirdmP7556RmCc2X56Rplv3feVsJB9i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7637

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
index 000000000000..ac31cfd38941
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
+nxpwifi_txpwr_policy[NXP_ATTR_TXPWR_MAX + 1] = {
+	[NXP_ATTR_TXPWR_ACTION]  = NLA_POLICY_MAX(NLA_U8,
+						  NXP_TXPWR_ACTION_SET),
+	[NXP_ATTR_TXPWR_SUBBAND] = { .type = NLA_U8 },
+	[NXP_ATTR_TXPWR_DATA]    = { .type = NLA_BINARY,
+				     .len  = NXPWIFI_MAX_TRPC_BUF },
+};
+
+static bool nxpwifi_txpwr_subband_valid(u8 subband)
+{
+	switch (subband) {
+	case NXP_TXPWR_SUBBAND_2G:
+	case NXP_TXPWR_SUBBAND_5G_0:
+	case NXP_TXPWR_SUBBAND_5G_1:
+	case NXP_TXPWR_SUBBAND_5G_2:
+	case NXP_TXPWR_SUBBAND_5G_3:
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
+	struct nlattr *tb[NXP_ATTR_TXPWR_MAX + 1];
+	struct nxpwifi_ds_chan_trpc_cfg *ch_trpc;
+	struct nxpwifi_private *priv;
+	struct sk_buff *resp;
+	u8 action, subband = 0;
+	u16 tlv_len = 0;
+	int ret;
+
+	ret = nla_parse(tb, NXP_ATTR_TXPWR_MAX, data, data_len,
+			nxpwifi_txpwr_policy, NULL);
+	if (ret)
+		return ret;
+
+	if (!tb[NXP_ATTR_TXPWR_ACTION])
+		return -EINVAL;
+	action = nla_get_u8(tb[NXP_ATTR_TXPWR_ACTION]);
+
+	if (tb[NXP_ATTR_TXPWR_SUBBAND]) {
+		subband = nla_get_u8(tb[NXP_ATTR_TXPWR_SUBBAND]);
+		if (!nxpwifi_txpwr_subband_valid(subband))
+			return -EINVAL;
+	} else if (action == NXP_TXPWR_ACTION_GET) {
+		/* A subband selector is required for GET operations. */
+		return -EINVAL;
+	}
+
+	if (action == NXP_TXPWR_ACTION_SET) {
+		if (!tb[NXP_ATTR_TXPWR_DATA])
+			return -EINVAL;
+		tlv_len = nla_len(tb[NXP_ATTR_TXPWR_DATA]);
+	}
+
+	priv = nxpwifi_get_priv(adapter, NXPWIFI_BSS_ROLE_STA);
+	if (!priv)
+		return -ENODEV;
+
+	/* Reserve space for the returned TRPC table on GET requests. */
+	ch_trpc = kzalloc_flex(*ch_trpc, tlvbuffer,
+			       (action == NXP_TXPWR_ACTION_SET) ?
+			       tlv_len : NXPWIFI_MAX_TRPC_BUF, GFP_KERNEL);
+	if (!ch_trpc)
+		return -ENOMEM;
+
+	ch_trpc->action = (action == NXP_TXPWR_ACTION_SET) ?
+			  HOST_ACT_GEN_SET : HOST_ACT_GEN_GET;
+	ch_trpc->subband = subband;
+
+	if (tlv_len)
+		memcpy(ch_trpc->tlvbuffer,
+		       nla_data(tb[NXP_ATTR_TXPWR_DATA]), tlv_len);
+
+	ch_trpc->len = sizeof(ch_trpc->action) + sizeof(ch_trpc->subband) +
+		       tlv_len;
+
+	ret = nxpwifi_chan_trpc_cfg(priv, NXPWIFI_SYNC_CMD, ch_trpc);
+	if (ret)
+		goto done;
+
+	if (action == NXP_TXPWR_ACTION_GET) {
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
+		if (nla_put(resp, NXP_ATTR_TXPWR_DATA, resp_len,
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
+		.policy = nxpwifi_txpwr_policy,
+		.maxattr = NXP_ATTR_TXPWR_MAX,
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

