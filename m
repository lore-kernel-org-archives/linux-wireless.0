Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54397 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3HVQoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 12:44:14 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo5so2036175pbc.37
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2013 09:44:14 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH] mac80211: only respond to probe request with mesh ID
Date: Thu, 22 Aug 2013 09:44:05 -0700
Message-Id: <1377189845-4843-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130822_184418_275774_242C2E6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>

Previously, the mesh STA responds to probe request from legacy STA
but now it will respond to legacy STA only if the legacy STA has
included the specific mesh ID or wildcard mesh ID in the probe request.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Acked-by: Thomas Pedersen <thomas@cozybit.com>
Acked-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 885a5f6..a660fb8 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -832,6 +832,9 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 
 	ieee802_11_parse_elems(pos, len - baselen, false, &elems);
 
+	if(!elems.mesh_id)
+		return;
+
 	/* 802.11-2012 10.1.4.3.2 */
 	if ((!ether_addr_equal(mgmt->da, sdata->vif.addr) &&
 	     !is_broadcast_ether_addr(mgmt->da)) ||
-- 
1.7.9.5

