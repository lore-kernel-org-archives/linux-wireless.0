Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24709 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab0BRL2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:16 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/22] wl1271: Fix key-remove error
Date: Thu, 18 Feb 2010 13:25:49 +0200
Message-Id: <1266492357-462-15-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new firmware does not allow removal of unicast keys - they will be
automatically removed on the next CMD_JOIN.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 9de7df7..4a0a15b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1478,6 +1478,13 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		break;
 
 	case DISABLE_KEY:
+		/* The wl1271 does not allow to remove unicast keys - they
+		   will be cleared automatically on next CMD_JOIN. Ignore the
+		   request silently, as we dont want the mac80211 to emit
+		   an error message. */
+		if (!is_broadcast_ether_addr(addr))
+			break;
+
 		ret = wl1271_cmd_set_key(wl, KEY_REMOVE,
 					 key_conf->keyidx, key_type,
 					 key_conf->keylen, key_conf->key,
-- 
1.6.3.3

