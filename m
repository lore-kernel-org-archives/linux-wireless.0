Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37268 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdHCOdD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:33:03 -0400
Received: by mail-pg0-f68.google.com with SMTP id 83so1661959pgb.4
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:33:03 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Subject: [v2 1/8] rsi: add support for rf-kill functionality
Date: Thu,  3 Aug 2017 19:58:57 +0530
Message-Id: <1501770544-6746-2-git-send-email-amitkarwar@gmail.com> (sfid-20170803_163307_744837_8CA8AA6A)
In-Reply-To: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
References: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavani Muthyala <pavani.muthyala@redpinesignals.com>

This patch implements rfkill_poll handler. Also, necessary changes
are done in interface up and down handler to support rfkill
functionality.

Signed-off-by: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index c91d6ef..193f922 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -279,11 +279,12 @@ static int rsi_mac80211_start(struct ieee80211_hw *hw)
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
 
+	rsi_dbg(ERR_ZONE, "===> Interface UP <===\n");
 	mutex_lock(&common->mutex);
 	common->iface_down = false;
-	mutex_unlock(&common->mutex);
-
+	wiphy_rfkill_start_polling(hw->wiphy);
 	rsi_send_rx_filter_frame(common, 0);
+	mutex_unlock(&common->mutex);
 
 	return 0;
 }
@@ -299,8 +300,10 @@ static void rsi_mac80211_stop(struct ieee80211_hw *hw)
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
 
+	rsi_dbg(ERR_ZONE, "===> Interface DOWN <===\n");
 	mutex_lock(&common->mutex);
 	common->iface_down = true;
+	wiphy_rfkill_stop_polling(hw->wiphy);
 
 	/* Block all rx frames */
 	rsi_send_rx_filter_frame(common, 0xffff);
@@ -1214,6 +1217,19 @@ static void rsi_reg_notify(struct wiphy *wiphy,
 	mutex_unlock(&common->mutex);
 }
 
+static void rsi_mac80211_rfkill_poll(struct ieee80211_hw *hw)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+	if (common->fsm_state != FSM_MAC_INIT_DONE)
+		wiphy_rfkill_set_hw_state(hw->wiphy, true);
+	else
+		wiphy_rfkill_set_hw_state(hw->wiphy, false);
+	mutex_unlock(&common->mutex);
+}
+
 static struct ieee80211_ops mac80211_ops = {
 	.tx = rsi_mac80211_tx,
 	.start = rsi_mac80211_start,
@@ -1232,6 +1248,7 @@ static struct ieee80211_ops mac80211_ops = {
 	.sta_remove = rsi_mac80211_sta_remove,
 	.set_antenna = rsi_mac80211_set_antenna,
 	.get_antenna = rsi_mac80211_get_antenna,
+	.rfkill_poll = rsi_mac80211_rfkill_poll,
 };
 
 /**
-- 
2.7.4
