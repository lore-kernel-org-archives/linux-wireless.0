Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1ARMpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:45:36 -0500
Subject: [PATCH] mac80211: don't return beacons when mesh is disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 13:45:32 +0100
Message-ID: <1295354732.3563.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When mesh is disabled, mac80211 was returning
beacons with an empty mesh ID. That isn't
desirable, even if drivers shouldn't be trying
to get beacons to start with.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    5 +++++
 1 file changed, 5 insertions(+)

--- wireless-testing.orig/net/mac80211/tx.c	2011-01-13 12:07:19.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2011-01-13 12:07:26.000000000 +0100
@@ -2299,6 +2299,11 @@ struct sk_buff *ieee80211_beacon_get_tim
 		struct ieee80211_mgmt *mgmt;
 		u8 *pos;
 
+#ifdef CONFIG_MAC80211_MESH
+		if (!sdata->u.mesh.mesh_id_len)
+			goto out;
+#endif
+
 		/* headroom, head length, tail length and maximum TIM length */
 		skb = dev_alloc_skb(local->tx_headroom + 400 +
 				sdata->u.mesh.vendor_ie_len);


