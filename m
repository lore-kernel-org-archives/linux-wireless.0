Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40188 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab2B2RTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:19:08 -0500
Subject: [PATCH 04/12] ath6kl: logical continuations should be on the previous
	line
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:19:04 +0200
Message-ID: <20120229171904.24264.37392.stgit@localhost6.localdomain6> (sfid-20120229_181912_885696_23994DEC)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All found by checkpatch:

ath6kl/wmi.c:1036: CHECK: Logical continuations should be on the previous line

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   10 +++++-----
 drivers/net/wireless/ath/ath6kl/htc.c      |    8 ++++----
 drivers/net/wireless/ath/ath6kl/main.c     |    4 ++--
 drivers/net/wireless/ath/ath6kl/wmi.c      |    9 +++++----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 308cc9b..c69de7b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -599,8 +599,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if ((!(ar->connect_ctrl_flags & CONNECT_DO_WPA_OFFLOAD)) &&
-	    ((vif->auth_mode == WPA_PSK_AUTH)
-	     || (vif->auth_mode == WPA2_PSK_AUTH))) {
+	    ((vif->auth_mode == WPA_PSK_AUTH) ||
+	     (vif->auth_mode == WPA2_PSK_AUTH))) {
 		mod_timer(&vif->disconnect_timer,
 			  jiffies + msecs_to_jiffies(DISCON_TIMER_INTVAL));
 	}
@@ -1058,9 +1058,9 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		return -ENOTSUPP;
 	}
 
-	if (((vif->auth_mode == WPA_PSK_AUTH)
-	     || (vif->auth_mode == WPA2_PSK_AUTH))
-	    && (key_usage & GROUP_USAGE))
+	if (((vif->auth_mode == WPA_PSK_AUTH) ||
+	     (vif->auth_mode == WPA2_PSK_AUTH)) &&
+	    (key_usage & GROUP_USAGE))
 		del_timer(&vif->disconnect_timer);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 0204b83..24cfc3b 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1672,8 +1672,8 @@ static int htc_parse_trailer(struct htc_target *target,
 		}
 
 		lk_ahd = (struct htc_lookahead_report *) record_buf;
-		if ((lk_ahd->pre_valid == ((~lk_ahd->post_valid) & 0xFF))
-		    && next_lk_ahds) {
+		if ((lk_ahd->pre_valid == ((~lk_ahd->post_valid) & 0xFF)) &&
+		    next_lk_ahds) {
 
 			ath6kl_dbg(ATH6KL_DBG_HTC,
 				   "htc rx lk_ahd found pre_valid 0x%x post_valid 0x%x\n",
@@ -2449,8 +2449,8 @@ int ath6kl_htc_conn_service(struct htc_target *target,
 
 		resp_msg = (struct htc_conn_service_resp *)rx_pkt->buf;
 
-		if ((le16_to_cpu(resp_msg->msg_id) != HTC_MSG_CONN_SVC_RESP_ID)
-		    || (rx_pkt->act_len < sizeof(*resp_msg))) {
+		if ((le16_to_cpu(resp_msg->msg_id) != HTC_MSG_CONN_SVC_RESP_ID) ||
+		    (rx_pkt->act_len < sizeof(*resp_msg))) {
 			status = -ENOMEM;
 			goto fail_tx;
 		}
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 18b4e16..16f7de2 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -972,8 +972,8 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 		set_bit(CONNECT_PEND, &vif->flags);
 		if (((reason == ASSOC_FAILED) &&
 		     (prot_reason_status == 0x11)) ||
-		    ((reason == ASSOC_FAILED) && (prot_reason_status == 0x0)
-		     && (vif->reconnect_flag == 1))) {
+		    ((reason == ASSOC_FAILED) && (prot_reason_status == 0x0) &&
+		     (vif->reconnect_flag == 1))) {
 			set_bit(CONNECTED, &vif->flags);
 			return;
 		}
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 1269f6a..60a11b2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -826,8 +826,8 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
 			if (pie[1] > 3 && pie[2] == 0x00 && pie[3] == 0x50 &&
 			    pie[4] == 0xf2 && pie[5] == WMM_OUI_TYPE) {
 				/* WMM OUT (00:50:F2) */
-				if (pie[1] > 5
-				    && pie[6] == WMM_PARAM_OUI_SUBTYPE)
+				if (pie[1] > 5 &&
+				    pie[6] == WMM_PARAM_OUI_SUBTYPE)
 					wmi->is_wmm_enabled = true;
 			}
 			break;
@@ -1032,8 +1032,9 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
 	if (len < 8 + 2 + 2)
 		return -EINVAL;
 
-	if (bih->frame_type == BEACON_FTYPE && test_bit(CONNECTED, &vif->flags)
-	    && memcmp(bih->bssid, vif->bssid, ETH_ALEN) == 0) {
+	if (bih->frame_type == BEACON_FTYPE &&
+	    test_bit(CONNECTED, &vif->flags) &&
+	    memcmp(bih->bssid, vif->bssid, ETH_ALEN) == 0) {
 		const u8 *tim;
 		tim = cfg80211_find_ie(WLAN_EID_TIM, buf + 8 + 2 + 2,
 				       len - 8 - 2 - 2);

