Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36268 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2K1Jm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:42:59 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4384742wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:42:58 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/20] wlcore: add ACX_PEER_CAP command
Date: Wed, 28 Nov 2012 11:42:31 +0200
Message-Id: <1354095769-8724-3-git-send-email-arik@wizery.com> (sfid-20121128_104308_148509_598397B3)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

ACX_PEER_CAP command is just ACX_PEER_HT_CAP, but allows
configuring the peer's support rates as well.

this is needed because we start the station role when
the remote rates are not known yet.

the two commands should be unified in future fw versions,
but for now add a new set_peer_cap per-hw op, that will
use ACX_PEER_CAP for 18xx, and ACX_PEER_HT_CAP for 12xx.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   10 ++++++
 drivers/net/wireless/ti/wl18xx/acx.c    |   54 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h    |   33 +++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c   |    9 ++++++
 drivers/net/wireless/ti/wlcore/acx.c    |    2 ++
 drivers/net/wireless/ti/wlcore/cmd.c    |    7 ++--
 drivers/net/wireless/ti/wlcore/hw_ops.h |   13 ++++++++
 drivers/net/wireless/ti/wlcore/main.c   |    9 +++---
 drivers/net/wireless/ti/wlcore/wlcore.h |    5 +++
 9 files changed, 134 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 0218edd..951b88c 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1623,6 +1623,15 @@ static int wl12xx_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 	return wlcore_set_key(wl, cmd, vif, sta, key_conf);
 }
 
+static int wl12xx_set_peer_cap(struct wl1271 *wl,
+			       struct ieee80211_sta_ht_cap *ht_cap,
+			       bool allow_ht_operation,
+			       u32 rate_set, u8 hlid)
+{
+	return wl1271_acx_set_ht_capabilities(wl, ht_cap, allow_ht_operation,
+					      hlid);
+}
+
 static int wl12xx_setup(struct wl1271 *wl);
 
 static struct wlcore_ops wl12xx_ops = {
@@ -1659,6 +1668,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.set_key		= wl12xx_set_key,
 	.channel_switch		= wl12xx_cmd_channel_switch,
 	.pre_pkt_send		= NULL,
+	.set_peer_cap		= wl12xx_set_peer_cap,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index 801d8af..a169bb5 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -140,3 +140,57 @@ out:
 	return ret;
 
 }
+
+/*
+ * this command is basically the same as wl1271_acx_ht_capabilities,
+ * with the addition of supported rates. they should be unified in
+ * the next fw api change
+ */
+int wl18xx_acx_set_peer_cap(struct wl1271 *wl,
+			    struct ieee80211_sta_ht_cap *ht_cap,
+			    bool allow_ht_operation,
+			    u32 rate_set, u8 hlid)
+{
+	struct wlcore_acx_peer_cap *acx;
+	int ret = 0;
+	u32 ht_capabilites = 0;
+
+	wl1271_debug(DEBUG_ACX,
+		     "acx set cap ht_supp: %d ht_cap: %d rates: 0x%x",
+		     ht_cap->ht_supported, ht_cap->cap, rate_set);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (allow_ht_operation && ht_cap->ht_supported) {
+		/* no need to translate capabilities - use the spec values */
+		ht_capabilites = ht_cap->cap;
+
+		/*
+		 * this bit is not employed by the spec but only by FW to
+		 * indicate peer HT support
+		 */
+		ht_capabilites |= WL12XX_HT_CAP_HT_OPERATION;
+
+		/* get data from A-MPDU parameters field */
+		acx->ampdu_max_length = ht_cap->ampdu_factor;
+		acx->ampdu_min_spacing = ht_cap->ampdu_density;
+	}
+
+	acx->hlid = hlid;
+	acx->ht_capabilites = cpu_to_le32(ht_capabilites);
+	acx->supported_rates = cpu_to_le32(rate_set);
+
+	ret = wl1271_cmd_configure(wl, ACX_PEER_CAP, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx ht capabilities setting failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index b57e348..0e636de 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -297,11 +297,44 @@ struct wlcore_peer_ht_operation_mode {
 	u8 padding[2];
 };
 
+/*
+ * ACX_PEER_CAP
+ * this struct is very similar to wl1271_acx_ht_capabilities, with the
+ * addition of supported rates
+ */
+struct wlcore_acx_peer_cap {
+	struct acx_header header;
+
+	/* bitmask of capability bits supported by the peer */
+	__le32 ht_capabilites;
+
+	/* rates supported by the remote peer */
+	__le32 supported_rates;
+
+	/* Indicates to which link these capabilities apply. */
+	u8 hlid;
+
+	/*
+	 * This the maximum A-MPDU length supported by the AP. The FW may not
+	 * exceed this length when sending A-MPDUs
+	 */
+	u8 ampdu_max_length;
+
+	/* This is the minimal spacing required when sending A-MPDUs to the AP*/
+	u8 ampdu_min_spacing;
+
+	u8 padding;
+} __packed;
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
 int wl18xx_acx_set_checksum_state(struct wl1271 *wl);
 int wl18xx_acx_clear_statistics(struct wl1271 *wl);
 int wl18xx_acx_peer_ht_operation_mode(struct wl1271 *wl, u8 hlid, bool wide);
+int wl18xx_acx_set_peer_cap(struct wl1271 *wl,
+			    struct ieee80211_sta_ht_cap *ht_cap,
+			    bool allow_ht_operation,
+			    u32 rate_set, u8 hlid);
 
 #endif /* __WL18XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 3f9504c..df8de71 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1414,6 +1414,14 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
+static int wl18xx_set_peer_cap(struct wl1271 *wl,
+			       struct ieee80211_sta_ht_cap *ht_cap,
+			       bool allow_ht_operation,
+			       u32 rate_set, u8 hlid)
+{
+	return wl18xx_acx_set_peer_cap(wl, ht_cap, allow_ht_operation,
+				       rate_set, hlid);
+}
 
 static int wl18xx_setup(struct wl1271 *wl);
 
@@ -1451,6 +1459,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.channel_switch	= wl18xx_cmd_channel_switch,
 	.pre_pkt_send	= wl18xx_pre_pkt_send,
 	.sta_rc_update	= wl18xx_sta_rc_update,
+	.set_peer_cap	= wl18xx_set_peer_cap,
 };
 
 /* HT cap appropriate for wide channels in 2Ghz */
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 9c32f0c..c796543 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -1340,6 +1340,8 @@ out:
 	kfree(acx);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl1271_acx_set_ht_capabilities);
+
 
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 56432c8..1fbee0d 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -506,11 +506,10 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->sta.hlid = wlvif->sta.hlid;
 	cmd->sta.session = wl->session_ids[wlvif->sta.hlid];
 	/*
-	 * We don't have the correct remote rates in this stage, and there
-	 * is no way to update them later, so use our supported rates instead.
-	 * The fw will take the configured rate policies into account anyway.
+	 * We don't have the correct remote rates in this stage. the rates
+	 * will be reconfigured later, after authorization.
 	 */
-	cmd->sta.remote_rates = cpu_to_le32(supported_rates);
+	cmd->sta.remote_rates = cpu_to_le32(wlvif->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 0e0b656..4db03e1 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -209,4 +209,17 @@ wlcore_hw_sta_rc_update(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		wl->ops->sta_rc_update(wl, wlvif, sta, changed);
 }
 
+static inline int
+wlcore_hw_set_peer_cap(struct wl1271 *wl,
+		       struct ieee80211_sta_ht_cap *ht_cap,
+		       bool allow_ht_operation,
+		       u32 rate_set, u8 hlid)
+{
+	if (wl->ops->set_peer_cap)
+		return wl->ops->set_peer_cap(wl, ht_cap, allow_ht_operation,
+					     rate_set, hlid);
+
+	return 0;
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3834e9d..4ef7ea7 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4147,10 +4147,11 @@ sta_not_found:
 		bool enabled =
 			bss_conf->channel_type != NL80211_CHAN_NO_HT;
 
-		ret = wl1271_acx_set_ht_capabilities(wl,
-						     &sta_ht_cap,
-						     enabled,
-						     wlvif->sta.hlid);
+		ret = wlcore_hw_set_peer_cap(wl,
+					     &sta_ht_cap,
+					     enabled,
+					     wlvif->rate_set,
+					     wlvif->sta.hlid);
 		if (ret < 0) {
 			wl1271_warning("Set ht cap failed %d", ret);
 			goto out;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 71137aa..ecdd5e6 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -106,6 +106,11 @@ struct wlcore_ops {
 	u32 (*pre_pkt_send)(struct wl1271 *wl, u32 buf_offset, u32 last_len);
 	void (*sta_rc_update)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			      struct ieee80211_sta *sta, u32 changed);
+	int (*set_peer_cap)(struct wl1271 *wl,
+			    struct ieee80211_sta_ht_cap *ht_cap,
+			    bool allow_ht_operation,
+			    u32 rate_set, u8 hlid);
+
 };
 
 enum wlcore_partitions {
-- 
1.7.9.5

