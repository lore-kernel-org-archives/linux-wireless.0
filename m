Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50985 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab0HUOYD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 10:24:03 -0400
From: wey-yi.w.guy@intel.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH v2 1/1] mac80211: fix warning for un-used parameter
Date: Sat, 21 Aug 2010 07:23:29 -0700
Message-Id: <1282400609-10064-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

mesh_hdr only used when CONFIG_MAC80211_MESH is defined

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
v2: use __maybe_unused
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bc4fefc..25dab7f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1701,7 +1701,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
 	struct ieee80211_hdr hdr;
-	struct ieee80211s_hdr mesh_hdr;
+	__maybe_unused struct ieee80211s_hdr mesh_hdr;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
-- 
1.6.0.4

