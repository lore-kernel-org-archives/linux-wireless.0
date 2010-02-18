Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50748 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0BRL2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:20 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/22] wl1271: Fix WEP key handling
Date: Thu, 18 Feb 2010 13:25:50 +0200
Message-Id: <1266492357-462-16-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WEP key index handling was broken: the default key when using key 0 was never
specified to the FW, and if using other default than 0, it would be set on the
TX path for every single TX'd frame.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    8 ++++++++
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 4a0a15b..459d9a0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1475,6 +1475,14 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			wl1271_error("Could not add or replace key");
 			goto out_sleep;
 		}
+
+		/* the default WEP key needs to be configured at least once */
+		if (key_type == KEY_WEP) {
+			ret = wl1271_cmd_set_default_wep_key(wl,
+							     wl->default_key);
+			if (ret < 0)
+				goto out_sleep;
+		}
 		break;
 
 	case DISABLE_KEY:
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index f6815a9..f9e0638 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -203,6 +203,7 @@ static int wl1271_tx_frame(struct wl1271 *wl, struct sk_buff *skb)
 			ret = wl1271_cmd_set_default_wep_key(wl, idx);
 			if (ret < 0)
 				return ret;
+			wl->default_key = idx;
 		}
 	}
 
-- 
1.6.3.3

