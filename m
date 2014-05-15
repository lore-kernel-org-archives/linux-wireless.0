Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51560 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaEOItO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 04:49:14 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so400730eek.26
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 01:49:13 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/5] ath10k: protect wep tx key setup
Date: Thu, 15 May 2014 10:42:03 +0200
Message-Id: <1400143324-14911-5-git-send-email-michal.kazior@tieto.com> (sfid-20140515_104933_799497_9BD0B97A)
In-Reply-To: <1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
 <1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All configuration sequences should be protected
with conf_mutex to avoid concurrent/conflicting
requests.

This should make sure that wep tx key setup is not
performed while hw is restarted (at least).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * skip wep update if state != ON [Kalle]
 * add empty space before goto label [Kalle]

 drivers/net/wireless/ath/ath10k/mac.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 577a3a5..e474eca 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1888,8 +1888,13 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
 						wep_key_work);
 	int ret, keyidx = arvif->def_wep_key_newidx;
 
+	mutex_lock(&arvif->ar->conf_mutex);
+
+	if (arvif->ar->state != ATH10K_STATE_ON)
+		goto unlock;
+
 	if (arvif->def_wep_key_idx == keyidx)
-		return;
+		goto unlock;
 
 	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d set keyidx %d\n",
 		   arvif->vdev_id, keyidx);
@@ -1902,10 +1907,13 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
 		ath10k_warn("failed to update wep key index for vdev %d: %d\n",
 			    arvif->vdev_id,
 			    ret);
-		return;
+		goto unlock;
 	}
 
 	arvif->def_wep_key_idx = keyidx;
+
+unlock:
+	mutex_unlock(&arvif->ar->conf_mutex);
 }
 
 static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
-- 
1.8.5.3

