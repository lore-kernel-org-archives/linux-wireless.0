Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:56490 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752272AbdBCNwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 08:52:45 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
        Thorsten Horstmann <thorsten@defutech.de>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH] mac80211: Fix adding of mesh vendor IEs
Date: Fri,  3 Feb 2017 14:38:29 +0100
Message-Id: <20170203133829.3219-1-sven@narfation.org> (sfid-20170203_145249_969240_F468065B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thorsten Horstmann <thorsten@defutech.de>

The function ieee80211_ie_split_vendor doesn't return 0 on errors. Instead
it returns any offset < ielen when WLAN_EID_VENDOR_SPECIFIC is found. The
return value in mesh_add_vendor_ies must therefore be checked against
ifmsh->ie_len and not 0. Otherwise all ifmsh->ie starting with
WLAN_EID_VENDOR_SPECIFIC will be rejected.

Fixes: 082ebb0c258d ("mac80211: fix mesh beacon format")
Signed-off-by: Thorsten Horstmann <thorsten@defutech.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[sven@narfation.org: Add commit message]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/mac80211/mesh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d36c7f4c0c7e..6e7b6a07b7d5 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -335,7 +335,7 @@ int mesh_add_vendor_ies(struct ieee80211_sub_if_data *sdata,
 	/* fast-forward to vendor IEs */
 	offset = ieee80211_ie_split_vendor(ifmsh->ie, ifmsh->ie_len, 0);
 
-	if (offset) {
+	if (offset < ifmsh->ie_len) {
 		len = ifmsh->ie_len - offset;
 		data = ifmsh->ie + offset;
 		if (skb_tailroom(skb) < len)
-- 
2.11.0
