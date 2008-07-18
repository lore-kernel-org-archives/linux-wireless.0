Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:37207 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYGRNul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 09:50:41 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath5k: fix recursive locking in ath5k_beacon_update
Date: Fri, 18 Jul 2008 09:50:08 -0400
Message-Id: <20080718134345.M6916@bobcopeland.com> (sfid-20080718_155046_103932_29EBD59D)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all, 

I found a lockdep error while playing with AP mode on ath5k.  I think
this is triggerable today in ad-hoc mode.

From: Bob Copeland <me@bobcopeland.com>
Date: Fri, 18 Jul 2008 11:11:21 -0400
Subject: [PATCH] ath5k: fix recursive locking in ath5k_beacon_update

ath5k_beacon_update takes sc->lock upon entry.  However, it is only
called from within ath5k_config_interface, which already holds the lock.
Remove the unnecessary locking from ath5k_beacon_update.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 217d506..235cba8 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -3032,8 +3032,6 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct
sk_buff *skb)
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	mutex_lock(&sc->lock);
-
 	if (sc->opmode != IEEE80211_IF_TYPE_IBSS) {
 		ret = -EIO;
 		goto end;
@@ -3048,7 +3046,6 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct
sk_buff *skb)
 		ath5k_beacon_config(sc);
 
 end:
-	mutex_unlock(&sc->lock);
 	return ret;
 }
 
-- 
1.5.4.2.182.gb3092

-- 
Bob Copeland %% www.bobcopeland.com


