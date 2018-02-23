Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44398 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750879AbeBWJGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 04:06:08 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3/4] mac80211: support fast-rx with incompatible PS capabilities when PS is disabled
Date: Fri, 23 Feb 2018 10:06:05 +0100
Message-Id: <20180223090606.55726-3-nbd@nbd.name> (sfid-20180223_100631_281774_E260DFE7)
In-Reply-To: <20180223090606.55726-1-nbd@nbd.name>
References: <20180223090606.55726-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When powersave is disabled for the interface, we can do fast-rx anyway.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/cfg.c |  1 +
 net/mac80211/rx.c  | 17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 46028e12e216..6f9d5beec73e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2685,6 +2685,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 	ieee80211_recalc_ps(local);
 	ieee80211_recalc_ps_vif(sdata);
+	ieee80211_check_fast_rx_iface(sdata);
 
 	return 0;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bef83c6bf50c..6e2506a84586 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3750,12 +3750,7 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 		/* 4-addr is harder to deal with, later maybe */
 		if (sdata->u.mgd.use_4addr)
 			goto clear;
-		/* software powersave is a huge mess, avoid all of it */
-		if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK))
-			goto clear;
-		if (ieee80211_hw_check(&local->hw, SUPPORTS_PS) &&
-		    !ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS))
-			goto clear;
+
 		if (sta->sta.tdls) {
 			fastrx.da_offs = offsetof(struct ieee80211_hdr, addr1);
 			fastrx.sa_offs = offsetof(struct ieee80211_hdr, addr2);
@@ -3767,6 +3762,16 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 			fastrx.expected_ds_bits =
 				cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		}
+
+		if (!sdata->u.mgd.powersave)
+		    break;
+
+		/* software powersave is a huge mess, avoid all of it */
+		if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK))
+			goto clear;
+		if (ieee80211_hw_check(&local->hw, SUPPORTS_PS) &&
+		    !ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS))
+			goto clear;
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_AP:
-- 
2.14.2
