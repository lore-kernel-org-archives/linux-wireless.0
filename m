Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:46192 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556Ab1JWTlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 15:41:06 -0400
Date: Sun, 23 Oct 2011 22:40:59 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>, Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: Fix STA supported rate configuration with dummy entry
Message-ID: <20111023194059.GA18385@jm.kir.nu> (sfid-20111023_214110_350963_BBCEF4D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TDLS adds a STA entry before full information about the STA is
available. This leaves rate control algorithms in pretty odd state.
Avoid this by claiming the lowest rate to be supported if no supported
rates are indicated and then update the rate control again when the rate
set changes.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 net/mac80211/cfg.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

Note: Without this, some rate control algorithms can get quite unhappy
with the TDLS entries and maybe other use cases that could result in no
supported rates. For example, minstral has a pretty horrible loop in
init_sample_table() going to n_srates = n_rates(0) - 1...

Are all rate control algorithms fine with the second
rate_control_rate_init() call? That is needed in the TDLS use case where
the supported rate set is known only after the STA entry has been
added. I guess it would be possible to delay addition of the STA entry
for TDLS until the supported rates are known, but I did not look at the
details on what exactly that would require.


diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a9ded52..b9dae9d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -682,7 +682,7 @@ static void ieee80211_send_layer2_update(struct sta_info *sta)
 	netif_rx_ni(skb);
 }
 
-static void sta_apply_parameters(struct ieee80211_local *local,
+static bool sta_apply_parameters(struct ieee80211_local *local,
 				 struct sta_info *sta,
 				 struct station_parameters *params)
 {
@@ -691,6 +691,7 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 mask, set;
+	bool supp_rates_changed = false;
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
@@ -774,6 +775,16 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 					rates |= BIT(j);
 			}
 		}
+		if (rates == 0) {
+			/*
+			 * Rate control algorithms may not like this.. Enable
+			 * the lowest rate even if we do not know the exact
+			 * supported rate set yet.
+			 */
+			rates = BIT(0);
+		}
+		if (sta->sta.supp_rates[local->oper_channel->band] != rates)
+			supp_rates_changed = true;
 		sta->sta.supp_rates[local->oper_channel->band] = rates;
 	}
 
@@ -806,6 +817,8 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 			}
 #endif
 	}
+
+	return supp_rates_changed;
 }
 
 static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
@@ -929,7 +942,8 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		ieee80211_send_layer2_update(sta);
 	}
 
-	sta_apply_parameters(local, sta, params);
+	if (sta_apply_parameters(local, sta, params))
+		rate_control_rate_init(sta);
 
 	rcu_read_unlock();
 
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
