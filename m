Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56822 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbeBMFfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 00:35:34 -0500
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCHv2 3/3] ath: change in cfg80211_probe_status API
Date: Tue, 13 Feb 2018 11:05:28 +0530
Message-Id: <1518500128-10837-1-git-send-email-vnaralas@codeaurora.org> (sfid-20180213_063620_466201_984EDF79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes cfg80211_probe_status API.

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 768f63f38..b799a53 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1599,7 +1599,8 @@ static void wil_probe_client_handle(struct wil6210_priv *wil,
 	 */
 	bool alive = (sta->status == wil_sta_connected);
 
-	cfg80211_probe_status(ndev, sta->addr, req->cookie, alive, GFP_KERNEL);
+	cfg80211_probe_status(ndev, sta->addr, req->cookie, alive,
+			      0, false, GFP_KERNEL);
 }
 
 static struct list_head *next_probe_client(struct wil6210_priv *wil)
-- 
2.7.4
