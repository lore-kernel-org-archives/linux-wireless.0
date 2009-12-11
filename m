Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63579 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762333AbZLKLmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:42:14 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 31/31] wl1271: Prevent performing "join" before association
Date: Fri, 11 Dec 2009 13:41:22 +0200
Message-Id: <1260531682-4695-32-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

There is a minor bug in the code causing a "join" to be performed before
there is an intention to associate. Fix this.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 99199f7..1ba3e0d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1223,7 +1223,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		if (conf->flags & IEEE80211_CONF_IDLE &&
 		    test_bit(WL1271_FLAG_JOINED, &wl->flags))
 			wl1271_unjoin_channel(wl);
-		else
+		else if (!(conf->flags & IEEE80211_CONF_IDLE))
 			wl1271_join_channel(wl, channel);
 
 		if (conf->flags & IEEE80211_CONF_IDLE) {
-- 
1.6.3.3

