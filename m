Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36786 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934241AbdAKWd2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 17:33:28 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, onelektra@gmx.net
Subject: [PATCH] mac80211: initialize SMPS field in HT capabilities
Date: Wed, 11 Jan 2017 23:33:22 +0100
Message-Id: <20170111223322.14698-1-nbd@nbd.name> (sfid-20170111_233331_236779_D257DEA3)
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
 net/mac80211/main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1822c77f2b1c..c269046aa02b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -913,10 +913,15 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
+		sband->ht_cap.cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
+			             IEEE80211_HT_CAP_SM_PS_SHIFT;
 
 		/* TODO: consider VHT for RX chains, hopefully it's the same */
 	}
-- 
2.11.0
