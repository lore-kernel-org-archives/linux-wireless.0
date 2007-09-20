Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXITP7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 11:59:53 -0400
Subject: [PATCH] mac80211: fix bugs with turbo removal
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 20 Sep 2007 18:00:16 +0200
Message-Id: <1190304016.18521.80.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It appears that I sent out/pushed the wrong patch, in the patch
that was merged some conversion were missing. This also adds
some sanity checks in places and fixes a thinko.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
This only applies to wireless-dev since all the ioctls that are touched
are not in mainline.

 net/mac80211/ieee80211_ioctl.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-20 17:34:41.731572754 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-20 17:36:45.941573677 +0200
@@ -158,7 +158,7 @@ static int ieee80211_ioctl_get_hw_featur
 		left -= sizeof(*hdr) + clen + rlen;
 
 		hdr = (struct hostapd_ioctl_hw_modes_hdr *) pos;
-		hdr->mode = mode->mode;
+		hdr->mode = mode_to_hostapd_mode(mode->mode);
 		hdr->num_channels = mode->num_channels;
 		hdr->num_rates = mode->num_rates;
 
@@ -714,10 +714,13 @@ static int ieee80211_ioctl_set_rate_sets
 	int i, mode, num_supp, num_basic, *supp, *basic, *prev;
 	struct ieee80211_hw_mode *hw_mode;
 
-	mode = param->u.set_rate_sets.mode;
+	mode = hostapd_mode_to_mode(param->u.set_rate_sets.mode);
 	num_supp = param->u.set_rate_sets.num_supported_rates;
 	num_basic = param->u.set_rate_sets.num_basic_rates;
 
+	if (mode < 0 || mode >= NUM_IEEE80211_MODES)
+		return -EINVAL;
+
 	if (left < (num_supp + num_basic) * 2) {
 		printk(KERN_WARNING "%s: invalid length in hostapd set rate "
 		       "sets ioctl (%d != %d)\n", dev->name, left,
@@ -878,7 +881,8 @@ static int ieee80211_ioctl_set_channel_f
 	int i;
 
 	list_for_each_entry(mode, &local->modes_list, list) {
-		if (mode->mode == param->u.set_channel_flag.mode)
+		if (mode->mode ==
+		    hostapd_mode_to_mode(param->u.set_channel_flag.mode))
 			goto found;
 	}
 	return -ENOENT;
@@ -1725,7 +1729,10 @@ static int ieee80211_ioctl_prism2_param(
 		break;
 
 	case PRISM2_PARAM_NEXT_MODE:
-		local->next_mode = hostapd_mode_to_mode(value);
+		mode = hostapd_mode_to_mode(value);
+		if (mode >= NUM_IEEE80211_MODES)
+			return -EINVAL;
+		local->next_mode = mode;
 		break;
 
 	case PRISM2_PARAM_EAPOL:
@@ -1753,13 +1760,13 @@ static int ieee80211_ioctl_prism2_param(
 		break;
 
 	case PRISM2_PARAM_HW_MODES:
-		mode = 1;
+		mode = 0;
 		local->enabled_modes = 0;
 		while (value) {
 			if (value & 1)
 				local->enabled_modes |=
-					hostapd_mode_to_mode(mode);
-			mode <<= 1;
+					(1 << hostapd_mode_to_mode(mode));
+			mode += 1;
 			value >>= 1;
 		}
 		break;
@@ -1872,7 +1879,7 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = 0;
 		while (mode < NUM_IEEE80211_MODES) {
 			if (local->enabled_modes & (1<<mode))
-				*param |= mode_to_hostapd_mode(1<<mode);
+				*param |= 1 << mode_to_hostapd_mode(mode);
 			mode++;
 		}
 		break;


