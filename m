Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47845 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1IHMj3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 08:39:29 -0400
Received: by eyx24 with SMTP id 24so422913eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 05:39:28 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/7] rt2x00: Introduce sta_add/remove callbacks
Date: Thu, 8 Sep 2011 14:36:04 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201109081434.23635.IvDoorn@gmail.com>
In-Reply-To: <201109081434.23635.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109081436.05113.IvDoorn@gmail.com> (sfid-20110908_143933_597669_1B33B62B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This implements a basic sta_add and sta_remove callback. Introduce a new
structure rt2x00_sta and ask mac80211 to allocate it as private part of
its ieee80211_sta. rt2x00_sta only contains the WCID for now.

The sta_add callback allows the driver to assign a WCID to a station
that is currently being added. The same wcid is also passed to the
sta_remove callback one mac80211 removes this STA.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |   22 ++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |    5 ++++
 drivers/net/wireless/rt2x00/rt2x00mac.c |   33 +++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index bacb533..2093a55 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -512,6 +512,19 @@ struct rt2x00intf_conf {
 };
 
 /*
+ * Private structure for storing STA details
+ * wcid: Wireless Client ID
+ */
+struct rt2x00_sta {
+	int wcid;
+};
+
+static inline struct rt2x00_sta* sta_to_rt2x00_sta(struct ieee80211_sta *sta)
+{
+	return (struct rt2x00_sta *)sta->drv_priv;
+}
+
+/*
  * rt2x00lib callback functions.
  */
 struct rt2x00lib_ops {
@@ -621,6 +634,11 @@ struct rt2x00lib_ops {
 	void (*config) (struct rt2x00_dev *rt2x00dev,
 			struct rt2x00lib_conf *libconf,
 			const unsigned int changed_flags);
+	int (*sta_add) (struct rt2x00_dev *rt2x00dev,
+			struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta);
+	int (*sta_remove) (struct rt2x00_dev *rt2x00dev,
+			   int wcid);
 };
 
 /*
@@ -1281,6 +1299,10 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 #else
 #define rt2x00mac_set_key	NULL
 #endif /* CONFIG_RT2X00_LIB_CRYPTO */
+int rt2x00mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta);
+int rt2x00mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta);
 void rt2x00mac_sw_scan_start(struct ieee80211_hw *hw);
 void rt2x00mac_sw_scan_complete(struct ieee80211_hw *hw);
 int rt2x00mac_get_stats(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 4db0ebe..7e4e062 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -932,6 +932,11 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->hw->extra_tx_headroom += RT2X00_ALIGN_SIZE;
 
 	/*
+	 * Tell mac80211 about the size of our private STA structure.
+	 */
+	rt2x00dev->hw->sta_data_size = sizeof(struct rt2x00_sta);
+
+	/*
 	 * Allocate tx status FIFO for driver use.
 	 */
 	if (test_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags)) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4cf1848..3cd70ff 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -552,6 +552,39 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 EXPORT_SYMBOL_GPL(rt2x00mac_set_key);
 #endif /* CONFIG_RT2X00_LIB_CRYPTO */
 
+int rt2x00mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
+
+	/*
+	 * If there's no space left in the device table store
+	 * -1 as wcid but tell mac80211 everything went ok.
+	 */
+	if (rt2x00dev->ops->lib->sta_add(rt2x00dev, vif, sta))
+		sta_priv->wcid = -1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_sta_add);
+
+int rt2x00mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
+
+	/*
+	 * If we never sent the STA to the device no need to clean it up.
+	 */
+	if (sta_priv->wcid < 0)
+		return 0;
+
+	return rt2x00dev->ops->lib->sta_remove(rt2x00dev, sta_priv->wcid);
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_sta_remove);
+
 void rt2x00mac_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-- 
1.7.3.4
