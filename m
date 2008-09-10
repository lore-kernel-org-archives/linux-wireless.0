Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYIJWPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:15:40 -0400
Message-Id: <20080910220426.564761000@sipsolutions.net> (sfid-20080911_001543_602609_9CDC3D7C)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:02:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/18] mac80211 hwsim: verify vif pointers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211-hwsim is a debugging tool for mac80211, and as such
it can very well verify that mac80211 isn't passing junk to
drivers, especially the vif pointer is prone to this because
for vlan interfaces the AP interface pointer needs to be passed.
This makes mac80211-hwsim add a magic cookie to the private vif
area and verify it whenever an operation is called that gets a
vif pointer.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |   58 ++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

--- everything.orig/drivers/net/wireless/mac80211_hwsim.c	2008-09-10 23:58:05.000000000 +0200
+++ everything/drivers/net/wireless/mac80211_hwsim.c	2008-09-10 23:58:11.000000000 +0200
@@ -28,6 +28,29 @@ static int radios = 2;
 module_param(radios, int, 0444);
 MODULE_PARM_DESC(radios, "Number of simulated radios");
 
+struct hwsim_vif_priv {
+	u32 magic;
+};
+
+#define HWSIM_VIF_MAGIC	0x69537748
+
+static inline void hwsim_check_magic(struct ieee80211_vif *vif)
+{
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+	BUG_ON(vp->magic != HWSIM_VIF_MAGIC);
+}
+
+static inline void hwsim_set_magic(struct ieee80211_vif *vif)
+{
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+	vp->magic = HWSIM_VIF_MAGIC;
+}
+
+static inline void hwsim_clear_magic(struct ieee80211_vif *vif)
+{
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+	vp->magic = 0;
+}
 
 static struct class *hwsim_class;
 
@@ -210,6 +233,9 @@ static int mac80211_hwsim_tx(struct ieee
 	ack = mac80211_hwsim_tx_frame(hw, skb);
 
 	txi = IEEE80211_SKB_CB(skb);
+
+	hwsim_check_magic(txi->control.vif);
+
 	memset(&txi->status, 0, sizeof(txi->status));
 	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		if (ack)
@@ -246,6 +272,7 @@ static int mac80211_hwsim_add_interface(
 	printk(KERN_DEBUG "%s:%s (type=%d mac_addr=%s)\n",
 	       wiphy_name(hw->wiphy), __func__, conf->type,
 	       print_mac(mac, conf->mac_addr));
+	hwsim_set_magic(conf->vif);
 	return 0;
 }
 
@@ -257,6 +284,8 @@ static void mac80211_hwsim_remove_interf
 	printk(KERN_DEBUG "%s:%s (type=%d mac_addr=%s)\n",
 	       wiphy_name(hw->wiphy), __func__, conf->type,
 	       print_mac(mac, conf->mac_addr));
+	hwsim_check_magic(conf->vif);
+	hwsim_clear_magic(conf->vif);
 }
 
 
@@ -267,6 +296,8 @@ static void mac80211_hwsim_beacon_tx(voi
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
 
+	hwsim_check_magic(vif);
+
 	if (vif->type != NL80211_IFTYPE_AP)
 		return;
 
@@ -341,7 +372,28 @@ static void mac80211_hwsim_configure_fil
 	*total_flags = data->rx_filter;
 }
 
+static int mac80211_hwsim_config_interface(struct ieee80211_hw *hw,
+					   struct ieee80211_vif *vif,
+					   struct ieee80211_if_conf *conf)
+{
+	hwsim_check_magic(vif);
+	return 0;
+}
 
+static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
+					    struct ieee80211_vif *vif,
+					    struct ieee80211_bss_conf *info,
+					    u32 changed)
+{
+	hwsim_check_magic(vif);
+}
+
+static void mac80211_hwsim_sta_notify(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      enum sta_notify_cmd cmd, const u8 *addr)
+{
+	hwsim_check_magic(vif);
+}
 
 static const struct ieee80211_ops mac80211_hwsim_ops =
 {
@@ -352,6 +404,9 @@ static const struct ieee80211_ops mac802
 	.remove_interface = mac80211_hwsim_remove_interface,
 	.config = mac80211_hwsim_config,
 	.configure_filter = mac80211_hwsim_configure_filter,
+	.config_interface = mac80211_hwsim_config_interface,
+	.bss_info_changed = mac80211_hwsim_bss_info_changed,
+	.sta_notify = mac80211_hwsim_sta_notify,
 };
 
 
@@ -452,6 +507,9 @@ static int __init init_mac80211_hwsim(vo
 			BIT(NL80211_IFTYPE_AP);
 		hw->ampdu_queues = 1;
 
+		/* ask mac80211 to reserve space for magic */
+		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
+
 		memcpy(data->channels, hwsim_channels, sizeof(hwsim_channels));
 		memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
 		data->band.channels = data->channels;

-- 

