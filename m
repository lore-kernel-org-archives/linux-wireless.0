Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:37949 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936487AbaH1LIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 07:08:36 -0400
Received: by mail-la0-f44.google.com with SMTP id hz20so712720lab.31
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 04:08:35 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: stop monitor vdev for sta assoc
Date: Thu, 28 Aug 2014 12:58:17 +0200
Message-Id: <1409223497-19946-3-git-send-email-michal.kazior@tieto.com> (sfid-20140828_130841_202755_2554D1BA)
In-Reply-To: <1409223497-19946-1-git-send-email-michal.kazior@tieto.com>
References: <1409223497-19946-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents some fw revisions from crashing in
many cases when user is trying to run a
promiscuous station interface (e.g. sniffing,
4addr bridge).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 19562a7..bf8a402 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3169,8 +3169,16 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		if (info->assoc)
+		if (info->assoc) {
+			/* Workaround: Make sure monitor vdev is not running
+			 * when associating to prevent some firmware revisions
+			 * (e.g. 10.1 and 10.2) from crashing.
+			 */
+			if (ar->monitor_started)
+				ath10k_monitor_stop(ar);
 			ath10k_bss_assoc(hw, vif, info);
+			ath10k_monitor_recalc(ar);
+		}
 	}
 
 exit:
-- 
1.8.5.3

