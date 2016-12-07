Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35672 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932511AbcLGRIQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 12:08:16 -0500
Received: by mail-wm0-f48.google.com with SMTP id a197so177545171wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 09:08:15 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 5/5] ath10k: add debug trace to rts/cts set function
Date: Wed,  7 Dec 2016 18:07:34 +0100
Message-Id: <1481130454-27244-5-git-send-email-bartosz.markowski@tieto.com> (sfid-20161207_180822_249369_E9B67CC5)
In-Reply-To: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
References: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align it with the cts protection call.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6f1825964177..508366f139f1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1275,6 +1275,9 @@ static int ath10k_recalc_rtscts_prot(struct ath10k_vif *arvif)
 		rts_cts |= SM(WMI_RTSCTS_FOR_SECOND_RATESERIES,
 			      WMI_RTSCTS_PROFILE);
 
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d recalc rts/cts prot %d\n",
+		   arvif->vdev_id, rts_cts);
+
 	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 					 rts_cts);
 }
-- 
2.1.2
