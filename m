Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab1HIJO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:29 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:28 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 31/40] wl12xx: use ap_bcast_hlid for recorded keys
Date: Tue,  9 Aug 2011 12:13:44 +0300
Message-Id: <1312881233-9366-32-git-send-email-eliad@wizery.com> (sfid-20110809_111441_489213_0A55CECE)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
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
index 5d5ace8..c873f24 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2498,20 +2498,25 @@ static int wl1271_ap_init_hwenc(struct wl1271 *wl)
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
+		if (hlid == WL1271_INVALID_LINK_ID)
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

