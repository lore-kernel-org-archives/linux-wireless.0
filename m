Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYIJWQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:16:43 -0400
Message-Id: <20080910220428.687397000@sipsolutions.net> (sfid-20080911_001645_613218_891667FD)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:02:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/18] mac80211 hwsim: verify sta pointers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In analogy with the previous patch to make mac80211-hwsim
verify that the virtual interface pointers are correct,
this makes it very that it knows about all station structs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |   43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- everything.orig/drivers/net/wireless/mac80211_hwsim.c	2008-09-10 23:58:12.000000000 +0200
+++ everything/drivers/net/wireless/mac80211_hwsim.c	2008-09-10 23:58:14.000000000 +0200
@@ -52,6 +52,30 @@ static inline void hwsim_clear_magic(str
 	vp->magic = 0;
 }
 
+struct hwsim_sta_priv {
+	u32 magic;
+};
+
+#define HWSIM_STA_MAGIC	0x6d537748
+
+static inline void hwsim_check_sta_magic(struct ieee80211_sta *sta)
+{
+	struct hwsim_sta_priv *sp = (void *)sta->drv_priv;
+	BUG_ON(sp->magic != HWSIM_VIF_MAGIC);
+}
+
+static inline void hwsim_set_sta_magic(struct ieee80211_sta *sta)
+{
+	struct hwsim_sta_priv *sp = (void *)sta->drv_priv;
+	sp->magic = HWSIM_VIF_MAGIC;
+}
+
+static inline void hwsim_clear_sta_magic(struct ieee80211_sta *sta)
+{
+	struct hwsim_sta_priv *sp = (void *)sta->drv_priv;
+	sp->magic = 0;
+}
+
 static struct class *hwsim_class;
 
 static struct ieee80211_hw **hwsim_radios;
@@ -235,6 +259,8 @@ static int mac80211_hwsim_tx(struct ieee
 	txi = IEEE80211_SKB_CB(skb);
 
 	hwsim_check_magic(txi->control.vif);
+	if (txi->control.sta)
+		hwsim_check_sta_magic(txi->control.sta);
 
 	memset(&txi->status, 0, sizeof(txi->status));
 	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK)) {
@@ -394,6 +420,22 @@ static void mac80211_hwsim_sta_notify(st
 				      struct ieee80211_sta *sta)
 {
 	hwsim_check_magic(vif);
+	switch (cmd) {
+	case STA_NOTIFY_ADD:
+		hwsim_set_sta_magic(sta);
+		break;
+	case STA_NOTIFY_REMOVE:
+		hwsim_clear_sta_magic(sta);
+		break;
+	}
+}
+
+static int mac80211_hwsim_set_tim(struct ieee80211_hw *hw,
+				  struct ieee80211_sta *sta,
+				  bool set)
+{
+	hwsim_check_sta_magic(sta);
+	return 0;
 }
 
 static const struct ieee80211_ops mac80211_hwsim_ops =
@@ -408,6 +450,7 @@ static const struct ieee80211_ops mac802
 	.config_interface = mac80211_hwsim_config_interface,
 	.bss_info_changed = mac80211_hwsim_bss_info_changed,
 	.sta_notify = mac80211_hwsim_sta_notify,
+	.set_tim = mac80211_hwsim_set_tim,
 };
 
 

-- 

