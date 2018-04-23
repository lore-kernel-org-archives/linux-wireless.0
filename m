Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:12177 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754484AbeDWIw0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 04:52:26 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 04/10] wil6210: fix call to wil6210_disconnect during unload
Date: Mon, 23 Apr 2018 11:52:07 +0300
Message-Id: <1524473533-24524-5-git-send-email-merez@codeaurora.org> (sfid-20180423_105238_791030_5D07B9BB)
In-Reply-To: <1524473533-24524-1-git-send-email-merez@codeaurora.org>
References: <1524473533-24524-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <liord@codeaurora.org>

Move the call to wil6210_disconnect so it will be called
before unregister_netdevice. This is because it calls
netif_carrier_off which is forbidden to call on an
unregistered net device. Calling netif_carrier_off can
add a link watch event which might be handled after
net device was freed, causing a kernel oops.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 05e9408..eb6c14ed 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -457,16 +457,16 @@ void wil_vif_remove(struct wil6210_priv *wil, u8 mid)
 		return;
 	}
 
+	mutex_lock(&wil->mutex);
+	wil6210_disconnect(vif, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
+	mutex_unlock(&wil->mutex);
+
 	ndev = vif_to_ndev(vif);
 	/* during unregister_netdevice cfg80211_leave may perform operations
 	 * such as stop AP, disconnect, so we only clear the VIF afterwards
 	 */
 	unregister_netdevice(ndev);
 
-	mutex_lock(&wil->mutex);
-	wil6210_disconnect(vif, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
-	mutex_unlock(&wil->mutex);
-
 	if (any_active && vif->mid != 0)
 		wmi_port_delete(wil, vif->mid);
 
-- 
1.9.1
