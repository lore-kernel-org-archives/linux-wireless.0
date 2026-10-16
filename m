Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012032.outbound.protection.outlook.com [52.101.66.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D7C30E0F2
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135130; cv=fail; b=hDdgKmBgoOnITzj6QleOG/kVFU+cz9qQG00DjI9/Z8ZhlyLOmpNQ0sqIXEvxzqURu2uiw87i0PUvlH6EArwTIB2QArVlR6XiRdhVfRRkn16d9w89lCvlkxYRLDwJ9sMeLb3DonKbPDlPjUTNm6oeo2SaK3Q0k+pR2ST+ZZfHYeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135130; c=relaxed/simple;
	bh=rLPo8S3qUJcxrlm8XvTpaB8EN5Zb2zG3yEzxgyg5k7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kHXG/ZVAL/5Ws3CfORTwTTnZgHs9b8WXHGR2HEGyEwlY9ad80GYeh43kpVYB/hmNOFsilE73Lc+aPUa9//JT22G0ujwf3/FawMiOpG4gWEMe+HAYSZv7zPKXxF8xZoNdeyNJhk9cyJ2sIM1jkuC2umXWnhlXSNnMKUTLIWTQqyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=cAYIKxk8; arc=fail smtp.client-ip=52.101.66.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="cAYIKxk8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BX35Vbl6DALxXx+XVPfUVDAAFl08/m+KmLM8/UjgWtMOpYd4HlNYj4/Pi7gjye6St4eiQURNQM0DfyNJtWpVWimJ8khS7/mMAdgfUKvzoAWozMS6OZu3Z7UBf2OWMVlW9vgVQjYH4PC+fOxztqeUHzRrFxh9Qgiv+GkX9r+zcYsTiapioPJs0QmVkTJ3BIpe0oWGJh15PZqmzwm/8VGwXow0WZ+exqTKNRrDaYwpftxTK3/oZci287uc7mZJCjxRzmY2uvULFM1omrq8MbPS3tHpt5brB7GYcVLBLwuvfOIP4/lAPBSEjyFyH74TydU5AEwTZou55afezKwL6uYb5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oza63SCFjgP38u0RITpBPYES5vKxwjo2xUwilJ27Gi0=;
 b=MhpTbm0bPXwrPhAkeOoPSUe5I/3u+LysHVtpPcxbHx/kski7u+KmCC9Mhy9CwPMN2cocu1/+LdFlJGALotc2l0Fa1xgn1HAhPJuWqrZR1dCuZPhChmoTfzNDrgpS2fSOyT05pfhYRuMGi7rxL6ldUjROMeorW4+Pki54m8URNG8fl+XWdAUTJCIP1cz04YTORO8qDsJzFUaNmTJxO/CsibXwFEKUziCboMB2kmaVQ/XgR7uVrbqL79yFDTBhnQLFWDEtKt4R6RphGDl8sLq52cXXOLlHWd3f1YpySrKjuPVxdtun/GV7Tqxf5MpAa9XVqF/wEQdFk+4rw48o9cf02A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oza63SCFjgP38u0RITpBPYES5vKxwjo2xUwilJ27Gi0=;
 b=cAYIKxk8jINn8VizzKTkUIb4VAqRuCNddyHeWj+T5t6f4H2BY/v6TqR76j5Rc9KPrGN5Dk/0J98laVctR4dzwuQoF9Av6C1vrACxNo02t8fGlo/pyZmU5+h5rpa9EKDRw6IVZzVOrbtmcpQA9RSRqAXXZD+gH3ofgzAS1VQL9VOffoMrsgUb7zbehWZSE2SzSwvdoR4ylSQ05oDyNkRFAkzMcO2DasF+neQLLDiiVKfUhH+Wy2YWXIyQCeITf7ZmVnp829lVIIuG80nWQgg642MnfbWqHkA3JZ0cMLoA3ltHyjCC7LiIO+Nz/pIirXVuVYNq2iov8hRC0MruLjTfbQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by MA6PR04MB287897.eurprd04.prod.outlook.com (2603:10a6:250:52::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 07:18:45 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:18:44 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next 1/3] wifi: nxpwifi: add P2P mode configuration command
Date: Fri, 16 Oct 2026 15:17:40 +0800
Message-Id: <20261016071742.3541420-2-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016071742.3541420-1-jeff.chen_1@oss.nxp.com>
References: <20261016071742.3541420-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0050.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::21) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|MA6PR04MB287897:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b9dce35-a774-4bd1-c7da-08df2b55b64e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|19092799006|23010399003|56012099006|11063799006|261009221227099003|261009223027099003|10067099003|22082099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	duu3ngHzp6pdxextVBASKGOCBKqZ7AsOCiV7aYBba8mJIeb893LgFGPz20MyzKbIebk0qCNgImhbm78CUTub6Ag3y4Igvn5d2NpEpWB2Cq3kGsNokVbt4Sk7ibhBfCFT4T70KYq0YrIarLZsSCnRFm3EI9h4nouBXhmWCg4YACrzRGgyNbPtGbQbc1Hjm2ed3mRI+yElv92rCHXQUxRYY/fs26hFayIHNIt6TXRuLHSQHUO2zatDj8CiyvwdKlvwtZIl6wsXxc3Ta9gnsfC4eee3RSGkopfXsS4dugZ06XrUhJ6Lc4R8NFD03mwERpgO7eT/OQqmYed/37qWAFzXbpVrOAfNIMw2+yf58TfyGni47r5bR/yhr6L+IIkyDNAwF0gSqS/HKwSnXWvotMry8J06C4uHTtViNKOymyqvZxTrDucDMZ7UqMjx6qMp5WgQEYtGGKZq5Odm/tbVCZfxHBAzOV5ctY/KQrz+DAi7GcY4RO1y/3zvsFflz0z/7HJIdV8KemZ/Ha5P0bB37VtT52AUFeJv4f4aXIZs7obABki+Nn8ouzkC8PMeYq3f7ZbgipX/5MUHDAL1UjnkrNVrlFo6t9hcBHPAdqznF5ZYfFz+7zIaWyaLrZT+wvcUV8ZNmr/A85lP/rGTEH/AH0PJfWcomh9RUzMT6vvhyJeIyQ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(19092799006)(23010399003)(56012099006)(11063799006)(261009221227099003)(261009223027099003)(10067099003)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3kV1A9avF5Ht53zF1HA4nKJQk/wZyXq33m5h+Dqd1VZHkmCZz51EruEPgOqX?=
 =?us-ascii?Q?TzBJZW02fHLkWHrp36cCr5KbDuaaGQqPgPQaV/m1sQvt+S2Bs038c8nqJcy1?=
 =?us-ascii?Q?MKs+22d86VFRXahZdJBo2mZHdvs483jlvsHEv8bhCdYX/ohoikrb9Smkj+zD?=
 =?us-ascii?Q?M5QzNZ4+R5TG/QFg/z72UfHKLzNpSdEYFC0HsutkUExixt8Wjlt582vjfjO0?=
 =?us-ascii?Q?0kLSaRbsoQG5taOK6hr7gWTGxpxsy4H/CgmBBlB9b15B2Vfm5nb0AcJKE0YA?=
 =?us-ascii?Q?QlM37uYNpNjWrBXds3+DBG4ifGuZYewmyQtiuYvgzFn+OOCaFjdnehittxu+?=
 =?us-ascii?Q?I7jy6Uin/GPLcM927rNo4B301ZIkwe5IT0SUIdhom9JowGcaSsoopUTU66+Z?=
 =?us-ascii?Q?VgOQn66TfzkE6GSVxt7oUE9apsMb/y0eSJ5TfjzLOdoDXE/abdbgl2UfJ9vJ?=
 =?us-ascii?Q?B2xUS29qHW5oORn8AfO/8ip7uAfXgV6kFOulWtwxn8dDh84tMejH7Jl/n53B?=
 =?us-ascii?Q?9IvwMFb+EFnq1URM63Z45Sr2axevtyxtzc0aMl+kCEtgrdcuJ36PGtj9S3/S?=
 =?us-ascii?Q?codmvry61ME18mOxhw0su4mqRxabtAFHqhkLvNXw8zRadCRtF9/M5BNDBwtU?=
 =?us-ascii?Q?mJvi9n5xh8qfD4maNIesIuLuXfZTNDAknUrXA0At3QI7OADI3u7nzpDN4l4e?=
 =?us-ascii?Q?XarsTxpUMWKRK9FxcUudv935bbTDUJGSvkxsl/RomIPphviDgkezeG61yqgx?=
 =?us-ascii?Q?UPuiHeSEDeO5IjSAx9ty4BPunj7RZ/HEzrGdaeR/m3WcwkVqiveGcwbGPCVl?=
 =?us-ascii?Q?9LfRmbEUJwoIgdh4i+Y6qp37zDu7sUFN+pe0RkirraPGbt84UzmZ7FHJa4FZ?=
 =?us-ascii?Q?+CfYJu7Icycx1vGF05H9+RVhowyX4R3MZwjRxZvnPJmPC05kSFW368dBHHux?=
 =?us-ascii?Q?AptpUAzaqZYFHegL/Kc3S/oK9AjHoJBiRthEnCoFVjLfLAongNoj5X9nNQRH?=
 =?us-ascii?Q?4HeeHZH1tch7EBgiVEhX7lWJExVnXggIOpTnBYxhmU3PbXIEUR+BmF5MMxS7?=
 =?us-ascii?Q?2zZcgtAu2spOi0FIaHBqVfn+hoEuIUrpob4hpeCsep5KtkTybG/tPCvltAkm?=
 =?us-ascii?Q?AjRZQ3urniNvr7xChbpTJ8s6o6IPMKtkYC/L1yq/zL6oZk4f5IPS1XUFJ0A4?=
 =?us-ascii?Q?XHa7wYLbSMfubj3KqRUVxw4gcxNbKJrlCPhxBj2NSfN2YRhWGC9HC8iHj7R7?=
 =?us-ascii?Q?QDowoK8DQM9VuPdymgprAxyqlcuIbwYcdWsgXRj2Ol5P4y+iKJ4uggBnIwug?=
 =?us-ascii?Q?jkrb5ERoyhvpBr5ReLQLr7q0ZoZqs0w2OCWSA+IRx5Xpser/iN9COPRUAbyR?=
 =?us-ascii?Q?SoDOaQKRFkNDHOMP16E6VIRPPqTRVeOEdZjT/izr9uhPxvL28u2Dkg7wsP5t?=
 =?us-ascii?Q?9cnpiRGSSNnZ42BB53ZO6C9IO/BUh5EUuPQFsktlrqDdTzDK3dxtq0m8wsSa?=
 =?us-ascii?Q?xCgxHPhyx0LkW3HqubLpSwpcV99XRjjWUm1H6PYXU87sNtssZivqn8xheBLi?=
 =?us-ascii?Q?U9dmIlrQocJ/F+YpEp9E1qviEs3b3cMOV06oFAeGUGPr81JM58/kA4mqckiV?=
 =?us-ascii?Q?n4/a31vSQ2xZ2cKFDQ4jLZ3/7qO5dmuI4f+E6sMT1BlB0I6KVmJwJBUQSJ3G?=
 =?us-ascii?Q?W4JVvps43EEn5CCdmSgRFrHSmNoxSXnNkKk13bk6zbOfEoUfimk+2MhcD6pL?=
 =?us-ascii?Q?AsksdFtnr7+29rKjaWrKrq3EU5UyyNOad5K5hqiLVHZ5xaBt63tx?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9dce35-a774-4bd1-c7da-08df2b55b64e
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 07:18:44.2092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYjHNV+zC4SUbsSYVo3i01wgb1MI157TSFRiaY9QTxV6+2Ryjkt66AwRpcVbVQBGzFCqeqY7HrhE2iK1AxqZS+hiAfQVQk1dOeX7sSuOtXq1ThM25GpPk5bDN5UsPtSG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA6PR04MB287897

From: Jeff Chen <jeff.chen_1@nxp.com>

Add support for the P2P mode configuration host command, which
switches the firmware between disabled, device, client and GO
P2P modes.

Also add the supporting command handling logic and parse the
firmware-reported maximum number of P2P connections to track
the per-adapter P2P interface limit.

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg.h     |  3 +++
 drivers/net/wireless/nxp/nxpwifi/cmdevt.c  | 11 +++++++++++
 drivers/net/wireless/nxp/nxpwifi/cmdevt.h  |  1 +
 drivers/net/wireless/nxp/nxpwifi/fw.h      | 16 ++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/init.c    |  1 +
 drivers/net/wireless/nxp/nxpwifi/main.h    |  2 +-
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c | 22 ++++++++++++++++++++++
 7 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg.h b/drivers/net/wireless/nxp/nxpwifi/cfg.h
index 8627a3372978..5e0f1a6b5702 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg.h
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg.h
@@ -141,6 +141,7 @@ static inline bool nxpwifi_radio_ctl_valid(enum nxpwifi_radio_ctl v)
 
 #define NXPWIFI_MAX_STA_NUM		3
 #define NXPWIFI_MAX_UAP_NUM		3
+#define NXPWIFI_MAX_P2P_NUM		1
 
 #define NXPWIFI_A_BAND_START_FREQ	5000
 
@@ -155,6 +156,7 @@ static inline bool nxpwifi_radio_ctl_valid(enum nxpwifi_radio_ctl v)
 enum nxpwifi_bss_type {
 	NXPWIFI_BSS_TYPE_STA = 0,
 	NXPWIFI_BSS_TYPE_UAP = 1,
+	NXPWIFI_BSS_TYPE_P2P = 2,
 	NXPWIFI_BSS_TYPE_ANY = 0xff,
 };
 
@@ -261,6 +263,7 @@ struct nxpwifi_histogram_data {
 struct nxpwifi_iface_comb {
 	u8 sta_intf;
 	u8 uap_intf;
+	u8 p2p_intf;
 };
 
 struct nxpwifi_radar_params {
diff --git a/drivers/net/wireless/nxp/nxpwifi/cmdevt.c b/drivers/net/wireless/nxp/nxpwifi/cmdevt.c
index fc1950a125b6..2f96ebe7b47f 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cmdevt.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cmdevt.c
@@ -1154,6 +1154,12 @@ int nxpwifi_mgmt_frame_reg(struct nxpwifi_private *priv, u32 mask)
 				0, &mask, false);
 }
 
+int nxpwifi_set_p2p_mode(struct nxpwifi_private *priv, u16 mode, bool sync)
+{
+	return nxpwifi_send_cmd(priv, HOST_CMD_P2P_MODE_CFG, HOST_ACT_GEN_SET,
+				0, &mode, sync);
+}
+
 int nxpwifi_set_uap_sys_cfg(struct nxpwifi_private *priv,
 			    struct nxpwifi_uap_bss_param *cfg)
 {
@@ -1250,6 +1256,11 @@ int nxpwifi_ap_sys_reset(struct nxpwifi_private *priv)
 				HOST_ACT_GEN_SET, 0, NULL, true);
 }
 
+int nxpwifi_cfg80211_deinit_p2p(struct nxpwifi_private *priv)
+{
+	return nxpwifi_set_p2p_mode(priv, NXPWIFI_P2P_MODE_DISABLE, true);
+}
+
 int nxpwifi_ap_get_sta_list(struct nxpwifi_private *priv)
 {
 	return nxpwifi_send_cmd(priv, HOST_CMD_APCMD_STA_LIST, HOST_ACT_GEN_GET,
diff --git a/drivers/net/wireless/nxp/nxpwifi/cmdevt.h b/drivers/net/wireless/nxp/nxpwifi/cmdevt.h
index 6112760b697e..d8d356ee0667 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cmdevt.h
+++ b/drivers/net/wireless/nxp/nxpwifi/cmdevt.h
@@ -92,6 +92,7 @@ void nxpwifi_process_tx_pause_event(struct nxpwifi_private *priv,
 void nxpwifi_bt_coex_wlan_param_update_event(struct nxpwifi_private *priv,
 					     struct sk_buff *event_skb);
 int nxpwifi_mgmt_frame_reg(struct nxpwifi_private *priv, u32 mask);
+int nxpwifi_set_p2p_mode(struct nxpwifi_private *priv, u16 mode, bool sync);
 int nxpwifi_set_uap_sys_cfg(struct nxpwifi_private *priv,
 			    struct nxpwifi_uap_bss_param *cfg);
 int nxpwifi_set_rts(struct nxpwifi_private *priv, u32 rts_thr);
diff --git a/drivers/net/wireless/nxp/nxpwifi/fw.h b/drivers/net/wireless/nxp/nxpwifi/fw.h
index 124728a72442..38efdb9e4fef 100644
--- a/drivers/net/wireless/nxp/nxpwifi/fw.h
+++ b/drivers/net/wireless/nxp/nxpwifi/fw.h
@@ -385,6 +385,7 @@ enum NXPWIFI_802_11_PRIVACY_FILTER {
 #define HOST_CMD_ROBUST_COEX                       0x00e0
 #define HOST_CMD_802_11_PS_MODE_ENH                0x00e4
 #define HOST_CMD_802_11_HS_CFG_ENH                 0x00e5
+#define HOST_CMD_P2P_MODE_CFG                      0x00eb
 #define HOST_CMD_CAU_REG_ACCESS                    0x00ed
 #define HOST_CMD_SET_BSS_MODE                      0x00f7
 #define HOST_CMD_PCIE_DESC_DETAILS                 0x00fa
@@ -435,6 +436,13 @@ enum ENH_PS_MODES {
 	DIS_AUTO_PS = 0xfe,
 };
 
+enum nxpwifi_p2p_mode {
+	NXPWIFI_P2P_MODE_DISABLE = 0,
+	NXPWIFI_P2P_MODE_DEVICE = 1,
+	NXPWIFI_P2P_MODE_GO = 2,
+	NXPWIFI_P2P_MODE_CLIENT = 3,
+};
+
 enum nxpwifi_channel_flags {
 	NXPWIFI_CHANNEL_PASSIVE = BIT(0),
 	NXPWIFI_CHANNEL_DFS = BIT(1),
@@ -1138,6 +1146,7 @@ struct hw_spec_api_rev {
 struct hw_spec_max_conn {
 	struct nxpwifi_ie_types_header header;
 	u8 reserved;
+	u8 max_p2p_conn;
 	u8 max_sta_conn;
 } __packed;
 
@@ -2369,6 +2378,12 @@ struct host_cmd_ds_802_11_net_monitor {
 	struct nxpwifi_ie_types_chan_band_list monitor_chan;
 } __packed;
 
+/* P2P mode configuration command. */
+struct host_cmd_ds_p2p_mode_cfg {
+	__le16 action;
+	__le16 mode;
+} __packed;
+
 struct host_cmd_twt_cfg {
 	__le16 action;
 	__le16 sub_id;
@@ -2449,6 +2464,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_11ax_cmd ax_cmd;
 		struct host_cmd_ds_802_11_net_monitor net_mon;
 		struct host_cmd_twt_cfg twt_cfg;
+		struct host_cmd_ds_p2p_mode_cfg mode_cfg;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/nxp/nxpwifi/init.c b/drivers/net/wireless/nxp/nxpwifi/init.c
index 3c4df37333d8..6e03aac54694 100644
--- a/drivers/net/wireless/nxp/nxpwifi/init.c
+++ b/drivers/net/wireless/nxp/nxpwifi/init.c
@@ -263,6 +263,7 @@ static void nxpwifi_init_adapter(struct nxpwifi_adapter *adapter)
 	eth_broadcast_addr(adapter->perm_addr);
 	adapter->iface_limit.sta_intf = NXPWIFI_MAX_STA_NUM;
 	adapter->iface_limit.uap_intf = NXPWIFI_MAX_UAP_NUM;
+	adapter->iface_limit.p2p_intf = NXPWIFI_MAX_P2P_NUM;
 	adapter->active_scan_triggered = false;
 	timer_setup(&adapter->wakeup_timer, wakeup_timer_fn, 0);
 	adapter->devdump_len = 0;
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.h b/drivers/net/wireless/nxp/nxpwifi/main.h
index b25a6a4f2936..bb2b4c77ed91 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.h
+++ b/drivers/net/wireless/nxp/nxpwifi/main.h
@@ -928,7 +928,7 @@ struct nxpwifi_adapter {
 	u8 fw_api_ver;
 	u8 fw_hotfix_ver;
 	u8 key_api_major_ver, key_api_minor_ver;
-	u8 max_sta_conn;
+	u8 max_p2p_conn, max_sta_conn;
 	struct memory_type_mapping *mem_type_mapping_tbl;
 	u8 num_mem_types;
 	bool scan_chan_gap_enabled;
diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
index 9bfa4aebc3e5..ab31b97efc98 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
@@ -144,7 +144,11 @@ nxpwifi_ret_sta_get_hw_spec(struct nxpwifi_private *priv,
 				break;
 			case TLV_TYPE_MAX_CONN:
 				max_conn = (struct hw_spec_max_conn *)tlv;
+				adapter->max_p2p_conn = max_conn->max_p2p_conn;
 				adapter->max_sta_conn = max_conn->max_sta_conn;
+				nxpwifi_dbg(adapter, INFO,
+					    "max p2p connections: %u\n",
+					    adapter->max_p2p_conn);
 				nxpwifi_dbg(adapter, INFO,
 					    "max sta connections: %u\n",
 					    adapter->max_sta_conn);
@@ -2378,6 +2382,21 @@ nxpwifi_ret_sta_802_11_hs_cfg(struct nxpwifi_private *priv,
 	return nxpwifi_ret_802_11_hs_cfg(priv, resp);
 }
 
+static int
+nxpwifi_cmd_sta_p2p_mode_cfg(struct nxpwifi_private *priv,
+			     struct host_cmd_ds_command *cmd,
+			     u16 cmd_no, void *data_buf,
+			     u16 cmd_action, u32 cmd_type)
+{
+	cmd->command = cpu_to_le16(cmd_no);
+	cmd->params.mode_cfg.action = cpu_to_le16(cmd_action);
+	cmd->params.mode_cfg.mode = cpu_to_le16(get_unaligned((u16 *)data_buf));
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_p2p_mode_cfg) +
+				S_DS_GEN);
+
+	return 0;
+}
+
 static int
 nxpwifi_cmd_sta_set_bss_mode(struct nxpwifi_private *priv,
 			     struct host_cmd_ds_command *cmd,
@@ -3160,6 +3179,9 @@ static const struct nxpwifi_cmd_entry cmd_table_sta[] = {
 	{.cmd_no = HOST_CMD_802_11_HS_CFG_ENH,
 	.prepare_cmd = nxpwifi_cmd_sta_802_11_hs_cfg,
 	.cmd_resp = nxpwifi_ret_sta_802_11_hs_cfg},
+	{.cmd_no = HOST_CMD_P2P_MODE_CFG,
+	.prepare_cmd = nxpwifi_cmd_sta_p2p_mode_cfg,
+	.cmd_resp = NULL},
 	{.cmd_no = HOST_CMD_CAU_REG_ACCESS,
 	.prepare_cmd = nxpwifi_cmd_sta_reg_access,
 	.cmd_resp = nxpwifi_ret_sta_reg_access},
-- 
2.34.1

