Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43503 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815AbZJMJuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:13 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 16/22] wl1271: Fix multicast list handling
Date: Tue, 13 Oct 2009 12:47:53 +0300
Message-Id: <1255427279-1224-17-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Fixes bugs in the multicast list handling:
 - Use atomic memory allocation in non-sleepable context
 - Increment address pointer when iterating list of MC addresses

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index ae41a70..19dbdb1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1160,7 +1160,7 @@ static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
 	 * configure_filter() instead of saving everything in the context.
 	 */
 
-	fp = kzalloc(sizeof(*fp), GFP_KERNEL);
+	fp = kzalloc(sizeof(*fp), GFP_ATOMIC);
 	if (!fp) {
 		wl1271_error("Out of memory setting filters.");
 		return 0;
@@ -1180,6 +1180,7 @@ static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
 			fp->mc_list_length++;
 		} else
 			wl1271_warning("Unknown mc address length.");
+		mc_list = mc_list->next;
 	}
 
 	/* FIXME: We still need to set our filters properly */
-- 
1.5.6.5

