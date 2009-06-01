Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:40152 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbZFATmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 15:42:09 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RESEND][PATCH 4/4] ar9170: introduce functions for MAC programming
Date: Mon, 1 Jun 2009 21:42:01 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
References: <200905120108.47748.chunkeey@web.de>
In-Reply-To: <200905120108.47748.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200906012142.02112.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces 3 new function which are used to update
the MAC state, whenever needed... e.g: after a band switch.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 17bd3ea..77dc647 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -215,6 +215,9 @@ int ar9170_update_multicast(struct ar9170 *ar);
 int ar9170_update_frame_filter(struct ar9170 *ar);
 int ar9170_set_operating_mode(struct ar9170 *ar);
 int ar9170_set_beacon_timers(struct ar9170 *ar);
+int ar9170_set_dyn_sifs_ack(struct ar9170 *ar);
+int ar9170_set_slot_time(struct ar9170 *ar);
+int ar9170_set_basic_rates(struct ar9170 *ar);
 int ar9170_set_hwretry_limit(struct ar9170 *ar, u32 max_retry);
 int ar9170_update_beacon(struct ar9170 *ar);
 void ar9170_new_beacon(struct work_struct *work);
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index 706262f..d9f1f46 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -38,6 +38,55 @@
 #include "ar9170.h"
 #include "cmd.h"
 
+int ar9170_set_dyn_sifs_ack(struct ar9170 *ar)
+{
+	u32 val;
+
+	if (conf_is_ht40(&ar->hw->conf))
+		val = 0x010a;
+	else {
+		if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+			val = 0x105;
+		else
+			val = 0x104;
+	}
+
+	return ar9170_write_reg(ar, AR9170_MAC_REG_DYNAMIC_SIFS_ACK, val);
+}
+
+int ar9170_set_slot_time(struct ar9170 *ar)
+{
+	u32 slottime = 20;
+
+	if (!ar->vif)
+		return 0;
+
+	if ((ar->hw->conf.channel->band == IEEE80211_BAND_5GHZ) ||
+	    ar->vif->bss_conf.use_short_slot)
+		slottime = 9;
+
+	return ar9170_write_reg(ar, AR9170_MAC_REG_SLOT_TIME, slottime << 10);
+}
+
+int ar9170_set_basic_rates(struct ar9170 *ar)
+{
+	u8 cck, ofdm;
+
+	if (!ar->vif)
+		return 0;
+
+	ofdm = ar->vif->bss_conf.basic_rates >> 4;
+
+	/* FIXME: is still necessary? */
+	if (ar->hw->conf.channel->band == IEEE80211_BAND_5GHZ)
+		cck = 0;
+	else
+		cck = ar->vif->bss_conf.basic_rates & 0xf;
+
+	return ar9170_write_reg(ar, AR9170_MAC_REG_BASIC_RATE,
+				ofdm << 8 | cck);
+}
+
 int ar9170_set_qos(struct ar9170 *ar)
 {
 	ar9170_regwrite_begin(ar);
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 4ef1d2f..df83883 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1344,15 +1344,21 @@ static int ar9170_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+
+		/* adjust slot time for 5 GHz */
+		err = ar9170_set_slot_time(ar);
+		if (err)
+			goto out;
+
+		err = ar9170_set_dyn_sifs_ack(ar);
+		if (err)
+			goto out;
+
 		err = ar9170_set_channel(ar, hw->conf.channel,
 				AR9170_RFI_NONE,
 				nl80211_to_ar9170(hw->conf.channel_type));
 		if (err)
 			goto out;
-		/* adjust slot time for 5 GHz */
-		if (hw->conf.channel->band == IEEE80211_BAND_5GHZ)
-			err = ar9170_write_reg(ar, AR9170_MAC_REG_SLOT_TIME,
-					       9 << 10);
 	}
 
 out:
@@ -1464,15 +1470,19 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID) {
 		memcpy(ar->bssid, bss_conf->bssid, ETH_ALEN);
 		err = ar9170_set_operating_mode(ar);
+		if (err)
+			goto out;
 	}
 
 	if (changed & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED)) {
 		err = ar9170_update_beacon(ar);
-		if (!err)
-			ar9170_set_beacon_timers(ar);
-	}
+		if (err)
+			goto out;
 
-	ar9170_regwrite_begin(ar);
+		err = ar9170_set_beacon_timers(ar);
+		if (err)
+			goto out;
+	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		ar->state = bss_conf->assoc ? AR9170_ASSOCIATED : ar->state;
@@ -1483,8 +1493,11 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 #endif /* CONFIG_AR9170_LEDS */
 	}
 
-	if (changed & BSS_CHANGED_BEACON_INT)
+	if (changed & BSS_CHANGED_BEACON_INT) {
 		err = ar9170_set_beacon_timers(ar);
+		if (err)
+			goto out;
+	}
 
 	if (changed & BSS_CHANGED_HT) {
 		/* TODO */
@@ -1492,31 +1505,18 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
-		u32 slottime = 20;
-
-		if (bss_conf->use_short_slot)
-			slottime = 9;
-
-		ar9170_regwrite(AR9170_MAC_REG_SLOT_TIME, slottime << 10);
+		err = ar9170_set_slot_time(ar);
+		if (err)
+			goto out;
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		u32 cck, ofdm;
-
-		if (hw->conf.channel->band == IEEE80211_BAND_5GHZ) {
-			ofdm = bss_conf->basic_rates;
-			cck = 0;
-		} else {
-			/* four cck rates */
-			cck = bss_conf->basic_rates & 0xf;
-			ofdm = bss_conf->basic_rates >> 4;
-		}
-		ar9170_regwrite(AR9170_MAC_REG_BASIC_RATE,
-				ofdm << 8 | cck);
+		err = ar9170_set_basic_rates(ar);
+		if (err)
+			goto out;
 	}
 
-	ar9170_regwrite_finish();
-	err = ar9170_regwrite_result();
+out:
 	mutex_unlock(&ar->mutex);
 }
 


