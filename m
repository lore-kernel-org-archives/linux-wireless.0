Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64541 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbZK2BBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 20:01:06 -0500
Received: by fxm5 with SMTP id 5so2637178fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 17:01:12 -0800 (PST)
Received: from debian64.daheim
	([192.168.0.4] helo=debian64.localnet ident=chuck)
	by debian64.daheim with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <chunkeey@googlemail.com>)
	id 1NEYEt-0008Ck-6z
	for linux-wireless@vger.kernel.org; Sun, 29 Nov 2009 02:06:11 +0100
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFT] ar9170: AP broadcast buffering
Date: Sun, 29 Nov 2009 02:06:07 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200911290206.07784.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch should fix "broadcast traffic before DTIM beacon",
But there is a downside: the broadcast (e.g arp) frames
might get delayed and won't make it in time.

let me know, if this patch does any good, or not...
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index b99a8c2..c3d1349 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -176,6 +176,7 @@ struct ar9170 {
 	/* beaconing */
 	struct sk_buff *beacon;
 	struct work_struct beacon_work;
+	struct work_struct cab_work;
 	bool enable_beacon;
 
 	/* cryptographic engine */
@@ -278,6 +279,7 @@ int ar9170_set_basic_rates(struct ar9170 *ar);
 int ar9170_set_hwretry_limit(struct ar9170 *ar, u32 max_retry);
 int ar9170_update_beacon(struct ar9170 *ar);
 void ar9170_new_beacon(struct work_struct *work);
+void ar9170_send_buffered(struct work_struct *work);
 int ar9170_upload_key(struct ar9170 *ar, u8 id, const u8 *mac, u8 ktype,
 		      u8 keyidx, u8 *keydata, int keylen);
 int ar9170_disable_key(struct ar9170 *ar, u8 id);
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index 857e861..805b4f4 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -463,7 +463,6 @@ void ar9170_new_beacon(struct work_struct *work)
 {
 	struct ar9170 *ar = container_of(work, struct ar9170,
 					 beacon_work);
-	struct sk_buff *skb;
 
 	if (unlikely(!IS_STARTED(ar)))
 		return ;
@@ -475,6 +474,24 @@ void ar9170_new_beacon(struct work_struct *work)
 
 	ar9170_update_beacon(ar);
 
+ out:
+	mutex_unlock(&ar->mutex);
+}
+
+void ar9170_send_buffered(struct work_struct *work)
+{
+	struct ar9170 *ar = container_of(work, struct ar9170,
+					 cab_work);
+	struct sk_buff *skb;
+
+	if (unlikely(!IS_STARTED(ar)))
+		return ;
+
+	mutex_lock(&ar->mutex);
+
+	if (!ar->vif)
+		goto out;
+
 	rcu_read_lock();
 	while ((skb = ieee80211_get_buffered_bc(ar->hw, ar->vif)))
 		ar9170_op_tx(ar->hw, skb);
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 20f04ab..f027d74 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -660,6 +660,10 @@ void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 		 * YY always 00
 		 * B1-B4 "should" be the number of send out beacons.
 		 */
+
+		if (ar->vif && ar->vif->type == NL80211_IFTYPE_AP)
+			ieee80211_queue_work(ar->hw, &ar->cab_work);
+
 		break;
 
 	case 0xc3:
@@ -1294,6 +1298,7 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 	cancel_delayed_work_sync(&ar->led_work);
 #endif
 	cancel_work_sync(&ar->beacon_work);
+	cancel_work_sync(&ar->cab_work);
 
 	mutex_lock(&ar->mutex);
 
@@ -2549,6 +2554,7 @@ void *ar9170_alloc(size_t priv_size)
 	}
 	ar9170_rx_reset_rx_mpdu(ar);
 	INIT_WORK(&ar->beacon_work, ar9170_new_beacon);
+	INIT_WORK(&ar->cab_work, ar9170_send_buffered);
 	INIT_DELAYED_WORK(&ar->tx_janitor, ar9170_tx_janitor);
 	INIT_LIST_HEAD(&ar->tx_ampdu_list);
 
