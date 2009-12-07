Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51001 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935560AbZLGUqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 15:46:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	johannes@sipsolutions.net
Subject: [PATCH] mac80211: only bother printing highest data rate on debugfs if its set
Date: Mon,  7 Dec 2009 15:47:01 -0500
Message-Id: <1260218821-17809-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE-802.11n spec says the RX highest data rate field does
not specify the highest supported RX data rate if its not set.
Ignore it if not set then. Refer to section 7.3.56.4

Cc: johannes@sipsolutions.net
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/ieee80211.h  |    5 ++++-
 net/mac80211/debugfs_sta.c |   10 ++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index d9724a2..a36b253 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -771,7 +771,10 @@ struct ieee80211_bar {
 /**
  * struct ieee80211_mcs_info - MCS information
  * @rx_mask: RX mask
- * @rx_highest: highest supported RX rate
+ * @rx_highest: highest supported RX rate. If set represents
+ *	the highest supported RX data rate in units of 1 Mbps.
+ *	If this field is 0 this value should not be used to
+ *	consider the highest RX data rate supported.
  * @tx_params: TX parameters
  */
 struct ieee80211_mcs_info {
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index ab3397a..eff7fcf 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -221,8 +221,14 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 		for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
 			p += scnprintf(p, sizeof(buf)+buf-p, " %.2x",
 					htc->mcs.rx_mask[i]);
-		p += scnprintf(p, sizeof(buf)+buf-p, "\nMCS rx highest: %d\n",
-				le16_to_cpu(htc->mcs.rx_highest));
+
+		/* If not set this is meaningless */
+		if (le16_to_cpu(htc->mcs.rx_highest)) {
+			p += scnprintf(p, sizeof(buf)+buf-p,
+				       "\nMCS rx highest: %d Mbps\n",
+				       le16_to_cpu(htc->mcs.rx_highest));
+		}
+
 		p += scnprintf(p, sizeof(buf)+buf-p, "MCS tx params: %x\n",
 				htc->mcs.tx_params);
 	}
-- 
1.6.3.3

