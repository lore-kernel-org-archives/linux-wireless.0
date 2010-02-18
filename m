Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:19682 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0BRL2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:08 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/22] wl1271: Fix channel changing code
Date: Thu, 18 Feb 2010 13:25:37 +0200
Message-Id: <1266492357-462-3-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel changing code would a) change the BSSID to a dummy on upon
channel change, breaking connectivity, and b) not update the channel number
at all for ad-hoc, breaking adhoc.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 6f026fe..8b46b70 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1234,8 +1234,16 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	/* if the channel changes while joined, join again */
-	if (channel != wl->channel && test_bit(WL1271_FLAG_JOINED, &wl->flags))
-		wl1271_join_channel(wl, channel);
+	if (channel != wl->channel &&
+	    test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
+		wl->channel = channel;
+		/* FIXME: maybe use CMD_CHANNEL_SWITCH for this? */
+		ret = wl1271_cmd_join(wl);
+		if (ret < 0)
+			wl1271_warning("cmd join to update channel failed %d",
+				       ret);
+	} else
+		wl->channel = channel;
 
 	if (conf->flags & IEEE80211_CONF_PS &&
 	    !test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
-- 
1.6.3.3

