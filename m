Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013061.outbound.protection.outlook.com [40.107.159.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7CE41A4FB
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135137; cv=fail; b=iAAeUxrboObnfMexBCJDGjqjoasbHXPkkIchGRU97Me6upbE2C5vmRz2oTx0by2yXfiGWUZxe170VhDCfqrT5CC4YDsKtbBknzboUoGrGxVTpuEvB1fK6mZaNa+pUQNlyrSz4LIgCJU8XNNDC5WQkt5asdJtZR7UPKH4wRGji9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135137; c=relaxed/simple;
	bh=AylTnPGL+AzQ7Un7NvxA6wF5X+2629jHoxKU2TBUhsM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lqo0W1jpQbPAQKAO0biC/29X28AeCZLKj+T3VkFaDWiU1/w/8tdKR0xYsJklFnwz6N6gNwEl7tik4fPqYngEUKVJzqjNP2wqLkHlbAOMhm7vOEUQf178vJ4VBqinsMnNC8mc+8l50+UpytnjbqtC4XzOZS0CxEgEioOtbL4iHwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=MRpxdn0+; arc=fail smtp.client-ip=40.107.159.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="MRpxdn0+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GWfpdd13IEIBVJR3Mv0So0xxYSgryWh+cZraLUSne2JE5S8yJm1YZAWqx/ryYVaurGwWhaN1dy0PdfYEGsGWvjB8NrIe57pPXtpSsGwA9agUaW2azPuhuO/2K9VhLTTeuZkwcCGWBaHtX0/BW16hwZwM6AlMPJMJpyZhCLgMD4wHWfNqilqjT9+2Z3vA4TLfaGqlvqebtEA7M/iyaKUkHwvr7NJpJzXQ6e9XvZa+V7Kywd9ed5fTHJj5XYCDRvYxcgRiy8JPA/lThp4xX0eeam0rXDlyc+A73MWOCDlEWiOtZ3SA9Ji8A1rQ8FgswoPjlKaGIE4sa6r2lyxc31UW5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g85lmUg+lTTza8R2xpV1c47PdmZcVhcpvrPwxCt7UXE=;
 b=E0sDvxJzXOUzVm+qzV/OpgEBCG7hWSpGYUmFL3g0H0cr+3Z3M0jVSLGKlnBJ8PeKYzvfjtybv9KyJt39w6rIvHcWRFuaaGLK2A29flbKOYL1CNP9Hk2K0gLUv3l3x9arljXkzLA+V9vvsfUrxk7dgNvOEZhXfs5GsXeV9JSOai5sI40EvlNdgpLkB4sNmZoYHEVof2LkmC89L3oD2XhKxKCotZx7+Qb8PfwTb5w7UHw7fh4C+DxhCOZvuCH9hSlaMp3w2E2iNdRlm3SZDVvv8oaUOiD+Eqb0n5IDDAdqep35UlnuZqwDkph25NRCjEonjC9HGzU340q8bX9FpyX31g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g85lmUg+lTTza8R2xpV1c47PdmZcVhcpvrPwxCt7UXE=;
 b=MRpxdn0+o3vPLmt/LEYXboKUSjAP+ByvFF6jiFiO16WWaI1lm8gG8cYW/NS6f/DwcZ2Vh2l6fELrCoRMJgRHjIoZkjayTku1RlgPRNqXz90InPepxGPQg3r9AucNCLk6oXFHSsUdZaHERFc1GQodJ9uaZYVrCDVIzTPXk3wmTXefi3QMCqYi1OcFPu2SWR00D8Cq6XlCKQFquQN5C5IXa+aYkXdLD6AWLgQWF3c9wQVEbWswhk4hGUMJLgaY40O+LLlP/O5AHqMyYKfaDv+IIinii3VgdS2sedwGvu0V3psnqMw5BF6axS9HaR7EwszXgvuSR4aP8wbFLywcpWVeIA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by DB9PR04MB9257.eurprd04.prod.outlook.com (2603:10a6:10:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Fri, 16 Oct
 2026 07:18:53 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:18:52 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next 2/3] wifi: nxpwifi: add P2P interface combinations and frame handling
Date: Fri, 16 Oct 2026 15:17:41 +0800
Message-Id: <20261016071742.3541420-3-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016071742.3541420-1-jeff.chen_1@oss.nxp.com>
References: <20261016071742.3541420-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:196::10) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|DB9PR04MB9257:EE_
X-MS-Office365-Filtering-Correlation-Id: 342f53e0-cbf6-4782-b116-08df2b55bb3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|376014|1800799024|23010399003|10067099003|18002099003|22082099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	MXAr7RtPkymf8TkF1iviyjT5QMuqmVV2kubUijqFSykj9wLUJQnwxQrdmwVUyGIrnqIF9caucOHXEcyaYl7e/xknMlt751Y+D2QY4W0TQQendhOKOtPtQKRgnBWDymmbr7+ZZxAjhndJ40nTDthOn6rsUJ6UYiqMGydcQ7msEq1deRyLRhbyo/7ifl9yLZlLEmTc7MFQBnCJB+eOIWrfJHcUkpkRjPoQVntx+GCqRlBQHKkm825w50RDSuEMB4bSJIzHGSHHkCN4+g8GVkH8BIRz7GhuRh5UXGO11uvhY54UA24BTMN7KIjFiY9ZK81sSDS8sEVZCD62odPP2NYrkuo8EKlmRv63Il1Qp2yxjJRWZD/owDf+ulp3OhmMng///LpBjjtM5tcgNbRZXR4BuBqIJPpPUzYqUV6FX7n9Ka8NavrBiOMo0ja6zPZX7mbN0t600Xy/ScUdjmfTD0Mkj9pARaYEESO9Tgtu7E3C3fJJCWW1yAfJVvO/RN6hUlY11K4EptdWvCWsM/csg3YT0IOU5yEMB3w3nwriqGkjk3wJtL0R8z9uNYU18SPEJKGCfihDon/+7p2Tu/mxf4LYt6SqNx9m8upSrt7k21EnZEGJRGW2X62u9D1kyBJor/Kthl3ksUwLNZ5ek7r3mnkzMqmBTWNWkunKemsZN+BDe1I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(376014)(1800799024)(23010399003)(10067099003)(18002099003)(22082099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2Lun+k+vWiMFkKWYF9aWDfIQRhtiHWVFvzdUh/Tbap3BgTTlLGcLopKcvLA6?=
 =?us-ascii?Q?U3MAd7wdRnmT5n0lbqqs8GxiYMSIIJsTX/+7cQpQpHdYIfRw9/JZAWQ/ouIK?=
 =?us-ascii?Q?O4w3Lc4IS8wuxKFouewh6aWvi3tcJNQPN6Jofu2h5mnrWS0ew+jiHXbixS1g?=
 =?us-ascii?Q?aK2+A59NrL1gTqMqcl3Cv6sfiW5eycn23c9cvsSFyY4O4AS1j7sL+Svc6xPv?=
 =?us-ascii?Q?bx/9Pbi/2R8gqeYuhf5wOa9GpOdBIXUB8myxpd2NBAPstYc1c8frjeSSpeZQ?=
 =?us-ascii?Q?iputbv9QoGjjCDkFgKq+RKB3g6nKh5xuU8wWHLPNQH83p3nxlw4dAmmJyTzP?=
 =?us-ascii?Q?rczfEm/tbnwF8TSSDeLNfEVu87dcWzRbsgj2Lg87sd/Y4iR72IX9ektTVMg+?=
 =?us-ascii?Q?6eFSUhqmDyi/LamJ9VzVzV7z4sytliJgif3S/vog++hs+FRMSbzdS+SDUG3k?=
 =?us-ascii?Q?JtvgvZKYqh34QF62ReJnBJfTpg1eFRCgKSvC4liVU6GQs4ikC+l1+i45ju5j?=
 =?us-ascii?Q?LTD4JXCfyC+nGXYCDbyU8NY8EiV0rdQCbiIQQ5IBeuSwgi+CW0NKkHp+O2t8?=
 =?us-ascii?Q?qdfXENrPBoQF4CVT8ua3SPG8HzkJNcskqA5ReG6IObWIldriPdlfuqxogJ2n?=
 =?us-ascii?Q?u4+6wqzUeF2QlA95zuoQLDSPOg2koKBtD67kS/q6PtRRqsqhsGTzyizFgZ8e?=
 =?us-ascii?Q?88Vtb2mhO+fjVInP0FGl7gzrGtdI9O+Yx2l5dHOK4aE/ket4Gbd352XclN9/?=
 =?us-ascii?Q?9cXW5VPI4DE9JGPNlV1uN/x/H+LH6b9FskZaDC7PoKppMdRQhxE97b3lSrxA?=
 =?us-ascii?Q?z7ucUSb58Buh96CCi154MBIeCuXSzzYfI2qQ/lTKa5989uGz09mxKYfFWT8c?=
 =?us-ascii?Q?1uMubyVGk4E4Fc2j+xcbgEDL+ZoYF0sle483m851eiV1ewvq6ffoqi1t3YrE?=
 =?us-ascii?Q?NMfckoVOKs6V1m5fkedj+64ofO1S/zYOYijiotPgwz0Exir0F+8/waPnjAJk?=
 =?us-ascii?Q?IdUZC8reOOrU+nDkd/+h1k8kHo+RclNTfmFVjKYn10djrt8nL6HaK346QHKA?=
 =?us-ascii?Q?gX9uh1tDRsWIloPS+JyZr5Um6vJWWdotWSc0T6RzdbGG6MVT+iDP6rKDgDbq?=
 =?us-ascii?Q?9CoeI3c7M8v/3CKin7dBdAePnf80sktERXuBRh6uRTxwqXXHt40vj49UFfy4?=
 =?us-ascii?Q?5PzhfaBglWGBCNmlUG8pHtWfTR+ntXJV+jCHFAnIMOCAKSixsP64sm38O1xT?=
 =?us-ascii?Q?eMGlBzSNx5LDZ+EinaMltLmiaUGu3/A4JhWqbVt1RCY//jEemAE3P0/apJpc?=
 =?us-ascii?Q?S8engTklyYNrRvjvqFHOpZhcH1aRz53B4ybugR/qCn1Ea9FjZ0+CQbgFk7ew?=
 =?us-ascii?Q?g7HkzKNIa4fZLtb64wi/6eKs0OgMlQyDpIVrAqWzXPf85t7KtzyhoS5XDSUy?=
 =?us-ascii?Q?fJ7Z2/vKKZd5ZilpEhdlUw/oHPMKlKGb1eRptoBkY+0dVq9dzrFiNP5r/oQT?=
 =?us-ascii?Q?jqXUrUAN7SHyTdHtt+Ddh5cQ23wy6Rbf20gJNSiS5nc78/Zs1NDisHxbo7sd?=
 =?us-ascii?Q?rgt5Bcxrcfo6BUv/VLssvJrTPYSYWa88kFqrMC+7UsIMyGcfNDcOO7Y+2AMQ?=
 =?us-ascii?Q?AwUGSMyh2gljmyZl9DBR6vR7n+GTAu1pG3qNecVucNLSGqOrmbJD8oSw/f9R?=
 =?us-ascii?Q?LJ2EVTc1OFPN7ArJ9VT1ydabmogFwHOdAqAO7QuSqGYL0rCtYWPGGtRAPRgs?=
 =?us-ascii?Q?chUPMGqDUnafxvxNJEvNciH4JWPWseZD6ZSlVabZmmdvwHnnq2x5?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342f53e0-cbf6-4782-b116-08df2b55bb3b
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 07:18:52.4591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdjNu0V6T+RVQTWom2VVNQ7XNWSBB3UQZij5AR1sAPAmEJDsSaPRvoMH12w9E1eVfxhygalU/8M3GD/LJ/yMJw8fQbAt1guA4RlgD1uEzPMun77K3tK+woQlphbdRqBA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9257

From: Jeff Chen <jeff.chen_1@nxp.com>

Advertise P2P client and GO support through cfg80211 and register
the management frame subtypes supported by each role.

Also handle P2P client interfaces in station-specific paths.

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/11n.c        |  3 ++-
 .../net/wireless/nxp/nxpwifi/11n_rxreorder.c  |  6 ++++--
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c   | 20 +++++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/cfp.c        |  3 ++-
 drivers/net/wireless/nxp/nxpwifi/join.c       |  1 +
 drivers/net/wireless/nxp/nxpwifi/sta_event.c  |  3 ++-
 6 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11n.c b/drivers/net/wireless/nxp/nxpwifi/11n.c
index 9eae93c3b800..3efd315eddd9 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11n.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11n.c
@@ -816,7 +816,8 @@ void nxpwifi_update_ampdu_txwinsize(struct nxpwifi_adapter *adapter)
 		priv = adapter->priv[i];
 		tx_win_size = priv->add_ba_param.tx_win_size;
 
-		if (priv->bss_type == NXPWIFI_BSS_TYPE_STA)
+		if (priv->bss_type == NXPWIFI_BSS_TYPE_STA ||
+		    priv->bss_type == NXPWIFI_BSS_TYPE_P2P)
 			priv->add_ba_param.tx_win_size =
 				NXPWIFI_STA_AMPDU_DEF_TXWINSIZE;
 
diff --git a/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c b/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
index 87cf2ec85991..ca9ca8cdcb16 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
@@ -677,14 +677,16 @@ static void nxpwifi_update_ampdu_rxwinsize(struct nxpwifi_adapter *adapter,
 		priv = adapter->priv[i];
 		rx_win_size = priv->add_ba_param.rx_win_size;
 		if (coex_flag) {
-			if (priv->bss_type == NXPWIFI_BSS_TYPE_STA)
+			if (priv->bss_type == NXPWIFI_BSS_TYPE_STA ||
+			    priv->bss_type == NXPWIFI_BSS_TYPE_P2P)
 				priv->add_ba_param.rx_win_size =
 					NXPWIFI_STA_COEX_AMPDU_DEF_RXWINSIZE;
 			if (priv->bss_type == NXPWIFI_BSS_TYPE_UAP)
 				priv->add_ba_param.rx_win_size =
 					NXPWIFI_UAP_COEX_AMPDU_DEF_RXWINSIZE;
 		} else {
-			if (priv->bss_type == NXPWIFI_BSS_TYPE_STA)
+			if (priv->bss_type == NXPWIFI_BSS_TYPE_STA ||
+			    priv->bss_type == NXPWIFI_BSS_TYPE_P2P)
 				priv->add_ba_param.rx_win_size =
 					NXPWIFI_STA_AMPDU_DEF_RXWINSIZE;
 			if (priv->bss_type == NXPWIFI_BSS_TYPE_UAP)
diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index ade57f128d10..8f590d76c6af 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -15,6 +15,8 @@ static const struct ieee80211_iface_limit nxpwifi_ap_sta_limits[] = {
 	{
 		.max = NXPWIFI_MAX_BSS_NUM,
 		.types = BIT(NL80211_IFTYPE_STATION) |
+			 BIT(NL80211_IFTYPE_P2P_GO) |
+			 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			 BIT(NL80211_IFTYPE_AP) |
 			 BIT(NL80211_IFTYPE_MONITOR),
 	},
@@ -1392,6 +1394,22 @@ nxpwifi_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 		      BIT(IEEE80211_STYPE_DEAUTH >> 4) |
 		      BIT(IEEE80211_STYPE_ACTION >> 4),
 	},
+	[NL80211_IFTYPE_P2P_CLIENT] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+	},
+	[NL80211_IFTYPE_P2P_GO] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_AUTH >> 4) |
+		      BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+		      BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+	},
 };
 
 /*
@@ -3788,6 +3806,8 @@ int nxpwifi_register_cfg80211(struct nxpwifi_adapter *adapter)
 	wiphy->mgmt_stypes = nxpwifi_mgmt_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				 BIT(NL80211_IFTYPE_P2P_GO) |
 				 BIT(NL80211_IFTYPE_AP) |
 				 BIT(NL80211_IFTYPE_MONITOR);
 
diff --git a/drivers/net/wireless/nxp/nxpwifi/cfp.c b/drivers/net/wireless/nxp/nxpwifi/cfp.c
index aec1d5014810..9d18bde01f9f 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfp.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfp.c
@@ -398,7 +398,8 @@ u32 nxpwifi_get_supported_rates(struct nxpwifi_private *priv, u8 *rates)
 
 	bands = nxpwifi_convert_config_bands(adapter->fw_bands);
 
-	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
+	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
+	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		if (bands == BAND_B) {
 			/* B only */
 			nxpwifi_dbg(adapter, INFO, "info: infra band=%d\t"
diff --git a/drivers/net/wireless/nxp/nxpwifi/join.c b/drivers/net/wireless/nxp/nxpwifi/join.c
index 359006e2c391..bebb66c2fd76 100644
--- a/drivers/net/wireless/nxp/nxpwifi/join.c
+++ b/drivers/net/wireless/nxp/nxpwifi/join.c
@@ -747,6 +747,7 @@ int nxpwifi_deauthenticate(struct nxpwifi_private *priv, u8 *mac)
 
 	switch (priv->bss_mode) {
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
 		ret = nxpwifi_deauthenticate_infra(priv, mac);
 		if (ret)
 			cfg80211_disconnected(priv->netdev, 0, NULL, 0,
diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_event.c b/drivers/net/wireless/nxp/nxpwifi/sta_event.c
index 355064b1d8f7..d70792efadca 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_event.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_event.c
@@ -638,7 +638,8 @@ void nxpwifi_reset_connect_state(struct nxpwifi_private *priv, u16 reason_code,
 		    "info: successfully disconnected from %pM: reason code %d\n",
 		    priv->cfg_bssid, reason_code);
 
-	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
+	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
+	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		if (adapter->host_mlme_link_lost)
 			nxpwifi_host_mlme_disconnect(adapter->priv_link_lost,
 						     reason_code, NULL);
-- 
2.34.1

