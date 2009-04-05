Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1613 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbZDECLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 22:11:09 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 6/6] wl12xx: update set_key callback to match current API
Date: Sat,  4 Apr 2009 22:10:28 -0400
Message-Id: <1238897428-19639-7-git-send-email-me@bobcopeland.com> (sfid-20090405_041131_248837_484CBF93)
In-Reply-To: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new prototype for ops->set_key which now takes a vif pointer
and sta pointer instead of a pair of addresses.  Remove the debug
statement for local_addr since wl12xx_op_set_key doesn't use the vif
pointer anyway.
---
 drivers/net/wireless/wl12xx/main.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 76b1efc..edf9ec1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -840,28 +840,30 @@ static int wl12xx_set_key_type(struct wl12xx *wl, struct acx_set_key *key,
 }
 
 static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-			     const u8 *local_addr, const u8 *addr,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta,
 			     struct ieee80211_key_conf *key)
 {
 	struct wl12xx *wl = hw->priv;
 	struct acx_set_key wl_key;
+	const u8 *addr;
 	int ret;
 
+	static const u8 bcast_addr[ETH_ALEN] =
+		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+
 	wl12xx_debug(DEBUG_MAC80211, "mac80211 set key");
 
 	memset(&wl_key, 0, sizeof(wl_key));
 
+	addr = sta ? sta->addr : bcast_addr;
+
 	wl12xx_debug(DEBUG_CRYPT, "CMD: 0x%x", cmd);
 	wl12xx_dump(DEBUG_CRYPT, "ADDR: ", addr, ETH_ALEN);
-	wl12xx_dump(DEBUG_CRYPT, "LOCAL_ADDR: ", local_addr, ETH_ALEN);
 	wl12xx_debug(DEBUG_CRYPT, "Key: algo:0x%x, id:%d, len:%d flags 0x%x",
 		     key->alg, key->keyidx, key->keylen, key->flags);
 	wl12xx_dump(DEBUG_CRYPT, "KEY: ", key->key, key->keylen);
 
-	if (is_zero_ether_addr(addr))
-		/* We dont support TX only encryption */
-		return -EOPNOTSUPP;
-
 	mutex_lock(&wl->mutex);
 
 	switch (cmd) {
-- 
1.6.0.6


