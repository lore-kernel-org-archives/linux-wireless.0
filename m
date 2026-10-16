Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013026.outbound.protection.outlook.com [40.107.159.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0551630E0EE
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135149; cv=fail; b=Tg2O713Sx9JbhDiZzqiPExo3Bqdy4//SfcWH2tReUJK/QlyknRoCt0zqP/UwlICbEo9OVALWgidvTfKWezeFAu7Fn1oYC0vY4wG4hIwtXGNsLJuKRu2hFsJrx4BhaHtCS9oRgU8fLfRe50YaR71I/LtSAwg78v1PdZqZtCcYon0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135149; c=relaxed/simple;
	bh=hOjr6vskv4PSFd/pjKPYlL4q/oPFJTXCyWp1xfetaKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WQhalxEqdH2wq7OJsFi8KG92R1SSUCEclSeF9HyZ9OT2kSTRtaEeLRJbscm2tBECQpQ4vOKnrbq5wwdg7OatvCfXMwaiuDtkmT8R/kpOWZagO2fWlwh7u92y3X9OL2Ajz5V2O+x+nGJm9V7FeHYhLtyhg+ECjAvJjHwylxnMuPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=mzrpx5uZ; arc=fail smtp.client-ip=40.107.159.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="mzrpx5uZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VzeG04pDttnIQWqhwHk7xLIwyqjxvAdBYSKj4DP2/JsYGLWrd4dK381vWerjqav9OFwsu/fxnTxuuLO1z6bf6xO3bE2zsiHr6AW9SZboPE+1ebEuybE708QnmzwzuYo3Kmm4MFmYZR/pYKYIsksQBcWI3ptrWJhyvKJlh7wHiksqWO4L/ZbU4Ib0hHGDw6uttgFqVATd+hTE9Jw1JMmznKVgH6A6BOhCzfvY9/cDgVFRRT1LH/JcwCxBSGGSr/HFIaY+fjC0Bs8XlX/m5Wrd61ZkTyLwR39eUitcJbQPH0ofdrCLmXUWv/1rLjVg+C4BKPwzzbpkR9SffEpWq0CXlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOnFNYoZWegBWMzdVdmrpnARw3xrRWg3qkN0DZakNeU=;
 b=q2/KCFHZsa20FLVHFvX6hvV9yZF1AF6mAekqA7WDNR7V6Waskyg33YvOH8PWlxumaERnJ1DdQAUSp27FEORPEB21oiV7i8BpoPfvmuEZzkLpus7pPBrTdXoaeF/Ycbzhk7olaRjjn2PJz9sPJkOOhP6taAh6pk3vCZLOpPbRzyx1nLrUcVyBNienhFzwmOj2+5e6Yt2xOM7dDHlap5Yk+96KaZmr16MuLZHUI0vA2hcP7a26mBdup06407hzfj7R517KcVcIztg3bY8Tq9z5qHkqkDMVxZ2kvSqoIdSogTwS0q2/tZYEmKkV1eXK1/bCFA+3Qpj56d/99YrKEIxNhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOnFNYoZWegBWMzdVdmrpnARw3xrRWg3qkN0DZakNeU=;
 b=mzrpx5uZMmOL7ij1WYYKITJVgMFli7VJ/Bc/66Aqld2QzHTTIJ4y9EGzyiuaZ474JgFMDxnMf1s/8LOTnEkGo7SWNHqrLVZacc/LB62vPCXXbewNwOicnNM7/f67U42VZb7jaoWCDVd93g4DCWimA8hNI2Notp9rFqA7zrCO7Dxa6ka3mmmC7fcRKxPm5G2Wqa4Gx+dEgrXASuiYF7fde9X8oh76whBhrv6CKX3RxHG/me9YJ1PaX/RABzZUNOBaFObd7GAVVYF0E8jdA4or2BoMsNQ+S7wOtieFZneXbHQwvFGJgsOf3Z90O78xeaX0HnvzMx8+SjjNUV4f/vVXaA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by DBBPR04MB7787.eurprd04.prod.outlook.com (2603:10a6:10:1e3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Fri, 16 Oct
 2026 07:19:04 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:19:03 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next 3/3] wifi: nxpwifi: enable P2P interface creation and role switching
Date: Fri, 16 Oct 2026 15:17:42 +0800
Message-Id: <20261016071742.3541420-4-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016071742.3541420-1-jeff.chen_1@oss.nxp.com>
References: <20261016071742.3541420-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JH0PR01CA0115.apcprd01.prod.exchangelabs.com
 (2603:1096:990:59::6) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|DBBPR04MB7787:EE_
X-MS-Office365-Filtering-Correlation-Id: 023b3792-2bc7-4079-a81d-08df2b55c19a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|23010399003|376014|1800799024|22082099003|18002099003|10067099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	MwSiVHdwD7dE9xr3lUlTXu1Xe+sR0A7empzNlal3nBNQLQONsvQW1nEwF8jMMV5gxtrcaPizsOhLxfDa5qsmlYcNthJICB4+7Z/fWLiPILSp+YwdCvOhYtWdVwiBUSDVhFFCQlwF14O29fYBQ0C9dWu8dLKtXWwIo5EkTTaSchm/d8ckKEB3Q+9pOViXqDdnwD5LjjCR0DF+brPi90DueoWI76uwGVmXSyXcem01Ru3TJAkPZHSBiZHN4RX/30KRlOlE64XLsowdDq/61DTDcRCSfnby4dRF8Ek6YAUSerUdwDl0gYUqIprhDoh51LT6+K7lXDo8iJsZ9cnvdmp/IMN6XPYgv/FXEighpBmd/91mhqUqA6rZxJ8gWX14z4c2Cf0kMxLjEhTXsujdG4mm3B4NcQAriwVO9B05laF35wDpSAL5p/l2BzHLbenqJ45CjIRhYv0dFjhitwp4ZMV6xw0c19e7Ra+gEpMj1S9ReOG9/4WcvT73fjAF2y94M1fuoKI42vtJ6Q/ybxwgJURGfka3CK0EbIM6hs9XJQPE/8LY6W6sWIRABopnga6/EJNY+aZvRz8n3jtKSJaJI2FzQiOOfUM9ob2CIIoaDEUMOANtqgaMOjcjcz94sHc2T0kcY5KHnbpNNJtP5VTuJwN59T8av0EsyCLYTPwE3l47nJA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(10067099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NqrCWHL5p85e2kDqJD4cgcrvARdkSQvnpdV27cPQDYN0r2BejSQNwB+bAFAX?=
 =?us-ascii?Q?zX0Www2emVSK86P2VjdSmx1Eyu1ZeR5AvuawUtAFt0eBIgJUEWlWxiyf0CBZ?=
 =?us-ascii?Q?o19C1IEgNuHxN12xUPc81/6bS4VxAmsdnVL7XU6BVrf4fFUV/axUwYWDASyx?=
 =?us-ascii?Q?ApZqsM9yK4Bz4m13sm2B0bBGnu5SlvSIEsE8E0+ZsNG5cQeOiHmIL71oCX5k?=
 =?us-ascii?Q?0Qdcn6Wd9qCO0kINXO4VNQlSAujT0GrVmzCjyulAEVZy+lBePo6LuY8z2SdU?=
 =?us-ascii?Q?sYOWx21O+k37nccbCbKVdEQTFHsPooab8y0LKZe/AOBI8xx3P4k+9BvwmyTs?=
 =?us-ascii?Q?f09Bi/4blVf5POyJgDlFACuhi7LURRUbbGBZIcGGcGa0GieVVFFKd8r6yXDF?=
 =?us-ascii?Q?tiyW6GkA4IxRNHmKYY682+E/Au87stDEViYo55nBf6mQo18sc2sHpQvUq/Ol?=
 =?us-ascii?Q?uhY5nZyQ1BZDSMAGz/bN3uev0BEKlO24BdYjZ1QIv9jR9HbVSc1xLGYbnsPx?=
 =?us-ascii?Q?YRuXP2zMU38qEj/26jWxi0x5ZwIE6rxk5x5O3YtXIbXtJuNZiGmtjVa9ChHs?=
 =?us-ascii?Q?s4txPrxCBYDWl1ubuRdZY8GX3TB7fFxW0DICrOh54OINLhi4CP3i1ebv/KNR?=
 =?us-ascii?Q?TY4j9hxp4r0dyPcr5QbN12274GGLTfqwEn9UBx8YPRxhn9NgJOgzhm+apdhy?=
 =?us-ascii?Q?SzpHMXCRvXO6cBREYmFzzKkrp1Hsw2StnxvgQlApqREzQoFWmS28RFpblNN8?=
 =?us-ascii?Q?Yd80QsuJp4Zeaq98ZrVINrybXQxjHndJO87i0ZQXpPpiC5QaUfL2wwK7m/gv?=
 =?us-ascii?Q?BqFdfy61ctKOXrje3Wi4Hfk/F7kSjTQRHqObNF6iXWn2SQidNFwG8+Q5lOzN?=
 =?us-ascii?Q?Mq+obLYAUVgzT03mnOlvxPy8OqMSr0hrzDM2z8sFXgvboS/VQVrwlLu/a57r?=
 =?us-ascii?Q?ASKAJC8wuQR3o5YrUu/JwbK4JDfY2M95L65Fo/tSfOgvt2wHFaQzQUddv+dh?=
 =?us-ascii?Q?i23M01yGwcQLobzVEu3xKXgsKBeSg6qk1/i5OJ9rM/CUQIxSeY0rqjBEo6j/?=
 =?us-ascii?Q?lLlNP7PF8A6JfdiYcYbb996PgkCnyPCwSnSt6paK+rSyk+dsaL8K643+4cmc?=
 =?us-ascii?Q?uEp8Y+ErRMqOuVvczG0j+pE6MZxAUwt7g5eqs5LwacgJmAN9d3ZFKnf8A7x2?=
 =?us-ascii?Q?Jl9gMDYimLVlcmT2Up6mx9sxKY9HnNs6ztRoxs049cEAsQ+2tzSlpk5vq1Zq?=
 =?us-ascii?Q?GNf4zdgDUIF5OOSBwj6E3nUy1vDNJOXmHOdSws2A2Ki/IcUKBvsc9YP75y0B?=
 =?us-ascii?Q?jDIwvmT822BnswxYePJXW/rKpbtmiefVKKHR4LFFMCZv0aXviiTyPuIEVSio?=
 =?us-ascii?Q?fzqalQmAJhINYGtMjqS+C3FSDfkweRh4hWGTtL7YS1Habepl21HAmWp9Ok3w?=
 =?us-ascii?Q?uIBbLD2jgDBldZz2MlA3NmZDBQ55ljmMENyq9NlY0HkED6zASq+okQABeyzp?=
 =?us-ascii?Q?IsvpnMg7F67JSspmNG1P7Z/w1YSEIwRBxssEj0DpM2AYpYgCtN7KGaHYggIC?=
 =?us-ascii?Q?VIMaXpQ0wfkfl5RD88RGwWYgimXxpIpiFGqM1rfFYF0NsxZ6HLtJyZK8T6UD?=
 =?us-ascii?Q?jZwLnq/u3bsCXeSRALvKDLVP0RhawX+lUpZ90Qy+3RGmuLh3DjpHst04PK/m?=
 =?us-ascii?Q?z/QzlksnatK6OF3H37O21KcO/HFZHK4QEEHnfB/67lJSxPrSYeDpTgKAh1Xb?=
 =?us-ascii?Q?Vkoqaj7bZtvvCDucfJmUJWjuhvnGTdJt+krQKqsIn7JiNuQDPU1r?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 023b3792-2bc7-4079-a81d-08df2b55c19a
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 07:19:03.1970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mzv3YDVkANCrr5eTs+qBS7Xfz3teCYnZirOyfLG8ILEx2FB5My8rcfQcJY8qb5nKbshdkzZtNkkyQwFZhetsqmfi8rF6kvH2g00MJXCyiXXqdv1X1ka53S1RSIqclONx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7787

From: Jeff Chen <jeff.chen_1@nxp.com>

Add cfg80211 support for creating P2P client and GO interfaces and
switching existing interfaces between P2P roles.

Configure the firmware P2P mode to match the selected interface
type when entering or leaving P2P operation.

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 274 +++++++++++++++++++-
 drivers/net/wireless/nxp/nxpwifi/main.c     |   5 +-
 2 files changed, 277 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 8f590d76c6af..f74b6ffbb8e9 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -685,6 +685,44 @@ nxpwifi_cfg80211_set_wiphy_params(struct wiphy *wiphy, int radio_idx, u32 change
 	return ret;
 }
 
+/* Initialize P2P client mode. */
+static int
+nxpwifi_cfg80211_init_p2p_client(struct nxpwifi_private *priv)
+{
+	int ret;
+
+	ret = nxpwifi_cfg80211_deinit_p2p(priv);
+
+	if (ret)
+		return ret;
+
+	ret = nxpwifi_set_p2p_mode(priv, NXPWIFI_P2P_MODE_DEVICE, true);
+
+	if (ret)
+		return ret;
+
+	return nxpwifi_set_p2p_mode(priv, NXPWIFI_P2P_MODE_CLIENT, true);
+}
+
+/* Initialize P2P GO mode. */
+static int
+nxpwifi_cfg80211_init_p2p_go(struct nxpwifi_private *priv)
+{
+	int ret;
+
+	ret = nxpwifi_cfg80211_deinit_p2p(priv);
+
+	if (ret)
+		return ret;
+
+	ret = nxpwifi_set_p2p_mode(priv, NXPWIFI_P2P_MODE_DEVICE, true);
+
+	if (ret)
+		return ret;
+
+	return nxpwifi_set_p2p_mode(priv, NXPWIFI_P2P_MODE_GO, true);
+}
+
 static int nxpwifi_deinit_priv_params(struct nxpwifi_private *priv)
 {
 	struct nxpwifi_adapter *adapter = priv->adapter;
@@ -739,6 +777,12 @@ nxpwifi_init_new_priv_params(struct nxpwifi_private *priv,
 	case NL80211_IFTYPE_AP:
 		priv->bss_role = NXPWIFI_BSS_ROLE_UAP;
 		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		priv->bss_role = NXPWIFI_BSS_ROLE_STA;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		priv->bss_role = NXPWIFI_BSS_ROLE_UAP;
+		break;
 	default:
 		nxpwifi_dbg(adapter, ERROR,
 			    "%s: changing to %d not supported\n",
@@ -772,6 +816,10 @@ is_vif_type_change_allowed(struct nxpwifi_adapter *adapter,
 	switch (old_iftype) {
 	case NL80211_IFTYPE_STATION:
 		switch (new_iftype) {
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			return adapter->curr_iface_comb.p2p_intf !=
+			       adapter->iface_limit.p2p_intf;
 		case NL80211_IFTYPE_AP:
 			return adapter->curr_iface_comb.uap_intf !=
 			       adapter->iface_limit.uap_intf;
@@ -784,6 +832,36 @@ is_vif_type_change_allowed(struct nxpwifi_adapter *adapter,
 		case NL80211_IFTYPE_STATION:
 			return adapter->curr_iface_comb.sta_intf !=
 			       adapter->iface_limit.sta_intf;
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			return adapter->curr_iface_comb.p2p_intf !=
+			       adapter->iface_limit.p2p_intf;
+		default:
+			return false;
+		}
+
+	case NL80211_IFTYPE_P2P_CLIENT:
+		switch (new_iftype) {
+		case NL80211_IFTYPE_STATION:
+			return true;
+		case NL80211_IFTYPE_P2P_GO:
+			return true;
+		case NL80211_IFTYPE_AP:
+			return adapter->curr_iface_comb.uap_intf !=
+			       adapter->iface_limit.uap_intf;
+		default:
+			return false;
+		}
+
+	case NL80211_IFTYPE_P2P_GO:
+		switch (new_iftype) {
+		case NL80211_IFTYPE_STATION:
+			return true;
+		case NL80211_IFTYPE_P2P_CLIENT:
+			return true;
+		case NL80211_IFTYPE_AP:
+			return adapter->curr_iface_comb.uap_intf !=
+			       adapter->iface_limit.uap_intf;
 		default:
 			return false;
 		}
@@ -808,6 +886,10 @@ update_vif_type_counter(struct nxpwifi_adapter *adapter,
 	case NL80211_IFTYPE_AP:
 		adapter->curr_iface_comb.uap_intf += change;
 		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		adapter->curr_iface_comb.p2p_intf += change;
+		break;
 	case NL80211_IFTYPE_MONITOR:
 		break;
 	default:
@@ -903,6 +985,69 @@ nxpwifi_change_vif_to_ap(struct net_device *dev,
 	return ret;
 }
 
+static int
+nxpwifi_change_vif_to_p2p(struct net_device *dev,
+			  enum nl80211_iftype curr_iftype,
+			  enum nl80211_iftype type,
+			  struct vif_params *params)
+{
+	struct nxpwifi_private *priv;
+	struct nxpwifi_adapter *adapter;
+	int ret;
+
+	priv = nxpwifi_netdev_get_priv(dev);
+
+	if (!priv)
+		return -EINVAL;
+
+	adapter = priv->adapter;
+
+	nxpwifi_dbg(adapter, INFO,
+		    "%s: changing role to p2p\n", dev->name);
+
+	ret = nxpwifi_deinit_priv_params(priv);
+	if (ret)
+		goto done;
+
+	ret = nxpwifi_init_new_priv_params(priv, dev, type);
+	if (ret)
+		goto done;
+
+	switch (type) {
+	case NL80211_IFTYPE_P2P_CLIENT:
+		ret = nxpwifi_cfg80211_init_p2p_client(priv);
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		ret = nxpwifi_cfg80211_init_p2p_go(priv);
+		break;
+	default:
+		nxpwifi_dbg(adapter, ERROR,
+			    "%s: changing to %d not supported\n",
+			    dev->name, type);
+		ret = -EOPNOTSUPP;
+		break;
+	}
+	if (ret)
+		goto done;
+
+	ret = nxpwifi_set_bss_mode(priv);
+	if (ret)
+		goto done;
+
+	/* Commit the interface type change only once the firmware has
+	 * accepted the new P2P role, so a failure above leaves the
+	 * interface counters and iftype unchanged.
+	 */
+	update_vif_type_counter(adapter, curr_iftype, -1);
+	update_vif_type_counter(adapter, type, 1);
+	dev->ieee80211_ptr->iftype = type;
+
+	ret = nxpwifi_sta_init_cmd(priv, false, false);
+
+done:
+	return ret;
+}
+
 /* cfg80211 operation handler to change interface type. */
 static int
 nxpwifi_cfg80211_change_virtual_intf(struct wiphy *wiphy,
@@ -946,6 +1091,10 @@ nxpwifi_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_AP:
 			return nxpwifi_change_vif_to_ap(dev, curr_iftype, type,
 							params);
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			return nxpwifi_change_vif_to_p2p(dev, curr_iftype,
+							 type, params);
 		default:
 			goto errnotsupp;
 		}
@@ -955,6 +1104,46 @@ nxpwifi_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_STATION:
 			return nxpwifi_change_vif_to_sta(dev, curr_iftype,
 							 type, params);
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			return nxpwifi_change_vif_to_p2p(dev, curr_iftype,
+							 type, params);
+		default:
+			goto errnotsupp;
+		}
+
+	case NL80211_IFTYPE_P2P_CLIENT:
+		if (nxpwifi_cfg80211_deinit_p2p(priv))
+			return -EFAULT;
+
+		switch (type) {
+		case NL80211_IFTYPE_STATION:
+			return nxpwifi_change_vif_to_sta(dev, curr_iftype,
+							 type, params);
+		case NL80211_IFTYPE_P2P_GO:
+			return nxpwifi_change_vif_to_p2p(dev, curr_iftype,
+							 type, params);
+		case NL80211_IFTYPE_AP:
+			return nxpwifi_change_vif_to_ap(dev, curr_iftype, type,
+							params);
+		default:
+			goto errnotsupp;
+		}
+
+	case NL80211_IFTYPE_P2P_GO:
+		if (nxpwifi_cfg80211_deinit_p2p(priv))
+			return -EFAULT;
+
+		switch (type) {
+		case NL80211_IFTYPE_STATION:
+			return nxpwifi_change_vif_to_sta(dev, curr_iftype,
+							 type, params);
+		case NL80211_IFTYPE_P2P_CLIENT:
+			return nxpwifi_change_vif_to_p2p(dev, curr_iftype,
+							 type, params);
+		case NL80211_IFTYPE_AP:
+			return nxpwifi_change_vif_to_ap(dev, curr_iftype, type,
+							params);
 		default:
 			goto errnotsupp;
 		}
@@ -2445,6 +2634,88 @@ struct wireless_dev *nxpwifi_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_started = 0;
 		priv->bss_mode = type;
 
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		if (adapter->curr_iface_comb.p2p_intf ==
+		    adapter->iface_limit.p2p_intf) {
+			nxpwifi_dbg(adapter, ERROR,
+				    "cannot create multiple P2P ifaces\n");
+			return ERR_PTR(-EINVAL);
+		}
+
+		priv = nxpwifi_get_unused_priv_by_bss_type
+		       (adapter, NXPWIFI_BSS_TYPE_P2P);
+		if (!priv) {
+			nxpwifi_dbg(adapter, ERROR,
+				    "could not get free private struct\n");
+			return ERR_PTR(-EFAULT);
+		}
+
+		priv->wdev.wiphy = wiphy;
+		/* At start-up, wpa_supplicant tries to change the interface
+		 * to NL80211_IFTYPE_STATION if it is not managed mode.
+		 */
+		priv->wdev.iftype = NL80211_IFTYPE_P2P_CLIENT;
+		priv->bss_mode = NL80211_IFTYPE_P2P_CLIENT;
+
+		/* Setting bss_type to P2P tells firmware that this interface
+		 * is receiving P2P peers found during find phase and doing
+		 * action frame handshake.
+		 */
+		priv->bss_type = NXPWIFI_BSS_TYPE_P2P;
+
+		priv->frame_type = NXPWIFI_DATA_FRAME_TYPE_ETH_II;
+		priv->bss_priority = 0;
+		priv->bss_role = NXPWIFI_BSS_ROLE_STA;
+		priv->bss_started = 0;
+
+		if (nxpwifi_cfg80211_init_p2p_client(priv)) {
+			memset(&priv->wdev, 0, sizeof(priv->wdev));
+			priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+			return ERR_PTR(-EFAULT);
+		}
+
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		if (adapter->curr_iface_comb.p2p_intf ==
+		    adapter->iface_limit.p2p_intf) {
+			nxpwifi_dbg(adapter, ERROR,
+				    "cannot create multiple P2P ifaces\n");
+			return ERR_PTR(-EINVAL);
+		}
+
+		priv = nxpwifi_get_unused_priv_by_bss_type
+		       (adapter, NXPWIFI_BSS_TYPE_P2P);
+		if (!priv) {
+			nxpwifi_dbg(adapter, ERROR,
+				    "could not get free private struct\n");
+			return ERR_PTR(-EFAULT);
+		}
+
+		priv->wdev.wiphy = wiphy;
+		/* At start-up, wpa_supplicant tries to change the interface
+		 * to NL80211_IFTYPE_STATION if it is not managed mode.
+		 */
+		priv->wdev.iftype = NL80211_IFTYPE_P2P_GO;
+		priv->bss_mode = NL80211_IFTYPE_P2P_GO;
+
+		/* Setting bss_type to P2P tells firmware that this interface
+		 * is receiving P2P peers found during find phase and doing
+		 * action frame handshake.
+		 */
+		priv->bss_type = NXPWIFI_BSS_TYPE_P2P;
+
+		priv->frame_type = NXPWIFI_DATA_FRAME_TYPE_ETH_II;
+		priv->bss_priority = 0;
+		priv->bss_role = NXPWIFI_BSS_ROLE_UAP;
+		priv->bss_started = 0;
+
+		if (nxpwifi_cfg80211_init_p2p_go(priv)) {
+			memset(&priv->wdev, 0, sizeof(priv->wdev));
+			priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+			return ERR_PTR(-EFAULT);
+		}
+
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		priv = nxpwifi_get_unused_priv_by_bss_type
@@ -3356,7 +3627,8 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	if (priv->wdev.iftype != NL80211_IFTYPE_STATION) {
+	if (priv->wdev.iftype != NL80211_IFTYPE_STATION &&
+	    priv->wdev.iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "Interface type is not correct (type %d)\n",
 			    priv->wdev.iftype);
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.c b/drivers/net/wireless/nxp/nxpwifi/main.c
index 3f30a1f47253..73fa00a9bc0d 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.c
+++ b/drivers/net/wireless/nxp/nxpwifi/main.c
@@ -945,7 +945,10 @@ int nxpwifi_set_mac_address(struct nxpwifi_private *priv,
 
 		mac_addr = old_mac_addr;
 
-		if (priv->adapter->priv[0] != priv) {
+		if (priv->bss_type == NXPWIFI_BSS_TYPE_P2P) {
+			mac_addr |= BIT_ULL(NXPWIFI_MAC_LOCAL_ADMIN_BIT);
+			mac_addr += priv->bss_num;
+		} else if (priv->adapter->priv[0] != priv) {
 			/* Set mac address based on bss_type/bss_num */
 			mac_addr ^= BIT_ULL(priv->bss_type + 8);
 			mac_addr += priv->bss_num;
-- 
2.34.1

