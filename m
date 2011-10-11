Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44677 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1JKJzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 05:55:01 -0400
Received: by wwf22 with SMTP id 22so10274602wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 02:55:00 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: couple role_start_dev with roc
Date: Tue, 11 Oct 2011 11:55:44 +0200
Message-Id: <1318326944-14072-1-git-send-email-eliad@wizery.com> (sfid-20111011_115507_095626_6CA3D8D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Device role is always started along with ROC.
Couple them together by introducing new wl12xx_start_dev
and wl12xx_stop_dev functions.

By using these functions, we solve a bug that occured during
channel switch - we started the dev role on one channel, and
ROCed on a different one.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c  |   53 ++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/cmd.h  |    4 +-
 drivers/net/wireless/wl12xx/main.c |   40 +++++++--------------------
 drivers/net/wireless/wl12xx/scan.c |    3 +-
 drivers/net/wireless/wl12xx/tx.c   |    6 +---
 5 files changed, 65 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 65bf952..8ea295e 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -467,7 +467,8 @@ static int wl12xx_get_new_session_id(struct wl1271 *wl,
 	return wlvif->session_counter;
 }
 
-int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
+				     struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_start *cmd;
 	int ret;
@@ -515,7 +516,8 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_role_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+static int wl12xx_cmd_role_stop_dev(struct wl1271 *wl,
+				    struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_stop *cmd;
 	int ret;
@@ -1775,3 +1777,50 @@ out_free:
 out:
 	return ret;
 }
+
+/* start dev role and roc on its channel */
+int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	int ret;
+
+	if (WARN_ON(!(wlvif->bss_type == BSS_TYPE_STA_BSS ||
+		      wlvif->bss_type == BSS_TYPE_IBSS)))
+		return -EINVAL;
+
+	ret = wl12xx_cmd_role_start_dev(wl, wlvif);
+	if (ret < 0)
+		goto out;
+
+	ret = wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
+	if (ret < 0)
+		goto out_stop;
+
+	return 0;
+
+out_stop:
+	wl12xx_cmd_role_stop_dev(wl, wlvif);
+out:
+	return ret;
+}
+
+/* croc dev hlid, and stop the role */
+int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	int ret;
+
+	if (WARN_ON(!(wlvif->bss_type == BSS_TYPE_STA_BSS ||
+		      wlvif->bss_type == BSS_TYPE_IBSS)))
+		return -EINVAL;
+
+	if (test_bit(wlvif->dev_role_id, wl->roc_map)) {
+		ret = wl12xx_croc(wl, wlvif->dev_role_id);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = wl12xx_cmd_role_stop_dev(wl, wlvif);
+	if (ret < 0)
+		goto out;
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 968d5bd..3f7d0b9 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -39,13 +39,13 @@ int wl1271_cmd_ext_radio_parms(struct wl1271 *wl);
 int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 *addr, u8 role_type,
 			   u8 *role_id);
 int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
-int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-int wl12xx_cmd_role_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_stop_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f29d18d..2037208 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2441,11 +2441,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (idle) {
 		/* no need to croc if we weren't busy (e.g. during boot) */
 		if (wl12xx_is_roc(wl)) {
-			ret = wl12xx_croc(wl, wlvif->dev_role_id);
-			if (ret < 0)
-				goto out;
-
-			ret = wl12xx_cmd_role_stop_dev(wl, wlvif);
+			ret = wl12xx_stop_dev(wl, wlvif);
 			if (ret < 0)
 				goto out;
 		}
@@ -2467,11 +2463,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			ieee80211_sched_scan_stopped(wl->hw);
 		}
 
-		ret = wl12xx_cmd_role_start_dev(wl, wlvif);
-		if (ret < 0)
-			goto out;
-
-		ret = wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
+		ret = wl12xx_start_dev(wl, wlvif);
 		if (ret < 0)
 			goto out;
 		clear_bit(WL1271_FLAG_IDLE, &wl->flags);
@@ -2537,16 +2529,13 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				 */
 				if (wl12xx_is_roc(wl) &&
 				    !(conf->flags & IEEE80211_CONF_IDLE)) {
-					ret = wl12xx_croc(wl,
-							  wlvif->dev_role_id);
+					ret = wl12xx_stop_dev(wl, wlvif);
 					if (ret < 0)
 						return ret;
 
-					ret = wl12xx_roc(wl, wlvif,
-							 wlvif->dev_role_id);
+					ret = wl12xx_start_dev(wl, wlvif);
 					if (ret < 0)
-						wl1271_warning("roc failed %d",
-							       ret);
+						return ret;
 				}
 			}
 		}
@@ -3099,8 +3088,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 			ret = -EBUSY;
 			goto out_sleep;
 		}
-		wl12xx_croc(wl, wlvif->dev_role_id);
-		wl12xx_cmd_role_stop_dev(wl, wlvif);
+		wl12xx_stop_dev(wl, wlvif);
 	}
 
 	ret = wl1271_scan(hw->priv, vif, ssid, len, req);
@@ -3611,8 +3599,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			if (test_and_clear_bit(WLVIF_FLAG_IBSS_JOINED,
 					       &wlvif->flags)) {
 				wl1271_unjoin(wl, wlvif);
-				wl12xx_cmd_role_start_dev(wl, wlvif);
-				wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
+				wl12xx_start_dev(wl, wlvif);
 			}
 		}
 	}
@@ -3788,11 +3775,8 @@ sta_not_found:
 				}
 
 				wl1271_unjoin(wl, wlvif);
-				if (!(conf_flags & IEEE80211_CONF_IDLE)) {
-					wl12xx_cmd_role_start_dev(wl, wlvif);
-					wl12xx_roc(wl, wlvif,
-						   wlvif->dev_role_id);
-				}
+				if (!(conf_flags & IEEE80211_CONF_IDLE))
+					wl12xx_start_dev(wl, wlvif);
 			}
 		}
 	}
@@ -3871,11 +3855,7 @@ sta_not_found:
 		 * STA role). TODO: make it better.
 		 */
 		if (wlvif->dev_role_id != WL12XX_INVALID_ROLE_ID) {
-			ret = wl12xx_croc(wl, wlvif->dev_role_id);
-			if (ret < 0)
-				goto out;
-
-			ret = wl12xx_cmd_role_stop_dev(wl, wlvif);
+			ret = wl12xx_stop_dev(wl, wlvif);
 			if (ret < 0)
 				goto out;
 		}
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 2711438..96d804f 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -76,8 +76,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	     (is_ibss && !test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags))) &&
 	    !test_bit(wlvif->dev_role_id, wl->roc_map)) {
 		/* restore remain on channel */
-		wl12xx_cmd_role_start_dev(wl, wlvif);
-		wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
+		wl12xx_start_dev(wl, wlvif);
 	}
 	wl1271_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 05968c6..02d606f 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -98,11 +98,7 @@ static int wl1271_tx_update_filters(struct wl1271 *wl,
 		goto out;
 
 	wl1271_debug(DEBUG_CMD, "starting device role for roaming");
-	ret = wl12xx_cmd_role_start_dev(wl, wlvif);
-	if (ret < 0)
-		goto out;
-
-	ret = wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
+	ret = wl12xx_start_dev(wl, wlvif);
 	if (ret < 0)
 		goto out;
 out:
-- 
1.7.6.401.g6a319

