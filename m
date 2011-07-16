Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:41539 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1GPQNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 12:13:47 -0400
Received: by fxd18 with SMTP id 18so4276295fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 09:13:46 -0700 (PDT)
Message-Id: <e7118cd014e5e6857227ae6edad51c2bc1c80894.1310831458.git.chunkeey@googlemail.com> (sfid-20110716_181352_829443_4E69FDA7)
In-Reply-To: <adb1d389949d70637c47a387df5c556e24a9837e.1310831458.git.chunkeey@googlemail.com>
References: <adb1d389949d70637c47a387df5c556e24a9837e.1310831458.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 16 Jul 2011 17:25:14 +0200
Subject: [PATCH 2/3] carl9170: move beacon_update into tx.c
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    2 +-
 drivers/net/wireless/ath/carl9170/mac.c      |  129 --------------------------
 drivers/net/wireless/ath/carl9170/tx.c       |  129 ++++++++++++++++++++++++++
 3 files changed, 130 insertions(+), 130 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 191ba91..2233ff5 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -544,7 +544,6 @@ int carl9170_set_ampdu_settings(struct ar9170 *ar);
 int carl9170_set_slot_time(struct ar9170 *ar);
 int carl9170_set_mac_rates(struct ar9170 *ar);
 int carl9170_set_hwretry_limit(struct ar9170 *ar, const u32 max_retry);
-int carl9170_update_beacon(struct ar9170 *ar, const bool submit);
 int carl9170_upload_key(struct ar9170 *ar, const u8 id, const u8 *mac,
 	const u8 ktype, const u8 keyidx, const u8 *keydata, const int keylen);
 int carl9170_disable_key(struct ar9170 *ar, const u8 id);
@@ -565,6 +564,7 @@ void carl9170_tx_drop(struct ar9170 *ar, struct sk_buff *skb);
 void carl9170_tx_scheduler(struct ar9170 *ar);
 void carl9170_tx_get_skb(struct sk_buff *skb);
 int carl9170_tx_put_skb(struct sk_buff *skb);
+int carl9170_update_beacon(struct ar9170 *ar, const bool submit);
 
 /* LEDs */
 #ifdef CONFIG_CARL9170_LEDS
diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index 385cf50..dfda919 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -455,135 +455,6 @@ int carl9170_set_beacon_timers(struct ar9170 *ar)
 	return carl9170_regwrite_result();
 }
 
-int carl9170_update_beacon(struct ar9170 *ar, const bool submit)
-{
-	struct sk_buff *skb = NULL;
-	struct carl9170_vif_info *cvif;
-	struct ieee80211_tx_info *txinfo;
-	__le32 *data, *old = NULL;
-	u32 word, off, addr, len;
-	int i = 0, err = 0;
-
-	rcu_read_lock();
-	cvif = rcu_dereference(ar->beacon_iter);
-retry:
-	if (ar->vifs == 0 || !cvif)
-		goto out_unlock;
-
-	list_for_each_entry_continue_rcu(cvif, &ar->vif_list, list) {
-		if (cvif->active && cvif->enable_beacon)
-			goto found;
-	}
-
-	if (!ar->beacon_enabled || i++)
-		goto out_unlock;
-
-	goto retry;
-
-found:
-	rcu_assign_pointer(ar->beacon_iter, cvif);
-
-	skb = ieee80211_beacon_get_tim(ar->hw, carl9170_get_vif(cvif),
-		NULL, NULL);
-
-	if (!skb) {
-		err = -ENOMEM;
-		goto err_free;
-	}
-
-	txinfo = IEEE80211_SKB_CB(skb);
-	if (txinfo->control.rates[0].flags & IEEE80211_TX_RC_MCS) {
-		err = -EINVAL;
-		goto err_free;
-	}
-
-	spin_lock_bh(&ar->beacon_lock);
-	data = (__le32 *)skb->data;
-	if (cvif->beacon)
-		old = (__le32 *)cvif->beacon->data;
-
-	off = cvif->id * AR9170_MAC_BCN_LENGTH_MAX;
-	addr = ar->fw.beacon_addr + off;
-	len = roundup(skb->len + FCS_LEN, 4);
-
-	if ((off + len) > ar->fw.beacon_max_len) {
-		if (net_ratelimit()) {
-			wiphy_err(ar->hw->wiphy, "beacon does not "
-				  "fit into device memory!\n");
-		}
-		err = -EINVAL;
-		goto err_unlock;
-	}
-
-	if (len > AR9170_MAC_BCN_LENGTH_MAX) {
-		if (net_ratelimit()) {
-			wiphy_err(ar->hw->wiphy, "no support for beacons "
-				"bigger than %d (yours:%d).\n",
-				 AR9170_MAC_BCN_LENGTH_MAX, len);
-		}
-
-		err = -EMSGSIZE;
-		goto err_unlock;
-	}
-
-	i = txinfo->control.rates[0].idx;
-	if (txinfo->band != IEEE80211_BAND_2GHZ)
-		i += 4;
-
-	word = __carl9170_ratetable[i].hw_value & 0xf;
-	if (i < 4)
-		word |= ((skb->len + FCS_LEN) << (3 + 16)) + 0x0400;
-	else
-		word |= ((skb->len + FCS_LEN) << 16) + 0x0010;
-
-	carl9170_async_regwrite_begin(ar);
-	carl9170_async_regwrite(AR9170_MAC_REG_BCN_PLCP, word);
-
-	for (i = 0; i < DIV_ROUND_UP(skb->len, 4); i++) {
-		/*
-		 * XXX: This accesses beyond skb data for up
-		 *	to the last 3 bytes!!
-		 */
-
-		if (old && (data[i] == old[i]))
-			continue;
-
-		word = le32_to_cpu(data[i]);
-		carl9170_async_regwrite(addr + 4 * i, word);
-	}
-	carl9170_async_regwrite_finish();
-
-	dev_kfree_skb_any(cvif->beacon);
-	cvif->beacon = NULL;
-
-	err = carl9170_async_regwrite_result();
-	if (!err)
-		cvif->beacon = skb;
-	spin_unlock_bh(&ar->beacon_lock);
-	if (err)
-		goto err_free;
-
-	if (submit) {
-		err = carl9170_bcn_ctrl(ar, cvif->id,
-					CARL9170_BCN_CTRL_CAB_TRIGGER,
-					addr, skb->len + FCS_LEN);
-
-		if (err)
-			goto err_free;
-	}
-out_unlock:
-	rcu_read_unlock();
-	return 0;
-
-err_unlock:
-	spin_unlock_bh(&ar->beacon_lock);
-
-err_free:
-	rcu_read_unlock();
-	dev_kfree_skb_any(skb);
-	return err;
-}
-
 int carl9170_upload_key(struct ar9170 *ar, const u8 id, const u8 *mac,
 			const u8 ktype, const u8 keyidx, const u8 *keydata,
 			const int keylen)
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index e94084f..0f8cdef 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1438,3 +1438,132 @@ void carl9170_tx_scheduler(struct ar9170 *ar)
 	if (ar->tx_schedule)
 		carl9170_tx(ar);
 }
+
+int carl9170_update_beacon(struct ar9170 *ar, const bool submit)
+{
+	struct sk_buff *skb = NULL;
+	struct carl9170_vif_info *cvif;
+	struct ieee80211_tx_info *txinfo;
+	__le32 *data, *old = NULL;
+	u32 word, off, addr, len;
+	int i = 0, err = 0;
+
+	rcu_read_lock();
+	cvif = rcu_dereference(ar->beacon_iter);
+retry:
+	if (ar->vifs == 0 || !cvif)
+		goto out_unlock;
+
+	list_for_each_entry_continue_rcu(cvif, &ar->vif_list, list) {
+		if (cvif->active && cvif->enable_beacon)
+			goto found;
+	}
+
+	if (!ar->beacon_enabled || i++)
+		goto out_unlock;
+
+	goto retry;
+
+found:
+	rcu_assign_pointer(ar->beacon_iter, cvif);
+
+	skb = ieee80211_beacon_get_tim(ar->hw, carl9170_get_vif(cvif),
+		NULL, NULL);
+
+	if (!skb) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	txinfo = IEEE80211_SKB_CB(skb);
+	if (txinfo->control.rates[0].flags & IEEE80211_TX_RC_MCS) {
+		err = -EINVAL;
+		goto err_free;
+	}
+
+	spin_lock_bh(&ar->beacon_lock);
+	data = (__le32 *)skb->data;
+	if (cvif->beacon)
+		old = (__le32 *)cvif->beacon->data;
+
+	off = cvif->id * AR9170_MAC_BCN_LENGTH_MAX;
+	addr = ar->fw.beacon_addr + off;
+	len = roundup(skb->len + FCS_LEN, 4);
+
+	if ((off + len) > ar->fw.beacon_max_len) {
+		if (net_ratelimit()) {
+			wiphy_err(ar->hw->wiphy, "beacon does not "
+				  "fit into device memory!\n");
+		}
+		err = -EINVAL;
+		goto err_unlock;
+	}
+
+	if (len > AR9170_MAC_BCN_LENGTH_MAX) {
+		if (net_ratelimit()) {
+			wiphy_err(ar->hw->wiphy, "no support for beacons "
+				"bigger than %d (yours:%d).\n",
+				 AR9170_MAC_BCN_LENGTH_MAX, len);
+		}
+
+		err = -EMSGSIZE;
+		goto err_unlock;
+	}
+
+	i = txinfo->control.rates[0].idx;
+	if (txinfo->band != IEEE80211_BAND_2GHZ)
+		i += 4;
+
+	word = __carl9170_ratetable[i].hw_value & 0xf;
+	if (i < 4)
+		word |= ((skb->len + FCS_LEN) << (3 + 16)) + 0x0400;
+	else
+		word |= ((skb->len + FCS_LEN) << 16) + 0x0010;
+
+	carl9170_async_regwrite_begin(ar);
+	carl9170_async_regwrite(AR9170_MAC_REG_BCN_PLCP, word);
+
+	for (i = 0; i < DIV_ROUND_UP(skb->len, 4); i++) {
+		/*
+		 * XXX: This accesses beyond skb data for up
+		 *	to the last 3 bytes!!
+		 */
+
+		if (old && (data[i] == old[i]))
+			continue;
+
+		word = le32_to_cpu(data[i]);
+		carl9170_async_regwrite(addr + 4 * i, word);
+	}
+	carl9170_async_regwrite_finish();
+
+	dev_kfree_skb_any(cvif->beacon);
+	cvif->beacon = NULL;
+
+	err = carl9170_async_regwrite_result();
+	if (!err)
+		cvif->beacon = skb;
+	spin_unlock_bh(&ar->beacon_lock);
+	if (err)
+		goto err_free;
+
+	if (submit) {
+		err = carl9170_bcn_ctrl(ar, cvif->id,
+					CARL9170_BCN_CTRL_CAB_TRIGGER,
+					addr, skb->len + FCS_LEN);
+
+		if (err)
+			goto err_free;
+	}
+out_unlock:
+	rcu_read_unlock();
+	return 0;
+
+err_unlock:
+	spin_unlock_bh(&ar->beacon_lock);
+
+err_free:
+	rcu_read_unlock();
+	dev_kfree_skb_any(skb);
+	return err;
+}
-- 
1.7.5.4

