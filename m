Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33957 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753572AbcJGO7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 10:59:48 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: add support for per sta tx bitrate
Date: Fri, 7 Oct 2016 20:28:52 +0530
Message-ID: <1475852332-18217-3-git-send-email-akolli@qti.qualcomm.com> (sfid-20161007_165953_438062_78912E98)
In-Reply-To: <1475852332-18217-1-git-send-email-akolli@qti.qualcomm.com>
References: <1475852332-18217-1-git-send-email-akolli@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

Per STA tx bitrate info is filled from peer stats.
Export per sta txrate info to cfg80211/nl80211

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 9955fea0802a..7daf9927a1ef 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -77,6 +77,19 @@ void ath10k_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	sinfo->rx_duration = arsta->rx_duration;
 	sinfo->filled |= 1ULL << NL80211_STA_INFO_RX_DURATION;
+
+	if (!arsta->txrate.legacy && !arsta->txrate.nss)
+		return;
+
+	if(arsta->txrate.legacy) {
+		sinfo->txrate.legacy = arsta->txrate.legacy;
+	} else {
+		sinfo->txrate.mcs = arsta->txrate.mcs;
+		sinfo->txrate.nss = arsta->txrate.nss;
+		sinfo->txrate.bw = arsta->txrate.bw;
+	}
+	sinfo->txrate.flags = arsta->txrate.flags;
+	sinfo->filled |= 1ULL << NL80211_STA_INFO_TX_BITRATE;
 }
 
 static ssize_t ath10k_dbg_sta_read_aggr_mode(struct file *file,
-- 
1.7.9.5
