Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59388 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2HBXsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 19:48:06 -0400
Received: by yhmm54 with SMTP id m54so127918yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 16:48:05 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 4/4] mac80211: skb leak in mesh_plink_frame_tx()
Date: Thu,  2 Aug 2012 16:47:54 -0700
Message-Id: <1343951274-24956-4-git-send-email-thomas@cozybit.com> (sfid-20120803_014858_740410_4FD88567)
In-Reply-To: <1343951274-24956-1-git-send-email-thomas@cozybit.com>
References: <1343951274-24956-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although adding an IE is almost guaranteed to succeed since we already
accounted for its length while allocating the skb, we should still free
the skb in case of failure.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index fba8d86..5a68097 100644
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
@@ -313,14 +315,18 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
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
+
+free:
+	kfree_skb(skb);
+	return err;
 }
 
 /* mesh_peer_init - initialize new mesh peer and return resulting sta_info
-- 
1.7.5.4

