Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54187 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2EBJZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 05:25:32 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl_sdio: Fix the EAPOL out of order issue
Date: Wed, 2 May 2012 14:55:25 +0530
Message-ID: <1335950725-15597-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120502_112559_162055_4B2E6CBE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send the EAPOL and management frames in the same AC_VO queue. The issue
happens when the AP supports QOS, the management frames are sent to AC_VO
queue and EAP frame goes to AC_BE queue. Even though the EAP frame is
queued before the DEAUTH management frame, as they are queued on different
h/w queues, order of delivery between these frames cannot be controlled.

This fixes the connection failure seen in P2P case.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    7 +++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |    2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 102477d..ee8ec23 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -290,6 +290,13 @@ int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, u8 if_idx,
 					layer2_priority);
 		} else
 			usr_pri = layer2_priority & 0x7;
+
+		/*
+		 * Queue the EAPOL frames in the same WMM_AC_VO queue
+		 * as that of management frames.
+		 */
+		if (skb->protocol == cpu_to_be16(ETH_P_PAE))
+			usr_pri = WMI_VOICE_USER_PRIORITY;
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9966140..9076bec 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -106,6 +106,8 @@ struct wmi_data_sync_bufs {
 #define WMM_AC_VI   2		/* video */
 #define WMM_AC_VO   3		/* voice */
 
+#define WMI_VOICE_USER_PRIORITY		0x7
+
 struct wmi {
 	u16 stream_exist_for_ac[WMM_NUM_AC];
 	u8 fat_pipe_exist;
-- 
1.7.10

