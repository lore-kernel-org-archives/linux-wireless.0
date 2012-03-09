Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2CIMMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 07:12:38 -0500
Subject: [PATCH] mac80211: set channel back after disassociating
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Mar 2012 13:12:35 +0100
Message-ID: <1331295155.3491.3.camel@jlt3.sipsolutions.net> (sfid-20120309_131241_812684_78208E11)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As we've discussed, we want to avoid channel changes
while associated. While the part when we actually
associate needs a bit more work, the bit that happens
on disassociating can be changed quite easily. Move
the channel type change later in the disassociate
process to set the channel only after the driver was
told that it's now disassociated.

As the driver could expect powersave to be enabled
only when associated, this thus results in splitting
the config call, but overall what happens makes more
sense this way.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/net/mac80211/mlme.c	2012-03-09 12:47:46.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-09 13:04:21.000000000 +0100
@@ -1374,7 +1374,7 @@ static void ieee80211_set_disassoc(struc
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	u32 changed = 0, config_changed = 0;
+	u32 changed = 0;
 	u8 bssid[ETH_ALEN];
 
 	ASSERT_MGD_MTX(ifmgd);
@@ -1434,9 +1434,6 @@ static void ieee80211_set_disassoc(struc
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;
 
-	/* channel(_type) changes are handled by ieee80211_hw_config */
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
-
 	/* on the next assoc, re-program HT parameters */
 	sdata->ht_opmode_valid = false;
 	memset(&ifmgd->ht_capa, 0, sizeof(ifmgd->ht_capa));
@@ -1449,12 +1446,10 @@ static void ieee80211_set_disassoc(struc
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-		config_changed |= IEEE80211_CONF_CHANGE_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 	local->ps_sdata = NULL;
 
-	ieee80211_hw_config(local, config_changed);
-
 	/* Disable ARP filtering */
 	if (sdata->vif.bss_conf.arp_filter_enabled) {
 		sdata->vif.bss_conf.arp_filter_enabled = false;
@@ -1468,6 +1463,10 @@ static void ieee80211_set_disassoc(struc
 	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	/* channel(_type) changes are handled by ieee80211_hw_config */
+	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
+	ieee80211_hw_config(local, 0);
+
 	/* disassociated - set to defaults now */
 	ieee80211_set_wmm_default(sdata, false);
 


