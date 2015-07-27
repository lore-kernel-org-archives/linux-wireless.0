Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51465 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbbG0TaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 15:30:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath10k: remove NULL ptr deref in variable init of ath10k_monitor_vdev_start
Date: Mon, 27 Jul 2015 15:22:15 -0400
Message-Id: <1438024935-3946-1-git-send-email-linville@tuxdriver.com> (sfid-20150727_213023_440953_EFAD173F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ath10k_monitor_vdev_start, chandef is initialized to NULL and then
channel is immediately thereafter initialized to chandef->chan (i.e.
NULL->chan).  This appears to be some sort of cut-n-paste error, since
the same assignment is done later (i.e. after chandef has been properly
assigned to a non-NULL value).  So, let's just remove this "brown paper
bag" typo/thinko... :-)

Coverity CID #1309505

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c9a7d5b5dffc..2823222dea92 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -836,7 +836,7 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 {
 	struct cfg80211_chan_def *chandef = NULL;
-	struct ieee80211_channel *channel = chandef->chan;
+	struct ieee80211_channel *channel;
 	struct wmi_vdev_start_request_arg arg = {};
 	int ret = 0;
 
-- 
2.4.3

