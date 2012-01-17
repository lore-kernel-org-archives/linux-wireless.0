Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:22273 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab2AQWOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 17:14:30 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] ath9k_htc: claim support for IBSS RSN
Date: Tue, 17 Jan 2012 23:13:30 +0100
Message-Id: <1326838410-5212-1-git-send-email-ordex@autistici.org> (sfid-20120117_231434_192989_4DDDA445)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Skip group keys configuration in hardware in order to make IBSS RSN work.
Keys will be managed using software.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 9be10a2..fc7519c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -741,6 +741,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+
 	hw->queues = 4;
 	hw->channel_change_time = 5000;
 	hw->max_listen_interval = 10;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ef4c606..06101b6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1409,6 +1409,21 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 	if (htc_modparam_nohwcrypt)
 		return -ENOSPC;
 
+	if ((vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
+	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		/*
+		 * For now, disable hw crypto for the RSN IBSS group keys. This
+		 * could be optimized in the future to use a modified key cache
+		 * design to support per-STA RX GTK, but until that gets
+		 * implemented, use of software crypto for group addressed
+		 * frames is a acceptable to allow RSN IBSS to be used.
+		 */
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&priv->mutex);
 	ath_dbg(common, CONFIG, "Set HW Key\n");
 	ath9k_htc_ps_wakeup(priv);
-- 
1.7.3.4

