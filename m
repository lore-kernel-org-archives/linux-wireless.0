Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55198 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752302AbdEPJXj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 05:23:39 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 7/7] mac80211: mark as action frame when parsing IEs of CSA action frames
Date: Tue, 16 May 2017 11:23:16 +0200
Message-Id: <20170516092316.15636-8-sw@simonwunderlich.de> (sfid-20170516_112816_170245_E8BD3E72)
In-Reply-To: <20170516092316.15636-1-sw@simonwunderlich.de>
References: <20170516092316.15636-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/mesh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a57af5df7ee4..ab07974cdcf4 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1308,7 +1308,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	pos = mgmt->u.action.u.chan_switch.variable;
 	baselen = offsetof(struct ieee80211_mgmt,
 			   u.action.u.chan_switch.variable);
-	ieee802_11_parse_elems(pos, len - baselen, false, &elems);
+	ieee802_11_parse_elems(pos, len - baselen, true, &elems);
 
 	ifmsh->chsw_ttl = elems.mesh_chansw_params_ie->mesh_ttl;
 	if (!--ifmsh->chsw_ttl)
-- 
2.11.0
