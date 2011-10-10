Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53588 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab1JJINU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:20 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so8169287bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:19 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 25/29] wl12xx: replace all remaining wl->vif references
Date: Mon, 10 Oct 2011 10:13:13 +0200
Message-Id: <1318234397-21081-26-git-send-email-eliad@wizery.com> (sfid-20111010_101326_835721_51935D64)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl->vif is appropriate only when a single vif is being used.
Instead, pass wlvif as parameter or iterate through all
the vifs (e.g. when a global configuration was changed)

Leave wl->vif only to determine whether a vif was already
added (this check will be removed as well after both the
driver and fw will support multiple vifs)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c     |   15 +++--
 drivers/net/wireless/wl12xx/debugfs.c |   11 +---
 drivers/net/wireless/wl12xx/main.c    |  112 ++++++++++++++++++++-------------
 drivers/net/wireless/wl12xx/ps.c      |   11 ++-
 drivers/net/wireless/wl12xx/ps.h      |    5 +-
 drivers/net/wireless/wl12xx/tx.c      |    2 +-
 6 files changed, 91 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 4c5c518..65bf952 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -654,7 +654,8 @@ out:
 int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_start *cmd;
-	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	int ret;
 
 	wl1271_debug(DEBUG_CMD, "cmd role start ap %d", wlvif->role_id);
@@ -773,7 +774,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct wl12xx_cmd_role_start *cmd;
-	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	int ret;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -1096,10 +1097,11 @@ out:
 int wl1271_cmd_build_ps_poll(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     u16 aid)
 {
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct sk_buff *skb;
 	int ret = 0;
 
-	skb = ieee80211_pspoll_get(wl->hw, wl->vif);
+	skb = ieee80211_pspoll_get(wl->hw, vif);
 	if (!skb)
 		goto out;
 
@@ -1176,6 +1178,7 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     __be32 ip_addr)
 {
 	int ret;
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct wl12xx_arp_rsp_template tmpl;
 	struct ieee80211_hdr_3addr *hdr;
 	struct arphdr *arp_hdr;
@@ -1187,8 +1190,8 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
 					 IEEE80211_STYPE_DATA |
 					 IEEE80211_FCTL_TODS);
-	memcpy(hdr->addr1, wl->vif->bss_conf.bssid, ETH_ALEN);
-	memcpy(hdr->addr2, wl->vif->addr, ETH_ALEN);
+	memcpy(hdr->addr1, vif->bss_conf.bssid, ETH_ALEN);
+	memcpy(hdr->addr2, vif->addr, ETH_ALEN);
 	memset(hdr->addr3, 0xff, ETH_ALEN);
 
 	/* llc layer */
@@ -1204,7 +1207,7 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	arp_hdr->ar_op = cpu_to_be16(ARPOP_REPLY);
 
 	/* arp payload */
-	memcpy(tmpl.sender_hw, wl->vif->addr, ETH_ALEN);
+	memcpy(tmpl.sender_hw, vif->addr, ETH_ALEN);
 	tmpl.sender_ip = ip_addr;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_ARP_RSP,
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 4abff82..d6c2d0c 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -615,19 +615,12 @@ static ssize_t beacon_filtering_write(struct file *file,
 				      size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
-	struct ieee80211_vif *vif;
 	struct wl12xx_vif *wlvif;
 	char buf[10];
 	size_t len;
 	unsigned long value;
 	int ret;
 
-	if (!wl->vif)
-		return -EINVAL;
-
-	vif = wl->vif;
-	wlvif = wl12xx_vif_to_data(vif);
-
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
@@ -645,7 +638,9 @@ static ssize_t beacon_filtering_write(struct file *file,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, !!value);
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, !!value);
+	}
 
 	wl1271_ps_elp_sleep(wl);
 out:
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 43cd276..e9120c2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -779,7 +779,9 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	return ret;
 }
 
-static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_pkts)
+static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
+					struct wl12xx_vif *wlvif,
+					u8 hlid, u8 tx_pkts)
 {
 	bool fw_ps, single_sta;
 
@@ -791,7 +793,7 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_pkts)
 	 * packets in FW or if the STA is awake.
 	 */
 	if (!fw_ps || tx_pkts < WL1271_PS_STA_MAX_PACKETS)
-		wl1271_ps_link_end(wl, hlid);
+		wl12xx_ps_link_end(wl, wlvif, hlid);
 
 	/*
 	 * Start high-level PS if the STA is asleep with enough blocks in FW.
@@ -799,7 +801,7 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_pkts)
 	 * case FW-memory congestion is not a problem.
 	 */
 	else if (!single_sta && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
-		wl1271_ps_link_start(wl, hlid, true);
+		wl12xx_ps_link_start(wl, wlvif, hlid, true);
 }
 
 static void wl12xx_irq_update_links_status(struct wl1271 *wl,
@@ -829,15 +831,15 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 		lnk->prev_freed_pkts = status->tx_lnk_free_pkts[hlid];
 		lnk->allocated_pkts -= cnt;
 
-		wl12xx_irq_ps_regulate_link(wl, hlid, lnk->allocated_pkts);
+		wl12xx_irq_ps_regulate_link(wl, wlvif, hlid,
+					    lnk->allocated_pkts);
 	}
 }
 
 static void wl12xx_fw_status(struct wl1271 *wl,
 			     struct wl12xx_fw_status *status)
 {
-	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl12xx_vif *wlvif;
 	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
 	int avail, freed_blocks;
@@ -892,8 +894,9 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 		clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 
 	/* for AP update num of allocated TX blocks per link and ps status */
-	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
+	wl12xx_for_each_wlvif_ap(wl, wlvif) {
 		wl12xx_irq_update_links_status(wl, wlvif, status);
+	}
 
 	/* update the host-chipset time offset */
 	getnstimeofday(&ts);
@@ -1212,6 +1215,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	struct wl1271 *wl =
 		container_of(work, struct wl1271, recovery_work);
 	struct wl12xx_vif *wlvif;
+	struct ieee80211_vif *vif;
 
 	mutex_lock(&wl->mutex);
 
@@ -1249,7 +1253,12 @@ static void wl1271_recovery_work(struct work_struct *work)
 	}
 
 	/* reboot the chipset */
-	__wl1271_op_remove_interface(wl, wl->vif, false);
+	while (!list_empty(&wl->wlvif_list)) {
+		wlvif = list_first_entry(&wl->wlvif_list,
+				       struct wl12xx_vif, list);
+		vif = wl12xx_wlvif_to_vif(wlvif);
+		__wl1271_op_remove_interface(wl, vif, false);
+	}
 
 	clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
 
@@ -1721,18 +1730,19 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 			    struct cfg80211_wowlan *wow)
 {
 	struct wl1271 *wl = hw->priv;
-	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl12xx_vif *wlvif;
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
 	WARN_ON(!wow || !wow->any);
 
 	wl->wow_enabled = true;
-	ret = wl1271_configure_suspend(wl, wlvif);
-	if (ret < 0) {
-		wl1271_warning("couldn't prepare device to suspend");
-		return ret;
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		ret = wl1271_configure_suspend(wl, wlvif);
+		if (ret < 0) {
+			wl1271_warning("couldn't prepare device to suspend");
+			return ret;
+		}
 	}
 	/* flush any remaining work */
 	wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
@@ -1751,7 +1761,9 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 
 	wl1271_enable_interrupts(wl);
 	flush_work(&wl->tx_work);
-	flush_delayed_work(&wlvif->pspoll_work);
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		flush_delayed_work(&wlvif->pspoll_work);
+	}
 	flush_delayed_work(&wl->elp_work);
 
 	return 0;
@@ -1760,8 +1772,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 static int wl1271_op_resume(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
-	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl12xx_vif *wlvif;
 	unsigned long flags;
 	bool run_irq_work = false;
 
@@ -1785,7 +1796,9 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 		wl1271_irq(0, wl);
 		wl1271_enable_interrupts(wl);
 	}
-	wl1271_configure_resume(wl, wlvif);
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		wl1271_configure_resume(wl, wlvif);
+	}
 	wl->wow_enabled = false;
 
 	return 0;
@@ -2232,6 +2245,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl12xx_vif *iter;
 
 	mutex_lock(&wl->mutex);
 
@@ -2243,10 +2257,14 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	 * wl->vif can be null here if someone shuts down the interface
 	 * just when hardware recovery has been started.
 	 */
-	if (wl->vif) {
-		WARN_ON(wl->vif != vif);
+	wl12xx_for_each_wlvif(wl, iter) {
+		if (iter != wlvif)
+			continue;
+
 		__wl1271_op_remove_interface(wl, vif, true);
+		break;
 	}
+	WARN_ON(iter != wlvif);
 out:
 	mutex_unlock(&wl->mutex);
 	cancel_work_sync(&wl->recovery_work);
@@ -2316,8 +2334,10 @@ static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	int ret;
 
 	if (test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags)) {
+		struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+
 		wl12xx_cmd_stop_channel_switch(wl);
-		ieee80211_chswitch_done(wl->vif, false);
+		ieee80211_chswitch_done(vif, false);
 	}
 
 	/* to stop listening to a channel, we disconnect */
@@ -2632,8 +2652,7 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 {
 	struct wl1271_filter_params *fp = (void *)(unsigned long)multicast;
 	struct wl1271 *wl = hw->priv;
-	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl12xx_vif *wlvif;
 
 	int ret;
 
@@ -2652,17 +2671,20 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
-		if (*total & FIF_ALLMULTI)
-			ret = wl1271_acx_group_address_tbl(wl, wlvif, false,
-							   NULL, 0);
-		else if (fp)
-			ret = wl1271_acx_group_address_tbl(wl, wlvif,
-							   fp->enabled,
-							   fp->mc_list,
-							   fp->mc_list_length);
-		if (ret < 0)
-			goto out_sleep;
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
+			if (*total & FIF_ALLMULTI)
+				ret = wl1271_acx_group_address_tbl(wl, wlvif,
+								   false,
+								   NULL, 0);
+			else if (fp)
+				ret = wl1271_acx_group_address_tbl(wl, wlvif,
+							fp->enabled,
+							fp->mc_list,
+							fp->mc_list_length);
+			if (ret < 0)
+				goto out_sleep;
+		}
 	}
 
 	/*
@@ -3152,8 +3174,7 @@ out:
 static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	struct wl1271 *wl = hw->priv;
-	struct ieee80211_vif *vif = wl->vif;
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl12xx_vif *wlvif;
 	int ret = 0;
 
 	mutex_lock(&wl->mutex);
@@ -3167,10 +3188,11 @@ static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_rts_threshold(wl, wlvif, value);
-	if (ret < 0)
-		wl1271_warning("wl1271_op_set_rts_threshold failed: %d", ret);
-
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		ret = wl1271_acx_rts_threshold(wl, wlvif, value);
+		if (ret < 0)
+			wl1271_warning("set rts threshold failed: %d", ret);
+	}
 	wl1271_ps_elp_sleep(wl);
 
 out:
@@ -3659,7 +3681,7 @@ sta_not_found:
 			wlvif->probereq = NULL;
 
 			/* re-enable dynamic ps - just in case */
-			ieee80211_enable_dyn_ps(wl->vif);
+			ieee80211_enable_dyn_ps(vif);
 
 			/* revert back to minimum rates for the current band */
 			wl1271_set_band_rate(wl, wlvif);
@@ -4295,9 +4317,11 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF)) {
-		mutex_unlock(&wl->mutex);
-		ieee80211_chswitch_done(wl->vif, false);
-		return;
+		wl12xx_for_each_wlvif_sta(wl, wlvif) {
+			struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+			ieee80211_chswitch_done(vif, false);
+		}
+		goto out;
 	}
 
 	ret = wl1271_ps_elp_wakeup(wl);
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 8153408..84a1afa 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -232,9 +232,11 @@ static void wl1271_ps_filter_frames(struct wl1271 *wl, u8 hlid)
 	wl1271_handle_tx_low_watermark(wl);
 }
 
-void wl1271_ps_link_start(struct wl1271 *wl, u8 hlid, bool clean_queues)
+void wl12xx_ps_link_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			  u8 hlid, bool clean_queues)
 {
 	struct ieee80211_sta *sta;
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 
 	if (test_bit(hlid, &wl->ap_ps_map))
 		return;
@@ -244,7 +246,7 @@ void wl1271_ps_link_start(struct wl1271 *wl, u8 hlid, bool clean_queues)
 		     clean_queues);
 
 	rcu_read_lock();
-	sta = ieee80211_find_sta(wl->vif, wl->links[hlid].addr);
+	sta = ieee80211_find_sta(vif, wl->links[hlid].addr);
 	if (!sta) {
 		wl1271_error("could not find sta %pM for starting ps",
 			     wl->links[hlid].addr);
@@ -262,9 +264,10 @@ void wl1271_ps_link_start(struct wl1271 *wl, u8 hlid, bool clean_queues)
 	__set_bit(hlid, &wl->ap_ps_map);
 }
 
-void wl1271_ps_link_end(struct wl1271 *wl, u8 hlid)
+void wl12xx_ps_link_end(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 {
 	struct ieee80211_sta *sta;
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 
 	if (!test_bit(hlid, &wl->ap_ps_map))
 		return;
@@ -274,7 +277,7 @@ void wl1271_ps_link_end(struct wl1271 *wl, u8 hlid)
 	__clear_bit(hlid, &wl->ap_ps_map);
 
 	rcu_read_lock();
-	sta = ieee80211_find_sta(wl->vif, wl->links[hlid].addr);
+	sta = ieee80211_find_sta(vif, wl->links[hlid].addr);
 	if (!sta) {
 		wl1271_error("could not find sta %pM for ending ps",
 			     wl->links[hlid].addr);
diff --git a/drivers/net/wireless/wl12xx/ps.h b/drivers/net/wireless/wl12xx/ps.h
index 6ad0a0b..a12052f 100644
--- a/drivers/net/wireless/wl12xx/ps.h
+++ b/drivers/net/wireless/wl12xx/ps.h
@@ -32,8 +32,9 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 void wl1271_ps_elp_sleep(struct wl1271 *wl);
 int wl1271_ps_elp_wakeup(struct wl1271 *wl);
 void wl1271_elp_work(struct work_struct *work);
-void wl1271_ps_link_start(struct wl1271 *wl, u8 hlid, bool clean_queues);
-void wl1271_ps_link_end(struct wl1271 *wl, u8 hlid);
+void wl12xx_ps_link_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			  u8 hlid, bool clean_queues);
+void wl12xx_ps_link_end(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
 
 #define WL1271_PS_COMPLETE_TIMEOUT 500
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index be06abf..a0eefe7 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -146,7 +146,7 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl,
 	 * case FW-memory congestion is not a problem.
 	 */
 	if (!single_sta && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
-		wl1271_ps_link_start(wl, hlid, true);
+		wl12xx_ps_link_start(wl, wlvif, hlid, true);
 }
 
 bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb)
-- 
1.7.6.401.g6a319

