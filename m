Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3EFN4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 09:56:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: milon@wq.cz, sgruszka@redhat.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10] mac80211: use just spin_lock() in ieee80211_get_tkip_p2k()
Date: Mon,  6 May 2013 15:56:33 +0200
Message-Id: <1367848593-16167-1-git-send-email-johannes@sipsolutions.net> (sfid-20130506_155650_594735_78247B00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_get_tkip_p2k() may be called with interrupts
disabled, so spin_unlock_bh() isn't safe and leads to
warnings. Since it's always called with BHs disabled
already, just use spin_lock().

Cc: stable@vger.kernel.org
Reported-by: Milan Kocian <milon@wq.cz>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tkip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 3ed801d..124b1fd 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -208,10 +208,10 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 	u32 iv32 = get_unaligned_le32(&data[4]);
 	u16 iv16 = data[2] | (data[0] << 8);
 
-	spin_lock_bh(&key->u.tkip.txlock);
+	spin_lock(&key->u.tkip.txlock);
 	ieee80211_compute_tkip_p1k(key, iv32);
 	tkip_mixing_phase2(tk, ctx, iv16, p2k);
-	spin_unlock_bh(&key->u.tkip.txlock);
+	spin_unlock(&key->u.tkip.txlock);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_p2k);
 
-- 
1.8.0

