Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3AaNOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:14:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: allow transmitting deauth with tainted key
Date: Thu, 31 Jan 2013 14:15:06 +0100
Message-Id: <1359638107-15306-1-git-send-email-johannes@sipsolutions.net> (sfid-20130131_141448_355132_8437FAF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we had a connection for WoWLAN and after resume it
needed to be disconnected, the previous commit enabled
sending a deauth frame to the AP. This frame would not
go through on MFP-enabled networks as the key for it is
marked tainted before the frame is transmitted.

Allow a tainted key to be used for deauth frames. Worst
case, we'll use a wrong key because the PTK was rekeyed
while suspended, but more likely the PTK is still fine
and the taint flag really only applies to the GTK(s).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a2cb6a3..7892b0a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -594,7 +594,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 			break;
 		}
 
-		if (unlikely(tx->key && tx->key->flags & KEY_FLAG_TAINTED))
+		if (unlikely(tx->key && tx->key->flags & KEY_FLAG_TAINTED &&
+			     !ieee80211_is_deauth(hdr->frame_control)))
 			return TX_DROP;
 
 		if (!skip_hw && tx->key &&
-- 
1.8.0

