Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:62230 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbASIyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 03:54:31 -0500
Received: by mail-we0-f172.google.com with SMTP id k11so30086381wes.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 00:54:25 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: use per-vif wmm param setup if possible
Date: Mon, 19 Jan 2015 09:53:43 +0100
Message-Id: <1421657623-11706-3-git-send-email-michal.kazior@tieto.com> (sfid-20150119_095433_908918_F74FB40A)
In-Reply-To: <1421657623-11706-1-git-send-email-michal.kazior@tieto.com>
References: <1421657623-11706-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New wmi-tlv firmware for qca6174 supports this.

This should fix issues related to multi-vif WMM.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a2a145b..7cbe0d4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4098,11 +4098,23 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 	 */
 	p->txop = params->txop * 32;
 
-	/* FIXME: FW accepts wmm params per hw, not per vif */
-	ret = ath10k_wmi_pdev_set_wmm_params(ar, &arvif->wmm_params);
-	if (ret) {
-		ath10k_warn(ar, "failed to set wmm params: %d\n", ret);
-		goto exit;
+	if (ar->wmi.ops->gen_vdev_wmm_conf) {
+		ret = ath10k_wmi_vdev_wmm_conf(ar, arvif->vdev_id,
+					       &arvif->wmm_params);
+		if (ret) {
+			ath10k_warn(ar, "failed to set vdev wmm params on vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+			goto exit;
+		}
+	} else {
+		/* This won't work well with multi-interface cases but it's
+		 * better than nothing.
+		 */
+		ret = ath10k_wmi_pdev_set_wmm_params(ar, &arvif->wmm_params);
+		if (ret) {
+			ath10k_warn(ar, "failed to set wmm params: %d\n", ret);
+			goto exit;
+		}
 	}
 
 	ret = ath10k_conf_tx_uapsd(ar, vif, ac, params->uapsd);
-- 
1.8.5.3

