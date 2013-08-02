Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:44350
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754833Ab3HBX5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 19:57:49 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH] cw1200:  Fix spurious BUG_ON() trigger when starting AP mode.
Date: Fri,  2 Aug 2013 19:57:40 -0400
Message-Id: <1375487860-345-1-git-send-email-pizza@shaftnet.org> (sfid-20130803_083953_617184_E14033FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's an underlying race condition with the unjoin_work() call that is
sometimes triggered depending on scheduling order and the phase of the
moon.  This doesn't fix the race condition, but it does remove the
ill-advised BUG_ON() call in an easily-recoverable situation.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
This should go into 3.11-rc!
 drivers/net/wireless/cw1200/sta.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 7365674..010b252 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -1406,11 +1406,8 @@ static void cw1200_do_unjoin(struct cw1200_common *priv)
 	if (!priv->join_status)
 		goto done;
 
-	if (priv->join_status > CW1200_JOIN_STATUS_IBSS) {
-		wiphy_err(priv->hw->wiphy, "Unexpected: join status: %d\n",
-			  priv->join_status);
-		BUG_ON(1);
-	}
+	if (priv->join_status == CW1200_JOIN_STATUS_AP)
+		goto done;
 
 	cancel_work_sync(&priv->update_filtering_work);
 	cancel_work_sync(&priv->set_beacon_wakeup_period_work);
-- 
1.8.3.1

