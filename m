Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793195908;
	b=ZMGs9YhR3PlucmCP30kfvWjCChhfqfywWwxqBRKNLpio4Z+/B5J/TgNGK4AAcEo9xll4
	 zEqaEfyzNO3lD9rgJA2CGWShswU5uv4tpXHRAhSqAn4FOTb0NLb1jISD0GLgzd6zzwyBS
	 GBAFTKQNfRKU5hy8/KMu7WMwQJ88fVDuP4PnW1Yxoucc4li80zeskFMJkLzI3gyr+ucMF
	 l2JkSMXeDt1NUO9uRzbj1CjR1uXvQC0UWVzpaZUW6qxfSRIldvtjE8wz3nIHniFz7RcbM
	 uynnVyNThQXLG9T2nI7E4qR5ac4od1kwEGO0c5mMVORh1YLeRhyCy11nSgnzi/nW5PA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793195908;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:X-CLAM-Verdict:X-CLAM-Score:X-CLAM-Description:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:Content-Type:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=b1ZsR0wZ6c1yl47fPPokbR/eZIGWlB+iwI67J2vdw0k=;
	b=J9hTcH35HftdDgowwHh9wMz19E5uomYWd5qn0JKEuE0aunr2imzgCG15LSRH1jb355y5
	 b1GXhD1ol5u4KP+SFc5UW2pYwZPnYltHmx07BaUbv1Eo3A+C1g2mERWRJbScJwOe0ty/f
	 qIXb9iif4MBqD/jdybVVChyz2zJHfgiRyrYciCbFqLAB9NKCcH2G7JIEFhPhZxibv8kTk
	 Z6nri7RcwE3pkH2i7RPYa2UV0LWYpItNBVQLEv2/EqY25iuwWvvwBf3EOBsLgjAfNcHv1
	 pWkLDFh92tRYv9nujW/3gpqXUzMzEZodyK5P3P+0AKJisFIHBgwHlJ5NHt/BZOG//Rg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=philips.com;
	spf=pass smtp.mailfrom=bbl.ms.philips.com;
	dkim=pass header.d=philips.com header.i=@philips.com header.a=rsa-sha256 header.s=selector1 header.b=za9ly2F6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.23
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011023.outbound.protection.outlook.com [52.101.70.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56F0606A31C
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 13:58:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D56F0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bbl.ms.philips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=philips.com header.i=@philips.com header.a=rsa-sha256 header.s=selector1 header.b=za9ly2F6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=do6WkCVGP+r5sZC0D8pFgTww7svjmIxuyeVPB+JBZp8MK8n3fcXv5NhPJ8pKO0U4+ri/NdM1rgoOuYk8/Tu1SJNcpWhTKdjRKDXeMQLmMkGblYRUkRfOBl2/tdMSJGW7MDVri3XkQro9bSpuiYpywOENPDGPF8SPQWDuFaJLX2oOVMdET1OqXxyRfEszDQc65ONwXg0ussB8kgkUJioeL/X90qXg6X0W6kWAL/EVBhI0cJCWnJbaEmdLZtJQIBmFsK2N4lDsz4ksbQp5EOlxIXy64LRin/gYQH5jc1suil4gGt1KY2rmi8gKWxUJW2gF4sAZgCKV7+uvgbl3i5/KqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1ZsR0wZ6c1yl47fPPokbR/eZIGWlB+iwI67J2vdw0k=;
 b=XzPyD+VFjWZ1ON21PB6IkylJdHQKpRJvBGcdlDGAL0on+eaCb9sLfzV6ZprcD5qkQPrIq4c7PG+BqjQt06tRmFyiEW4VUk4nxQ0xYC2bIM+HwrRzyRUfHaJFhQMyNisc4M/XjimICIqYe9haUiWJ13zY4iEljWpmVXSNSCVbQdPOJHcDz1Uob3rh99mQLPB7woRZBLo6JlA5tJdejfw2bB7q53kd8AnKgH3x23NGOpqvC57yih/Te82eGr0K/60KDefFkNL1yNUA9VusTndHf0YUbS4BMRIzOkHJLEwVZvpds51aC2sTj77ZvngFbSM6060SZlVwdovv7slIpcvXPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 3.248.88.141) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=bbl.ms.philips.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=philips.com; dkim=none (message not signed); arc=none
 (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=philips.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1ZsR0wZ6c1yl47fPPokbR/eZIGWlB+iwI67J2vdw0k=;
 b=za9ly2F6Fj9s3KQn2AxgNyFITXqQvUPWTZvhN/5sW1KrQoksdlZeI9kHvP2N4asyEFxM/0U/NLrj/7A4XYiHDUOZ/SfASIRmFUfAabfsrCGVUUgTBv1yf+VwTpy3HSBQytXrPasLcaxMhe5PifwXBMqVwWAhTqsL/0W8WNSDCQM=
Received: from DU6P191CA0019.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::23)
 by GVXPR10MB9162.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 13:58:22 +0000
Received: from DB1PEPF000509E8.eurprd03.prod.outlook.com
 (2603:10a6:10:540:cafe::3c) by DU6P191CA0019.outlook.office365.com
 (2603:10a6:10:540::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Wed,
 28 Oct 2026 13:58:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 3.248.88.141) smtp.mailfrom=bbl.ms.philips.com; dkim=none (message not
 signed) header.d=none;dmarc=pass action=none header.from=philips.com;
Received-SPF: Pass (protection.outlook.com: domain of bbl.ms.philips.com
 designates 3.248.88.141 as permitted sender) receiver=protection.outlook.com;
 client-ip=3.248.88.141; helo=ext-eur1.smtp.philips.com; pr=C
Received: from ext-eur1.smtp.philips.com (3.248.88.141) by
 DB1PEPF000509E8.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 28 Oct 2026 13:58:22 +0000
Received: from smtprelay-eur1.philips.com ([130.138.84.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 256/256 bits)
	(Client did not present a certificate)
	by ext-eur1.smtp.philips.com with ESMTPS
	id LuqjxngoztKtZM4AYxIh0F; Wed, 28 Oct 2026 14:58:22 +0100
Received: from mail.bbl.ms.philips.com ([130.143.87.230])
	by smtprelay-eur1.philips.com with ESMTP
	id M4AXxaQijL551M4AXxy56J; Wed, 28 Oct 2026 14:58:22 +0100
X-CLAM-Verdict: legit
X-CLAM-Score: ??
X-CLAM-Description: ??
Received: from bbl2xvg1.bbl.ms.philips.com (bbl2xvg1.bbl.ms.philips.com [130.143.220.100])
	by mail.bbl.ms.philips.com (Postfix) with ESMTP id C050F180394;
	Wed, 28 Oct 2026 14:58:21 +0100 (CET)
Received: by bbl2xvg1.bbl.ms.philips.com (Postfix, from userid 2884)
	id BA35CFE0237; Wed, 28 Oct 2026 14:58:21 +0100 (CET)
From: Vishal Gupta <vishal.gupta_1@philips.com>
To: briannorris@chromium.org
Cc: francesco@dolcini.it,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vishal Gupta <vishal.gupta_1@philips.com>
Subject: [PATCH 1/1] wifi: mwifiex: synchronize scan cancellation state
Date: Wed, 28 Oct 2026 14:58:18 +0100
Message-ID: <20261028135818.4166538-1-vishal.gupta_1@philips.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB1PEPF000509E8:EE_|GVXPR10MB9162:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 8c355e47-160d-4618-b062-08df34fb874c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|11063799006|56012099006|261009223027099003|261026121527099003|261021121427099003|261021123027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QEaQFrutpSZ11d7IdHZ6L48qkTWXE2ftOuSECG9fruij3JAdeMD6Jqq0SDB5ffKDRrnbxPVsKKa8qnIfmXkoJR/D3UIxvTY/TiW3Hen+MVk7yvkUfSNiZbjTDiYxgFUlqFd77Lf8yYeskMucCOCmjU6gB9GqgPt5Hnxc2USx9eq4sZl/X2bZVH7pTrHAOICRXDFJlcWugC/GpLdTrhQwn/7F40h40uQ8cxmE0dDxa//tJ1N6xtrspIrTtSM1HPgs+2An6QiEjVNHZmbznQ3RAmYolaZ6gPq0agtqyWuu/OxiE8XEw97C2x15/gWuaCq+Zu7BO9T6jjb7xTAyvdpVDJI5ibEd/VC1lBgZZkvIgypAWQqxtzAm1v6fReFNplocTojWutFYlSddN/4QyqkSLCJB1PUOyQ9PIwCYg0USG04Tk0kglxSxeWsk40zLyipHDCR+TvOmA4ix4eh9VMjoHWDGYkIeD4xkJjlprHWAA9NdYDSdDaZTKauuUWnetSkZ9hETU3umojJGTkZgtbF1Q6cyqwwYGZAlyYPma7eWqx66yYU0wwgULZj76//S69tWunvMiPFQenZ41yG6FcxVQQVINo6bWCg+fYKT2ACdX8tRhB2eqYqsE2wKDVjCnTG7tfbTQIKzi6ujroo6Gms/um4nOAsDVy8HQ6j14pB1vt4jXd2A9naO9p+2rjoiQJqKyaVl+/FgqS2skfpThSWzXg==
X-Forefront-Antispam-Report:
	CIP:3.248.88.141;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ext-eur1.smtp.philips.com;PTR:ext-eur1.smtp.philips.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261021121427099003)(261021123027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nhSFF70oRwhvqXAgXilBN8JUEg0BNsDPftXuGOcbCorEzUzK1E4VKF6RkmWIz1/Wn4ANZ/lpUReQRRrNgZ5aiteFihXhroDX8TAJZ/cQUjopKodjdKC6jGRI/tWB+2wmIECnhfhOoofNjWOIVm6pW/I1qUgDJ+wofnyQbj5YmvCbv3o50wxLqoqcY/LZG+co74juJWkG2eH1OdY6W5WhJPYX0uuTxobxoECEZ4UQAPHuoMDmtklCjtyceaVzWmOKUCEqqX2Bs94jlzmOQyb59N+qXO0lrHvctzD6gp4H0s1hKdwz5nj2OO63BYa/+nhMYl+DL71tiLVMJWqEJ7eHwNFRW3C1uxIYxIomYt2oWFf7k6TclQP1ojJZJUSN2wEEiOCoS828g3feenppufoSMssKBrCzABtHi9VGgSUHrUf0nBhHo/CHiHJJvjSYWzTf
X-OriginatorOrg: philips.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 13:58:22.1231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c355e47-160d-4618-b062-08df34fb874c
X-MS-Exchange-CrossTenant-Id: 1a407a2d-7675-4d17-8692-b3ac285306e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1a407a2d-7675-4d17-8692-b3ac285306e4;Ip=[3.248.88.141];Helo=[ext-eur1.smtp.philips.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR10MB9162

Read and update scan_processing under mwifiex_cmd_lock so cancellation
cannot race with scan state changes. Skip scan completion when no scan
was active.

Signed-off-by: Vishal Gupta <vishal.gupta_1@philips.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 34 ++++++++++++---------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index bdd4b8465863b..c2c5738d8a3fa 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2059,26 +2059,32 @@ void mwifiex_cancel_scan(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_private *priv;
 	int i;
+	bool cancel = false;
 
 	mwifiex_cancel_pending_scan_cmd(adapter);
 
+	spin_lock_bh(&adapter->mwifiex_cmd_lock);
 	if (adapter->scan_processing) {
-		spin_lock_bh(&adapter->mwifiex_cmd_lock);
 		adapter->scan_processing = false;
-		spin_unlock_bh(&adapter->mwifiex_cmd_lock);
-		for (i = 0; i < adapter->priv_num; i++) {
-			priv = adapter->priv[i];
-			if (priv->scan_request) {
-				struct cfg80211_scan_info info = {
-					.aborted = true,
-				};
+		cancel = true;
+	}
+	spin_unlock_bh(&adapter->mwifiex_cmd_lock);
 
-				mwifiex_dbg(adapter, INFO,
-					    "info: aborting scan\n");
-				cfg80211_scan_done(priv->scan_request, &info);
-				priv->scan_request = NULL;
-				priv->scan_aborting = false;
-			}
+	if (!cancel)
+		return;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (priv->scan_request) {
+			struct cfg80211_scan_info info = {
+				.aborted = true,
+			};
+
+			mwifiex_dbg(adapter, INFO,
+				    "info: aborting scan\n");
+			cfg80211_scan_done(priv->scan_request, &info);
+			priv->scan_request = NULL;
+			priv->scan_aborting = false;
 		}
 	}
 }
-- 
2.43.0

