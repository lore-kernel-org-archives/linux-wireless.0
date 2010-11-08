Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63163 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab0KHJvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 04:51:20 -0500
Received: by mail-fx0-f46.google.com with SMTP id 16so3835093fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 01:51:19 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 2/2] wl1271: add support for HW TX fragmentation
Date: Mon,  8 Nov 2010 11:51:07 +0200
Message-Id: <1289209867-21422-3-git-send-email-arik@wizery.com>
In-Reply-To: <1289209867-21422-1-git-send-email-arik@wizery.com>
References: <1289209867-21422-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indicate to mac80211 we support HW fragmentation.
Support updates of the fragmentation threshold via the
set_frag_threshold callback.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |    4 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   31 ++++++++++++++++++++++++++++-
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index bd7f95f..bbaf066 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -862,7 +862,7 @@ out:
 	return ret;
 }
 
-int wl1271_acx_frag_threshold(struct wl1271 *wl)
+int wl1271_acx_frag_threshold(struct wl1271 *wl, u16 frag_threshold)
 {
 	struct acx_frag_threshold *acx;
 	int ret = 0;
@@ -876,7 +876,7 @@ int wl1271_acx_frag_threshold(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->frag_threshold = cpu_to_le16(wl->conf.tx.frag_threshold);
+	acx->frag_threshold = cpu_to_le16(frag_threshold);
 	ret = wl1271_cmd_configure(wl, ACX_FRAG_CFG, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of frag threshold failed: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index b7c4908..5963dea 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1161,7 +1161,7 @@ int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
 int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
 		       u8 tsid, u8 ps_scheme, u8 ack_policy,
 		       u32 apsd_conf0, u32 apsd_conf1);
-int wl1271_acx_frag_threshold(struct wl1271 *wl);
+int wl1271_acx_frag_threshold(struct wl1271 *wl, u16 frag_threshold);
 int wl1271_acx_tx_config_options(struct wl1271 *wl);
 int wl1271_acx_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_init_mem_config(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 8044bba..3ba7acd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -290,7 +290,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Default fragmentation threshold */
-	ret = wl1271_acx_frag_threshold(wl);
+	ret = wl1271_acx_frag_threshold(wl, wl->conf.tx.frag_threshold);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index f5b1d19..a1f2786 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -404,7 +404,7 @@ static int wl1271_plt_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Default fragmentation threshold */
-	ret = wl1271_acx_frag_threshold(wl);
+	ret = wl1271_acx_frag_threshold(wl, wl->conf.tx.frag_threshold);
 	if (ret < 0)
 		goto out_free_memmap;
 
@@ -1724,6 +1724,34 @@ out:
 	return ret;
 }
 
+static int wl1271_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret = 0;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_acx_frag_threshold(wl, (u16)value);
+	if (ret < 0)
+		wl1271_warning("wl1271_op_set_frag_threshold failed: %d", ret);
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
 static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	struct wl1271 *wl = hw->priv;
@@ -2406,6 +2434,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.set_key = wl1271_op_set_key,
 	.hw_scan = wl1271_op_hw_scan,
 	.bss_info_changed = wl1271_op_bss_info_changed,
+	.set_frag_threshold = wl1271_op_set_frag_threshold,
 	.set_rts_threshold = wl1271_op_set_rts_threshold,
 	.conf_tx = wl1271_op_conf_tx,
 	.get_tsf = wl1271_op_get_tsf,
-- 
1.7.1

