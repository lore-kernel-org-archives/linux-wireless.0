Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:59387
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756374AbaKSTIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 14:08:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 6/7] mac0211: add a helper function for fixing up tx status rates
Date: Wed, 19 Nov 2014 20:08:12 +0100
Message-Id: <1416424093-19439-6-git-send-email-nbd@openwrt.org> (sfid-20141119_200827_111723_AEE9F99B)
In-Reply-To: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
References: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/status.c | 52 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index ba35a44..249ca3a 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -570,24 +570,13 @@ static void ieee80211_lost_packet(struct sta_info *sta,
 	sta->lost_packets = 0;
 }
 
-void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int ieee80211_tx_get_rates(struct ieee80211_hw *hw,
+				  struct ieee80211_tx_info *info,
+				  int *retry_count)
 {
-	struct sk_buff *skb2;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	__le16 fc;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_sub_if_data *sdata;
-	struct net_device *prev_dev = NULL;
-	struct sta_info *sta, *tmp;
-	int retry_count = -1, i;
 	int rates_idx = -1;
-	bool send_to_cooked;
-	bool acked;
-	struct ieee80211_bar *bar;
-	int rtap_len;
-	int shift = 0;
+	int count = -1;
+	int i;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
@@ -605,12 +594,37 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			break;
 		}
 
-		retry_count += info->status.rates[i].count;
+		count += info->status.rates[i].count;
 	}
 	rates_idx = i - 1;
 
-	if (retry_count < 0)
-		retry_count = 0;
+	if (count < 0)
+		count = 0;
+
+	*retry_count = count;
+	return rates_idx;
+}
+
+void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct sk_buff *skb2;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	__le16 fc;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_sub_if_data *sdata;
+	struct net_device *prev_dev = NULL;
+	struct sta_info *sta, *tmp;
+	int retry_count;
+	int rates_idx;
+	bool send_to_cooked;
+	bool acked;
+	struct ieee80211_bar *bar;
+	int rtap_len;
+	int shift = 0;
+
+	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
 
 	rcu_read_lock();
 
-- 
2.1.2

