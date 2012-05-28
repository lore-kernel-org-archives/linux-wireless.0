Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45704 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2E1GVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 02:21:20 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath6kl: Remove unneeded memset in roam related config func
Date: Mon, 28 May 2012 11:51:12 +0530
Message-ID: <1338186073-4986-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120528_082124_522414_F70CF3B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

No need to clear requested memory after allocating new SKB
with help of ath6kl_wmi_get_new_buf(). This clear part is
already taken care in ath6kl_wmi_get_new_buf().

Found this on code review.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 63dc4fd..43bce9c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -743,7 +743,6 @@ int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
 		return -ENOMEM;
 
 	cmd = (struct roam_ctrl_cmd *) skb->data;
-	memset(cmd, 0, sizeof(*cmd));
 
 	memcpy(cmd->info.bssid, bssid, ETH_ALEN);
 	cmd->roam_ctrl = WMI_FORCE_ROAM;
@@ -763,7 +762,6 @@ int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode)
 		return -ENOMEM;
 
 	cmd = (struct roam_ctrl_cmd *) skb->data;
-	memset(cmd, 0, sizeof(*cmd));
 
 	cmd->info.roam_mode = mode;
 	cmd->roam_ctrl = WMI_SET_ROAM_MODE;
-- 
1.7.1

