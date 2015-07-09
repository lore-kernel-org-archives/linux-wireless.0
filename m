Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34320 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbbGILIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 07:08:51 -0400
Received: by lbnk3 with SMTP id k3so72934851lbn.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 04:08:50 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/6] ath10k: fix hw roc expiration notifcation
Date: Thu,  9 Jul 2015 13:08:36 +0200
Message-Id: <1436440119-30231-4-git-send-email-michal.kazior@tieto.com> (sfid-20150709_130858_442975_775DF688)
In-Reply-To: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
References: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The expiration function must not be called when
roc is explicitly cancelled by mac80211. However
since fcf9844636be ("ath10k: fix hw roc
expiration") the notification was never sent when
roc actually expired.

This fixes some P2P connection setup issues.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2e5c935579c4..78e07051b897 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -633,6 +633,7 @@ struct ath10k {
 		bool is_roc;
 		int vdev_id;
 		int roc_freq;
+		bool roc_notify;
 	} scan;
 
 	struct {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 115889cb0ff6..a060b7708f4a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3449,14 +3449,13 @@ void __ath10k_scan_finish(struct ath10k *ar)
 	case ATH10K_SCAN_IDLE:
 		break;
 	case ATH10K_SCAN_RUNNING:
-		if (ar->scan.is_roc)
-			ieee80211_remain_on_channel_expired(ar->hw);
-		/* fall through */
 	case ATH10K_SCAN_ABORTING:
 		if (!ar->scan.is_roc)
 			ieee80211_scan_completed(ar->hw,
 						 (ar->scan.state ==
 						  ATH10K_SCAN_ABORTING));
+		else if (ar->scan.roc_notify)
+			ieee80211_remain_on_channel_expired(ar->hw);
 		/* fall through */
 	case ATH10K_SCAN_STARTING:
 		ar->scan.state = ATH10K_SCAN_IDLE;
@@ -5459,6 +5458,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 		ar->scan.is_roc = true;
 		ar->scan.vdev_id = arvif->vdev_id;
 		ar->scan.roc_freq = chan->center_freq;
+		ar->scan.roc_notify = true;
 		ret = 0;
 		break;
 	case ATH10K_SCAN_STARTING:
@@ -5522,7 +5522,13 @@ static int ath10k_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	struct ath10k *ar = hw->priv;
 
 	mutex_lock(&ar->conf_mutex);
+
+	spin_lock_bh(&ar->data_lock);
+	ar->scan.roc_notify = false;
+	spin_unlock_bh(&ar->data_lock);
+
 	ath10k_scan_abort(ar);
+
 	mutex_unlock(&ar->conf_mutex);
 
 	cancel_delayed_work_sync(&ar->scan.timeout);
-- 
2.1.4

