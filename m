Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3A2Knj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 05:43:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/2] mac80211: allow transmitting deauth with tainted key
Date: Tue, 29 Jan 2013 11:43:59 +0100
Message-Id: <1359456239-28077-2-git-send-email-johannes@sipsolutions.net> (sfid-20130129_114342_647582_685132BF)
In-Reply-To: <1359456239-28077-1-git-send-email-johannes@sipsolutions.net>
References: <1359456239-28077-1-git-send-email-johannes@sipsolutions.net>
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

Change-Id: I685f048b69f76fe51d4a9b68114211747babf8c6
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 655de2d..ca57d12 100644
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

