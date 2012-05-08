Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43918 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab2EHTxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 15:53:52 -0400
Received: by wgbdr13 with SMTP id dr13so6345318wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 12:53:50 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] mac80211: allow low-level drivers to set netdev feature bits
Date: Tue,  8 May 2012 22:53:41 +0300
Message-Id: <1336506821-23709-2-git-send-email-arik@wizery.com> (sfid-20120508_215355_466186_CF7F7A28)
In-Reply-To: <1336506821-23709-1-git-send-email-arik@wizery.com>
References: <1336506821-23709-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow low-level drivers to change the feature bit for a vif's underlying
net_device struct.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h |   10 ++++++++++
 net/mac80211/tx.c      |    9 +++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4d6e6c6..acc46b2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2992,6 +2992,16 @@ struct sk_buff *
 ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 
 /**
+ * ieee80211_set_netdev_features - set netdev feature bits for vif
+ * @vif: virtual interface to set netdev flags on
+ * @features: feature bits (see &struct net_device for details)
+ *
+ * This function sets netdev feature bit for the device associated with the
+ * specified vif.
+ */
+void ieee80211_set_netdev_features(struct ieee80211_vif *vif, int features);
+
+/**
  * ieee80211_get_tkip_p1k_iv - get a TKIP phase 1 key for IV32
  *
  * This function returns the TKIP phase 1 key for the given IV32.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d67d36f..d9f94a6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2754,3 +2754,12 @@ void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 	ieee80211_xmit(sdata, skb);
 	local_bh_enable();
 }
+
+void ieee80211_set_netdev_features(struct ieee80211_vif *vif, int features)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	if (sdata->dev)
+		sdata->dev->features |= features;
+}
+EXPORT_SYMBOL(ieee80211_set_netdev_features);
-- 
1.7.9.5

