Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36423 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932192AbcLGRIP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 12:08:15 -0500
Received: by mail-wm0-f51.google.com with SMTP id g23so177907306wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 09:08:14 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 4/5] ath10k: set CTS protection VDEV param only if VDEV is up
Date: Wed,  7 Dec 2016 18:07:33 +0100
Message-Id: <1481130454-27244-4-git-send-email-bartosz.markowski@tieto.com> (sfid-20161207_180819_092611_FCFADCAA)
In-Reply-To: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
References: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cts protection vdev parameter, in new QCA9377 TF2.0 firmware,
requires bss peer to be created for the STATION vdev type.
bss peer is being allocated by the firmware after vdev_start/_up commands.
mac80211 may call the cts protection setup at any time, so the
we needs to track the situation and defer the cts configuration
to prevent firmware asserts, like below:

[00]: 0x05020001 0x000015B3 0x0099ACE2 0x00955B31
[04]: 0x0099ACE2 0x00060730 0x00000004 0x00000000
[08]: 0x0044C754 0x00412C10 0x00000000 0x00409C54
[12]: 0x00000009 0x00000000 0x00952F6C 0x00952F77
[16]: 0x00952CC4 0x00910712 0x00000000 0x00000000
[20]: 0x4099ACE2 0x0040E858 0x00421254 0x004127F4
[24]: 0x8099B9B2 0x0040E8B8 0x00000000 0xC099ACE2
[28]: 0x800B75CB 0x0040E8F8 0x00000007 0x00005008
[32]: 0x809B048A 0x0040E958 0x00000010 0x00433B10
[36]: 0x809AFBBC 0x0040E9A8 0x0042BB74 0x0042BBBC
[40]: 0x8091D252 0x0040E9C8 0x0042BBBC 0x00000001
[44]: 0x809FFA45 0x0040EA78 0x0043D3E4 0x0042C2C8
[48]: 0x809FCEF4 0x0040EA98 0x0043D3E4 0x00000001
[52]: 0x80911210 0x0040EAE8 0x00000010 0x004041D0
[56]: 0x80911154 0x0040EB28 0x00400000 0x00000000

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 51 +++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d06a12d548fd..6f1825964177 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1227,6 +1227,36 @@ static int ath10k_monitor_recalc(struct ath10k *ar)
 		return ath10k_monitor_stop(ar);
 }
 
+static bool ath10k_mac_can_set_cts_prot(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (!arvif->is_started) {
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "defer cts setup, vdev is not ready yet\n");
+		return false;
+	}
+
+	return true;
+}
+
+static int ath10k_mac_set_cts_prot(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	u32 vdev_param;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	vdev_param = ar->wmi.vdev_param->protection_mode;
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d cts_protection %d\n",
+		   arvif->vdev_id, arvif->use_cts_prot);
+
+	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+					 arvif->use_cts_prot ? 1 : 0);
+}
+
 static int ath10k_recalc_rtscts_prot(struct ath10k_vif *arvif)
 {
 	struct ath10k *ar = arvif->ar;
@@ -5329,20 +5359,18 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
 		arvif->use_cts_prot = info->use_cts_prot;
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d cts_prot %d\n",
-			   arvif->vdev_id, info->use_cts_prot);
 
 		ret = ath10k_recalc_rtscts_prot(arvif);
 		if (ret)
 			ath10k_warn(ar, "failed to recalculate rts/cts prot for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 
-		vdev_param = ar->wmi.vdev_param->protection_mode;
-		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
-						info->use_cts_prot ? 1 : 0);
-		if (ret)
-			ath10k_warn(ar, "failed to set protection mode %d on vdev %i: %d\n",
-				    info->use_cts_prot, arvif->vdev_id, ret);
+		if (ath10k_mac_can_set_cts_prot(arvif)) {
+			ret = ath10k_mac_set_cts_prot(arvif);
+			if (ret)
+				ath10k_warn(ar, "failed to set cts protection for vdev %d: %d\n",
+					    arvif->vdev_id, ret);
+		}
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
@@ -7365,6 +7393,13 @@ ath10k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 		arvif->is_up = true;
 	}
 
+	if (ath10k_mac_can_set_cts_prot(arvif)) {
+		ret = ath10k_mac_set_cts_prot(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to set cts protection for vdev %d: %d\n",
+				    arvif->vdev_id, ret);
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 
-- 
2.1.2
