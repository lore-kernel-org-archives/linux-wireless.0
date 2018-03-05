Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:45693 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbeCEOt1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:49:27 -0500
Received: by mail-pg0-f66.google.com with SMTP id i133so6889823pgc.12
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:49:27 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [PATCH 10/10] rsi: drop RX broadcast/multicast packets with invalid PN
Date: Mon,  5 Mar 2018 20:07:00 +0530
Message-Id: <1520260620-4694-11-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154940_119357_8A3160E9)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

This patch adds a check to drop received broadcast/multicast frames if
PN is invalid (i.e. not greater than last PN). bc_mc_pn
variable added for each interface

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 166 ++++++++++++++++++++++++++--
 drivers/net/wireless/rsi/rsi_main.h         |   3 +
 2 files changed, 160 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 70b2d61..f73c0f0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -522,6 +522,9 @@ static int rsi_mac80211_add_interface(struct ieee80211_hw *hw,
 		mutex_unlock(&common->mutex);
 		return -EINVAL;
 	}
+	memset(vif_info->rx_bcmc_pn, 0, IEEE80211_CCMP_PN_LEN);
+	vif_info->rx_pn_valid = false;
+	vif_info->key = NULL;
 
 	if ((vif->type == NL80211_IFTYPE_AP) ||
 	    (vif->type == NL80211_IFTYPE_P2P_GO)) {
@@ -1035,6 +1038,8 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
 	struct security_info *secinfo = &common->secinfo;
+	struct vif_priv *vif_info = (struct vif_priv *)vif->drv_priv;
+	struct ieee80211_key_seq seq;
 	int status;
 
 	mutex_lock(&common->mutex);
@@ -1047,10 +1052,41 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
 			return status;
 		}
 
-		if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+		if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
 			secinfo->ptk_cipher = key->cipher;
-		else
+		} else {
 			secinfo->gtk_cipher = key->cipher;
+			ieee80211_get_key_rx_seq(key, 0, &seq);
+			switch (key->cipher) {
+			case WLAN_CIPHER_SUITE_CCMP:
+			case WLAN_CIPHER_SUITE_CCMP_256:
+				memcpy(vif_info->rx_bcmc_pn, seq.ccmp.pn,
+				       IEEE80211_CCMP_PN_LEN);
+				vif_info->rx_pn_valid = true;
+				vif_info->key = key;
+				break;
+			case WLAN_CIPHER_SUITE_TKIP:
+				vif_info->rx_bcmc_pn[0] = seq.tkip.iv16 & 0xff;
+				vif_info->rx_bcmc_pn[1] =
+					(seq.tkip.iv16 >> 8) & 0xff;
+				vif_info->rx_bcmc_pn[2] = seq.tkip.iv32 & 0xff;
+				vif_info->rx_bcmc_pn[3] =
+					(seq.tkip.iv32 >> 8) & 0xff;
+				vif_info->rx_bcmc_pn[4] =
+					(seq.tkip.iv32 >> 16) & 0xff;
+				vif_info->rx_bcmc_pn[5] =
+					(seq.tkip.iv32 >> 24) & 0xff;
+				vif_info->rx_pn_valid = true;
+				vif_info->key = key;
+				break;
+			case WLAN_CIPHER_SUITE_AES_CMAC:
+				memcpy(vif_info->rx_bcmc_pn,
+				       seq.aes_cmac.pn, IEEE80211_CMAC_PN_LEN);
+				vif_info->rx_pn_valid = true;
+				vif_info->key = key;
+				break;
+			}
+		}
 
 		key->hw_key_idx = key->keyidx;
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -1063,6 +1099,9 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
 			secinfo->security_enable = false;
 		rsi_dbg(ERR_ZONE, "%s: RSI del key\n", __func__);
 		memset(key, 0, sizeof(struct ieee80211_key_conf));
+		memset(vif_info->rx_bcmc_pn, 0, IEEE80211_CCMP_PN_LEN);
+		vif_info->rx_pn_valid = false;
+		vif_info->key = NULL;
 		status = rsi_hal_key_config(hw, vif, key, sta);
 		break;
 
@@ -1277,6 +1316,103 @@ static void rsi_perform_cqm(struct rsi_common *common,
 	return;
 }
 
+struct dot11_ccmp_hdr {
+	u8 pn0;
+	u8 pn1;
+	u8 reserved;
+	u8 keyid_info;
+	u8 pn2;
+	u8 pn3;
+	u8 pn4;
+	u8 pn5;
+};
+
+struct dot11_tkip_hdr {
+	u8 tsc1;
+	u8 wep_seed;
+	u8 tsc0;
+	u8 keyid_info;
+	u8 tsc2;
+	u8 tsc3;
+	u8 tsc4;
+	u8 tsc5;
+};
+
+static int rsi_validate_pn(struct rsi_hw *adapter, struct ieee80211_hdr *hdr)
+{
+	struct ieee80211_vif *vif;
+	struct ieee80211_bss_conf *bss;
+	struct vif_priv *vif_info = NULL;
+	u8 cur_pn[IEEE80211_CCMP_PN_LEN];
+	u8 *last_pn;
+	int i, hdrlen;
+
+	if (!is_broadcast_ether_addr(hdr->addr1) &&
+	    !is_multicast_ether_addr(hdr->addr1))
+		return 1;
+
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	for (i = 0; i < adapter->sc_nvifs; i++) {
+		vif = adapter->vifs[i];
+
+		if (!vif)
+			continue;
+		if (vif->type != NL80211_IFTYPE_STATION &&
+		    vif->type != NL80211_IFTYPE_P2P_CLIENT)
+			continue;
+		bss = &vif->bss_conf;
+		if (!bss->assoc)
+			continue;
+		if (!ether_addr_equal(bss->bssid, hdr->addr2))
+			continue;
+		vif_info = (struct vif_priv *)vif->drv_priv;
+		if (!vif_info->key) {
+			vif_info = NULL;
+			continue;
+		}
+		if (!vif_info->rx_pn_valid) {
+			vif_info = NULL;
+			continue;
+		}
+	}
+	if (!vif_info)
+		return 1;
+	last_pn = vif_info->rx_bcmc_pn;
+	if (vif_info->key->cipher == WLAN_CIPHER_SUITE_CCMP) {
+		struct dot11_ccmp_hdr *ccmp =
+			(struct dot11_ccmp_hdr *)&((u8 *)hdr)[hdrlen];
+
+		cur_pn[0] = ccmp->pn0;
+		cur_pn[1] = ccmp->pn1;
+		cur_pn[2] = ccmp->pn2;
+		cur_pn[3] = ccmp->pn3;
+		cur_pn[4] = ccmp->pn4;
+		cur_pn[5] = ccmp->pn5;
+	} else {
+		struct dot11_tkip_hdr *tkip =
+			(struct dot11_tkip_hdr *)&((u8 *)hdr)[hdrlen];
+
+		cur_pn[0] = tkip->tsc0;
+		cur_pn[1] = tkip->tsc1;
+		cur_pn[2] = tkip->tsc2;
+		cur_pn[3] = tkip->tsc3;
+		cur_pn[4] = tkip->tsc4;
+		cur_pn[5] = tkip->tsc5;
+	}
+	for (i = (IEEE80211_CCMP_PN_LEN - 1); i >= 0; i--)
+		if (last_pn[i] ^ cur_pn[i])
+			break;
+	if (i < 0)
+		return -1;
+
+	if (last_pn[i] >= cur_pn[i])
+		return -1;
+
+	memcpy(vif_info->rx_bcmc_pn, cur_pn, IEEE80211_CCMP_PN_LEN);
+
+	return 0;
+}
+
 /**
  * rsi_fill_rx_status() - This function fills rx status in
  *			  ieee80211_rx_status structure.
@@ -1287,10 +1423,10 @@ static void rsi_perform_cqm(struct rsi_common *common,
  *
  * Return: None.
  */
-static void rsi_fill_rx_status(struct ieee80211_hw *hw,
-			       struct sk_buff *skb,
-			       struct rsi_common *common,
-			       struct ieee80211_rx_status *rxs)
+static int rsi_fill_rx_status(struct ieee80211_hw *hw,
+			      struct sk_buff *skb,
+			      struct rsi_common *common,
+			      struct ieee80211_rx_status *rxs)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_vif *vif;
@@ -1323,6 +1459,17 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 			memmove(skb->data + 4, skb->data, hdrlen);
 			skb_pull(skb, 4);
 		} else {
+			if (skb->len < (hdrlen + IEEE80211_CCMP_HDR_LEN)) {
+				rsi_dbg(ERR_ZONE, "Invalid encrypted packet\n");
+				dev_kfree_skb(skb);
+				return -EINVAL;
+			}
+			if (rsi_validate_pn(adapter, hdr) < 0) {
+				rsi_dbg(INFO_ZONE,
+					"Invalid RX PN; Dropping\n");
+				dev_kfree_skb(skb);
+				return -EINVAL;
+			}
 			memmove(skb->data + 8, skb->data, hdrlen);
 			skb_pull(skb, 8);
 			rxs->flag |= RX_FLAG_MMIC_STRIPPED;
@@ -1341,14 +1488,14 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 		}
 	}
 	if (!bss)
-		return;
+		return -1;
 	/* CQM only for connected AP beacons, the RSSI is a weighted avg */
 	if (bss->assoc && !(memcmp(bss->bssid, hdr->addr2, ETH_ALEN))) {
 		if (ieee80211_is_beacon(hdr->frame_control))
 			rsi_perform_cqm(common, hdr->addr2, rxs->signal, vif);
 	}
 
-	return;
+	return 0;
 }
 
 /**
@@ -1371,7 +1518,8 @@ void rsi_indicate_pkt_to_os(struct rsi_common *common,
 	}
 
 	/* filling in the ieee80211_rx_status flags */
-	rsi_fill_rx_status(hw, skb, common, rx_status);
+	if (rsi_fill_rx_status(hw, skb, common, rx_status))
+		return;
 
 	ieee80211_rx_irqsafe(hw, skb);
 }
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 9e09dd5..566379c 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -191,6 +191,9 @@ struct vif_priv {
 	bool sgi;
 	u16 seq_start;
 	int vap_id;
+	struct ieee80211_key_conf *key;
+	u8 rx_bcmc_pn[IEEE80211_CCMP_PN_LEN];
+	bool rx_pn_valid;
 };
 
 struct rsi_event {
-- 
2.7.4
