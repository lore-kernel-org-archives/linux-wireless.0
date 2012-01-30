Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35943 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2A3L5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:57:44 -0500
Received: by werb13 with SMTP id b13so3350590wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 03:57:43 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/12] wl12xx: fw api change - add role_id to tsf_info
Date: Mon, 30 Jan 2012 14:00:49 +0200
Message-Id: <1327924857-1250-5-git-send-email-eliad@wizery.com> (sfid-20120130_125749_376867_3D383524)
In-Reply-To: <1327924857-1250-1-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ACX_TSF_INFO command now takes role_id as param.
change the struct accordingly, and pass the wlvif
to the wl1271_acx_tsf_info() function.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |    7 +++++--
 drivers/net/wireless/wl12xx/acx.h  |    9 ++++++---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 7537c40..af2c312 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1459,9 +1459,10 @@ out:
 	return ret;
 }
 
-int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime)
+int wl12xx_acx_tsf_info(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			u64 *mactime)
 {
-	struct wl1271_acx_fw_tsf_information *tsf_info;
+	struct wl12xx_acx_fw_tsf_information *tsf_info;
 	int ret;
 
 	tsf_info = kzalloc(sizeof(*tsf_info), GFP_KERNEL);
@@ -1470,6 +1471,8 @@ int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime)
 		goto out;
 	}
 
+	tsf_info->role_id = wlvif->role_id;
+
 	ret = wl1271_cmd_interrogate(wl, ACX_TSF_INFO,
 				     tsf_info, sizeof(*tsf_info));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 69892b4..a5bf761 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -995,15 +995,17 @@ struct wl1271_acx_ba_receiver_setup {
 	u8 padding[2];
 } __packed;
 
-struct wl1271_acx_fw_tsf_information {
+struct wl12xx_acx_fw_tsf_information {
 	struct acx_header header;
 
+	u8 role_id;
+	u8 padding1[3];
 	__le32 current_tsf_high;
 	__le32 current_tsf_low;
 	__le32 last_bttt_high;
 	__le32 last_tbtt_low;
 	u8 last_dtim_count;
-	u8 padding[3];
+	u8 padding2[3];
 } __packed;
 
 struct wl1271_acx_ps_rx_streaming {
@@ -1296,7 +1298,8 @@ int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl,
 				       struct wl12xx_vif *wlvif);
 int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
 				       u16 ssn, bool enable, u8 peer_hlid);
-int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
+int wl12xx_acx_tsf_info(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			u64 *mactime);
 int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       bool enable);
 int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl, struct wl12xx_vif *wlvif);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 51059a8..1c73c01 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4019,6 +4019,7 @@ static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw,
 {
 
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	u64 mactime = ULLONG_MAX;
 	int ret;
 
@@ -4033,7 +4034,7 @@ static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_tsf_info(wl, &mactime);
+	ret = wl12xx_acx_tsf_info(wl, wlvif, &mactime);
 	if (ret < 0)
 		goto out_sleep;
 
-- 
1.7.6.401.g6a319

