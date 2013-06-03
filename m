Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxout2.netvision.net.il ([194.90.9.21]:51966 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab3FCKeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 06:34:46 -0400
Received: from localhost.localdomain ([82.166.196.250])
 by mxout2.netvision.net.il
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MNT00EMMBCPPDE0@mxout2.netvision.net.il> for
 linux-wireless@vger.kernel.org; Mon, 03 Jun 2013 13:19:43 +0300 (IDT)
From: Kirshenbaum Erez <erezk@wilocity.com>
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	Kirshenbaum Erez <erezk@wilocity.com>
Subject: [PATCH] Fix channel index in WMI PCP start
Date: Mon, 03 Jun 2013 12:19:13 +0300
Message-id: <1370251153-13791-1-git-send-email-erezk@wilocity.com> (sfid-20130603_123449_276659_60A8547D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 45b04e3..26f760a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -724,7 +724,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 		.bcon_interval = cpu_to_le16(bi),
 		.network_type = wmi_nettype,
 		.disable_sec_offload = 1,
-		.channel = chan,
+		.channel = chan-1,
 	};
 	struct {
 		struct wil6210_mbox_hdr_wmi wmi;
@@ -733,9 +733,9 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 
 	if (!wil->secure_pcp)
 		cmd.disable_sec = 1;
-
+	/* This may take some time (FW set/calibrate new freq) */
 	rc = wmi_call(wil, WMI_PCP_START_CMDID, &cmd, sizeof(cmd),
-		      WMI_PCP_STARTED_EVENTID, &reply, sizeof(reply), 100);
+		      WMI_PCP_STARTED_EVENTID, &reply, sizeof(reply), 5000);
 	if (rc)
 		return rc;
 
-- 
1.7.11.7

