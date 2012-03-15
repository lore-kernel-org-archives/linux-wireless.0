Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39914 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab2COVgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 17:36:17 -0400
From: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Subject: [PATCH] ath6kl: add debug log for AP MLME operations
Date: Thu, 15 Mar 2012 14:36:11 -0700
Message-ID: <1331847371-2213-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com> (sfid-20120315_223620_532511_C663FC3A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is useful during debugging to check if disconnect commands were issued by
the host.

Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 79aa90b..2ed0a7d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3030,6 +3030,8 @@ int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 if_idx, u8 cmd, const u8 *mac,
 	cm->reason = cpu_to_le16(reason);
 	cm->cmd = cmd;
 
+	ath6kl_dbg(ATH6KL_DBG_WMI, "ap_set_mlme: cmd=%d reason=%d\n", cm->cmd,
+		   cm->reason);
+
 	return ath6kl_wmi_cmd_send(wmip, if_idx, skb, WMI_AP_SET_MLME_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
-- 
1.7.0.4

