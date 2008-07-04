Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:38918 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbYGDRoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 13:44:09 -0400
Received: by mu-out-0910.google.com with SMTP id w8so379639mue.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 10:44:07 -0700 (PDT)
From: Milan Plzik <milan.plzik@gmail.com>
Subject: [PATCH 2/7] Don't leave queues stopped when not neccessary.
To: linux-wireless@vger.kernel.org
Date: Fri, 04 Jul 2008 19:44:04 +0200
Message-ID: <20080704174404.4996.26267.stgit@localhost> (sfid-20080704_194412_426709_BA65B80C)
In-Reply-To: <20080704174350.4996.72931.stgit@localhost>
References: <20080704174350.4996.72931.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

at76_usb driver doesn't enable transmit queue very often -- in fact the 
only place where queues are being started is tx callback handler. This
patch adds calls to ieee80211_start_queues to proper places, so the card 
will not hang in state with queues stopped.

Signed-off-by: Milan Plzik <milan.plzik@gmail.com>
---

 drivers/net/wireless/at76_usb.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index dc6edb3..13ea9ca 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1910,8 +1910,13 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 	
 	ieee80211_scan_completed(priv->hw);
 
-	if (is_valid_ether_addr(priv->bssid))
+	if (is_valid_ether_addr(priv->bssid)) {
+		ieee80211_start_queues(priv->hw);
 		at76_join(priv);
+	} else
+		ieee80211_stop_queues(priv->hw);
+
+	ieee80211_start_queues(priv->hw);
 
 // CHECKME:	ieee80211_wake_queues(priv->hw);
 
@@ -1974,10 +1979,13 @@ static int at76_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 
 	priv->channel = conf->channel->hw_value;
 
-	if (is_valid_ether_addr(priv->bssid))
+	if (is_valid_ether_addr(priv->bssid)) {
 		at76_join(priv);
-	else
+		ieee80211_start_queues(priv->hw);
+	} else {
+		ieee80211_stop_queues(priv->hw);
 		at76_start_monitor(priv);
+	};
 
 	mutex_unlock(&priv->mtx);
 

