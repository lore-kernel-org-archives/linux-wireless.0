Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792426454;
	b=X/C0B1XOJfimS1SrZxrBh/61G8b/HInLhO13BCLmsjxl7TbDs89mJyRcLSUvOg7T2raC
	 +kLi6bhxU8RYvseOJpzRNRNQSKwqlepjhLjxs6N4tAttyqXbjWtCyHG/DJufzyUpHTezf
	 XWpQpZiKJLMmb19KiGQE8HutTv4XyEVzB0BZSUWakvnisFLjoakWzNlWdmwT4Zj0npyLD
	 xpy51j57NVOhR/e3GXIu8EFUrSaJ28hzAS7DQ0YDLQmxGO8dcZJwPR+dtJCoLosHHzIbp
	 3g9yFJu1x0mCvU/cJdc63J//kNQg/l4B2iJaGNJEt2ioVV6gwE3ar99M/POuye7w9pA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792426454;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:X-CLAM-Verdict:X-CLAM-Score:X-CLAM-Description:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:Content-Type:
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
	bh=ZqnGzIUflhw3JhCsOERD1n4KaWDGEL8Kdaq8Pb/h1ns=;
	b=LNWE+Rg30DawhLA8pzUk0iASloLvaNThRmNG4tr/JJvqzKzMkafxFiEFxAsMihIsJh6Z
	 kvpUO7LkT7YxgDLG5s+J6zvqRBqgW1i+Wy0u22f6CQBEUmVVnTqf/zBAwJGzpnbBckcx+
	 3rTCN85RG5n8ZWYDozTkKARbM2j3utkVNRTZKXG0HUo4aL0hWPHP9np9QBL895GzFYQTQ
	 66h5aZ0Fv/NREH5FF4GMmwzPCHc0Eog8GfDbZ4y0GZ3uckD6OzeobWvoRFxwdTBoI1fD4
	 SJgxj4O/HZ47F+OJ9uTXTZqIhshFuke/mWNWODLAi2nWa9/H6y8ApW9WKsFDqdQum0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=philips.com;
	spf=pass smtp.mailfrom=bbl.ms.philips.com;
	dkim=pass header.d=philips.com header.i=@philips.com header.a=rsa-sha256 header.s=selector1 header.b=ZXA4Ze3D;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.22
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011022.outbound.protection.outlook.com [52.101.65.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE44606AAF4
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 16:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADE44606AAF4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bbl.ms.philips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=philips.com header.i=@philips.com header.a=rsa-sha256 header.s=selector1 header.b=ZXA4Ze3D
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pTYvPwHFExkfDa4yl+hPi75RefWr7oSuV3V3S2c+vZEb6iavRa7ZKxB/LDxQT0r+2dn1N9LrBGo8rWPL5TqPpwiV58UqLq4d5jvlD3ClzKDm2yLNWwXWIwfoCrpkztEAFLihxp49WgBfdJuB4Orgwa5wYJPlH3I8OLEJS1IJ9PtOzarD9aLPO66Z4I3H6kAkpbFrAaHpSqxuTN0S5l7WZqkg4qyu+/hRFnQ2wGCfu2Se+x3dnVDFOxRw2G9qziwGf3rKKNtRfBWzdTgjuJ1gKAq2njy9n/TnEVdnJFWNfLUifngyXB9HWOqr+YKY4yuUr8D8a1+5yaK6NcKyqE9f/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqnGzIUflhw3JhCsOERD1n4KaWDGEL8Kdaq8Pb/h1ns=;
 b=c08P6/Sj2ED7wnRybWl6Zp8ItI0nR28YX4UDPYXp75ON0rEiYppDCNlu38KPzfrA7EiOHCtRYUz9vm3Coy4Hbe0y1soyCTOyoclMkaCxG+0IOPzln3VFPMNOu9sqSm6k8LT/DGBhhxFRF7UELHeSkWwSWsnVgrZns3KpUHgJwJXjG/hwUPK3ohMpHt4SpJk05XsEI7fULAgp2KX6MvKc2Ufwjn1zlDfm6lo0bFATx2nqWju7zEyoYN0p5toCVQ6FO3/2PYuMD+PxSE2Jzr1d5I4zoaKZ02EI+VUPAdBB+mHrqKtyVVY7pjO5+tvm/XMBS6VcLZ06TXZcWEoKXct3Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 3.248.88.141) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=bbl.ms.philips.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=philips.com; dkim=none (message not signed); arc=none
 (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=philips.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqnGzIUflhw3JhCsOERD1n4KaWDGEL8Kdaq8Pb/h1ns=;
 b=ZXA4Ze3DdB2fFaYNmEFxY1IKICFBYwfrtJJTyM4jwevR2yKgNqDr3HZk4NhvscrbqIt6DLGMyQfHpjrx/h7jChw0eVFwukkisuKgLs6qir77rw3HtlRdJ3nKgUWcmO3Crvsq+3HU1+CgGyddnb5PYwqh+s/58IkM3HxC6LQOJyA=
Received: from OS6P279CA0127.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:3b::6) by
 AS2PR10MB7048.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:594::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.17; Mon, 19 Oct
 2026 16:14:07 +0000
Received: from CPH1EPF00000519.eurprd04.prod.outlook.com
 (2603:10a6:e10:3b:cafe::3e) by OS6P279CA0127.outlook.office365.com
 (2603:10a6:e10:3b::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.19 via Frontend Transport; Mon,
 19 Oct 2026 16:14:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 3.248.88.141) smtp.mailfrom=bbl.ms.philips.com; dkim=none (message not
 signed) header.d=none;dmarc=pass action=none header.from=philips.com;
Received-SPF: Pass (protection.outlook.com: domain of bbl.ms.philips.com
 designates 3.248.88.141 as permitted sender) receiver=protection.outlook.com;
 client-ip=3.248.88.141; helo=ext-eur1.smtp.philips.com; pr=C
Received: from ext-eur1.smtp.philips.com (3.248.88.141) by
 CPH1EPF00000519.mail.protection.outlook.com (10.167.241.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Mon, 19 Oct 2026 16:14:07 +0000
Received: from smtprelay-eur1.philips.com ([130.138.84.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 256/256 bits)
	(Client did not present a certificate)
	by ext-eur1.smtp.philips.com with ESMTPS
	id IfUgxeV69tKtZIpzyxpdkC; Mon, 19 Oct 2026 18:14:06 +0200
Received: from mail.bbl.ms.philips.com ([130.143.87.230])
	by smtprelay-eur1.philips.com with ESMTP
	id IpzyxPdGLL551IpzyxaO5x; Mon, 19 Oct 2026 18:14:06 +0200
X-CLAM-Verdict: legit
X-CLAM-Score: ??
X-CLAM-Description: ??
Received: from bbl2xvg1.bbl.ms.philips.com (bbl2xvg1.bbl.ms.philips.com [130.143.220.100])
	by mail.bbl.ms.philips.com (Postfix) with ESMTP id 9BE7D180094;
	Mon, 19 Oct 2026 18:14:06 +0200 (CEST)
Received: by bbl2xvg1.bbl.ms.philips.com (Postfix, from userid 2884)
	id 968E6FE023E; Mon, 19 Oct 2026 18:14:06 +0200 (CEST)
From: Vishal Gupta <vishal.gupta_1@philips.com>
To: jeff.chen_1@nxp.com,
	johannes@sipsolutions.net
Cc: francesco@dolcini.it,
	linux-wireless@vger.kernel.org,
	Vishal Gupta <vishal.gupta_1@philips.com>
Subject: [PATCH v2] wifi: nxpwifi: synchronize scan cancellation state
Date: Mon, 19 Oct 2026 18:13:57 +0200
Message-ID: <20261019161357.84150-1-vishal.gupta_1@philips.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015113433.2312077-1-vishal.gupta_1@philips.com>
References: <20261015113433.2312077-1-vishal.gupta_1@philips.com>
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
X-MS-TrafficTypeDiagnostic: CPH1EPF00000519:EE_|AS2PR10MB7048:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: d888cbea-336d-4704-fde2-08df2dfc007b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|376014|36860700016|10067099003|22082099003|18002099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	iW9hEcCb6jz8F8m4QgUFXbnNX3t6X16BmnZpnGHbtMtv6boXh+c/yZJ8EryJzeeupVMTfUGhoJe420MU3EaaH1d7Bvi2eze/lK7Vx1sKcA6dWRBY4puuu7nc9J0lo0RoEPb8CIEjdbb7e/omjDWOB8Ja4jhOIUpVgrrFcRy8/gN+r3lEqZOC+m/M0n8MjlOsIoXDu8dzqFCsQkY58wmZf1xfv5RHioB2RHyxfHQ9tKstLsk5sEob22NBuir9CkTP7b1mME1JjtRmjZ+/LKKzAE3pDF4kJB21q/lnB7jpaj/0WAfqnHhmU8+GMtj/zfcJ1Lemfo/hdyyDshosvx6XARPlcEsADvVk6kugvI6RcV93IO4Q3CXp+dvkMrd+ibcR4SdxL3hiPVxEqgIrg+iLxY+v+1UBPZtbX8vFp0mJ/i8VHcBl74M+hWFb/xODZl6NoYQKuGOhPJsjtL2s295o0SF0QXrEcRgjvLXOS28Q1fEGLWZmWF/C0CsqY+g/6iQQeilmsWNM7Y8SB3F1xhYssTzbvS8kWyzl2UlyvRXjnz19ets5zLfiHfyWtVXLscO05A6GqGHDGJIOCraildPOLrx1jwXNml5tsi6JfrLUIv1FgFJTKeS7us8upRtsZ7CenjrhZTpy6meqp3UaKkdygo5FZF8x0ZJNnn9BBzNfdO8vc4u4ncDWIzzEdlj1cYb4YDty3ES8bcXYYotUIaKkuQ==
X-Forefront-Antispam-Report:
	CIP:3.248.88.141;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ext-eur1.smtp.philips.com;PTR:ext-eur1.smtp.philips.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(376014)(36860700016)(10067099003)(22082099003)(18002099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	F9MhZJzdaF/NojA0mtoG+JDvibCHU60Jk73vKwm9dgRyrou9aLGpSwdc925Qs6rU4hNVTzToL50f6z7YLwv0VEd79TMmm15bVngrEyJuSwFhZ87gmbo8Lgtxp1J6Xo31LvRfnitWzw9Hu7Z4VUFgfCKq8i8zJnByhop/KaCCOyJD0sd0Yi7w92rMfd1JnY/4Wk/FpOugrZwXi8055PMHuiYCxqBWeIy2dja+3twDgsRB5ZwtmaQvVdornc/yqisz2zqaGhgR6Y9JydJTPDHFVysQLa+q6jeqi3s5hZuvNWnrfNfA8eGbhSoais8+r7gSCntAb75m2uqKQ91i/5p49sabhn2FaYlPchcXyyuQCpiPyZTOdPbGXFn09oR4DIfsH238s7z9XuF5w7WGIjZXiUE/8A0iKCJ38Pokn0xiZiQDD74LD+j9krozm6Ceu3MK
X-OriginatorOrg: philips.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 16:14:07.2091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d888cbea-336d-4704-fde2-08df2dfc007b
X-MS-Exchange-CrossTenant-Id: 1a407a2d-7675-4d17-8692-b3ac285306e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1a407a2d-7675-4d17-8692-b3ac285306e4;Ip=[3.248.88.141];Helo=[ext-eur1.smtp.philips.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF00000519.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR10MB7048

Before the change, nxpwifi_cancel_scan() checked scan_processing outside
the lock, then acquired nxpwifi_cmd_lock only to clear it. That left a
gap where another path could change the scan state between the check and
the clear. Read and update scan_processing variable under nxpwifi_cmd_lock
so cancellation cannot race with scan state changes and skip scan completion
when no scan was active.

Signed-off-by: Vishal Gupta <vishal.gupta_1@philips.com>
---
 drivers/net/wireless/nxp/nxpwifi/scan.c | 34 +++++++++++++++----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/scan.c b/drivers/net/wireless/nxp/nxpwifi/scan.c
index 67d7ff2f10c59..8ba955860c928 100644
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
+				    "info: aborting scan\n");
+			cfg80211_scan_done(priv->scan_request, &info);
+			priv->scan_request = NULL;
+			priv->scan_aborting = false;
 		}
 	}
 }
-- 
2.43.0

