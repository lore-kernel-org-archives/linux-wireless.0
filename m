Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58771 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab0D3SPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 14:15:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Added get_survey callback in order to get channel noise
Date: Thu, 29 Apr 2010 15:56:25 -0400
Message-Id: <1272570985-11291-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43legacy/main.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 1d070be..6e9e0df 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3481,6 +3481,23 @@ static int b43legacy_op_beacon_set_tim(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int b43legacy_op_get_survey(struct ieee80211_hw *hw, int idx,
+				   struct survey_info *survey)
+{
+	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
+	struct b43legacy_wldev *dev = wl->current_dev;
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
 static const struct ieee80211_ops b43legacy_hw_ops = {
 	.tx			= b43legacy_op_tx,
 	.conf_tx		= b43legacy_op_conf_tx,
@@ -3493,6 +3510,7 @@ static const struct ieee80211_ops b43legacy_hw_ops = {
 	.start			= b43legacy_op_start,
 	.stop			= b43legacy_op_stop,
 	.set_tim		= b43legacy_op_beacon_set_tim,
+	.get_survey		= b43legacy_op_get_survey,
 	.rfkill_poll		= b43legacy_rfkill_poll,
 };
 
-- 
1.6.6.1

