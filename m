Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64337 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1ITUni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 16:43:38 -0400
Received: by iaqq3 with SMTP id q3so938099iaq.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 13:43:38 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH] mac80211: notify peer when shutting down peer link
Date: Tue, 20 Sep 2011 13:43:32 -0700
Message-Id: <1316551412-2816-1-git-send-email-thomas@cozybit.com> (sfid-20110920_224341_733696_417F2571)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send a Mesh Peering Close frame when we deactivate a mesh peer link.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4396906..1213a23 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -43,6 +43,10 @@ enum plink_event {
 	CLS_IGNR
 };
 
+static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
+		enum ieee80211_self_protected_actioncode action,
+		u8 *da, __le16 llid, __le16 plid, __le16 reason);
+
 static inline
 void mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
@@ -133,6 +137,10 @@ void mesh_plink_deactivate(struct sta_info *sta)
 
 	spin_lock_bh(&sta->lock);
 	deactivated = __mesh_plink_deactivate(sta);
+	sta->reason = cpu_to_le16(WLAN_REASON_MESH_PEER_CANCELED);
+	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+			    sta->sta.addr, sta->llid, sta->plid,
+			    sta->reason);
 	spin_unlock_bh(&sta->lock);
 
 	if (deactivated)
-- 
1.7.4.1

