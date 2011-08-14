Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65029 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1HNKSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:18:04 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967085wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:18:04 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 32/40] wl12xx: don't remove key if hlid was already deleted
Date: Sun, 14 Aug 2011 13:17:31 +0300
Message-Id: <1313317059-16567-33-git-send-email-eliad@wizery.com> (sfid-20110814_121809_619570_F4E98402)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When wep key was removed after disconnection, sta_hlid was invalid,
and it resulted in a fw crash.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f4f0011..0ef63b5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2622,12 +2622,17 @@ static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		   will be cleared automatically on next CMD_JOIN. Ignore the
 		   request silently, as we dont want the mac80211 to emit
 		   an error message. */
 		if (action == KEY_REMOVE && !is_broadcast_ether_addr(addr))
 			return 0;
 
+		/* don't remove key if hlid was already deleted */
+		if (action == KEY_REMOVE &&
+		    wl->sta_hlid == WL12XX_INVALID_LINK_ID)
+			return 0;
+
 		ret = wl1271_cmd_set_sta_key(wl, action,
 					     id, key_type, key_size,
 					     key, addr, tx_seq_32,
 					     tx_seq_16);
 		if (ret < 0)
 			return ret;
-- 
1.7.6.401.g6a319

