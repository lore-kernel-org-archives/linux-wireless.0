Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:43879 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab2EHXO4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 19:14:56 -0400
Date: Wed, 9 May 2012 01:14:46 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt28xx: Revert
 eccc068e8e84c8fe997115629925e0422a98e4de which causes txpower to be stuck
 at 0
Message-ID: <20120508231446.GC5472@yumi.tdiedrich.de> (sfid-20120509_011500_237550_3644AB26)
References: <20120506153806.GF2774@yumi.tdiedrich.de>
 <CAGXE3d8X3FLoUEjmg+13ggCzVdDHncpr7uwwLweSb+4r87jRpQ@mail.gmail.com>
 <20120508004333.GB5472@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120508004333.GB5472@yumi.tdiedrich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Diedrich wrote:
> Helmut Schaa wrote:
> > On Sun, May 6, 2012 at 5:38 PM, Tobias Diedrich
> > > Before reverting this "iw phy phy0 info" would show "0.0 dBm" as
> > > maximum transmit power for all frequencies.
> > >
> > > After reverting this (and with regdomain set to CH) it is back to
> > > the expected 20 dBm.
> > 
> > Ok, the problem seems to come from the fact that rt2800 doesn't
> > register a per channel
> > max power to mac80211.
> 
> BTW I have a secondary issue that I've today bisected down to some
> change between compat-wireless-2012-04-11 and
> compat-wireless-2012-04-12, but I still need to narrow it down
> further and verify it.
> Even with the max_power issue fixed associating with an rt28xx AP
> running compat-wireless-2012-04-12 or higher doesn't work (IIRC AP
> claims wpa auth succeeded, but STA claims it timed out).
> STA mode worked fine though (But only tested it once on Sunday).

I've bisected it down to commit 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63:
"mac80211: manage AP netdev carrier state"

I verified it against compat-wireless-2012-04-17 (latest OpenWRT
mac80211 package) and after reverting this on top of the other patch
AP mode works again for my rt305x-based APs.

So these are my patches now (The net/wireless/reg.c patch still has
two debug printks in it):

Index: compat-wireless-2012-02-06/net/wireless/reg.c
===================================================================
--- compat-wireless-2012-02-06.orig/net/wireless/reg.c	2012-05-07 19:27:35.966242549 +0200
+++ compat-wireless-2012-02-06/net/wireless/reg.c	2012-05-07 19:42:57.883440781 +0200
@@ -874,7 +874,8 @@
 			map_regdom_flags(reg_rule->flags) | bw_flags;
 		chan->max_antenna_gain = chan->orig_mag =
 			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
-		chan->max_power = chan->orig_mpwr =
+		chan->max_power = chan->orig_mpwr = chan->max_reg_power =
 			(int) MBM_TO_DBM(power_rule->max_eirp);
+		printk(KERN_INFO "max_power = max_reg_power = %d\n", chan->max_power);
 		return;
 	}
@@ -884,7 +884,11 @@
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+	printk(KERN_INFO "max_power = %d, max_reg_power = %d\n", chan->max_power, chan->max_reg_power);
-	chan->max_power = min(chan->max_power, chan->max_reg_power);
+	if (chan->max_power == 0)
+		chan->max_power = chan->max_reg_power;
+	else
+		chan->max_power = min(chan->max_power, chan->max_reg_power);
 }
 
 static void handle_band(struct wiphy *wiphy,
Index: compat-wireless-2012-04-17/net/mac80211/cfg.c
===================================================================
--- compat-wireless-2012-04-17.orig/net/mac80211/cfg.c	2012-05-09 01:00:39.247974053 +0200
+++ compat-wireless-2012-04-17/net/mac80211/cfg.c	2012-05-09 01:02:32.514918371 +0200
@@ -656,10 +656,6 @@
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	netif_carrier_on(dev);
-	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-		netif_carrier_on(vlan->dev);
-
 	return 0;
 }
 
@@ -685,7 +681,7 @@
 
 static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata, *vlan;
+	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -694,10 +690,6 @@
 	if (!old)
 		return -ENOENT;
 
-	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-		netif_carrier_off(vlan->dev);
-	netif_carrier_off(dev);
-
 	RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
 
 	kfree_rcu(old, rcu_head);
Index: compat-wireless-2012-04-17/net/mac80211/iface.c
===================================================================
--- compat-wireless-2012-04-17.orig/net/mac80211/iface.c	2012-05-09 01:00:39.197975402 +0200
+++ compat-wireless-2012-04-17/net/mac80211/iface.c	2012-05-09 01:02:32.514918371 +0200
@@ -356,11 +356,7 @@
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
-		/* no need to tell driver, but set carrier */
-		if (rtnl_dereference(sdata->bss->beacon))
-			netif_carrier_on(dev);
-		else
-			netif_carrier_off(dev);
+		/* no need to tell driver */
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
@@ -411,8 +407,7 @@
 		ieee80211_bss_info_change_notify(sdata, changed);
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_AP)
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 			netif_carrier_off(dev);
 		else
 			netif_carrier_on(dev);
