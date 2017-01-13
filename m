Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51098 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751419AbdAMK2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:28:32 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, onelektra@gmx.net
Subject: [PATCH v2] mac80211: initialize SMPS field in HT capabilities
Date: Fri, 13 Jan 2017 11:28:25 +0100
Message-Id: <20170113102825.72047-1-nbd@nbd.name> (sfid-20170113_112843_107276_BCC6F903)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ibss and mesh modes copy the ht capabilites from the band without
overriding the SMPS state. Unfortunately the default value 0 for the
SMPS field means static SMPS instead of disabled.

This results in HT ibss and mesh setups using only single-stream rates,
even though SMPS is not supposed to be active.

Initialize SMPS to disabled for all bands on ieee80211_hw_register to
ensure that the value is sane where it is not overriden with the real
SMPS state.

Reported-by: Elektra Wagenrad <onelektra@gmx.net>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
v2: add comment about OR'ing the PS_DISABLED value

 net/mac80211/main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1822c77f2b1c..d253ce71d472 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -913,10 +913,16 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 		supp_vht = supp_vht || sband->vht_cap.vht_supported;
 
-		if (sband->ht_cap.ht_supported)
-			local->rx_chains =
-				max(ieee80211_mcs_to_chains(&sband->ht_cap.mcs),
-				    local->rx_chains);
+		if (!sband->ht_cap.ht_supported)
+			continue;
+
+		local->rx_chains =
+			max(ieee80211_mcs_to_chains(&sband->ht_cap.mcs),
+			    local->rx_chains);
+
+		/* no need to mask, SM_PS_DISABLED has all bits set */
+		sband->ht_cap.cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
+			             IEEE80211_HT_CAP_SM_PS_SHIFT;
 
 		/* TODO: consider VHT for RX chains, hopefully it's the same */
 	}
-- 
2.11.0
