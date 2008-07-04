Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:7643 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYGDRoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 13:44:01 -0400
Received: by yw-out-2324.google.com with SMTP id 9so567449ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 10:44:01 -0700 (PDT)
From: Milan Plzik <milan.plzik@gmail.com>
Subject: [PATCH 1/7] Fix possible mutex double-locking
To: linux-wireless@vger.kernel.org
Date: Fri, 04 Jul 2008 19:43:51 +0200
Message-ID: <20080704174350.4996.72931.stgit@localhost> (sfid-20080704_194405_186199_15278F5A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After finishing scan, at76_dwork_hw_scan locks priv->mtx and calls
ieee80211_scan_completed, which in turn can possibly call at76_config,
which tries to lock the mutex again.

Signed-off-by: Milan Plzik <milan.plzik@gmail.com>
---

 drivers/net/wireless/at76_usb.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index eab8f16..dc6edb3 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1897,8 +1897,6 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 					      dwork_hw_scan.work);
 	int ret;
 
-	mutex_lock(&priv->mtx);
-
 	ret = at76_get_cmd_status(priv->udev, CMD_SCAN);
 	at76_dbg(DBG_MAC80211, "%s: CMD_SCAN status 0x%02x", __func__, ret);
 
@@ -1909,16 +1907,16 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 				   SCAN_POLL_INTERVAL);
 		goto exit;
 	}
-
+	
 	ieee80211_scan_completed(priv->hw);
 
 	if (is_valid_ether_addr(priv->bssid))
 		at76_join(priv);
 
-	ieee80211_wake_queues(priv->hw);
+// CHECKME:	ieee80211_wake_queues(priv->hw);
 
 exit:
-	mutex_unlock(&priv->mtx);
+	return;
 }
 
 static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)

