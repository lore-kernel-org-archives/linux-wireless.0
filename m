Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58825 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752546AbcHULRM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 07:17:12 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
        Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH 2/3 v2] wlcore: Pass win_size taken from ieee80211_sta to FW
Date: Sun, 21 Aug 2016 14:24:24 +0300
Message-ID: <20160821112425.11302-2-maxim.altshul@ti.com> (sfid-20160821_131719_586638_10ACDECA)
In-Reply-To: <20160821112425.11302-1-maxim.altshul@ti.com>
References: <20160821112425.11302-1-maxim.altshul@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When starting a new BA session, we must pass the win_size to the FW.

To do this we take max_rx_aggregation_subframes (BA RX win size)
which is stored in ieee80211_sta structure (e.g per link and not per HW)

We will use the value stored per link when passing the win_size to
firmware through the ACX_BA_SESSION_RX_SETUP command.

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
Now sending params->buf_size instead of sta->max_aggregation_subframes.
buf_size is already set in the function ampdu_action when action is IEEE80211_AMPDU_RX_START.

 drivers/net/wireless/ti/wlcore/acx.c  | 5 +++--
 drivers/net/wireless/ti/wlcore/acx.h  | 3 ++-
 drivers/net/wireless/ti/wlcore/main.c | 6 ++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 26cc23f..a485999 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -1419,7 +1419,8 @@ out:
 
 /* setup BA session receiver setting in the FW. */
 int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
-				       u16 ssn, bool enable, u8 peer_hlid)
+				       u16 ssn, bool enable, u8 peer_hlid,
+				       u8 win_size)
 {
 	struct wl1271_acx_ba_receiver_setup *acx;
 	int ret;
@@ -1435,7 +1436,7 @@ int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
 	acx->hlid = peer_hlid;
 	acx->tid = tid_index;
 	acx->enable = enable;
-	acx->win_size = wl->conf.ht.rx_ba_win_size;
+	acx->win_size =	win_size;
 	acx->ssn = ssn;
 
 	ret = wlcore_cmd_configure_failsafe(wl, ACX_BA_SESSION_RX_SETUP, acx,
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 6321ed4..f46d7fd 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -1113,7 +1113,8 @@ int wl1271_acx_set_ht_information(struct wl1271 *wl,
 int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl,
 				       struct wl12xx_vif *wlvif);
 int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
-				       u16 ssn, bool enable, u8 peer_hlid);
+				       u16 ssn, bool enable, u8 peer_hlid,
+				       u8 win_size);
 int wl12xx_acx_tsf_info(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			u64 *mactime);
 int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 9e1f2d9..8f954b4 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5286,7 +5286,9 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 		}
 
 		ret = wl12xx_acx_set_ba_receiver_session(wl, tid, *ssn, true,
-							 hlid);
+				hlid,
+				params->buf_size);
+
 		if (!ret) {
 			*ba_bitmap |= BIT(tid);
 			wl->ba_rx_session_count++;
@@ -5307,7 +5309,7 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 		}
 
 		ret = wl12xx_acx_set_ba_receiver_session(wl, tid, 0, false,
-							 hlid);
+							 hlid, 0);
 		if (!ret) {
 			*ba_bitmap &= ~BIT(tid);
 			wl->ba_rx_session_count--;
-- 
2.9.0
