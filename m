Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52496 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0ILLL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 07:11:26 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kalle.valo@iki.fi>,
	Felix Fietkau <nbd@openwrt.org>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/2] mac80211: fix compilation warning
Date: Sun, 12 Sep 2010 14:10:29 +0300
Message-Id: <1284289829-25425-3-git-send-email-felipe.contreras@gmail.com>
In-Reply-To: <1284289829-25425-1-git-send-email-felipe.contreras@gmail.com>
References: <1284289829-25425-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/tx.c: In function ‘ieee80211_subif_start_xmit’:
net/mac80211/tx.c:1702: warning: unused variable ‘mesh_hdr’

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 net/mac80211/tx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c54db96..323a6b5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1699,7 +1699,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
 	struct ieee80211_hdr hdr;
-	struct ieee80211s_hdr mesh_hdr;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
@@ -1755,7 +1754,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		hdrlen = 30;
 		break;
 #ifdef CONFIG_MAC80211_MESH
-	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT: {
+		struct ieee80211s_hdr mesh_hdr;
+
 		if (!sdata->u.mesh.mshcfg.dot11MeshTTL) {
 			/* Do not send frames with mesh_ttl == 0 */
 			sdata->u.mesh.mshstats.dropped_frames_ttl++;
@@ -1813,6 +1814,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 		}
 		break;
+	}
 #endif
 	case NL80211_IFTYPE_STATION:
 		memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
-- 
1.7.2.3

