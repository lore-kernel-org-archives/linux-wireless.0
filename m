Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36165 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbICIoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 04:44:30 -0400
Received: by lbcao8 with SMTP id ao8so20159001lbc.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2015 01:44:29 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: handle IEEE80211_CHANCTX_CHANGE_WIDTH properly
Date: Thu,  3 Sep 2015 10:44:52 +0200
Message-Id: <1441269892-438-2-git-send-email-michal.kazior@tieto.com> (sfid-20150903_104436_530911_931BE0B2)
In-Reply-To: <1441269892-438-1-git-send-email-michal.kazior@tieto.com>
References: <1441269892-438-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vdevs associated with a given chanctx should be
restarted if the bandwidth changes. Otherwise
traffic may cease.

This is known to fix STA CSA with bandwidths wider
than 20MHz.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 64 +++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 13e9d5659e96..34aff8683943 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6352,12 +6352,52 @@ ath10k_mac_op_remove_chanctx(struct ieee80211_hw *hw,
 	mutex_unlock(&ar->conf_mutex);
 }
 
+struct ath10k_mac_change_chanctx_arg {
+	struct ieee80211_chanctx_conf *ctx;
+	struct ieee80211_vif_chanctx_switch *vifs;
+	int n_vifs;
+	int next_vif;
+};
+
+static void
+ath10k_mac_change_chanctx_cnt_iter(void *data, u8 *mac,
+				   struct ieee80211_vif *vif)
+{
+	struct ath10k_mac_change_chanctx_arg *arg = data;
+
+	if (rcu_access_pointer(vif->chanctx_conf) != arg->ctx)
+		return;
+
+	arg->n_vifs++;
+}
+
+static void
+ath10k_mac_change_chanctx_fill_iter(void *data, u8 *mac,
+				    struct ieee80211_vif *vif)
+{
+	struct ath10k_mac_change_chanctx_arg *arg = data;
+	struct ieee80211_chanctx_conf *ctx;
+
+	ctx = rcu_access_pointer(vif->chanctx_conf);
+	if (ctx != arg->ctx)
+		return;
+
+	if (WARN_ON(arg->next_vif == arg->n_vifs))
+		return;
+
+	arg->vifs[arg->next_vif].vif = vif;
+	arg->vifs[arg->next_vif].old_ctx = ctx;
+	arg->vifs[arg->next_vif].new_ctx = ctx;
+	arg->next_vif++;
+}
+
 static void
 ath10k_mac_op_change_chanctx(struct ieee80211_hw *hw,
 			     struct ieee80211_chanctx_conf *ctx,
 			     u32 changed)
 {
 	struct ath10k *ar = hw->priv;
+	struct ath10k_mac_change_chanctx_arg arg = { .ctx = ctx };
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -6371,6 +6411,30 @@ ath10k_mac_op_change_chanctx(struct ieee80211_hw *hw,
 	if (WARN_ON(changed & IEEE80211_CHANCTX_CHANGE_CHANNEL))
 		goto unlock;
 
+	if (changed & IEEE80211_CHANCTX_CHANGE_WIDTH) {
+		ieee80211_iterate_active_interfaces_atomic(
+					hw,
+					IEEE80211_IFACE_ITER_NORMAL,
+					ath10k_mac_change_chanctx_cnt_iter,
+					&arg);
+		if (arg.n_vifs == 0)
+			goto radar;
+
+		arg.vifs = kcalloc(arg.n_vifs, sizeof(arg.vifs[0]),
+				   GFP_KERNEL);
+		if (!arg.vifs)
+			goto radar;
+
+		ieee80211_iterate_active_interfaces_atomic(
+					hw,
+					IEEE80211_IFACE_ITER_NORMAL,
+					ath10k_mac_change_chanctx_fill_iter,
+					&arg);
+		ath10k_mac_update_vif_chan(ar, arg.vifs, arg.n_vifs);
+		kfree(arg.vifs);
+	}
+
+radar:
 	ath10k_recalc_radar_detection(ar);
 
 	/* FIXME: How to configure Rx chains properly? */
-- 
2.1.4

