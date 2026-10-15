Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013025.outbound.protection.outlook.com [40.107.159.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1C944470C
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 11:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064122; cv=fail; b=ZdKOkAZ+lzKX6XFk865QhM/B26zlaoekJWE+lXQhfZw4yFy0PDLmR1V3gwZ+2E/AV5XpGEuTInegsTPK8qYIsyarrtb/86rD0AqvGSqAMgBC6G2MAXPIh3kM0mx1uIIEfmuQbucub/44MSZSOCF4ggDb74JB49OcvW7d4GRFH+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064122; c=relaxed/simple;
	bh=jxzpPPhtf/NAwcp/lahrA8WSuvBEc64hP+LHbxIz2fM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oYF/b5ONaO4VeADMHdUWMnIo1cWIzGVx8WbpeDNsfTF1hVNr0peZdpC/bXQ7p/WoloazeXfKMlRkGnrFUoO3GB5kGAsC7uMKGkgVv9JVSTZReAEYIv1jMblhNrFMCnIGUF7+5uVD38pviyn5Gn8zRladYsYH+T9WcTplccAw9Uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philips.com; spf=pass smtp.mailfrom=bbl.ms.philips.com; dkim=pass (1024-bit key) header.d=philips.com header.i=@philips.com header.b=CWm/ERJX; arc=fail smtp.client-ip=40.107.159.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bbl.ms.philips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philips.com header.i=@philips.com header.b="CWm/ERJX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V8/3IN6RT3gFAfV+l0gBUvf0SNuAX8mxjLkNMggjSrviGMqzNPJxw9iT1KkCs/ekvyPhqbKjAMeHACZz48A+u54VN54eJNPJ7412O6xYzOo04eWhOZEgOqw+v3t+Ou29GQjTL5Rf2GyIqIokiqXcSwrP5S59J89arjehZkx+KTpKWfNiDYH8AJXNaqZCaXUKFoFyVqEUTjXgxrEtivAbrYGlnUzPnZ/8ftwpmJ03c48Uc4zVTvJLpaomC202qTSWWcgQRyPah9AMPVjqKx+mtFsauqkmIl1oFlR6saRroI9HDFrocVhFeRi6NaXNDFvZo2N3Zy7prpOVAZTk+Zc5ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4s8H2vSNvo8SJTUh0JZC6M8NqDcCkCimgCYC0JJ2vrI=;
 b=F1DaOlLtThNV7vKz5a6QfWtOPRu2+1/y1eH2CbwOpCoumL89IOQVZpi/IXIP85zjCx7ssrftK/b5xQ7FU1s7sOATIZ3SP4pNc/IvIEz0WbHnA4zxMUL7fx1n6oRQRFef5dIITnJ2gVHM+SGaQKGvDzuP30GWF9+zWHn+XcLkJyNyQQ184nFgoDEbUJdJiMRyN8zLrqgGjImMs+pJ0x4gZVnF925Cf3lfl2a3XZ97NEVMqVNBs2dkf1mSzhQunaHWDUfRdFUmVmTUKGZp9z3u9H94X0p24l7T/RNGmM78IeXjWIbzWMau6En0LijoCvMmJP6OEAwtsAQrTUCldLPNCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 3.248.88.141) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=bbl.ms.philips.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=philips.com; dkim=none (message not signed); arc=none
 (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=philips.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4s8H2vSNvo8SJTUh0JZC6M8NqDcCkCimgCYC0JJ2vrI=;
 b=CWm/ERJXrnbtHCqCCn7sodxc36qJ4WK1vftRBKtTO4/N47IxofaTEiblcqy3JyIxVa3nwNWo89rRbMmjBq2w1TwBEmIIR8DmJs8ggkG/cZR2lnobc60BaAf+5kkwTCW62q2EtDHO5CuUyY1snEBrx8Z4FOH0DlEP/tI0CyOWrB4=
Received: from GV3PEPF0001DC16.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::270) by DB9PR10MB5858.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:395::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 11:35:13 +0000
Received: from WA1PEPF000099D2.eurprd04.prod.outlook.com (2603:10a6:1d8::16a)
 by GV3PEPF0001DC16.outlook.office365.com (2603:10a6:158:400::270) with
 Microsoft SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id
 15.21.406.12 via Frontend Transport; Thu, 15 Oct 2026 11:35:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 3.248.88.141) smtp.mailfrom=bbl.ms.philips.com; dkim=none (message not
 signed) header.d=none;dmarc=pass action=none header.from=philips.com;
Received-SPF: Pass (protection.outlook.com: domain of bbl.ms.philips.com
 designates 3.248.88.141 as permitted sender) receiver=protection.outlook.com;
 client-ip=3.248.88.141; helo=ext-eur1.smtp.philips.com; pr=C
Received: from ext-eur1.smtp.philips.com (3.248.88.141) by
 WA1PEPF000099D2.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 11:35:12 +0000
Received: from smtprelay-eur1.philips.com ([130.138.84.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 256/256 bits)
	(Client did not present a certificate)
	by ext-eur1.smtp.philips.com with ESMTPS
	id HFyLxanSWtKtZHJjrxc33x; Thu, 15 Oct 2026 13:35:11 +0200
Received: from mail.bbl.ms.philips.com ([130.143.87.230])
	by smtprelay-eur1.philips.com with ESMTP
	id HJjrxKWU3L551HJjrxOSSX; Thu, 15 Oct 2026 13:35:11 +0200
X-CLAM-Verdict: legit
X-CLAM-Score: ??
X-CLAM-Description: ??
Received: from bbl2xvg1.bbl.ms.philips.com (bbl2xvg1.bbl.ms.philips.com [130.143.220.100])
	by mail.bbl.ms.philips.com (Postfix) with ESMTP id 8E0AB180078;
	Thu, 15 Oct 2026 13:35:11 +0200 (CEST)
Received: by bbl2xvg1.bbl.ms.philips.com (Postfix, from userid 2884)
	id 89845FE023D; Thu, 15 Oct 2026 13:35:11 +0200 (CEST)
From: Vishal Gupta <vishal.gupta_1@philips.com>
To: jeff.chen_1@nxp.com,
	johannes@sipsolutions.net
Cc: francesco@dolcini.it,
	linux-wireless@vger.kernel.org,
	Vishal Gupta <vishal.gupta_1@philips.com>
Subject: [PATCH] wifi: nxpwifi: synchronize scan cancellation state
Date: Thu, 15 Oct 2026 13:34:33 +0200
Message-ID: <20261015113433.2312077-1-vishal.gupta_1@philips.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: WA1PEPF000099D2:EE_|DB9PR10MB5858:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: ba2fce7c-c886-440c-60b8-08df2ab06003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|36860700016|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ofjwLH88vO19DmBX32/shTt6squtFOyE1gsZeCZGJ6eUhyQ3SlAa1oeHhl3I/cq6QkcAloL2glgLecDCST4TD0376ve+5cjDPJD3BJDrD3Rdk1onQVw2k8zdI9LwjVQ/f/ewuxk7KbhMGev//oPxHnfYdGGEz08ItZSTwG7rx4nhv1nB4Zeny8amk4fPpbJBhkJLxapn6ydanAzHmWOHu5TvZUZImw4a1m8bj2O1rt8Yu3Sb2xcKnGUa5m0UQR9ud+iOpo9K3VgkzpW1zk+b4ifOENwsRWP5P6AztFm1VytoNjbhESKbFxsozaHJax62odkEFgdXmYAqsLzkxk9dFQkzRIT1EhUco1oUZnZHuXvyveCI71xLIHCsv/nl1LebsKX6RA6iBfQ0ku1EqpHWCZl6WzSzGNDrig7UBBI4UvUqIWVVKszBLmsbt95+GBwArwX6mSJzB/Y4YiaMKZldK8k09DaynoEC2j5fk4qL+ih4P5y9Nx+zZBGRoMGoQkEFJYWGyDnC0CBOs99kaYyMyfhmRh39MmPf1tPlYVfXM2iPRIaVloCIDnKnSuSOgTSAVT9IE0wSAShIqRvOnBPACPS7dJ8Qbl80SD4T8UgycYeWHxDu7HGroRuLKvP1eTTwQ9N/kzEkVb5jj6W9teOu5P/LpMzEl8yYk6/mKAcjfqYlNuXic1aUiJP46bklAIbIb7WbaycAPTf2KV+oAW95ww==
X-Forefront-Antispam-Report:
	CIP:3.248.88.141;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ext-eur1.smtp.philips.com;PTR:ext-eur1.smtp.philips.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+d0Ebzov5jOf5qPUTpQT19a5lVjjajEW1oIc3o6XaEQJ1IE88v7FTo2TeuqRZZkLFWN6l5gxjRC47W/Ir9yZD+Z/1KjjqsajO8aYPqI//h2TN4xBYzQCXseFJ1c11WyBY5YrrQChaoNIP934kgu5cqYI1FU+fE/r3qppsaiSsCm2mBvS/Phjae1Mq2EOhBIjINCIGBb0buq1xvlaX9KOTRXa/lKquIxS1KM2ScYSbGsdgA2PRB5NykOolm5tYyfIGyuT1YqGkO97Rse50e32CsnDdnyytl9kqYWPQHEHkx4Aq2U4x/sK5JWc2PdTCOXXdLhd1cBeblR63JNNFGWC1/bfm1P4m3DnniBkdMvbUQfAg+TQaKqHwjGaWX6hS5lmGvTNsLzt+DxTFaF5qRVpGplPqZrMYnDwYos+iXJCDJj7fJhmrff4fyVYakjvqJ2B
X-OriginatorOrg: philips.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:35:12.2222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2fce7c-c886-440c-60b8-08df2ab06003
X-MS-Exchange-CrossTenant-Id: 1a407a2d-7675-4d17-8692-b3ac285306e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1a407a2d-7675-4d17-8692-b3ac285306e4;Ip=[3.248.88.141];Helo=[ext-eur1.smtp.philips.com]
X-MS-Exchange-CrossTenant-AuthSource:
	WA1PEPF000099D2.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB5858

Read and update scan_processing under nxpwifi_cmd_lock so cancellation
cannot race with scan state changes. Skip scan completion when no scan
was active.

Signed-off-by: Vishal Gupta <vishal.gupta_1@philips.com>
---
 drivers/net/wireless/nxp/nxpwifi/scan.c | 34 +++++++++++++++----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/scan.c b/drivers/net/wireless/nxp/nxpwifi/scan.c
index 67d7ff2f10c59..57ab10908c152 100644
--- a/drivers/net/wireless/nxp/nxpwifi/scan.c
+++ b/drivers/net/wireless/nxp/nxpwifi/scan.c
@@ -1855,26 +1855,32 @@ void nxpwifi_cancel_scan(struct nxpwifi_adapter *adapter)
 {
 	struct nxpwifi_private *priv;
 	int i;
+	bool cancel = false;
 
 	nxpwifi_cancel_pending_scan_cmd(adapter);
 
+	spin_lock_bh(&adapter->nxpwifi_cmd_lock);
 	if (adapter->scan_processing) {
-		spin_lock_bh(&adapter->nxpwifi_cmd_lock);
 		adapter->scan_processing = false;
-		spin_unlock_bh(&adapter->nxpwifi_cmd_lock);
-		for (i = 0; i < adapter->priv_num; i++) {
-			priv = adapter->priv[i];
-			if (priv->scan_request) {
-				struct cfg80211_scan_info info = {
-					.aborted = true,
-				};
+		cancel = true;
+	}
+	spin_unlock_bh(&adapter->nxpwifi_cmd_lock);
 
-				nxpwifi_dbg(adapter, INFO,
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
+			nxpwifi_dbg(adapter, INFO,
+					"info: aborting scan\n");
+			cfg80211_scan_done(priv->scan_request, &info);
+			priv->scan_request = NULL;
+			priv->scan_aborting = false;
 		}
 	}
 }
-- 
2.43.0

