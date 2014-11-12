Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58180 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaKLIkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 03:40:32 -0500
Received: by mail-pa0-f51.google.com with SMTP id kq14so12406820pab.24
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 00:40:32 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath9k: fix the assignment of hw queues for mesh interface
Date: Wed, 12 Nov 2014 16:40:19 +0800
Message-Id: <1415781619-4384-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20141112_094035_956370_46EE6DF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to assign the hw queues for mesh interface. Otherwise,
we are not able to bring up the mesh interface due to the
IEEE80211_INVAL_HW_QUEUE error.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 644552c..88a5cf2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1188,7 +1188,8 @@ static void ath9k_assign_hw_queues(struct ieee80211_hw *hw,
 	for (i = 0; i < IEEE80211_NUM_ACS; i++)
 		vif->hw_queue[i] = i;
 
-	if (vif->type == NL80211_IFTYPE_AP)
+	if (vif->type == NL80211_IFTYPE_AP ||
+	    vif->type == NL80211_IFTYPE_MESH_POINT)
 		vif->cab_queue = hw->queues - 2;
 	else
 		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
-- 
2.1.1

