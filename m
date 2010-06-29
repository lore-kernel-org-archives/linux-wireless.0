Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx04.teleca.com ([212.92.145.6]:34032 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab0F2Kux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 06:50:53 -0400
From: Yuri Ershov <ext-yuri.ershov@nokia.com>
To: johannes@sipsolutions.net
Cc: ext-yuri.kululin@nokia.com, linux-wireless@vger.kernel.org
Subject: [RFC 1/3] mac80211: Put some code under MESH macro
Date: Tue, 29 Jun 2010 15:08:06 +0400
Message-Id: <4b8939924daf1a8904b7bbedd3bfb784a762089a.1277808543.git.ext-yuri.ershov@nokia.com>
In-Reply-To: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
References: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
In-Reply-To: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
References: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the function ieee80211_subif_start_xmit the logic related with
meshdrlen is under CONFIG_MAC80211_MESH macro, but in one place it isn't.
This is some update for this

Signed-off-by: Yuri Ershov <ext-yuri.ershov@nokia.com>
---
---
 net/mac80211/tx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 698d471..007b76a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1942,11 +1942,13 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		h_pos += encaps_len;
 	}
 
+#ifdef CONFIG_MAC80211_MESH
 	if (meshhdrlen > 0) {
 		memcpy(skb_push(skb, meshhdrlen), &mesh_hdr, meshhdrlen);
 		nh_pos += meshhdrlen;
 		h_pos += meshhdrlen;
 	}
+#endif
 
 	if (ieee80211_is_data_qos(fc)) {
 		__le16 *qos_control;
-- 
1.7.0.4

