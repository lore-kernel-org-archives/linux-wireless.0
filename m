Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:33580 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbbGILIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 07:08:53 -0400
Received: by laar3 with SMTP id r3so244403386laa.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 04:08:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/6] ath10k: update vdev ps state on start
Date: Thu,  9 Jul 2015 13:08:37 +0200
Message-Id: <1436440119-30231-5-git-send-email-michal.kazior@tieto.com> (sfid-20150709_130900_576339_7683B982)
In-Reply-To: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
References: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Psmode can be forcefully enabled when vdev isn't
started. It isn't guaranteed that mac80211 will
re-issue psmode setting after vdev is started
unless actual bss_conf.ps value has changed.

Even if this doesn't fix any problems now it may
prevent future breakage.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a060b7708f4a..e25e6a8f44a5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6222,6 +6222,13 @@ ath10k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 
 	arvif->is_started = true;
 
+	ret = ath10k_mac_vif_setup_ps(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to update vdev %i ps: %d\n",
+			    arvif->vdev_id, ret);
+		goto err_stop;
+	}
+
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		ret = ath10k_wmi_vdev_up(ar, arvif->vdev_id, 0, vif->addr);
 		if (ret) {
@@ -6239,6 +6246,7 @@ ath10k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 err_stop:
 	ath10k_vdev_stop(arvif);
 	arvif->is_started = false;
+	ath10k_mac_vif_setup_ps(arvif);
 
 err:
 	mutex_unlock(&ar->conf_mutex);
-- 
2.1.4

