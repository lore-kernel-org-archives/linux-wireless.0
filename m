Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58768 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159Ab0D3SPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 14:15:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Added get_survey callback in order to get channel noise
Date: Thu, 29 Apr 2010 15:56:06 -0400
Message-Id: <1272570966-11248-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/main.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 14cf3bd..f66b658 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4570,6 +4570,23 @@ static void b43_op_sw_scan_complete_notifier(struct ieee80211_hw *hw)
 	mutex_unlock(&wl->mutex);
 }
 
+static int b43_op_get_survey(struct ieee80211_hw *hw, int idx,
+			     struct survey_info *survey)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev = wl->current_dev;
+	struct ieee80211_conf *conf = &hw->conf;
+
+	if (idx != 0)
+		return -ENOENT;
+
+	survey->channel = conf->channel;
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = dev->stats.link_noise;
+
+	return 0;
+}
+
 static const struct ieee80211_ops b43_hw_ops = {
 	.tx			= b43_op_tx,
 	.conf_tx		= b43_op_conf_tx,
@@ -4589,6 +4606,7 @@ static const struct ieee80211_ops b43_hw_ops = {
 	.sta_notify		= b43_op_sta_notify,
 	.sw_scan_start		= b43_op_sw_scan_start_notifier,
 	.sw_scan_complete	= b43_op_sw_scan_complete_notifier,
+	.get_survey		= b43_op_get_survey,
 	.rfkill_poll		= b43_rfkill_poll,
 };
 
-- 
1.6.6.1

