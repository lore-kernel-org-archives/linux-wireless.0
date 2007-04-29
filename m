Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44839 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754489AbXD2AdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 20:33:05 -0400
Received: from logostar.upir.cz (r2u241.net.upc.cz [62.245.84.241])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.suse.cz (SUSE LINUX ESMTP Mailer) with ESMTP id 67C09628062
	for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2007 02:33:04 +0200 (CEST)
Date: Sun, 29 Apr 2007 02:33:03 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mac80211: remove test_mode
Message-ID: <20070429023303.6106567b@logostar.upir.cz>
In-Reply-To: <20070429023215.40c2aea7@logostar.upir.cz>
References: <20070429023215.40c2aea7@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Testing of a radio is a driver-specific debug feature and doesn't belong to
the stack. Drivers should implement it using debugfs.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 include/net/mac80211.h         |   28 ------------------
 net/mac80211/hostapd_ioctl.h   |    2 -
 net/mac80211/ieee80211_ioctl.c |   63 -----------------------------------------
 3 files changed, 93 deletions(-)

--- dscape.orig/include/net/mac80211.h
+++ dscape/include/net/mac80211.h
@@ -687,12 +687,6 @@ struct ieee80211_ops {
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
 
-	/* Enable/disable test modes; mode = IEEE80211_TEST_* */
-	int (*test_mode)(struct ieee80211_hw *hw, int mode);
-
-	/* Configuration of test parameters */
-	int (*test_param)(struct ieee80211_hw *hw, int param, int value);
-
 	/* For devices that generate their own beacons and probe response
 	 * or association responses this updates the state of privacy_invoked
 	 * returns 0 for success or an error number */
@@ -1056,28 +1050,6 @@ void ieee80211_scan_completed(struct iee
 int  ieee80211_radar_status(struct ieee80211_hw *hw, int channel,
 			    int radar, int radar_type);
 
-/* Test modes */
-enum {
-	IEEE80211_TEST_DISABLE = 0 /* terminate testing */,
-	IEEE80211_TEST_UNMASK_CHANNELS = 1 /* allow all channels to be used */,
-	IEEE80211_TEST_CONTINUOUS_TX = 2,
-};
-
-/* Test parameters */
-enum {
-	/* TX power in hardware specific raw value */
-	IEEE80211_TEST_PARAM_TX_POWER_RAW = 0,
-	/* TX rate in hardware specific raw value */
-	IEEE80211_TEST_PARAM_TX_RATE_RAW = 1,
-	/* Continuous TX pattern (32-bit) */
-	IEEE80211_TEST_PARAM_TX_PATTERN = 2,
-	/* TX power in 0.1 dBm, 100 = 10 dBm */
-	IEEE80211_TEST_PARAM_TX_POWER = 3,
-	/* TX rate in 100 kbps, 540 = 54 Mbps */
-	IEEE80211_TEST_PARAM_TX_RATE = 4,
-	IEEE80211_TEST_PARAM_TX_ANT_SEL_RAW = 5,
-};
-
 /* return a pointer to the source address (SA) */
 static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
 {
--- dscape.orig/net/mac80211/hostapd_ioctl.h
+++ dscape/net/mac80211/hostapd_ioctl.h
@@ -20,7 +20,6 @@
 #define PRISM2_IOCTL_PRISM2_PARAM (SIOCIWFIRSTPRIV + 0)
 #define PRISM2_IOCTL_GET_PRISM2_PARAM (SIOCIWFIRSTPRIV + 1)
 #define PRISM2_IOCTL_HOSTAPD (SIOCIWFIRSTPRIV + 3)
-#define PRISM2_IOCTL_TEST_PARAM (SIOCIWFIRSTPRIV + 4)
 
 /* PRISM2_IOCTL_PRISM2_PARAM ioctl() subtypes:
  * This table is no longer added to, the whole sub-ioctl
@@ -41,7 +40,6 @@ enum {
 	PRISM2_PARAM_DROP_UNENCRYPTED = 1002,
 	PRISM2_PARAM_PREAMBLE = 1003,
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
-	PRISM2_PARAM_TEST_MODE = 1007,
 	PRISM2_PARAM_NEXT_MODE = 1008,
 	PRISM2_PARAM_CLEAR_KEYS = 1009,
 	PRISM2_PARAM_RADIO_ENABLED = 1010,
--- dscape.orig/net/mac80211/ieee80211_ioctl.c
+++ dscape/net/mac80211/ieee80211_ioctl.c
@@ -2189,38 +2189,6 @@ static int ieee80211_ioctl_giwretry(stru
 	return 0;
 }
 
-
-static void ieee80211_ioctl_unmask_channels(struct ieee80211_local *local)
-{
-	struct ieee80211_hw_mode *mode;
-	int c;
-
-	list_for_each_entry(mode, &local->modes_list, list) {
-		for (c = 0; c < mode->num_channels; c++) {
-			struct ieee80211_channel *chan = &mode->channels[c];
-			chan->flag |= IEEE80211_CHAN_W_SCAN;
-		}
-	}
-}
-
-
-static int ieee80211_ioctl_test_mode(struct net_device *dev, int mode)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int ret = -EOPNOTSUPP;
-
-	if (mode == IEEE80211_TEST_UNMASK_CHANNELS) {
-		ieee80211_ioctl_unmask_channels(local);
-		ret = 0;
-	}
-
-	if (local->ops->test_mode)
-		ret = local->ops->test_mode(local_to_hw(local), mode);
-
-	return ret;
-}
-
-
 static int ieee80211_ioctl_clear_keys(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -2537,10 +2505,6 @@ static int ieee80211_ioctl_prism2_param(
 					local_to_hw(local), value);
 		break;
 
-	case PRISM2_PARAM_TEST_MODE:
-		ret = ieee80211_ioctl_test_mode(dev, value);
-		break;
-
 	case PRISM2_PARAM_NEXT_MODE:
 		local->next_mode = value;
 		break;
@@ -2871,27 +2835,6 @@ static int ieee80211_ioctl_get_prism2_pa
 	return ret;
 }
 
-
-static int ieee80211_ioctl_test_param(struct net_device *dev,
-				      struct iw_request_info *info,
-				      void *wrqu, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int *i = (int *) extra;
-	int param = *i;
-	int value = *(i + 1);
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	if (local->ops->test_param)
-		return local->ops->test_param(local_to_hw(local),
-					     param, value);
-
-	return -EOPNOTSUPP;
-}
-
-
 static int ieee80211_ioctl_siwmlme(struct net_device *dev,
 				   struct iw_request_info *info,
 				   struct iw_point *data, char *extra)
@@ -3177,8 +3120,6 @@ static const struct iw_priv_args ieee802
 	{ PRISM2_IOCTL_GET_PRISM2_PARAM,
 	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
 	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "get_param" },
-	{ PRISM2_IOCTL_TEST_PARAM,
-	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 2, 0, "test_param" },
 };
 
 
@@ -3190,10 +3131,6 @@ int ieee80211_ioctl(struct net_device *d
 	switch (cmd) {
 		/* Private ioctls (iwpriv) that have not yet been converted
 		 * into new wireless extensions API */
-	case PRISM2_IOCTL_TEST_PARAM:
-		ret = ieee80211_ioctl_test_param(dev, NULL, &wrq->u,
-						 (char *) &wrq->u);
-		break;
 	case PRISM2_IOCTL_HOSTAPD:
 		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
 		else ret = ieee80211_ioctl_priv_hostapd(dev, &wrq->u.data);
