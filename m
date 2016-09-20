Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26370 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbcITIWl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 04:22:41 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Ignore SWBA event for a vif if its marked for no beacon
Date: Tue, 20 Sep 2016 13:52:07 +0530
Message-ID: <1474359727-6854-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160920_102247_078860_9706507D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Ignore processing further in SWBA event scheduled for a vif, if mac80211
has marked the particular vif for stop beaconing and brought the vdev
down in 'ath10k_control_beaconing'. This should potentially avoid ath10k
warning/error messages while running continuous wifi down/up with max
number of vaps configured. Found this change during code walk through
and going through other beacon configuration related functions in ath10k

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index eb4ab6f..f37f178 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3514,6 +3514,12 @@ void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 			continue;
 		}
 
+		/* mac80211 would have already asked us to stop beaconing and
+		 * bring the vdev down, so continue in that case
+		 */
+		if (!arvif->is_up)
+			continue;
+
 		/* There are no completions for beacons so wait for next SWBA
 		 * before telling mac80211 to decrement CSA counter
 		 *
-- 
1.9.1
