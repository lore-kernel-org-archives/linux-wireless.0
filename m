Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55625 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3CXAsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 20:48:33 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 12/15] brcmsmac: add support for probe response template
Date: Sun, 24 Mar 2013 01:46:00 +0100
Message-Id: <1364085963-25940-13-git-send-email-hauke@hauke-m.de> (sfid-20130324_014836_865548_619397E3)
In-Reply-To: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ucode is able to answer probe response by itself. This writes such
a template into the specific memory. Currently the probe requests are
also send to mac80211 so there are more answers send to a requesting
client. We have to make the ucode stop sending probe requests to the
driver.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   11 ++
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  112 +++++---------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    2 +
 4 files changed, 42 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 1d0d0f6..d4a51f0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -539,6 +539,15 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		spin_unlock_bh(&wl->lock);
 	}
 
+	if (changed & BSS_CHANGED_AP_PROBE_RESP) {
+		struct sk_buff *probe_resp;
+
+		spin_lock_bh(&wl->lock);
+		probe_resp = ieee80211_proberesp_get(hw, vif);
+		brcms_c_set_new_probe_resp(wl->wlc, probe_resp);
+		spin_unlock_bh(&wl->lock);
+	}
+
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		/* Beaconing should be enabled/disabled (beaconing modes) */
 		brcms_err(core, "%s: Beacon enabled: %s\n", __func__,
@@ -1038,6 +1047,8 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	hw->channel_change_time = 7 * 1000;
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
+	hw->wiphy->flags |= WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+
 	hw->rate_control_algorithm = "minstrel_ht";
 
 	hw->sta_data_size = 0;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index cf11d894..04192ed 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -451,6 +451,8 @@ static void brcms_c_detach_mfree(struct brcms_c_info *wlc)
 	kfree(wlc->hw);
 	if (wlc->beacon)
 		dev_kfree_skb_any(wlc->beacon);
+	if (wlc->probe_resp)
+		dev_kfree_skb_any(wlc->probe_resp);
 
 	/* free the wlc */
 	kfree(wlc);
@@ -7323,69 +7325,6 @@ brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 	}
 }
 
-/*	Max buffering needed for beacon template/prb resp template is 142 bytes.
- *
- *	PLCP header is 6 bytes.
- *	802.11 A3 header is 24 bytes.
- *	Max beacon frame body template length is 112 bytes.
- *	Max probe resp frame body template length is 110 bytes.
- *
- *      *len on input contains the max length of the packet available.
- *
- *	The *len value is set to the number of bytes in buf used, and starts
- *	with the PLCP and included up to, but not including, the 4 byte FCS.
- */
-static void
-brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
-			 u32 bcn_rspec,
-			 struct brcms_bss_cfg *cfg, u16 *buf, int *len)
-{
-	static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
-	struct cck_phy_hdr *plcp;
-	struct ieee80211_mgmt *h;
-	int hdr_len, body_len;
-
-	hdr_len = D11_PHY_HDR_LEN + DOT11_MAC_HDR_LEN;
-
-	/* calc buffer size provided for frame body */
-	body_len = *len - hdr_len;
-	/* return actual size */
-	*len = hdr_len + body_len;
-
-	/* format PHY and MAC headers */
-	memset(buf, 0, hdr_len);
-
-	plcp = (struct cck_phy_hdr *) buf;
-
-	/*
-	 * PLCP for Probe Response frames are filled in from
-	 * core's rate table
-	 */
-	if (type == IEEE80211_STYPE_BEACON)
-		/* fill in PLCP */
-		brcms_c_compute_plcp(wlc, bcn_rspec,
-				 (DOT11_MAC_HDR_LEN + body_len + FCS_LEN),
-				 (u8 *) plcp);
-
-	/* "Regular" and 16 MBSS but not for 4 MBSS */
-	/* Update the phytxctl for the beacon based on the rspec */
-	brcms_c_beacon_phytxctl_txant_upd(wlc, bcn_rspec);
-
-	h = (struct ieee80211_mgmt *)&plcp[1];
-
-	/* fill in 802.11 header */
-	h->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | type);
-
-	/* DUR is 0 for multicast bcn, or filled in by MAC for prb resp */
-	/* A1 filled in by MAC for prb resp, broadcast for bcn */
-	if (type == IEEE80211_STYPE_BEACON)
-		memcpy(&h->da, &ether_bcast, ETH_ALEN);
-	memcpy(&h->sa, &wlc->pub->cur_etheraddr, ETH_ALEN);
-	memcpy(&h->bssid, &cfg->BSSID, ETH_ALEN);
-
-	/* SEQ filled in by MAC */
-}
-
 int brcms_c_get_header_len(void)
 {
 	return TXOFF;
@@ -7527,6 +7466,20 @@ void brcms_c_set_new_beacon(struct brcms_c_info *wlc, struct sk_buff *beacon,
 	brcms_c_update_beacon(wlc);
 }
 
+void brcms_c_set_new_probe_resp(struct brcms_c_info *wlc,
+				struct sk_buff *probe_resp)
+{
+	if (!probe_resp)
+		return;
+	if (wlc->probe_resp)
+		dev_kfree_skb_any(wlc->probe_resp);
+	wlc->probe_resp = probe_resp;
+
+	/* add PLCP */
+	skb_push(wlc->probe_resp, D11_PHY_HDR_LEN);
+	brcms_c_update_probe_resp(wlc, false);
+}
+
 /* Write ssid into shared memory */
 static void
 brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_bss_cfg *cfg)
@@ -7546,30 +7499,19 @@ brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_bss_cfg *cfg)
 static void
 brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 			      struct brcms_bss_cfg *cfg,
+			      struct sk_buff *probe_resp,
 			      bool suspend)
 {
-	u16 *prb_resp;
-	int len = BCN_TMPL_LEN;
+	int len;
 
-	prb_resp = kmalloc(BCN_TMPL_LEN, GFP_ATOMIC);
-	if (!prb_resp)
-		return;
-
-	/*
-	 * write the probe response to hardware, or save in
-	 * the config structure
-	 */
-
-	/* create the probe response template */
-	brcms_c_bcn_prb_template(wlc, IEEE80211_STYPE_PROBE_RESP, 0,
-				 cfg, prb_resp, &len);
+	len = min_t(size_t, probe_resp->len, BCN_TMPL_LEN);
 
 	if (suspend)
 		brcms_c_suspend_mac_and_wait(wlc);
 
 	/* write the probe response into the template region */
 	brcms_b_write_template_ram(wlc->hw, T_PRS_TPL_BASE,
-				    (len + 3) & ~3, prb_resp);
+				    (len + 3) & ~3, probe_resp->data);
 
 	/* write the length of the probe response frame (+PLCP/-FCS) */
 	brcms_b_write_shm(wlc->hw, M_PRB_RESP_FRM_LEN, (u16) len);
@@ -7583,13 +7525,11 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 	 * PLCP header for the call to brcms_c_mod_prb_rsp_rate_table()
 	 * by subtracting the PLCP len and adding the FCS.
 	 */
-	len += (-D11_PHY_HDR_LEN + FCS_LEN);
-	brcms_c_mod_prb_rsp_rate_table(wlc, (u16) len);
+	brcms_c_mod_prb_rsp_rate_table(wlc,
+				      (u16)len + FCS_LEN - D11_PHY_HDR_LEN);
 
 	if (suspend)
 		brcms_c_enable_mac(wlc);
-
-	kfree(prb_resp);
 }
 
 void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
@@ -7598,8 +7538,12 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 
 	/* update AP or IBSS probe responses */
 	if (wlc->pub->up && (bsscfg->type == BRCMS_TYPE_AP ||
-			     bsscfg->type == BRCMS_TYPE_ADHOC))
-		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
+			     bsscfg->type == BRCMS_TYPE_ADHOC)) {
+		if (!wlc->probe_resp)
+			return;
+		brcms_c_bss_update_probe_resp(wlc, bsscfg, wlc->probe_resp,
+					      suspend);
+	}
 }
 
 int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 82382da..b5d7a38 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -567,6 +567,7 @@ struct brcms_c_info {
 	struct sk_buff *beacon;
 	u16 beacon_tim_offset;
 	u16 beacon_dtim_period;
+	struct sk_buff *probe_resp;
 };
 
 /* antsel module specific state */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 6ed0a20..5e6db62 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -336,6 +336,8 @@ extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
 extern void brcms_c_set_new_beacon(struct brcms_c_info *wlc,
 				   struct sk_buff *beacon, u16 tim_offset,
 				   u16 dtim_period);
+extern void brcms_c_set_new_probe_resp(struct brcms_c_info *wlc,
+				       struct sk_buff *probe_resp);
 extern void brcms_c_set_ssid(struct brcms_c_info *wlc, u8 *ssid,
 			     size_t ssid_len);
 
-- 
1.7.10.4

