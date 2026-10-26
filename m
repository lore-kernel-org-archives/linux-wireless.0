Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793020608;
	b=pXTz1noaEu5W2g2YoKkii6KvgaGhVzJpW9FfqJh5A52DcPzuxmA9P7+MAx5Rvo5SiFTT
	 qtGS4ocjb9COHJ+U5ozFtGJKCVz+Dsz4fzxbtzNfr7iqY/RJo4Hbu2NpmY3fhVQ8e6u+N
	 yPIuwEIrOyjZhGb8bPkydws/Cy/B9CxTEzUkyvl1bOlx1g91t2bIrxyOgxFPBJy0dJni6
	 r+UVgVb9L/Oul26D3JAJGM4j5weTbfKu2kYrmJ+AKi4qtXC86/Sa0kmGYRBT5dKv9jbQd
	 lLQAKmpY7kg65NOHwXyipghDb/Ywh1d3yFjW0IqGVMWY4XIJMiYLdy7gOgiFU1qIF8A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020608;
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
	bh=Gj2TLTov2oenwsWB0TH00dT/jYWyEjO2Kh4CfNfEalc=;
	b=NJhPERY0JyYrVoKWXXtylA84OKSc4Xr3LHXxJW0u57dYs1CQ0zio1ZgcIQnTRtsQD93r
	 rnPKTn9CI0Uu14Fo0Sf7U1xmzHJAOmsolq0AaGN0V9S8/WdoblRhdvzulSr+1pXxSXSPA
	 W6a/D3rVX8/0iFCQSk5jTHmBWyDhinmcY9YGhtlbQMtU7u+zF17l3inZ74HjtytkitzWi
	 LeSyqsWm3gwKpU1ct9CpH/FgIygvABH1hhyGRoTPcBq33hZMy/hMt4bKPuXVCfCY+VPlh
	 EZPFt2uWOT01qNVpywiDfom8szofYnK+0vhUfAEMFyxKBNtnrHesi1tnwi5j3MXG2CA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=philips.com;
	spf=pass smtp.mailfrom=bbl.ms.philips.com;
	dkim=pass header.d=philips.com header.i=@philips.com header.a=rsa-sha256 header.s=selector1 header.b=RIOFqlS6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.64
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013064.outbound.protection.outlook.com [40.107.162.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CC3606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 13:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55CC3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bbl.ms.philips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=philips.com header.i=@philips.com header.a=rsa-sha256 header.s=selector1 header.b=RIOFqlS6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qf6DyyWG4EZcbl8ta2ixEZTPM3zzM4p2haQHABeqw+6naBSGkGSbJnK6IU6KcaaCgnSUPvo4SStc+Et9nimmqkG7OFo387bhR0E+wrs8lrl5KujlsLd6bop+Gy+q/KV2B8mHzvDwG/6kDNE6yZi3piGMOAo2EqWMC61hEhF2iMBtHBIqXXkl+TR3dG0OfkNj2eYEzUBtqWpUJDx6n5o6R+Zy1AAaPlqNHDw4rkbJvLv5XHA76TXC3oZ5YhuQH0CBd3EyWejp+2UbElhcgsHlm6/b+ZI8VQgyhwO3t2CpbrGU7Joq8d8ab4EnLWq4tJ1Hq81XBln7EslrA+lYTk4KSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gj2TLTov2oenwsWB0TH00dT/jYWyEjO2Kh4CfNfEalc=;
 b=PNXqJr4BHZeST10RplXL5Wzx6+ENYfpWwiDfUNFhkCkV+9GCNjlUrFkDeSJD3YU+mSj8XBf4kTQUf52SlJ0+NlR/9eHb2rP03it8H+ZKkudhh2fwWcrt2zl9FXZpqTVUmFMJiJianNXIFg3kDXDPaK63QuzwwMLWwIr/M/l2wMJ7AehL02qcx+lKJhL7MPovUPaSVCyHwPkC1PlX96wdNLEqkgLMwFl0eEIOI7DcRpOGtBGnH633VGpp49aPkIT/zwi6RQ61b8ZmGqvqB8b8zxbjwbXoh9l7AmLG9f+KjQfxPERexq+fjjLkqpEMSKwDoBUMOlgmH6gIuNqDHK/5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 3.248.88.141) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=bbl.ms.philips.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=philips.com; dkim=none (message not signed); arc=none
 (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=philips.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj2TLTov2oenwsWB0TH00dT/jYWyEjO2Kh4CfNfEalc=;
 b=RIOFqlS6wKGDoeEzKF8EDYVH+nUlBt+5Vef1gS0ZWGNcBXGjFTRpMA7DSv1Go0TCVb+SXXD7b4238l6rXSKp6tlV0TYyXlI2VlBEy1Nx2Yf7h+R5ye9pI+AG7ljum8A53RBhMKryjD9ofOQNw3u9XAiNMH7Vy1jkIPBX/059BHo=
Received: from FR4P281CA0144.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:b8::20)
 by AMBPR10MB9707.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:76c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.7; Mon, 26 Oct
 2026 13:16:42 +0000
Received: from MI3PEPF0000855A.eurprd05.prod.outlook.com
 (2603:10a6:d10:b8:cafe::11) by FR4P281CA0144.outlook.office365.com
 (2603:10a6:d10:b8::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.7 via Frontend Transport; Mon, 26
 Oct 2026 13:16:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 3.248.88.141) smtp.mailfrom=bbl.ms.philips.com; dkim=none (message not
 signed) header.d=none;dmarc=pass action=none header.from=philips.com;
Received-SPF: Pass (protection.outlook.com: domain of bbl.ms.philips.com
 designates 3.248.88.141 as permitted sender) receiver=protection.outlook.com;
 client-ip=3.248.88.141; helo=ext-eur1.smtp.philips.com; pr=C
Received: from ext-eur1.smtp.philips.com (3.248.88.141) by
 MI3PEPF0000855A.mail.protection.outlook.com (10.167.240.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 13:16:42 +0000
Received: from smtprelay-eur1.philips.com ([130.138.84.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 256/256 bits)
	(Client did not present a certificate)
	by ext-eur1.smtp.philips.com with ESMTPS
	id L7xHxlEubtKtZLKZ7xALlF; Mon, 26 Oct 2026 14:16:41 +0100
Received: from mail.bbl.ms.philips.com ([130.143.87.230])
	by smtprelay-eur1.philips.com with ESMTP
	id LKZ7xXRcfL551LKZ7xrFYS; Mon, 26 Oct 2026 14:16:41 +0100
X-CLAM-Verdict: legit
X-CLAM-Score: ??
X-CLAM-Description: ??
Received: from bbl2xvg1.bbl.ms.philips.com (bbl2xvg1.bbl.ms.philips.com [130.143.220.100])
	by mail.bbl.ms.philips.com (Postfix) with ESMTP id AD41D180094;
	Mon, 26 Oct 2026 14:16:41 +0100 (CET)
Received: by bbl2xvg1.bbl.ms.philips.com (Postfix, from userid 2884)
	id A6F54FE0202; Mon, 26 Oct 2026 14:16:41 +0100 (CET)
From: Vishal Gupta <vishal.gupta_1@philips.com>
To: linux-wireless@vger.kernel.org
Cc: Vishal Gupta <vishal.gupta_1@philips.com>,
	Uwe Schnick <uwe.schnick@philips.com>
Subject: [PATCH 1/1] ath6kl: synchronize scan request completion
Date: Mon, 26 Oct 2026 14:16:31 +0100
Message-ID: <20261026131631.1229744-1-vishal.gupta_1@philips.com>
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
X-MS-TrafficTypeDiagnostic: MI3PEPF0000855A:EE_|AMBPR10MB9707:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 3e7d64c8-0f2c-41f6-e326-08df33636059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700016|23010399003|18002099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261021135927099003;
X-Microsoft-Antispam-Message-Info:
	XqFXT2lDktA90uvHprqM0J4SYt8sIS5Js5QtDqudkY6+WE63YGjONzsXIyY3dFMjk9lc9YhIYTCt6QVueVFmbuDA+N6YCD58wTUGQMJn2iqzjX3/kpKLsBN6xBrDe3vuAnzJ+DeFeokanEHc9S/hOHyVjbcgya//qnqxmfkO/Y3jw2v0wJcpqv0aFHxz97ujv4QshuvAT0qqCM7n7CuQRuPuikkfjpo5/7FKLPsjru0tU0nnOwfJkaiakAZaWCT5xpfh2lY1x34mzIlcJc0W6ZWEDVtKIBzCnCDChH7dFSMLQjRXjMF0hKMPYPNDaKIeSFhRoplLRDawsAdNn/w5/coLBXou4wWc/HODPPg2KwOPGkQkSghccKSWjbOLsfHwOM2M+LeJfYUk3skplAW1iz63Zo0mWqYW1FJOlwzjhr51QOfreGc/K4OoNLDjDQfgv8EpRbU4xl/1GC0YdFIK5oBlvnGW60PoeBEr6WUWS6sGk/DTf6Rz6JHIlLxytv8luBSgGRa0qh7xssHRN+7Emvdd4N17K1Emm7vAwd6DGizr9iwoVpLxbd1t4S4FVC/C+vHfIYDSvJfAfzkQC+acMfmx34q169zuerv6oYE8cwV6X4DMRD2wqOHEN5FasKoWl/nAhLC+j6XHhBzukassO/r+Pj0D62SaB1H8uYyVFCTPU+RfWlzv5iTG3avHzK6gw2hA3416iL3v87WMuyxgMg==
X-Forefront-Antispam-Report:
	CIP:3.248.88.141;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ext-eur1.smtp.philips.com;PTR:ext-eur1.smtp.philips.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700016)(23010399003)(18002099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261021135927099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VmnK/0qzATMt9XyEoyVkVlglSKPDdbHCVgUXpNHnVGDLY0afY4kLkah3qRDlH+iK0BaBUUU3ljG/l5n/eaEg/Ct7e33J7USXVqlwkjtms9C6HkkcI5a8YFNTjF7APCWYpSMQRyfPYKprokAZLCFkFJkaLWqmd4tsoqA+sRmQgt43sGvPZ3MU4/v9IdHjHKjr06L+uMsZmId7JefyST0N1Wg1fp6fkTP/2EIiIc9jrwO/Y84AWBpKOyuJBXClm+XMgJFzAmEIIstJXk3LvY+2GhHBwH2ldxBn2Q8kmlvkIlG3rlReQkuFrglUksoZrW6E799WZC8WBlf9plV5ZAeLUPhh2vr93sqx97Nmdb2B/NUlMGrF8WZTwDjhCFcZki9FwsifV4db6ls5TgJ6QHhaHofZqcSSuNxB7twIZZnSsVI/zjzMlpiZOBYF8yyKVknR
X-OriginatorOrg: philips.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 13:16:42.0160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7d64c8-0f2c-41f6-e326-08df33636059
X-MS-Exchange-CrossTenant-Id: 1a407a2d-7675-4d17-8692-b3ac285306e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1a407a2d-7675-4d17-8692-b3ac285306e4;Ip=[3.248.88.141];Helo=[ext-eur1.smtp.philips.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF0000855A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR10MB9707

Protect vif->scan_req with a spinlock to serialize scan submission,
completion, disconnect, and interface-stop paths. This prevents scan
completion and abort handling from notifying cfg80211 more than once
or accessing a cleared scan request. Without synchronization, one
thread can set scan_req to NULL while another dereferences it, causing
a kernel panic.

Signed-off-by: Vishal Gupta <vishal.gupta_1@philips.com>
Signed-off-by: Uwe Schnick <uwe.schnick@philips.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 45 ++++++++++++++++------
 drivers/net/wireless/ath/ath6kl/core.h     |  2 +
 2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 8bbe554a9b364..19934c357a98b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -866,14 +866,20 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 				      u8 *assoc_info, u16 proto_reason)
 {
 	struct ath6kl *ar = vif->ar;
+	struct cfg80211_scan_request *req;
 
-	if (vif->scan_req) {
+	spin_lock_bh(&vif->scan_req_lock);
+	req = vif->scan_req;
+	vif->scan_req = NULL;
+	spin_unlock_bh(&vif->scan_req_lock);
+
+	if (req) {
 		struct cfg80211_scan_info info = {
 			.aborted = true,
 		};
 
-		cfg80211_scan_done(vif->scan_req, &info);
-		vif->scan_req = NULL;
+		cfg80211_scan_done(req, &info);
+		req = NULL;
 	}
 
 	if (vif->nw_type & ADHOC_NETWORK) {
@@ -1060,7 +1066,9 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy,
 	if (test_bit(CONNECTED, &vif->flags))
 		force_fg_scan = 1;
 
+	spin_lock_bh(&vif->scan_req_lock);
 	vif->scan_req = request;
+	spin_unlock_bh(&vif->scan_req_lock);
 
 	ret = ath6kl_wmi_beginscan_cmd(ar->wmi, vif->fw_vif_idx,
 				       WMI_LONG_SCAN, force_fg_scan,
@@ -1071,7 +1079,9 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy,
 				       request->rates);
 	if (ret) {
 		ath6kl_err("failed to start scan: %d\n", ret);
+		spin_lock_bh(&vif->scan_req_lock);
 		vif->scan_req = NULL;
+		spin_unlock_bh(&vif->scan_req_lock);
 	}
 
 	kfree(channels);
@@ -1082,6 +1092,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy,
 void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted)
 {
 	struct ath6kl *ar = vif->ar;
+	struct cfg80211_scan_request *req;
 	struct cfg80211_scan_info info = {
 		.aborted = aborted,
 	};
@@ -1090,14 +1101,19 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted)
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: status%s\n", __func__,
 		   aborted ? " aborted" : "");
 
-	if (!vif->scan_req)
+	spin_lock_bh(&vif->scan_req_lock);
+	req = vif->scan_req;
+	vif->scan_req = NULL;
+	spin_unlock_bh(&vif->scan_req_lock);
+
+	if (!req)
 		return;
 
 	if (aborted)
 		goto out;
 
-	if (vif->scan_req->n_ssids && vif->scan_req->ssids[0].ssid_len) {
-		for (i = 0; i < vif->scan_req->n_ssids; i++) {
+	if (req->n_ssids && req->ssids[0].ssid_len) {
+		for (i = 0; i < req->n_ssids; i++) {
 			ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
 						  i, DISABLE_SSID_FLAG,
 						  0, NULL);
@@ -1105,8 +1121,8 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted)
 	}
 
 out:
-	cfg80211_scan_done(vif->scan_req, &info);
-	vif->scan_req = NULL;
+	cfg80211_scan_done(req, &info);
+	req = NULL;
 }
 
 void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int freq,
@@ -3599,6 +3615,7 @@ static int ath6kl_cfg80211_vif_init(struct ath6kl_vif *vif)
 
 	set_bit(WMM_ENABLED, &vif->flags);
 	spin_lock_init(&vif->if_lock);
+	spin_lock_init(&vif->scan_req_lock);
 
 	INIT_LIST_HEAD(&vif->mc_filter);
 
@@ -3607,6 +3624,7 @@ static int ath6kl_cfg80211_vif_init(struct ath6kl_vif *vif)
 
 void ath6kl_cfg80211_vif_stop(struct ath6kl_vif *vif, bool wmi_ready)
 {
+	struct cfg80211_scan_request *req;
 	static u8 bcast_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	bool discon_issued;
 
@@ -3627,13 +3645,18 @@ void ath6kl_cfg80211_vif_stop(struct ath6kl_vif *vif, bool wmi_ready)
 						0, NULL, 0);
 	}
 
-	if (vif->scan_req) {
+	spin_lock_bh(&vif->scan_req_lock);
+	req = vif->scan_req;
+	vif->scan_req = NULL;
+	spin_unlock_bh(&vif->scan_req_lock);
+
+	if (req) {
 		struct cfg80211_scan_info info = {
 			.aborted = true,
 		};
 
-		cfg80211_scan_done(vif->scan_req, &info);
-		vif->scan_req = NULL;
+		cfg80211_scan_done(req, &info);
+		req = NULL;
 	}
 
 	/* need to clean up enhanced bmiss detection fw state */
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index a0b236eeeab54..522844e758202 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -647,6 +647,8 @@ struct ath6kl_vif {
 	u16 rsn_capab;
 
 	struct list_head mc_filter;
+	/* Lock to protect scan_req */
+	spinlock_t scan_req_lock;
 };
 
 static inline struct ath6kl_vif *ath6kl_vif_from_wdev(struct wireless_dev *wdev)
-- 
2.43.0

