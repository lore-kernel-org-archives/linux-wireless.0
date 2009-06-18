Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbZFRWWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:22:47 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:22:50 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 20/23] orinoco: convert mode setting to cfg80211
Date: Thu, 18 Jun 2009 23:21:32 +0100
Message-Id: <1245363695-8289-21-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/cfg.c     |   46 +++++++++++++++++++-
 drivers/net/wireless/orinoco/hw.c      |   12 +++--
 drivers/net/wireless/orinoco/main.c    |   15 +++---
 drivers/net/wireless/orinoco/orinoco.h |    2 +-
 drivers/net/wireless/orinoco/wext.c    |   75 +++----------------------------
 5 files changed, 70 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 9a616dd..9e59d90 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -93,6 +93,50 @@ int orinoco_wiphy_register(struct wiphy *wiphy)
 	return wiphy_register(wiphy);
 }
 
-const struct cfg80211_ops orinoco_cfg_ops = {
+static int orinoco_change_vif(struct wiphy *wiphy, struct net_device *dev,
+			      enum nl80211_iftype type, u32 *flags,
+			      struct vif_params *params)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	int err = 0;
+	unsigned long lock;
+
+	if (orinoco_lock(priv, &lock) != 0)
+		return -EBUSY;
+
+	switch (type) {
+	case NL80211_IFTYPE_ADHOC:
+		if (!priv->has_ibss && !priv->has_port3)
+			err = -EINVAL;
+		break;
+
+	case NL80211_IFTYPE_STATION:
+		break;
+
+	case NL80211_IFTYPE_MONITOR:
+		if (priv->broken_monitor && !force_monitor) {
+			printk(KERN_WARNING "%s: Monitor mode support is "
+			       "buggy in this firmware, not enabling\n",
+			       wiphy_name(wiphy));
+			err = -EINVAL;
+		}
+		break;
+
+	default:
+		err = -EINVAL;
+	}
 
+	if (!err) {
+		priv->iw_mode = type;
+		set_port_type(priv);
+		err = orinoco_commit(priv);
+	}
+
+	orinoco_unlock(priv, &lock);
+
+	return err;
+}
+
+const struct cfg80211_ops orinoco_cfg_ops = {
+	.change_virtual_intf = orinoco_change_vif,
 };
diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 56627d9..4600fe4 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -7,7 +7,7 @@
 #include <linux/if_arp.h>
 #include <linux/ieee80211.h>
 #include <linux/wireless.h>
-
+#include <net/cfg80211.h>
 #include "hermes.h"
 #include "hermes_rid.h"
 #include "orinoco.h"
@@ -409,6 +409,7 @@ void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic)
 int orinoco_hw_program_rids(struct orinoco_private *priv)
 {
 	struct net_device *dev = priv->ndev;
+	struct wireless_dev *wdev = netdev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	int err;
 	struct hermes_idstring idbuf;
@@ -431,7 +432,7 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 		return err;
 	}
 	/* Set the channel/frequency */
-	if (priv->channel != 0 && priv->iw_mode != IW_MODE_INFRA) {
+	if (priv->channel != 0 && priv->iw_mode != NL80211_IFTYPE_STATION) {
 		err = hermes_write_wordrec(hw, USER_BAP,
 					   HERMES_RID_CNFOWNCHANNEL,
 					   priv->channel);
@@ -612,7 +613,7 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 		}
 	}
 
-	if (priv->iw_mode == IW_MODE_MONITOR) {
+	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		/* Enable monitor mode */
 		dev->type = ARPHRD_IEEE80211;
 		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
@@ -630,6 +631,9 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 	priv->promiscuous = 0;
 	priv->mc_count = 0;
 
+	/* Record mode change */
+	wdev->iftype = priv->iw_mode;
+
 	return 0;
 }
 
@@ -884,7 +888,7 @@ int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 		} else
 			master_wep_flag = 0;
 
-		if (priv->iw_mode == IW_MODE_MONITOR)
+		if (priv->iw_mode == NL80211_IFTYPE_MONITOR)
 			master_wep_flag |= HERMES_WEP_HOST_DECRYPT;
 
 		/* Master WEP setting : on/off */
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index dab6649..ebf92ae 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -222,11 +222,11 @@ static int __orinoco_commit(struct orinoco_private *priv);
 void set_port_type(struct orinoco_private *priv)
 {
 	switch (priv->iw_mode) {
-	case IW_MODE_INFRA:
+	case NL80211_IFTYPE_STATION:
 		priv->port_type = 1;
 		priv->createibss = 0;
 		break;
-	case IW_MODE_ADHOC:
+	case NL80211_IFTYPE_ADHOC:
 		if (priv->prefer_port3) {
 			priv->port_type = 3;
 			priv->createibss = 0;
@@ -235,7 +235,7 @@ void set_port_type(struct orinoco_private *priv)
 			priv->createibss = 1;
 		}
 		break;
-	case IW_MODE_MONITOR:
+	case NL80211_IFTYPE_MONITOR:
 		priv->port_type = 3;
 		priv->createibss = 0;
 		break;
@@ -359,7 +359,8 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 	}
 
-	if (!netif_carrier_ok(dev) || (priv->iw_mode == IW_MODE_MONITOR)) {
+	if (!netif_carrier_ok(dev) ||
+	    (priv->iw_mode == NL80211_IFTYPE_MONITOR)) {
 		/* Oops, the firmware hasn't established a connection,
 		   silently drop the packet (this seems to be the
 		   safest approach). */
@@ -820,7 +821,7 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 	}
 
 	/* Handle frames in monitor mode */
-	if (priv->iw_mode == IW_MODE_MONITOR) {
+	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		orinoco_rx_monitor(dev, rxfid, desc);
 		goto out;
 	}
@@ -1331,7 +1332,7 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		u16 newstatus;
 		int connected;
 
-		if (priv->iw_mode == IW_MODE_MONITOR)
+		if (priv->iw_mode == NL80211_IFTYPE_MONITOR)
 			break;
 
 		if (len != sizeof(linkstatus)) {
@@ -1981,7 +1982,7 @@ int orinoco_init(struct orinoco_private *priv)
 	}
 
 	/* Set up the default configuration */
-	priv->iw_mode = IW_MODE_INFRA;
+	priv->iw_mode = NL80211_IFTYPE_STATION;
 	/* By default use IEEE/IBSS ad-hoc mode if we have it */
 	priv->prefer_port3 = priv->has_port3 && (!priv->has_ibss);
 	set_port_type(priv);
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 4ee85f8..0c89c28 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -121,7 +121,7 @@ struct orinoco_private {
 	unsigned int broken_monitor:1;
 
 	/* Configuration paramaters */
-	u32 iw_mode;
+	enum nl80211_iftype iw_mode;
 	int prefer_port3;
 	u16 encode_alg, wep_restrict, tx_key;
 	struct orinoco_key keys[ORINOCO_MAX_KEYS];
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 4c20b1d..9cd991a 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -52,7 +52,7 @@ static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 	 * here so we're not safe to sleep here. */
 	hermes_inquire(hw, HERMES_INQ_TALLIES);
 
-	if (priv->iw_mode == IW_MODE_ADHOC) {
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC) {
 		memset(&wstats->qual, 0, sizeof(wstats->qual));
 		/* If a spy address is defined, we report stats of the
 		 * first spy address - Jean II */
@@ -124,7 +124,7 @@ static int orinoco_ioctl_setwap(struct net_device *dev,
 		goto out;
 	}
 
-	if (priv->iw_mode != IW_MODE_INFRA) {
+	if (priv->iw_mode != NL80211_IFTYPE_STATION) {
 		printk(KERN_WARNING "%s: Manual roaming supported only in "
 		       "managed mode\n", dev->name);
 		err = -EOPNOTSUPP;
@@ -172,65 +172,6 @@ static int orinoco_ioctl_getwap(struct net_device *dev,
 	return err;
 }
 
-static int orinoco_ioctl_setmode(struct net_device *dev,
-				 struct iw_request_info *info,
-				 u32 *mode,
-				 char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int err = -EINPROGRESS;		/* Call commit handler */
-	unsigned long flags;
-
-	if (priv->iw_mode == *mode)
-		return 0;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	switch (*mode) {
-	case IW_MODE_ADHOC:
-		if (!priv->has_ibss && !priv->has_port3)
-			err = -EOPNOTSUPP;
-		break;
-
-	case IW_MODE_INFRA:
-		break;
-
-	case IW_MODE_MONITOR:
-		if (priv->broken_monitor && !force_monitor) {
-			printk(KERN_WARNING "%s: Monitor mode support is "
-			       "buggy in this firmware, not enabling\n",
-			       dev->name);
-			err = -EOPNOTSUPP;
-		}
-		break;
-
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	if (err == -EINPROGRESS) {
-		priv->iw_mode = *mode;
-		set_port_type(priv);
-	}
-
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
-static int orinoco_ioctl_getmode(struct net_device *dev,
-				 struct iw_request_info *info,
-				 u32 *mode,
-				 char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-
-	*mode = priv->iw_mode;
-	return 0;
-}
-
 static int orinoco_ioctl_getiwrange(struct net_device *dev,
 				    struct iw_request_info *info,
 				    struct iw_point *rrq,
@@ -280,7 +221,7 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
 	if (priv->has_wpa)
 		range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_CIPHER_TKIP;
 
-	if ((priv->iw_mode == IW_MODE_ADHOC) && (!SPY_NUMBER(priv))) {
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) && (!SPY_NUMBER(priv))) {
 		/* Quality stats meaningless in ad-hoc mode */
 	} else {
 		range->max_qual.qual = 0x8b - 0x2f;
@@ -596,7 +537,7 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 	int err = -EINPROGRESS;		/* Call commit handler */
 
 	/* In infrastructure mode the AP sets the channel */
-	if (priv->iw_mode == IW_MODE_INFRA)
+	if (priv->iw_mode == NL80211_IFTYPE_STATION)
 		return -EBUSY;
 
 	if ((frq->e == 0) && (frq->m <= 1000)) {
@@ -622,7 +563,7 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 		return -EBUSY;
 
 	priv->channel = chan;
-	if (priv->iw_mode == IW_MODE_MONITOR) {
+	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		/* Fast channel change - no commit if successful */
 		hermes_t *hw = &priv->hw;
 		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
@@ -1673,7 +1614,7 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 	/* In monitor mode, the scan results are always empty.
 	 * Probe responses are passed to the driver as received
 	 * frames and could be processed in software. */
-	if (priv->iw_mode == IW_MODE_MONITOR) {
+	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2209,8 +2150,8 @@ static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCGIWNAME,	cfg80211_wext_giwname),
 	STD_IW_HANDLER(SIOCSIWFREQ,	orinoco_ioctl_setfreq),
 	STD_IW_HANDLER(SIOCGIWFREQ,	orinoco_ioctl_getfreq),
-	STD_IW_HANDLER(SIOCSIWMODE,	orinoco_ioctl_setmode),
-	STD_IW_HANDLER(SIOCGIWMODE,	orinoco_ioctl_getmode),
+	STD_IW_HANDLER(SIOCSIWMODE,	cfg80211_wext_siwmode),
+	STD_IW_HANDLER(SIOCGIWMODE,	cfg80211_wext_giwmode),
 	STD_IW_HANDLER(SIOCSIWSENS,	orinoco_ioctl_setsens),
 	STD_IW_HANDLER(SIOCGIWSENS,	orinoco_ioctl_getsens),
 	STD_IW_HANDLER(SIOCGIWRANGE,	orinoco_ioctl_getiwrange),
-- 
1.6.0.6

