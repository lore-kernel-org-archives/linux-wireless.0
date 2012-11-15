Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992436Ab2KORB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 12:01:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use CMAC_PN_LEN
Date: Thu, 15 Nov 2012 18:02:28 +0100
Message-Id: <1352998948-4843-1-git-send-email-johannes@sipsolutions.net> (sfid-20121115_180201_416503_14A2F174)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of hardcoding its value (6), use the constant.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d27e61a..0f18ef5 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -372,8 +372,9 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		key->conf.iv_len = 0;
 		key->conf.icv_len = sizeof(struct ieee80211_mmie);
 		if (seq)
-			for (j = 0; j < 6; j++)
-				key->u.aes_cmac.rx_pn[j] = seq[6 - j - 1];
+			for (j = 0; j < CMAC_PN_LEN; j++)
+				key->u.aes_cmac.rx_pn[j] =
+					seq[CMAC_PN_LEN - j - 1];
 		/*
 		 * Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
-- 
1.8.0

