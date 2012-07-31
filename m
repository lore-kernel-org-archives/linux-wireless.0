Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2GaOV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 10:21:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlegacy: use eth_broadcast_addr
Date: Tue, 31 Jul 2012 16:21:53 +0200
Message-Id: <1343744513-6003-1-git-send-email-johannes@sipsolutions.net> (sfid-20120731_162207_647621_FEE58320)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of copying from a constant array
(which is still needed for other purposes)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 0370403..9c6c42b 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1586,9 +1586,9 @@ il_fill_probe_req(struct il_priv *il, struct ieee80211_mgmt *frame,
 		return 0;
 
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, il_bcast_addr, ETH_ALEN);
+	eth_broadcast_addr(frame->da);
 	memcpy(frame->sa, ta, ETH_ALEN);
-	memcpy(frame->bssid, il_bcast_addr, ETH_ALEN);
+	eth_broadcast_addr(frame->bssid);
 	frame->seq_ctrl = 0;
 
 	len += 24;
-- 
1.7.10.4

