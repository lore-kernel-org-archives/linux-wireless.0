Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:53006 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaC1Jab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 05:30:31 -0400
Subject: [PATCH] ath10k: cleanup debug messages in ath10k_wmi_event_host_swba()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 11:30:28 +0200
Message-ID: <20140328093028.16927.81551.stgit@potku.adurom.net> (sfid-20140328_103038_833674_A9998DBD)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They were just too superfluous and made it harder to read logs. Change them to
follow the normal style used in ath10k.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d4b48ef0ec2e..fe4d5f1c672f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1362,13 +1362,10 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 	struct sk_buff *bcn;
 	int ret, vdev_id = 0;
 
-	ath10k_dbg(ATH10K_DBG_MGMT, "WMI_HOST_SWBA_EVENTID\n");
-
 	ev = (struct wmi_host_swba_event *)skb->data;
 	map = __le32_to_cpu(ev->vdev_map);
 
-	ath10k_dbg(ATH10K_DBG_MGMT, "host swba:\n"
-		   "-vdev map 0x%x\n",
+	ath10k_dbg(ATH10K_DBG_MGMT, "mgmt swba vdev_map 0x%x\n",
 		   ev->vdev_map);
 
 	for (; map; map >>= 1, vdev_id++) {
@@ -1385,12 +1382,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		bcn_info = &ev->bcn_info[i];
 
 		ath10k_dbg(ATH10K_DBG_MGMT,
-			   "-bcn_info[%d]:\n"
-			   "--tim_len %d\n"
-			   "--tim_mcast %d\n"
-			   "--tim_changed %d\n"
-			   "--tim_num_ps_pending %d\n"
-			   "--tim_bitmap 0x%08x%08x%08x%08x\n",
+			   "mgmt event bcn_info %d tim_len %d mcast %d changed %d num_ps_pending %d bitmap 0x%08x%08x%08x%08x\n",
 			   i,
 			   __le32_to_cpu(bcn_info->tim_info.tim_len),
 			   __le32_to_cpu(bcn_info->tim_info.tim_mcast),

