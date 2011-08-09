Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1HIJOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:31 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:31 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 32/40] wl12xx: don't remove key if hlid was already deleted
Date: Tue,  9 Aug 2011 12:13:45 +0300
Message-Id: <1312881233-9366-33-git-send-email-eliad@wizery.com> (sfid-20110809_111436_913633_E7368E9D)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When wep key was removed after disconnection, sta_hlid was invalid,
and it resulted in a fw crash.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c873f24..b223c27 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2590,12 +2590,17 @@ static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		   will be cleared automatically on next CMD_JOIN. Ignore the
 		   request silently, as we dont want the mac80211 to emit
 		   an error message. */
 		if (action == KEY_REMOVE && !is_broadcast_ether_addr(addr))
 			return 0;
 
+		/* don't remove key if hlid was already deleted */
+		if (action == KEY_REMOVE &&
+		    wl->sta_hlid == WL1271_INVALID_LINK_ID)
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

