Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44741 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaEIM35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:29:57 -0400
Received: by mail-ee0-f42.google.com with SMTP id d49so2658693eek.29
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:29:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/5] ath10k: protect wep tx key setup
Date: Fri,  9 May 2014 14:15:48 +0200
Message-Id: <1399637749-13489-5-git-send-email-michal.kazior@tieto.com> (sfid-20140509_143005_193991_7643CC00)
In-Reply-To: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All configuration sequences should be protected
with conf_mutex to avoid concurrent/conflicting
requests.

This should make sure that wep tx key setup is not
performed while hw is restarted (at least).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 40ce1e9..78b427d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1888,8 +1888,10 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
 						wep_key_work);
 	int ret, keyidx = arvif->def_wep_key_newidx;
 
+	mutex_lock(&arvif->ar->conf_mutex);
+
 	if (arvif->def_wep_key_idx == keyidx)
-		return;
+		goto unlock;
 
 	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d set keyidx %d\n",
 		   arvif->vdev_id, keyidx);
@@ -1902,10 +1904,12 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
 		ath10k_warn("failed to update wep key index for vdev %d: %d\n",
 			    arvif->vdev_id,
 			    ret);
-		return;
+		goto unlock;
 	}
 
 	arvif->def_wep_key_idx = keyidx;
+unlock:
+	mutex_unlock(&arvif->ar->conf_mutex);
 }
 
 static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
-- 
1.8.5.3

