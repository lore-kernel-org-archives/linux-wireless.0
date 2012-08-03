Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab2HCTVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 15:21:43 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so1800271pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2012 12:21:43 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 4/4] mac80211: skb leak in mesh_plink_frame_tx()
Date: Fri,  3 Aug 2012 12:21:35 -0700
Message-Id: <1344021695-12859-4-git-send-email-thomas@cozybit.com> (sfid-20120803_212150_439255_DDD99154)
In-Reply-To: <1344021695-12859-1-git-send-email-thomas@cozybit.com>
References: <1344021695-12859-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although adding an IE is almost guaranteed to succeed since we already
accounted for its length while allocating the skb, we should still free
the skb in case of failure.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a5300ef..7e1c924 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -224,6 +224,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	u8 *pos, ie_len = 4;
 	int hdr_len = offsetof(struct ieee80211_mgmt, u.action.u.self_prot) +
 		      sizeof(mgmt->u.action.u.self_prot);
+	int err = -ENOMEM;
 
 	skb = dev_alloc_skb(local->tx_headroom +
 			    hdr_len +
@@ -265,11 +266,11 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata))
-			return -1;
+			goto free;
 	} else {	/* WLAN_SP_MESH_PEERING_CLOSE */
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 		if (mesh_add_meshid_ie(skb, sdata))
-			return -1;
+			goto free;
 	}
 
 	/* Add Mesh Peering Management element */
@@ -288,11 +289,12 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		ie_len += 2;	/* reason code */
 		break;
 	default:
-		return -EINVAL;
+		err = -EINVAL;
+		goto free;
 	}
 
 	if (WARN_ON(skb_tailroom(skb) < 2 + ie_len))
-		return -ENOMEM;
+		goto free;
 
 	pos = skb_put(skb, 2 + ie_len);
 	*pos++ = WLAN_EID_PEER_MGMT;
@@ -313,14 +315,17 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	if (action != WLAN_SP_MESH_PEERING_CLOSE) {
 		if (mesh_add_ht_cap_ie(skb, sdata) ||
 		    mesh_add_ht_oper_ie(skb, sdata))
-			return -1;
+			goto free;
 	}
 
 	if (mesh_add_vendor_ies(skb, sdata))
-		return -1;
+		goto free;
 
 	ieee80211_tx_skb(sdata, skb);
 	return 0;
+free:
+	kfree_skb(skb);
+	return err;
 }
 
 /**
-- 
1.7.5.4

