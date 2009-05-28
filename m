Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42365 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbZE1Jsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 05:48:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Jason Andryuk <jandryuk@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	karllinuxtest.relton@ntlworld.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] at76c50x-usb: avoid mutex deadlock in at76_dwork_hw_scan
Date: Thu, 28 May 2009 11:45:26 +0200
Message-Id: <1243503926-5094-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20090528004925.d6d9be31.akpm@linux-foundation.org>
References: <20090528004925.d6d9be31.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13312

at76_dwork_hw_scan holds a mutex while calling ieee80211_scan_completed,
which then calls at76_config which needs the same mutex.  This reworks
the ordering to not hold the lock while calling ieee80211_scan_completed.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/at76c50x-usb.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index e3caeef..b51281f 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1873,18 +1873,18 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 	if (ret != CMD_STATUS_COMPLETE) {
 		queue_delayed_work(priv->hw->workqueue, &priv->dwork_hw_scan,
 				   SCAN_POLL_INTERVAL);
-		goto exit;
+		mutex_unlock(&priv->mtx);
+		return;
 	}
 
-	ieee80211_scan_completed(priv->hw, false);
-
 	if (is_valid_ether_addr(priv->bssid))
 		at76_join(priv);
 
-	ieee80211_wake_queues(priv->hw);
-
-exit:
 	mutex_unlock(&priv->mtx);
+
+	ieee80211_scan_completed(priv->hw, false);
+
+	ieee80211_wake_queues(priv->hw);
 }
 
 static int at76_hw_scan(struct ieee80211_hw *hw,
-- 
1.6.0.6

