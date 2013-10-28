Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43532 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3J1GVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 02:21:01 -0400
Received: by mail-ee0-f48.google.com with SMTP id e50so3160924eek.35
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 23:21:00 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: plug memory leak in wmi mgmt tx worker
Date: Mon, 28 Oct 2013 07:18:13 +0100
Message-Id: <1382941094-3291-2-git-send-email-michal.kazior@tieto.com> (sfid-20131028_072110_233535_C4D3D2A9)
In-Reply-To: <1382941094-3291-1-git-send-email-michal.kazior@tieto.com>
References: <1382941094-3291-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sk_buff was not freed in some cases. The patch
unifies the msdu freeing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 +++-
 drivers/net/wireless/ath/ath10k/wmi.c | 4 +---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bbb0efa..f45eca0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1729,8 +1729,10 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 			break;
 
 		ret = ath10k_wmi_mgmt_tx(ar, skb);
-		if (ret)
+		if (ret) {
 			ath10k_warn("wmi mgmt_tx failed (%d)\n", ret);
+			ieee80211_free_txskb(ar->hw, skb);
+		}
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index a796d0b..8db9db2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -674,10 +674,8 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 
 	/* Send the management frame buffer to the target */
 	ret = ath10k_wmi_cmd_send(ar, wmi_skb, ar->wmi.cmd->mgmt_tx_cmdid);
-	if (ret) {
-		dev_kfree_skb_any(skb);
+	if (ret)
 		return ret;
-	}
 
 	/* TODO: report tx status to mac80211 - temporary just ACK */
 	info->flags |= IEEE80211_TX_STAT_ACK;
-- 
1.8.4.rc3

