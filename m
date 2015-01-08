Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54749 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbbAHLSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 06:18:10 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so2545213wiv.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 03:18:08 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 5/5] ath10k: implement support for ap beacon offloading
Date: Thu,  8 Jan 2015 12:12:30 +0100
Message-Id: <1420715550-16017-6-git-send-email-michal.kazior@tieto.com> (sfid-20150108_121814_361134_8A0ADC58)
In-Reply-To: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
References: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New firmware revisions support beacon and probe
response templates instead. This means SWBA events
are no longer delivered for these firmware
revisions.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * add a comment why P2P IE is stripped from beacon template [Kalle]

 drivers/net/wireless/ath/ath10k/mac.c | 162 ++++++++++++++++++++++++++++++++++
 1 file changed, 162 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5085f55..b4d4fec 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -967,6 +967,143 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 	return ret;
 }
 
+static int ath10k_mac_setup_bcn_p2p_ie(struct ath10k_vif *arvif,
+				       struct sk_buff *bcn)
+{
+	struct ath10k *ar = arvif->ar;
+	struct ieee80211_mgmt *mgmt;
+	const u8 *p2p_ie;
+	int ret;
+
+	if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
+		return 0;
+
+	if (arvif->vdev_subtype != WMI_VDEV_SUBTYPE_P2P_GO)
+		return 0;
+
+	mgmt = (void *)bcn->data;
+	p2p_ie = cfg80211_find_vendor_ie(WLAN_OUI_WFA, WLAN_OUI_TYPE_WFA_P2P,
+					 mgmt->u.beacon.variable,
+					 bcn->len - (mgmt->u.beacon.variable -
+						     bcn->data));
+	if (!p2p_ie)
+		return -ENOENT;
+
+	ret = ath10k_wmi_p2p_go_bcn_ie(ar, arvif->vdev_id, p2p_ie);
+	if (ret) {
+		ath10k_warn(ar, "failed to submit p2p go bcn ie for vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath10k_mac_remove_vendor_ie(struct sk_buff *skb, unsigned int oui,
+				       u8 oui_type, size_t ie_offset)
+{
+	size_t len;
+	const u8 *next;
+	const u8 *end;
+	u8 *ie;
+
+	if (WARN_ON(skb->len < ie_offset))
+		return -EINVAL;
+
+	ie = (u8 *)cfg80211_find_vendor_ie(oui, oui_type,
+					   skb->data + ie_offset,
+					   skb->len - ie_offset);
+	if (!ie)
+		return -ENOENT;
+
+	len = ie[1] + 2;
+	end = skb->data + skb->len;
+	next = ie + len;
+
+	if (WARN_ON(next > end))
+		return -EINVAL;
+
+	memmove(ie, next, end - next);
+	skb_trim(skb, skb->len - len);
+
+	return 0;
+}
+
+static int ath10k_mac_setup_bcn_tmpl(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	struct ieee80211_hw *hw = ar->hw;
+	struct ieee80211_vif *vif = arvif->vif;
+	struct ieee80211_mutable_offsets offs = {};
+	struct sk_buff *bcn;
+	int ret;
+
+	if (!test_bit(WMI_SERVICE_BEACON_OFFLOAD, ar->wmi.svc_map))
+		return 0;
+
+	bcn = ieee80211_beacon_get_template(hw, vif, &offs);
+	if (!bcn) {
+		ath10k_warn(ar, "failed to get beacon template from mac80211\n");
+		return -EPERM;
+	}
+
+	ret = ath10k_mac_setup_bcn_p2p_ie(arvif, bcn);
+	if (ret) {
+		ath10k_warn(ar, "failed to setup p2p go bcn ie: %d\n", ret);
+		kfree_skb(bcn);
+		return ret;
+	}
+
+	/* P2P IE is inserted by firmware automatically (as configured above)
+	 * so remove it from the base beacon template to avoid duplicate P2P
+	 * IEs in beacon frames.
+	 */
+	ath10k_mac_remove_vendor_ie(bcn, WLAN_OUI_WFA, WLAN_OUI_TYPE_WFA_P2P,
+				    offsetof(struct ieee80211_mgmt,
+					     u.beacon.variable));
+
+	ret = ath10k_wmi_bcn_tmpl(ar, arvif->vdev_id, offs.tim_offset, bcn, 0,
+				  0, NULL, 0);
+	kfree_skb(bcn);
+
+	if (ret) {
+		ath10k_warn(ar, "failed to submit beacon template command: %d\n",
+			    ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath10k_mac_setup_prb_tmpl(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	struct ieee80211_hw *hw = ar->hw;
+	struct ieee80211_vif *vif = arvif->vif;
+	struct sk_buff *prb;
+	int ret;
+
+	if (!test_bit(WMI_SERVICE_BEACON_OFFLOAD, ar->wmi.svc_map))
+		return 0;
+
+	prb = ieee80211_proberesp_get(hw, vif);
+	if (!prb) {
+		ath10k_warn(ar, "failed to get probe resp template from mac80211\n");
+		return -EPERM;
+	}
+
+	ret = ath10k_wmi_prb_tmpl(ar, arvif->vdev_id, prb);
+	kfree_skb(prb);
+
+	if (ret) {
+		ath10k_warn(ar, "failed to submit probe resp template command: %d\n",
+			    ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 				     struct ieee80211_bss_conf *info)
 {
@@ -3283,6 +3420,18 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret)
 			ath10k_warn(ar, "failed to set beacon mode for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
+
+		ret = ath10k_mac_setup_bcn_tmpl(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to update beacon template: %d\n",
+				    ret);
+	}
+
+	if (changed & BSS_CHANGED_AP_PROBE_RESP) {
+		ret = ath10k_mac_setup_prb_tmpl(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to setup probe resp template on vdev %i: %d\n",
+				    arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_BEACON_INFO) {
@@ -5127,6 +5276,19 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	ar->hw->max_listen_interval = ATH10K_MAX_HW_LISTEN_INTERVAL;
 
+	if (test_bit(WMI_SERVICE_BEACON_OFFLOAD, ar->wmi.svc_map)) {
+		ar->hw->wiphy->flags |= WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+
+		/* Firmware delivers WPS/P2P Probe Requests frames to driver so
+		 * that userspace (e.g. wpa_supplicant/hostapd) can generate
+		 * correct Probe Responses. This is more of a hack advert..
+		 */
+		ar->hw->wiphy->probe_resp_offload |=
+			NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+			NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
+			NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
+	}
+
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
-- 
1.8.5.3

