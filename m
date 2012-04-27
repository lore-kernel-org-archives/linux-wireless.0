Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58787 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759603Ab2D0Dsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 23:48:40 -0400
Received: by mail-ob0-f174.google.com with SMTP id ta14so494409obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 20:48:40 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 3/4] mac80211: Allow nonHT/HT peering in mesh
Date: Thu, 26 Apr 2012 20:48:25 -0700
Message-Id: <1335498506-9600-3-git-send-email-ashok@cozybit.com> (sfid-20120427_054916_197631_0DD5CCCA)
In-Reply-To: <1335498506-9600-1-git-send-email-ashok@cozybit.com>
References: <1335498506-9600-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we have protection enabled, allow non-HT and HT20 stations to peer
with HT40+/- stations. Peering is still disallowed for HT40+/- mismatch.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Reviewed-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8a952e0..d25cb78 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -76,6 +76,7 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
 	u32 basic_rates = 0;
+	enum nl80211_channel_type sta_channel_type;
 
 	/*
 	 * As support for each feature is added, check for matching
@@ -102,10 +103,15 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.bss_conf.basic_rates != basic_rates)
 		goto mismatch;
 
-	/* disallow peering with mismatched channel types for now */
+	if (ie->ht_operation)
+		sta_channel_type =
+			ieee80211_ht_oper_to_channel_type(ie->ht_operation);
+
+	/* Disallow HT40+/- mismatch */
 	if (ie->ht_operation &&
-	    (local->_oper_channel_type !=
-	     ieee80211_ht_oper_to_channel_type(ie->ht_operation)))
+	    local->_oper_channel_type > NL80211_CHAN_HT20 &&
+	    sta_channel_type > NL80211_CHAN_HT20 &&
+	    local->_oper_channel_type != sta_channel_type)
 		goto mismatch;
 
 	return true;
-- 
1.7.5.4

