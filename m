Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:60546 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab2EFPpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 11:45:17 -0400
Date: Sun, 6 May 2012 17:38:07 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org
Subject: [PATCH] rt28xx: Revert eccc068e8e84c8fe997115629925e0422a98e4de
 which causes txpower to be stuck at 0
Message-ID: <20120506153806.GF2774@yumi.tdiedrich.de> (sfid-20120506_174550_950402_68E389C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Revert eccc068e8e84c8fe997115629925e0422a98e4de which causes txpower
to be stuck at 0.

Recent OpenWRT has txpower stuck at 0 for at least rt28xx, and I
found this commit as the root cause:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de

Before reverting this "iw phy phy0 info" would show "0.0 dBm" as
maximum transmit power for all frequencies.

After reverting this (and with regdomain set to CH) it is back to
the expected 20 dBm.


Signed-off-by: Tobias Diedrich <ranma+openwrt@tdiedrich.de>

Index: package/mac80211/patches/900-revert-txpower-stuck-at-zero-bad-commit.patch
===================================================================
--- package/mac80211/patches/900-revert-txpower-stuck-at-zero-bad-commit.patch	(revision 0)
+++ package/mac80211/patches/900-revert-txpower-stuck-at-zero-bad-commit.patch	(revision 0)
@@ -0,0 +1,30 @@
+Index: compat-wireless-2012-04-26/net/wireless/reg.c
+===================================================================
+--- compat-wireless-2012-04-26.orig/net/wireless/reg.c	2012-05-06 16:39:36.314688959 +0200
++++ compat-wireless-2012-04-26/net/wireless/reg.c	2012-05-06 16:54:11.199571334 +0200
+@@ -892,8 +892,23 @@
+ 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
+ 	chan->max_antenna_gain = min(chan->orig_mag,
+ 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
+-	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+-	chan->max_power = min(chan->max_power, chan->max_reg_power);
++	if (chan->orig_mpwr) {
++		/*
++		 * Devices that have their own custom regulatory domain
++		 * but also use WIPHY_FLAG_STRICT_REGULATORY will follow the
++		 * passed country IE power settings.
++		 */
++		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
++		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
++		    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
++			chan->max_power =
++				MBM_TO_DBM(power_rule->max_eirp);
++		} else {
++			chan->max_power = min(chan->orig_mpwr,
++				(int) MBM_TO_DBM(power_rule->max_eirp));
++		}
++	} else
++		chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+ }
+ 
+ static void handle_band(struct wiphy *wiphy,


