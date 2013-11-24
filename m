Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:60110 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3KXQ44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 11:56:56 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so1926053eaj.28
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 08:56:55 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	sujith@msujith.org, johannes@sipsolutions.net,
	rmanohar@qca.qualcomm.com
Subject: [PATCH 1/3] mac80211: implement ieee80211_get_vif_by_addr
Date: Sun, 24 Nov 2013 17:56:49 +0100
Message-Id: <1385312211-3119-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131124_175702_179022_2BBB86C0)
In-Reply-To: <1385312211-3119-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1385312211-3119-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_get_vif_by_addr allows low level drivers to get a reference to
vif data structure which is not added to the driver as monitor interface.
ieee80211_get_vif_by_addr will be used in ath9k tx99 code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/mac80211.h |  9 +++++++++
 net/mac80211/util.c    | 26 ++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7ceed99..cdec60d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4585,4 +4585,13 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, struct sk_buff *skb,
 			      int band, struct ieee80211_sta **sta);
 
+/**
+ * ieee80211_get_vif_by_addr - get vif for given mac address
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @mac: mac address
+ *
+ */
+struct ieee80211_vif *ieee80211_get_vif_by_addr(struct ieee80211_hw *hw,
+						const u8 *mac);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 592a181..6a7a3df 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2472,3 +2472,29 @@ int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 	return 0;
 }
+
+/**
+ * ieee80211_get_vif_by_addr - get vif for given mac address
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @mac: mac address
+ *
+ */
+struct ieee80211_vif *ieee80211_get_vif_by_addr(struct ieee80211_hw *hw,
+						const u8 *mac)
+{
+	struct ieee80211_vif *vif = NULL;
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!compare_ether_addr(sdata->vif.addr, mac)) {
+			vif = &sdata->vif;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return vif;
+}
+EXPORT_SYMBOL(ieee80211_get_vif_by_addr);
-- 
1.8.3.2

