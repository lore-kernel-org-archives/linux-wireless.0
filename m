Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1HNKSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:18:03 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967072wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:18:02 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 31/40] wl12xx: use ap_bcast_hlid for recorded keys
Date: Sun, 14 Aug 2011 13:17:30 +0300
Message-Id: <1313317059-16567-32-git-send-email-eliad@wizery.com> (sfid-20110814_121806_521099_970B8E1A)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when the key was recorded, wl->ap_bcast_hlid was invalid
(since the role wasn't started), so when configuring the
key we need to use the current ap_bcast_hlid.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 053751e..f4f0011 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2530,20 +2530,25 @@ static int wl1271_ap_init_hwenc(struct wl1271 *wl)
 {
 	int i, ret = 0;
 	struct wl1271_ap_key *key;
 	bool wep_key_added = false;
 
 	for (i = 0; i < MAX_NUM_KEYS; i++) {
+		u8 hlid;
 		if (wl->recorded_ap_keys[i] == NULL)
 			break;
 
 		key = wl->recorded_ap_keys[i];
+		hlid = key->hlid;
+		if (hlid == WL12XX_INVALID_LINK_ID)
+			hlid = wl->ap_bcast_hlid;
+
 		ret = wl1271_cmd_set_ap_key(wl, KEY_ADD_OR_REPLACE,
 					    key->id, key->key_type,
 					    key->key_size, key->key,
-					    key->hlid, key->tx_seq_32,
+					    hlid, key->tx_seq_32,
 					    key->tx_seq_16);
 		if (ret < 0)
 			goto out;
 
 		if (key->key_type == KEY_WEP)
 			wep_key_added = true;
-- 
1.7.6.401.g6a319

