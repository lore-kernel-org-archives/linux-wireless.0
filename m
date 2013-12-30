Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:57371 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3L3IIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Dec 2013 03:08:07 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so4985915eak.30
        for <linux-wireless@vger.kernel.org>; Mon, 30 Dec 2013 00:08:06 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] ath10k: disable STA KICKOUT in FW
Date: Mon, 30 Dec 2013 09:07:51 +0100
Message-Id: <1388390871-3932-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20131230_090811_598346_D9D4EC12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ath10k is not using STA KICKOUT firmware functionality.
In order to avoid unwanted FW events this functionality should be
disabled when not used.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5b45f3a..93416ab 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2292,11 +2292,20 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
+		u32 param_id;
+
 		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr);
 		if (ret) {
 			ath10k_warn("Failed to create peer for AP: %d\n", ret);
 			goto err_vdev_delete;
 		}
+
+		param_id = ar->wmi.pdev_param->sta_kickout_th;
+
+		/* Disable STA KICKOUT functionality in FW */
+		ret = ath10k_wmi_pdev_set_param(ar, param_id, 0);
+		if (ret)
+			ath10k_warn("Failed to disable STA KICKOUT\n");
 	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_STA) {
-- 
1.8.1.2

