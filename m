Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011026.outbound.protection.outlook.com [52.101.65.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6619934A3A5
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132454; cv=fail; b=bzgse2yBHdiyn6m6tac1SXMiKvLDuCG2Xnc5/XBGZSJ2le8+YhE9/Mu0y1vQd6Ea4SuE0b8LQjyvPzS4N5tn78CN9UeawOzzNCbSFYWBTSv97Uo+aPt1lLlidqK6SMTlb+R/WqyVcWqDGfDj/y0kXf0QbKHC0f/co3cplR226yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132454; c=relaxed/simple;
	bh=MDV/fTW37ncHEl1gPALpinYOIBD5EV//WVaC+u1coVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fSHVLjWcGG88k5PPAnHzmNmFko+GdtG8EA7K+BOWXU+Ojmf3B2w7HHH9VsKbgEKj4KjEmrMlu6F63Ez1EF5QHv8k8kCpRZcQKfwpS3Z09iee1ooYBFKLT6pjJGFKeKtzR5rNaUMiepIWxjdGXNZjYNgp5S5JMT1wXMdTdmfBi38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=sgsH4wci; arc=fail smtp.client-ip=52.101.65.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="sgsH4wci"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lat7HS+TpKGhn8oUJSMKCARVnnztD4oFyRPZCJTPOgtIw1o7j4cc2lV5quPrQ0L7V1Lg/z8uCz1plZCPS10qWCm1Y5BEKc0W4mZQ2t1PgKZR9untMo5vG+ePmPaJG8Q8/54QIu0Ql5qZDJjFnWMAdn1yZOhujCfXyCPcyaHlVFr+5xmtJXzRGiAVTfFUFq7dCSUu33tKmfcu0FFq7L+Exhywm0JW2rFgDZP8EEFyBaNnjqRMLnCwUKt1qoHoF4ME9f8sXeAd5K/g0YTOBNC9i7/be1AYCzYj8iZhFWdqFNWQoOInwxDmVlQGTdCFovDFy4OIBFpGaoVTStNETfHLHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk6uHI226KGYl4Rv+20h5tWwqDyhwCpOUyui55plNmI=;
 b=voY7tVZCPT28gYFv5MHXKHGZgqm8Doqh/qeUNuHIPnyjP/axNF+a8QwzMt69xD2B+wmhVgq26XT/2NBaCiMf9qzQp1wJ0g0Zy6TT45jzMwzQNSt9GnHU83XATvsDaziV+goH/IZnIIumZHuToh08+q0KqDN7SvGGWgVf4vmgo0l7s0FMJImy4aRW9PkZn37HhZMZ+C1Yy+Mvw8YUubZVPwSfBz91FwtZSgB+L7U+mxe8j6mJDy79P4r1YhFHdhz+sZT8nIClSPyZcki9tX9/M3v6fgl0j07X7o+Fe8N6FlFgGAP197duoPyAVLfJboyqrlbMRY8kqaOEX19NB2XhMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk6uHI226KGYl4Rv+20h5tWwqDyhwCpOUyui55plNmI=;
 b=sgsH4wcibVVx41r7l3jyFRDyDRwahJZz6S8MNj3NErd5++2lUcTxEOEWGihpADLhW+f0r78fniaNXJ9ILTGX+NqRbPQprlLgB0x0kdodcF7PGy5Cc9yiOwtWEfLmohVZ4Qe5qJaM6kR4+yK8BsgTVAqlbhAM3QMm1m22jsa6bXp4nfys64ehMaq4XlzJBJM+fpjD3dhWnb10Eysl9em4mqRlNIW2MVr1kuhcJm7MIezHrL8UzBCXe4QBNdwTw9LLo3gkRMz/2zc43yus857bgBZ+lmtWr6Y2zzwjtJrWv7a8/DXaHS1RDmKVFr1FIFa5qD7so8vwdnm/1N91A15a0w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AS8PR04MB7637.eurprd04.prod.outlook.com (2603:10a6:20b:29d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 16:47:30 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Sun, 4 Oct 2026
 16:47:29 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	kees+treewide@kernel.org,
	arend.vanspriel@broadcom.com,
	benjamin.berg@intel.com,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next v2 2/3] wifi: nxpwifi: add firmware TRPC command support
Date: Mon,  5 Oct 2026 00:46:28 +0800
Message-Id: <20261004164629.2860677-3-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261004164629.2860677-1-jeff.chen_1@oss.nxp.com>
References: <20261004164629.2860677-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0033.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::27) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AS8PR04MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: 95955914-565a-46e5-4f1f-08df22372de0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|19092799006|1800799024|376014|18002099003|22082099003|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	ypwez4dn7jIw/TyOlFc9g3mSOze0MCHheXhdsGWpAhmojIIpZ75nFm9tpFCUPazbP/kNgB0XAIo+Zk824P9Du3wEfU57/D0UntsG6pkCdy8AP9ZI4TUfaekzseij51rXHeuUFkfAYczo5eUM+gPr4rMpmWdWV+EJ0zMQPJB2aeoleeacFRk0e4EpJy7MBoio5gLa6ueUO1NMCWl5XKIkinXfz7pIHcw0YLfZb2ic3eSBRYihQLweFWpCxbttA03TtWYrsTyb35QsmGdvtjkJPK6MFM6ZI6GFai/xm5WODFV5OICjUr9cyW3bB/YFLu++FzIs3urAtZ45AdvCKOCsyLhegjVCE2hYdjwTL15P4CjhXSrFBMv3pB5cQzwL9nCjtvQ4JcxzWBSWelkDsuIP2b6fOk66p8szJRTzhrkd1imZL9VQX6ruxlfh/8x3oBz2cQnYb/hiqK7CLdAP3pn3erlTBaVJAeenNlQOn2LTmSnF8jnoPUv63DxGUT9ZgV0DpEEYRg1Y0dZtZOotqzbBGQeMofoRjOMHGjN7bssrimHM0ZzPBKGe46/MuQ1DLifWM8wPm313/3y5yPZ3qhxEiIWfG/jlsEBP5l3aQQ33i906iHa/I+yGpgHzxzWgPrMTqK3uTnKH0yXlcSpfwmc5lzY+kArD/NvLmfx3Npvm60o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4X/RrllMj5h7yM6NRjtSem/zoUEIeyp0QhvVOT9xNPD+lWSbZbdIuD7IprJF?=
 =?us-ascii?Q?lmolP6Ao6B8v8tNAFh9/JR4757QC98HNqUp+gDu26Pof3ZMaANARk6A0oMa8?=
 =?us-ascii?Q?xgAyzCMf2ruASjwnZBYJNsy6ltraXXteK8E1eyxfvLf03evKW7QFwYU89QyS?=
 =?us-ascii?Q?k1jDC6SJ8iUQ9lIY/KLQlEmmqV/MSRVmlXaraeVIUeeobUsTbY/yAOnz4a+e?=
 =?us-ascii?Q?wzoL1J9Mz5BJilikj8LAJeOQ9t/P+f3k94Ae9or1St1cP7No9BVmXkkqnpS/?=
 =?us-ascii?Q?E+GCn0sY3Fd4uqpz1J/ViZqPjX/b9y6X/RSBD3jHGQ6FYcU3aVHp6EAhh/4p?=
 =?us-ascii?Q?EQp9Xrh+VZoUQ6yw91DJ0pPLtpI0mBYMtKKeOS1X4SIGg4wPM/GhddYmZ7kz?=
 =?us-ascii?Q?/D+CNUBTVveytwTtxyVO8IXyLEuc9QUa9loTnhYWGwUIBpqx2J/mn6aMfMLC?=
 =?us-ascii?Q?vgCHa7Gk80PObk9KKH9kFeSIc/pg7F6UI5Ux8Klsp4MtmWLHX3nE4z/sfrk6?=
 =?us-ascii?Q?MaipRFQ59nKCBodLxrLU6aM4vVm7U+uKwpSylAOiDXY6kbd+RtB/ITYfun8K?=
 =?us-ascii?Q?UTskQL8kFcChoHlmsVbYPQoh1JNbT4A0Lv7ZAVac8Js/62LhkKerJ3O/i9NI?=
 =?us-ascii?Q?P7KVmgwvfA5aAwJxqROglH4Dn90IfDsyPR2T2JWWhhpZfNaxwPOmDfpq4KIO?=
 =?us-ascii?Q?bxZ4vdlxnnxt26BFf9lt2CcD9eKDJbJ2b9gUhpI3Ew0XiaWpCiE83PK0Td6Z?=
 =?us-ascii?Q?EioMKv+ZOO1q0FZM9jfrV/MCfxbn+5iafPAm3F2eq8JM5o36G1U7Y7Xp+ENG?=
 =?us-ascii?Q?PqUvyyna65bwlDUr3752fu9XVSoKPiGulq9v0qeVI07zxZAPw9fUayd91lBJ?=
 =?us-ascii?Q?eqHf/jINm1y0mzT2VRPZgVvXFdrPUl4yFC81L4Jzp0y5EG5wF9G8OvaTM2Ms?=
 =?us-ascii?Q?+fLUlwloZOyADWCVO19m48VYQnEDxk5yTLM/Z/BtJUDZAPEcTFru7B46oJm+?=
 =?us-ascii?Q?6KniDq6gAU/rrYHlnski9q7vjbQvhureByQe5los8LPbRrZNbpvbhQMlp08r?=
 =?us-ascii?Q?ZlgBfFLsmAbS6xUfD+WTO+DUPLigs/u0HclJy0tTN40QG07vAOXYV9KcoB6K?=
 =?us-ascii?Q?t3TCyt47AC6AEyv9RTkcg3O2amgbqnSddzG7lC4Espkv1OEHFgfvu1kxoMgt?=
 =?us-ascii?Q?itRYYrwH6LAOhrfEJRcLOd2+WK312G2/8zDv1aQiBnqrvmwi8ijHUEUtB+c/?=
 =?us-ascii?Q?X5N1NlXfY42t0+wWK8PYq4EtMIja4KDvdm5xs8aSz4zuCeeYyxrxskZ+8HtR?=
 =?us-ascii?Q?CjmnJzxXSaa51d4U+HhJmOcjRa74M2UX8Q3FK0oaB+p02XK9wT2boNVZn2IF?=
 =?us-ascii?Q?jhnwPY/WoiGDw2qQSy7SNs8axEcQJ+3fzfb/ZBja4KG00qtvGgPGtLGleMeE?=
 =?us-ascii?Q?I/uTtLhROAwZT8LLD2dMi8OrLeC2qSOVihm2tt74WfF02AmB6L/zbtO/AUsQ?=
 =?us-ascii?Q?7DUAKT4soi+6yMmAQCH9BABiuY92jjk36owOJ9uLeBq6FZMUEOMjEghs4W3q?=
 =?us-ascii?Q?XY0T+21DYxK6+9PoZYosOSiELjjs+lHOyk3IIDNKG2mtnbH7XfD5PjJAXtz9?=
 =?us-ascii?Q?zsSYtMTRKMxL0D4l9MiKRrfZRCVlgIpRO+HxTnyxH/M7Ga4bwrTvcGYGBPAm?=
 =?us-ascii?Q?vu47OY2k/GVLPJh47gcPIo8CmGj/jl9KrvqmMtWZIG+N2eHcQPC5Wb1NRK8f?=
 =?us-ascii?Q?Axk3CN26Wdq18JsPSgWGrmHY9aUGQnTuSe9gKeic8ZLCD+ELDs9a?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95955914-565a-46e5-4f1f-08df22372de0
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 16:47:29.9112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0W83Zomvk8YF2UkHSe9Kutvg2X096Mniu2hEHJa06f7jUI98F/cZL5lJZdhnR+AUzfBTnJ4JupVYo7RbQb982NuIkEVmzMcMpz+ZxKeDheL3rkHMuNuAAtrHh7hpJmk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7637

From: Jeff Chen <jeff.chen_1@nxp.com>

Add support for the firmware channel TRPC configuration command used to
retrieve and update TX power limit data.

Assisted-by: LLM
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg.h     | 11 ++++
 drivers/net/wireless/nxp/nxpwifi/fw.h      |  8 +++
 drivers/net/wireless/nxp/nxpwifi/main.h    |  2 +
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c |  8 +++
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c | 67 ++++++++++++++++++++++
 5 files changed, 96 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg.h b/drivers/net/wireless/nxp/nxpwifi/cfg.h
index 8627a3372978..4c0558ed483e 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg.h
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg.h
@@ -755,6 +755,17 @@ struct nxpwifi_ds_coalesce_cfg {
 	struct nxpwifi_coalesce_rule rule[NXPWIFI_COALESCE_MAX_RULES];
 };
 
+/* Host-side helper for the channel TRPC command. */
+struct nxpwifi_ds_chan_trpc_cfg {
+	u32 len;
+	u16 action;
+	u16 subband;
+	u8 tlvbuffer[];
+};
+
+/* Upper bound on the TRPC TLV table exchanged with the firmware. */
+#define NXPWIFI_MAX_TRPC_BUF (4 * 1024)
+
 struct nxpwifi_11ax_he_cap_cfg {
 	u16 id;
 	u16 len;
diff --git a/drivers/net/wireless/nxp/nxpwifi/fw.h b/drivers/net/wireless/nxp/nxpwifi/fw.h
index 188110b020cf..0de5d2fc9242 100644
--- a/drivers/net/wireless/nxp/nxpwifi/fw.h
+++ b/drivers/net/wireless/nxp/nxpwifi/fw.h
@@ -386,6 +386,7 @@ enum NXPWIFI_802_11_PRIVACY_FILTER {
 #define HOST_CMD_CAU_REG_ACCESS                    0x00ed
 #define HOST_CMD_SET_BSS_MODE                      0x00f7
 #define HOST_CMD_PCIE_DESC_DETAILS                 0x00fa
+#define HOST_CMD_CHAN_TRPC_CONFIG                  0x00fb
 #define HOST_CMD_802_11_NET_MONITOR                0x0102
 #define HOST_CMD_802_11_SCAN_EXT                   0x0107
 #define HOST_CMD_COALESCE_CFG                      0x010a
@@ -2373,6 +2374,12 @@ struct host_cmd_twt_cfg {
 	u8 val[];
 } __packed;
 
+struct host_cmd_chan_trpc_cfg {
+	__le16 action;
+	__le16 subband;
+	u8 tlvbuffer[];
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -2447,6 +2454,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_11ax_cmd ax_cmd;
 		struct host_cmd_ds_802_11_net_monitor net_mon;
 		struct host_cmd_twt_cfg twt_cfg;
+		struct host_cmd_chan_trpc_cfg ch_trpc_cfg;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.h b/drivers/net/wireless/nxp/nxpwifi/main.h
index b25a6a4f2936..9ae017bdc6ca 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.h
+++ b/drivers/net/wireless/nxp/nxpwifi/main.h
@@ -1415,6 +1415,8 @@ int nxpwifi_get_wakeup_reason(struct nxpwifi_private *priv, u16 action,
 			      struct nxpwifi_ds_wakeup_reason *wakeup_reason);
 int nxpwifi_get_chan_info(struct nxpwifi_private *priv,
 			  struct nxpwifi_channel_band *channel_band);
+int nxpwifi_chan_trpc_cfg(struct nxpwifi_private *priv, int cmd_type,
+			  struct nxpwifi_ds_chan_trpc_cfg *ch_trpc);
 void nxpwifi_coex_ampdu_rxwinsize(struct nxpwifi_adapter *adapter);
 void nxpwifi_11n_delba(struct nxpwifi_private *priv, int tid);
 int nxpwifi_send_domain_info_cmd_fw(struct wiphy *wiphy, enum nl80211_band band);
diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c b/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
index 56cf63fbf7fe..650de6156912 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
@@ -1175,3 +1175,11 @@ int nxpwifi_get_chan_info(struct nxpwifi_private *priv,
 				HOST_ACT_GEN_GET, 0, channel_band,
 				NXPWIFI_SYNC_CMD);
 }
+
+int nxpwifi_chan_trpc_cfg(struct nxpwifi_private *priv, int cmd_type,
+			  struct nxpwifi_ds_chan_trpc_cfg *ch_trpc)
+{
+	return nxpwifi_send_cmd(priv, HOST_CMD_CHAN_TRPC_CONFIG,
+				ch_trpc->action, 0, ch_trpc,
+				cmd_type == NXPWIFI_SYNC_CMD);
+}
diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
index 9bfa4aebc3e5..c255dc0195b6 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
@@ -3033,6 +3033,70 @@ nxpwifi_ret_sta_twt_cfg(struct nxpwifi_private *priv,
 	return nxpwifi_ret_twt_cfg(priv, resp, data_buf);
 }
 
+static int nxpwifi_cmd_chan_trpc_cfg(struct nxpwifi_private *priv,
+				     struct host_cmd_ds_command *cmd,
+				     u16 cmd_no, void *data_buf, u16 cmd_action,
+				     u32 cmd_type)
+{
+	struct host_cmd_chan_trpc_cfg *chan_trpc_cfg = &cmd->params.ch_trpc_cfg;
+	struct nxpwifi_ds_chan_trpc_cfg *usr_chan_trpc_cfg =
+		(struct nxpwifi_ds_chan_trpc_cfg *)data_buf;
+	u32 hdr_len = sizeof(chan_trpc_cfg->action) +
+		      sizeof(chan_trpc_cfg->subband);
+
+	/* usr_chan_trpc_cfg->len covers action, subband, and TRPC data.
+	 * Reject lengths outside the supported command payload range.
+	 */
+	if (usr_chan_trpc_cfg->len < hdr_len ||
+	    usr_chan_trpc_cfg->len > hdr_len + NXPWIFI_MAX_TRPC_BUF)
+		return -EINVAL;
+
+	cmd->command = cpu_to_le16(cmd_no);
+	cmd->size = cpu_to_le16(S_DS_GEN + usr_chan_trpc_cfg->len);
+
+	memcpy(chan_trpc_cfg, &usr_chan_trpc_cfg->action,
+	       usr_chan_trpc_cfg->len);
+
+	return 0;
+}
+
+static int nxpwifi_ret_chan_trpc_cfg(struct nxpwifi_private *priv,
+				     struct host_cmd_ds_command *resp,
+				     u16 cmdresp_no, void *data_buf)
+{
+	struct host_cmd_chan_trpc_cfg *chan_trpc_cfg =
+		&resp->params.ch_trpc_cfg;
+	struct nxpwifi_ds_chan_trpc_cfg *usr_chan_trpc_cfg =
+		(struct nxpwifi_ds_chan_trpc_cfg *)data_buf;
+
+	if (chan_trpc_cfg->action == HOST_ACT_GEN_GET) {
+		u16 resp_size = le16_to_cpu(resp->size);
+		u16 resp_len;
+
+		if (resp_size < S_DS_GEN)
+			return -EINVAL;
+
+		resp_len = resp_size - S_DS_GEN;
+		/* The firmware response contains action, subband, and TRPC
+		 * data. Validate that the payload length is within bounds.
+		 */
+		if (resp_len < sizeof(chan_trpc_cfg->action) +
+			       sizeof(chan_trpc_cfg->subband) ||
+		    resp_len > sizeof(chan_trpc_cfg->action) +
+			       sizeof(chan_trpc_cfg->subband) +
+			       NXPWIFI_MAX_TRPC_BUF) {
+			nxpwifi_dbg(priv->adapter, ERROR,
+				    "chan_trpc bad resp len: %u\n", resp_len);
+			return -EINVAL;
+		}
+
+		usr_chan_trpc_cfg->len = resp_len;
+		memcpy(&usr_chan_trpc_cfg->action, chan_trpc_cfg, resp_len);
+	}
+
+	return 0;
+}
+
 static const struct nxpwifi_cmd_entry cmd_table_sta[] = {
 	{.cmd_no = HOST_CMD_GET_HW_SPEC,
 	.prepare_cmd = nxpwifi_cmd_sta_get_hw_spec,
@@ -3217,6 +3281,9 @@ static const struct nxpwifi_cmd_entry cmd_table_sta[] = {
 	{.cmd_no = HOST_CMD_TWT_CFG,
 	.prepare_cmd = nxpwifi_cmd_sta_twt_cfg,
 	.cmd_resp = nxpwifi_ret_sta_twt_cfg},
+	{.cmd_no = HOST_CMD_CHAN_TRPC_CONFIG,
+	.prepare_cmd = nxpwifi_cmd_chan_trpc_cfg,
+	.cmd_resp = nxpwifi_ret_chan_trpc_cfg},
 };
 
 /*
-- 
2.34.1

