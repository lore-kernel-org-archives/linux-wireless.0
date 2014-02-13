Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47847 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBMTKs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 14:10:48 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [RFC] wmi:  Handle failure to start scan.
Date: Thu, 13 Feb 2014 11:09:54 -0800
Message-Id: <1392318594-32540-1-git-send-email-greearb@candelatech.com> (sfid-20140213_201051_204377_266452F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Properly clean up driver state in case firmware fails
to start scan for some reason.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 20f7c79..a5be0d3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -770,7 +770,25 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_dbg(ATH10K_DBG_WMI, "WMI_SCAN_EVENT_PREEMPTED\n");
 		break;
 	case WMI_SCAN_EVENT_START_FAILED:
-		ath10k_dbg(ATH10K_DBG_WMI, "WMI_SCAN_EVENT_START_FAILED\n");
+		ath10k_warn("WMI_SCAN_EVENT_START_FAILED, reason: %i\n", reason);
+
+		ar->scan_channel = NULL;
+		if (!ar->scan.in_progress) {
+			ath10k_warn("scan-start-failed: no scan requested, ignoring\n");
+			break;
+		}
+
+		if (ar->scan.is_roc) {
+			ath10k_offchan_tx_purge(ar);
+
+			if (!ar->scan.aborting)
+				ieee80211_remain_on_channel_expired(ar->hw);
+		} else {
+			ieee80211_scan_completed(ar->hw, ar->scan.aborting);
+		}
+
+		del_timer(&ar->scan.timeout);
+		ar->scan.in_progress = false;
 		break;
 	default:
 		break;
-- 
1.7.11.7

