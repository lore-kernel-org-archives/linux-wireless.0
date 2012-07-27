Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44592 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2G0BLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 21:11:16 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath6kl-devel@qualcomm.com>, <kvalo@qca.qualcomm.com>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: restart concurrent vifs on failed connect
Date: Thu, 26 Jul 2012 18:11:11 -0700
Message-ID: <1343351471-2800-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120727_031121_159085_F43E1CDA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an ath6kl STA vif is issued a connect command, the firmware will
disconnect all other beaconing vifs in preparation for a potential
channel switch. The case where the connect fails is currently unhandled,
so if a connection attempt on a STA vif fails and any vifs were waiting
for a new channel, simply restart the concurrent vifs on their previous
channel.

Requires that we start tracking the last issued channel in ar->last_ch,
which is valid since ath6kl only supports 1 channel at a time.

Also clear the beaconing vif's want_ch_switch bit regardless of whether
channel switch succeeds, to stop recommitting the same failed profile.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/main.c |   18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index eb86b31..baf149e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -699,6 +699,7 @@ struct ath6kl {
 	struct ath6kl_req_key ap_mode_bkey;
 	struct sk_buff_head mcastpsq;
 	u32 want_ch_switch;
+	u16 last_ch;
 
 	/*
 	 * FIXME: protects access to mcastpsq but is actually useless as
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 6beffde..eca4d47 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -441,12 +441,9 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 		break;
 	}
 
-	if (ar->want_ch_switch & (1 << vif->fw_vif_idx)) {
-		ar->want_ch_switch &= ~(1 << vif->fw_vif_idx);
+	if (ar->last_ch != channel)
 		/* we actually don't know the phymode, default to HT20 */
-		ath6kl_cfg80211_ch_switch_notify(vif, channel,
-						 WMI_11G_HT20);
-	}
+		ath6kl_cfg80211_ch_switch_notify(vif, channel, WMI_11G_HT20);
 
 	ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx, NONE_BSS_FILTER, 0);
 	set_bit(CONNECTED, &vif->flags);
@@ -633,6 +630,9 @@ static void ath6kl_check_ch_switch(struct ath6kl *ar, u16 channel)
 		if (ar->want_ch_switch & (1 << vif->fw_vif_idx))
 			res = ath6kl_commit_ch_switch(vif, channel);
 
+		/* if channel switch failed, oh well we tried */
+		ar->want_ch_switch &= ~(1 << vif->fw_vif_idx);
+
 		if (res)
 			ath6kl_err("channel switch failed nw_type %d res %d\n",
 				   vif->nw_type, res);
@@ -986,8 +986,11 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 	if (vif->nw_type == AP_NETWORK) {
 		/* disconnect due to other STA vif switching channels */
 		if (reason == BSS_DISCONNECTED &&
-		    prot_reason_status == WMI_AP_REASON_STA_ROAM)
+		    prot_reason_status == WMI_AP_REASON_STA_ROAM) {
 			ar->want_ch_switch |= 1 << vif->fw_vif_idx;
+			/* bail back to this channel if STA vif fails connect */
+			ar->last_ch = le16_to_cpu(vif->profile.ch);
+		}
 
 		if (!ath6kl_remove_sta(ar, bssid, prot_reason_status))
 			return;
@@ -1046,6 +1049,9 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 		}
 	}
 
+	/* restart disconnected concurrent vifs waiting for new channel */
+	ath6kl_check_ch_switch(ar, ar->last_ch);
+
 	/* update connect & link status atomically */
 	spin_lock_bh(&vif->if_lock);
 	clear_bit(CONNECTED, &vif->flags);
-- 
1.7.4.1

