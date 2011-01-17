Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42019 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1AQSJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 13:09:07 -0500
From: wey-yi.w.guy@intel.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] mac80211: mesh only parameter mppath maybe unused
Date: Mon, 17 Jan 2011 10:08:01 -0800
Message-Id: <1295287681-17951-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

mppath is mesh related parameter and maybe unused

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index dc261bb..2378305 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1750,7 +1750,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	__le16 fc;
 	struct ieee80211_hdr hdr;
 	struct ieee80211s_hdr mesh_hdr __maybe_unused;
-	struct mesh_path *mppath = NULL;
+	struct mesh_path __maybe_unused *mppath = NULL;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
-- 
1.6.0.4

