Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58200 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaKXCfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2014 21:35:54 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath10k: Fix shared WEP
Date: Mon, 24 Nov 2014 08:07:35 +0530
Message-Id: <1416796657-24657-2-git-send-email-sujith@msujith.org> (sfid-20141124_033559_460460_BBE24DCA)
In-Reply-To: <1416796657-24657-1-git-send-email-sujith@msujith.org>
References: <1416796657-24657-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When static keys are used in shared WEP, when a
station is associated, message 3 is sent with an
encrypted payload. But, for subsequent
authentications that are triggered without a
deauth, the auth frame is decrypted by the HW.

To handle this, check if the WEP keys have already
been set for the peer and if so, mark the
frame as decrypted. This scenario can happen
when a station changes its default TX key and initiates
a new authentication sequence.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h |  2 ++
 drivers/net/wireless/ath/ath10k/wmi.c | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1245ac8..23116c2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -179,6 +179,29 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
 	return first_errno;
 }
 
+bool ath10k_mac_is_peer_wep_key_set(struct ath10k *ar, const u8 *addr,
+				    u8 keyidx)
+{
+	struct ath10k_peer *peer;
+	int i;
+
+	/* We don't know which vdev this peer belongs to,
+	 * since WMI doesn't give us that information.
+	 *
+	 * FIXME: multi-bss needs to be handled.
+	 */
+	peer = ath10k_peer_find(ar, 0, addr);
+	if (!peer)
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(peer->keys); i++) {
+		if (peer->keys[i] && peer->keys[i]->keyidx == keyidx)
+			return true;
+	}
+
+	return false;
+}
+
 static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 				 struct ieee80211_key_conf *key)
 {
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 4e3c989..cfa4d5d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -41,6 +41,8 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work);
 void ath10k_halt(struct ath10k *ar);
 void ath10k_mac_vif_beacon_free(struct ath10k_vif *arvif);
 void ath10k_drain_tx(struct ath10k *ar);
+bool ath10k_mac_is_peer_wep_key_set(struct ath10k *ar, const u8 *addr,
+				    u8 keyidx);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c2bc828..a12bba4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1113,6 +1113,37 @@ static inline u8 get_rate_idx(u32 rate, enum ieee80211_band band)
 	return rate_idx;
 }
 
+static void ath10k_wmi_handle_wep_reauth(struct ath10k *ar,
+					 struct sk_buff *skb,
+					 struct ieee80211_rx_status *status)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen;
+	bool peer_key;
+	u8 *addr, keyidx;
+
+	if (!ieee80211_is_auth(hdr->frame_control) ||
+	    !ieee80211_has_protected(hdr->frame_control))
+		return;
+
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (skb->len < (hdrlen + IEEE80211_WEP_IV_LEN))
+		return;
+
+	keyidx = skb->data[hdrlen + 3] >> 6;
+	addr = ieee80211_get_SA(hdr);
+
+	spin_lock_bh(&ar->data_lock);
+	peer_key = ath10k_mac_is_peer_wep_key_set(ar, addr, keyidx);
+	spin_unlock_bh(&ar->data_lock);
+
+	if (peer_key) {
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "wep key present for peer: %pM\n", addr);
+		status->flag |= RX_FLAG_DECRYPTED;
+	}
+}
+
 static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_mgmt_rx_event_v1 *ev_v1;
@@ -1200,6 +1231,8 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = le16_to_cpu(hdr->frame_control);
 
+	ath10k_wmi_handle_wep_reauth(ar, skb, status);
+
 	/* FW delivers WEP Shared Auth frame with Protected Bit set and
 	 * encrypted payload. However in case of PMF it delivers decrypted
 	 * frames with Protected Bit set. */
-- 
2.1.3

