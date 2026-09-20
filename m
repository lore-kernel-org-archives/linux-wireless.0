Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013036.outbound.protection.outlook.com [52.101.72.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143223B71CC;
	Sun, 20 Sep 2026 02:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789871509; cv=fail; b=ZT6ooFUXmnHg+92jmlavWBqWKbZYE9UF8nLoJ+wamKKUJhm4IFUFIIWBHFFA/QTBjSdoAi9bFpgOeTuwg15SDiI/kcK4MkzeZ6VPnAtGoS0qWX+r6msnbkVvUdYI2imh2OAypo7LqdzXNbVDhuH0St6IObrNdiyCI9b3JiZGd5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789871509; c=relaxed/simple;
	bh=1DeK4kjYaE+CwS3wofXeQSO7k+lhsTcI3lcrFUIUDio=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Mu+GGI8i8boG6isxM1Z9jXLBuUcVIVhFjq+D2WFJk0Zo7I4QVBnDPuCmsgkCqyADVKrxSDZXenIt09KSZJadoVUFYvlbfxEF6X9UI+nYDSfJ+qFVfF/obf5qmNn7kJ3LmVho8zssaU8VpdSKwr3RgOqftiD2dgbXobkLOWCm/7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=LX1iDcD2; arc=fail smtp.client-ip=52.101.72.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="LX1iDcD2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HQMpTHScEGhujRax1NTxSBASq30sy2m/TDDcptSKY/0eLTZhsAREt6LGfzM42OffE3uKBPoAO967lgKkSkWKAQI11rj5DGBfCWG3IBUaTSLPEfuNAK+3wXaCyp29Z1u62rTeHDRbNiUUrAKHscrVgEex/FFt+KdYEgMB2xgip4zv8gRUpfzNuGU0yx0NqRKZ4IaOCwA8V2219cwpUlHAC5fECOmOJZqbH5G2og8NwJsS04LKMgeEW3G//HZ4FDucuYaNQMmCxwsBsMEv5LP3oe08O8/eUzw+Zwtbko++6ZnEdUr3+wmy1VagZ/PC7U8oeItts+z1zA1uXanTxFm32w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OEhjQEfKHehWWyuIrItPzyNzNDYT2EBoe1fqpLlin/o=;
 b=dMLCRVkIpKFvBzw/mx6rDhBbX3hwQ2eKHLECfpDuDk9ke7H3p4G6lRYpm1iRlPm+mWrb0EmrfKxJmYz8GFO+Kr0sacMw6+XyzcdS1ncbQmrDMeAnD+nkTWMnePM5/MEmLxmiryaZdOVe+UXwmrhaEZ2vjfhCWIazgzNmwyaPhcbQ2eqDftL3RjaKuod5Y7MsJ3ok1R5/gu/eR/LCTPfVJiAD6j0TWEvgu0XBPfsBGTuz3rCryBntIZb3D/raCTdFLH0P44tg2KljWl2oVQdWS4ukl99Z9QCWbghxeiCo487mvEkZ/Dq2wHw7Nah3wNSk3xA9vpjeiweJc4F1LlTiBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEhjQEfKHehWWyuIrItPzyNzNDYT2EBoe1fqpLlin/o=;
 b=LX1iDcD2/zRqD1V0OmKb+Fi/zB3e6P+/CPTEua/1dSwXKQRSHa0PV0/OkakWvVZcGO7jivttV9gaiPaXkZWiOsSG0s2mDPLXvXLDxee1vnA+e05uYVl2FAqfSV6euSkUWWXApJXE1XQytS+uibZgd5/j6pkZg8m0P9cSMr5POPdX3AZl7vSVZCsFAdsVKHhejx1lz5yO84ONLZMUEgWDVUIOy8h6dOoWXHu55JPKdPyE5D/P+DZQgL7gy9mZ4zOEAP2UPUM5VkGwOqq+UqveBbGt/DkMSYUwZ39oaNsm7G8hBoFYbcbu5m/LvAC+RHtV2MNjAPsCBhWwSOTzDSDD3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by PAXPR04MB9596.eurprd04.prod.outlook.com (2603:10a6:102:23e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Sun, 20 Sep
 2026 02:30:53 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.014; Sun, 20 Sep 2026
 02:30:52 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Peng Fan <peng.fan@nxp.com>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: mac80211: use assign_bit() where applicable
Date: Sun, 20 Sep 2026 10:28:18 +0800
Message-ID: <20260920022822.3145944-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR03CA0002.apcprd03.prod.outlook.com
 (2603:1096:4:297::9) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|PAXPR04MB9596:EE_
X-MS-Office365-Filtering-Correlation-Id: 59b6a2fd-dccb-44c8-0655-08df16bf3118
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|19092799006|366016|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	PGAGAlN+ugSZnd6tZtprKsQkMDTOnQeTJD3uoNrWXZdILDYcxe0Shi6seru4W7PU+BHe0Jx0xJfXymD8xngOL3RePE5rj8NaGd1TPUthOhkxavfZjTHQOi4VGGkMVkMOa/C7UljTD/asyaCSLecpmrDHYS9Oz5FDKlQxvIIMVZuNM998d2/1PwWkEVWuiJVjFY2vTjd9dxXAeBsdRk60mtAmVAqzkhwzY/LVYv5ixPbAJGJZQtOvEa/e9bw2iNjLrfyiSo3j3n4g5hmy/rdKVG8l1wbaij3C4Y3J1fhDxN0HP5bRjQ72beFUigaqn8o2RAc+D6rGu5ZWgTAoQXP6Mzqli/lcu/dLQvC6KB1g9MSeWzKR/n+vOASpd4a4k6uOkmuyTTmlqzpnk2hFQNlLUw8rUAs7pMdi9XooBk7EvJaKw+KM5CnFahv8yUUZtRW9IqW2fx74ECLRAhIoUAqkHlvnC98TlVfxcEKph90VADptyKDR++BeDaP0sCD875B3zGBbWme3q6VVuplZelciVr3Osrw0mPtPwdb1DDYZVZ2IE2GM9K8kRladBLirFmS/Vgz3p4Hxr+Rz9yZ0CwKtwcBLERcHGkuFh9F0ZgceAQReqay1PjxngyBD907QvxZuayFcXen89UpFGWXAmDDLrD3i1ql9KhkvTRQkeLp5pJs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(19092799006)(366016)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mNILClU96VXfVZPrKa52x91ZLEWBD1clzihezpsRyWtSLgYHa+5ZeCsqmWWk?=
 =?us-ascii?Q?MRKOqG1NiWxt0TV82MMCEVmF3lTjhbsO2mAbiT/AyHAmLu+OwDWHMIdHT72v?=
 =?us-ascii?Q?Exrvmr5UrO1tE5ElWOIGpETx/3Vt5C/uQu46RS1x8gwzkxFGc4iqRlpnSGbu?=
 =?us-ascii?Q?0ly2bpFZFBNc+iSvv8ymzJKDpnIF8ky4BB9sV+2Mt3Pi0GIu3Z5+HRbGxzc4?=
 =?us-ascii?Q?xRdb1u/4siWNe18Ivgh/O+REV1B6uBAEq7DfUIqwF2ygvyoSmYyi+HzZ0Flo?=
 =?us-ascii?Q?SiUzgi+b126nFHoqS489Yx3/G0MqmFGlsizGdjlaHtDocj0p5jYvSycoSw4Z?=
 =?us-ascii?Q?tnqIm7CTDLyOuIu9gbziAWJO3nKrgSa0p0Xgf1gUNNExaslGOUgXqT3W7S3i?=
 =?us-ascii?Q?vu4LVbOOGaY+j+s/hOwBazpn1zmGDZ08PrDlQoXoDjB2NmN+SI73ps6ceqai?=
 =?us-ascii?Q?xfi91m+ivfuAIEuz+Mu4ZkTeEzQO471BhjGQBL0LQAk4d4sjO6nkWv05bjmN?=
 =?us-ascii?Q?ln1NmLNwTryuI2VkXMcs1/71melQVqYKY0g7wAvAvq9/1/b14aYqUGxJ1frW?=
 =?us-ascii?Q?wUAGBRjrf1RY+Akrl6CxKm/IsdjTUiniJmnOVW/2Q1mrZIqiVPG5UCFArlg0?=
 =?us-ascii?Q?pb0yCWZEVToUrztQdtCpTEpvF4191tNcFG41dlHsuVLJCmQqe4PQHgXfZA+f?=
 =?us-ascii?Q?IhWWQXFKBcuk7c/RyVzJcpf0JbKWSH4iA8yQH6FF+5EJZS82arQyYbLYPwid?=
 =?us-ascii?Q?Py82eF8I54N3p6F4f6e5BPbxRHIgHJhakXtXm+3Yd3PHOWyns2YmcyMPmkq+?=
 =?us-ascii?Q?0LRl1btZ5AuTi61JIIE6kk2PtpcqgM38KVge7BbGAn9fAfKDua73kydEVe1R?=
 =?us-ascii?Q?9mJqRZq4V5E2AW5/VI2cNAPU4QRfpX3zDPwnfPsvcSVN+oU/i+YIVdwobIgq?=
 =?us-ascii?Q?C1a1eNk7r1VDPt7j87Wmkdrp21J7Q1dUYyWqlxbeZKz5hU8BwPHluExWCBt6?=
 =?us-ascii?Q?3W++KD4O5KM10E2iPa2s1ocf73q2rEms0q/WwbGDB1nAh4qWqK2mzqVSCrB8?=
 =?us-ascii?Q?S4d72qDlqictpuc2U/rq1uhhVQ1MsNtqjbAbGoF+2Gv8J7tzbCzJaJd+6+fh?=
 =?us-ascii?Q?DJN9+MqBuvXyqotnhn1nBCwRi49Z6FGp1EYk0/JieiGDl3+VgcsC1J+2qT6m?=
 =?us-ascii?Q?9iGloovO4epHXdsbgAqDbjojYLw5kS5YHFtEtlg2ai5ZSOzQOvag5WS+MOVR?=
 =?us-ascii?Q?BLgFfZHPallHSKzaqpKUM4gWMcmWgvKf26VrR6wirDTIWRXviCy32aPbFERd?=
 =?us-ascii?Q?0Iklz5DW6TAQOIz4TNBmHw0uuX8vazDE3co5gh8WyPPV5NTstRUaNv7G/gii?=
 =?us-ascii?Q?ias0aX9K4X/P+1/2sOyshEeK610S05OuEnCtGGCs1HqBQcRsJOlGVJJ4ipHQ?=
 =?us-ascii?Q?YFSDKuTRD//iKcr0m4LYLunQMhFTK7ygVb6iL1f8LdAYpdUy16ySm1l4Bt6u?=
 =?us-ascii?Q?g3zxE0MqmBlhl0On5bPorgxTyu749q87Hd41DD3I11OUlW5gKYiSieuSuTx/?=
 =?us-ascii?Q?LGRbx3lSmu7smNGWIAGnZj2Cvre2sj7mqczVv/3dA+DyFsoxhGhvV8B1pZsk?=
 =?us-ascii?Q?IC/Xrn69AXwzNtdZ/XHORuwNzsXJn8ck3dCnOWJShQtOnTqBTwUClpkc6ogX?=
 =?us-ascii?Q?sWzdCS2f3i0kLH7rFJ55so4Sztdl9q/7n+qNcvAUxAEtb3gqcR3501LRtXue?=
 =?us-ascii?Q?AvzVsgwenUAQIRPb8/SiAfbnW2sEhcjrEfn+DZXD4Xk68vTP7u2f?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b6a2fd-dccb-44c8-0655-08df16bf3118
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 02:30:52.9225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65mR8XwRxHjnGOUfSyCb09qXoF0OVSpIOROZed4dzZ99j6eLGTuV0CQTJwxMrHGkjxO8fHb6E2P9znbc3prq9z1nv1Ypob2B+ewDGrsFRcgwR1FWBfvvMVG6cSll4qbz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9596

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit the assign_bit API.

Done with Coccinelle semantic patch:
    // set_bit -> clear_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        set_bit(bit, addr);
    -else
    -        clear_bit(bit, addr);
    +assign_bit(bit, addr, cond);

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        clear_bit(bit, addr);
    -else
    -        set_bit(bit, addr);
    +assign_bit(bit, addr, !cond);

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 net/mac80211/agg-tx.c          | 5 +----
 net/mac80211/rx.c              | 5 +----
 net/mac80211/tests/chan-mode.c | 6 ++----
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index ce9fb19d8c18..f3ecdd8601a0 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -212,10 +212,7 @@ ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
 
 	txqi = to_txq_info(txq);
 
-	if (enable)
-		set_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
-	else
-		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
+	assign_bit(IEEE80211_TXQ_AMPDU, &txqi->flags, enable);
 
 	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
 	local_bh_disable();
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d6755a4c7d3c..b3990b7a7299 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1692,10 +1692,7 @@ static void sta_ps_start(struct sta_info *sta)
 			list_del_init(&txqi->schedule_order);
 		spin_unlock(&local->active_txq_lock[txq->ac]);
 
-		if (txq_has_queue(txq))
-			set_bit(tid, &sta->txq_buffered_tids);
-		else
-			clear_bit(tid, &sta->txq_buffered_tids);
+		assign_bit(tid, &sta->txq_buffered_tids, txq_has_queue(txq));
 	}
 
 	sta_info_recalc_tim(sta);
diff --git a/net/mac80211/tests/chan-mode.c b/net/mac80211/tests/chan-mode.c
index ab7d38ef6a3a..85dc87215d23 100644
--- a/net/mac80211/tests/chan-mode.c
+++ b/net/mac80211/tests/chan-mode.c
@@ -219,10 +219,8 @@ static void test_determine_chan_mode(struct kunit *test)
 	/* To force EHT downgrade to HE on punctured 80 MHz downgraded to 40 MHz */
 	set_bit(IEEE80211_HW_DISALLOW_PUNCTURING, t_sdata->local.hw.flags);
 
-	if (params->strict)
-		set_bit(IEEE80211_HW_STRICT, t_sdata->local.hw.flags);
-	else
-		clear_bit(IEEE80211_HW_STRICT, t_sdata->local.hw.flags);
+	assign_bit(IEEE80211_HW_STRICT, t_sdata->local.hw.flags,
+		   params->strict);
 
 	t_sdata->sdata->u.mgd.ht_capa_mask = params->ht_capa_mask;
 	t_sdata->sdata->u.mgd.vht_capa = params->vht_capa;
-- 
2.51.0

