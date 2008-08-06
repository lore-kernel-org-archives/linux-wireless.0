Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:13846 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYHFM2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 08:28:11 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1117115nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 05:28:10 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Wed, 6 Aug 2008 13:17:54 +0200
Subject: [PATCH] mac80211: keep mesh ifaces in allmulti mode
Message-ID: <4899975a.2135440a.05a6.3c34@mx.google.com> (sfid-20080806_142813_952403_74B7A125)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently a mesh node will not forward a multicast frame if it is not subscribed
to the specific multicast address. This patch addresses the issue and fixes mesh
multicast forwarding.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/main.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0c02c47..aa5a191 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -245,10 +245,13 @@ static int ieee80211_open(struct net_device *dev)
 	case IEEE80211_IF_TYPE_AP:
 		sdata->bss = &sdata->u.ap;
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		/* mesh ifaces must set allmulti to forward mcast traffic */
+		atomic_inc(&local->iff_allmultis);
+		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_IBSS:
-	case IEEE80211_IF_TYPE_MESH_POINT:
 		/* no special treatment */
 		break;
 	case IEEE80211_IF_TYPE_INVALID:
@@ -495,6 +498,9 @@ static int ieee80211_stop(struct net_device *dev)
 		netif_addr_unlock_bh(local->mdev);
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
+		/* allmulti is always set on mesh ifaces */
+		atomic_dec(&local->iff_allmultis);
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
-- 
1.5.4.3



