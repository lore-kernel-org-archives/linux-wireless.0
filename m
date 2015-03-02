Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34372 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbbCBKWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 05:22:40 -0500
Received: by lbiv13 with SMTP id v13so10344822lbi.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 02:22:38 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: improve 11b coex
Date: Mon,  2 Mar 2015 11:21:17 +0100
Message-Id: <1425291677-1478-1-git-send-email-michal.kazior@tieto.com> (sfid-20150302_112244_006976_0AE0A228)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This improves coexistance with 11b legacy devices
on wmi-tlv and qca6174.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0f39af7..3fcd0fd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3577,6 +3577,13 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret)
 			ath10k_warn(ar, "failed to recalculate rts/cts prot for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
+
+		vdev_param = ar->wmi.vdev_param->protection_mode;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+						info->use_cts_prot ? 1 : 0);
+		if (ret)
+			ath10k_warn(ar, "failed to set protection mode %d on vdev %i: %d\n",
+					info->use_cts_prot, arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
-- 
1.8.5.3

