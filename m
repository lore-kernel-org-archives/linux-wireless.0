Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:47996 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933986Ab3HHIOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 04:14:17 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/4] ath10k: clean up monitor start code
Date: Thu, 8 Aug 2013 10:14:07 +0200
Message-ID: <1375949650-9699-2-git-send-email-michal.kazior@tieto.com> (sfid-20130808_101424_485358_B08D40F0)
In-Reply-To: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove useless code that was causing WARN_ON when
a 80MHz+ vif entered promiscuous mode or monitor
interface was started.

The channel mode is already computed by
chan_to_phymode().

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cf2ba4d..05f5f76 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -503,13 +503,10 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 {
 	struct ieee80211_channel *channel = ar->hw->conf.chandef.chan;
 	struct wmi_vdev_start_request_arg arg = {};
-	enum nl80211_channel_type type;
 	int ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	type = cfg80211_get_chandef_type(&ar->hw->conf.chandef);
-
 	arg.vdev_id = vdev_id;
 	arg.channel.freq = channel->center_freq;
 	arg.channel.band_center_freq1 = ar->hw->conf.chandef.center_freq1;
-- 
1.7.9.5

