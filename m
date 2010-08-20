Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45609 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0HTVuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 17:50:11 -0400
From: wey-yi.w.guy@intel.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] mac80211: fix warning for un-used parameter
Date: Fri, 20 Aug 2010 14:49:36 -0700
Message-Id: <1282340976-10665-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

mesh_hdr only used when CONFIG_MAC80211_MESH is defined

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/tx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bc4fefc..364d56a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1701,7 +1701,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
 	struct ieee80211_hdr hdr;
+#ifdef CONFIG_MAC80211_MESH
 	struct ieee80211s_hdr mesh_hdr;
+#endif
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
-- 
1.6.0.4

