Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39110 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0DSHQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 03:16:33 -0400
Received: by wyb39 with SMTP id 39so2297052wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 00:16:31 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 1/3] orinoco: implement set_wiphy_params
Date: Mon, 19 Apr 2010 08:16:21 +0100
Message-Id: <1271661383-27839-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... to set fragmentation and RTS thresholds. Also report RTS retry
settings during wiphy init.

Note that the existing semantics for enabling microwave robustness are
preserved on firmwares that have it.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/cfg.c     |   88 +++++++++++++++-
 drivers/net/wireless/orinoco/hw.c      |   26 +++++
 drivers/net/wireless/orinoco/orinoco.h |    2 +
 drivers/net/wireless/orinoco/wext.c    |  183 +-------------------------------
 4 files changed, 120 insertions(+), 179 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 27f2d33..90dd4d0 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -88,7 +88,9 @@ int orinoco_wiphy_register(struct wiphy *wiphy)
 
 	wiphy->rts_threshold = priv->rts_thresh;
 	if (!priv->has_mwo)
-		wiphy->frag_threshold = priv->frag_thresh;
+		wiphy->frag_threshold = priv->frag_thresh + 1;
+	wiphy->retry_short = priv->short_retry_limit;
+	wiphy->retry_long = priv->long_retry_limit;
 
 	return wiphy_register(wiphy);
 }
@@ -196,8 +198,92 @@ static int orinoco_set_channel(struct wiphy *wiphy,
 	return err;
 }
 
+static int orinoco_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	int frag_value = -1;
+	int rts_value = -1;
+	int err = 0;
+
+	if (changed & WIPHY_PARAM_RETRY_SHORT) {
+		/* Setting short retry not supported */
+		err = -EINVAL;
+	}
+
+	if (changed & WIPHY_PARAM_RETRY_LONG) {
+		/* Setting long retry not supported */
+		err = -EINVAL;
+	}
+
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
+		/* Set fragmentation */
+		if (priv->has_mwo) {
+			if (wiphy->frag_threshold < 0)
+				frag_value = 0;
+			else {
+				printk(KERN_WARNING "%s: Fixed fragmentation "
+				       "is not supported on this firmware. "
+				       "Using MWO robust instead.\n",
+				       priv->ndev->name);
+				frag_value = 1;
+			}
+		} else {
+			if (wiphy->frag_threshold < 0)
+				frag_value = 2346;
+			else if ((wiphy->frag_threshold < 257) ||
+				 (wiphy->frag_threshold > 2347))
+				err = -EINVAL;
+			else
+				/* cfg80211 value is 257-2347 (odd only)
+				 * orinoco rid has range 256-2346 (even only) */
+				frag_value = wiphy->frag_threshold & ~0x1;
+		}
+	}
+
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
+		/* Set RTS.
+		 *
+		 * Prism documentation suggests default of 2432,
+		 * and a range of 0-3000.
+		 *
+		 * Current implementation uses 2347 as the default and
+		 * the upper limit.
+		 */
+
+		if (wiphy->rts_threshold < 0)
+			rts_value = 2347;
+		else if (wiphy->rts_threshold > 2347)
+			err = -EINVAL;
+		else
+			rts_value = wiphy->rts_threshold;
+	}
+
+	if (!err) {
+		unsigned long flags;
+
+		if (orinoco_lock(priv, &flags) != 0)
+			return -EBUSY;
+
+		if (frag_value >= 0) {
+			if (priv->has_mwo)
+				priv->mwo_robust = frag_value;
+			else
+				priv->frag_thresh = frag_value;
+		}
+		if (rts_value >= 0)
+			priv->rts_thresh = rts_value;
+
+		err = orinoco_commit(priv);
+
+		orinoco_unlock(priv, &flags);
+	}
+
+	return err;
+}
+
 const struct cfg80211_ops orinoco_cfg_ops = {
 	.change_virtual_intf = orinoco_change_vif,
 	.set_channel = orinoco_set_channel,
 	.scan = orinoco_scan,
+	.set_wiphy_params = orinoco_set_wiphy_params,
 };
diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 883b8f8..24ea4b4 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -374,6 +374,32 @@ int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 		err = hermes_read_wordrec(hw, USER_BAP,
 					  HERMES_RID_CNFPREAMBLE_SYMBOL,
 					  &priv->preamble);
+		if (err) {
+			dev_err(dev, "Failed to read preamble setup\n");
+			goto out;
+		}
+	}
+
+	/* Retry settings */
+	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_SHORTRETRYLIMIT,
+				  &priv->short_retry_limit);
+	if (err) {
+		dev_err(dev, "Failed to read short retry limit\n");
+		goto out;
+	}
+
+	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_LONGRETRYLIMIT,
+				  &priv->long_retry_limit);
+	if (err) {
+		dev_err(dev, "Failed to read long retry limit\n");
+		goto out;
+	}
+
+	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_MAXTRANSMITLIFETIME,
+				  &priv->retry_lifetime);
+	if (err) {
+		dev_err(dev, "Failed to read max retry lifetime\n");
+		goto out;
 	}
 
 out:
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 665ef56..ff6b7b1 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -131,6 +131,8 @@ struct orinoco_private {
 	u16 ap_density, rts_thresh;
 	u16 pm_on, pm_mcast, pm_period, pm_timeout;
 	u16 preamble;
+	u16 short_retry_limit, long_retry_limit;
+	u16 retry_lifetime;
 #ifdef WIRELESS_SPY
 	struct iw_spy_data spy_data; /* iwspy support */
 	struct iw_public_data	wireless_data;
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 57b850e..a1006bf 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -538,125 +538,6 @@ static int orinoco_ioctl_setsens(struct net_device *dev,
 	return -EINPROGRESS;		/* Call commit handler */
 }
 
-static int orinoco_ioctl_setrts(struct net_device *dev,
-				struct iw_request_info *info,
-				struct iw_param *rrq,
-				char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int val = rrq->value;
-	unsigned long flags;
-
-	if (rrq->disabled)
-		val = 2347;
-
-	if ((val < 0) || (val > 2347))
-		return -EINVAL;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	priv->rts_thresh = val;
-	orinoco_unlock(priv, &flags);
-
-	return -EINPROGRESS;		/* Call commit handler */
-}
-
-static int orinoco_ioctl_getrts(struct net_device *dev,
-				struct iw_request_info *info,
-				struct iw_param *rrq,
-				char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-
-	rrq->value = priv->rts_thresh;
-	rrq->disabled = (rrq->value == 2347);
-	rrq->fixed = 1;
-
-	return 0;
-}
-
-static int orinoco_ioctl_setfrag(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_param *frq,
-				 char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int err = -EINPROGRESS;		/* Call commit handler */
-	unsigned long flags;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	if (priv->has_mwo) {
-		if (frq->disabled)
-			priv->mwo_robust = 0;
-		else {
-			if (frq->fixed)
-				printk(KERN_WARNING "%s: Fixed fragmentation "
-				       "is not supported on this firmware. "
-				       "Using MWO robust instead.\n",
-				       dev->name);
-			priv->mwo_robust = 1;
-		}
-	} else {
-		if (frq->disabled)
-			priv->frag_thresh = 2346;
-		else {
-			if ((frq->value < 256) || (frq->value > 2346))
-				err = -EINVAL;
-			else
-				/* must be even */
-				priv->frag_thresh = frq->value & ~0x1;
-		}
-	}
-
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
-static int orinoco_ioctl_getfrag(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_param *frq,
-				 char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
-	int err;
-	u16 val;
-	unsigned long flags;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	if (priv->has_mwo) {
-		err = hermes_read_wordrec(hw, USER_BAP,
-					  HERMES_RID_CNFMWOROBUST_AGERE,
-					  &val);
-		if (err)
-			val = 0;
-
-		frq->value = val ? 2347 : 0;
-		frq->disabled = !val;
-		frq->fixed = 0;
-	} else {
-		err = hermes_read_wordrec(hw, USER_BAP,
-					  HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
-					  &val);
-		if (err)
-			val = 0;
-
-		frq->value = val;
-		frq->disabled = (val >= 2346);
-		frq->fixed = 1;
-	}
-
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
 static int orinoco_ioctl_setrate(struct net_device *dev,
 				 struct iw_request_info *info,
 				 struct iw_param *rrq,
@@ -1201,60 +1082,6 @@ static int orinoco_ioctl_set_mlme(struct net_device *dev,
 	return ret;
 }
 
-static int orinoco_ioctl_getretry(struct net_device *dev,
-				  struct iw_request_info *info,
-				  struct iw_param *rrq,
-				  char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
-	int err = 0;
-	u16 short_limit, long_limit, lifetime;
-	unsigned long flags;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_SHORTRETRYLIMIT,
-				  &short_limit);
-	if (err)
-		goto out;
-
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_LONGRETRYLIMIT,
-				  &long_limit);
-	if (err)
-		goto out;
-
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_MAXTRANSMITLIFETIME,
-				  &lifetime);
-	if (err)
-		goto out;
-
-	rrq->disabled = 0;		/* Can't be disabled */
-
-	/* Note : by default, display the retry number */
-	if ((rrq->flags & IW_RETRY_TYPE) == IW_RETRY_LIFETIME) {
-		rrq->flags = IW_RETRY_LIFETIME;
-		rrq->value = lifetime * 1000;	/* ??? */
-	} else {
-		/* By default, display the min number */
-		if ((rrq->flags & IW_RETRY_LONG)) {
-			rrq->flags = IW_RETRY_LIMIT | IW_RETRY_LONG;
-			rrq->value = long_limit;
-		} else {
-			rrq->flags = IW_RETRY_LIMIT;
-			rrq->value = short_limit;
-			if (short_limit != long_limit)
-				rrq->flags |= IW_RETRY_SHORT;
-		}
-	}
-
- out:
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
 static int orinoco_ioctl_reset(struct net_device *dev,
 			       struct iw_request_info *info,
 			       void *wrqu,
@@ -1528,11 +1355,11 @@ static const iw_handler	orinoco_handler[] = {
 	IW_HANDLER(SIOCGIWESSID,	(iw_handler)orinoco_ioctl_getessid),
 	IW_HANDLER(SIOCSIWRATE,		(iw_handler)orinoco_ioctl_setrate),
 	IW_HANDLER(SIOCGIWRATE,		(iw_handler)orinoco_ioctl_getrate),
-	IW_HANDLER(SIOCSIWRTS,		(iw_handler)orinoco_ioctl_setrts),
-	IW_HANDLER(SIOCGIWRTS,		(iw_handler)orinoco_ioctl_getrts),
-	IW_HANDLER(SIOCSIWFRAG,		(iw_handler)orinoco_ioctl_setfrag),
-	IW_HANDLER(SIOCGIWFRAG,		(iw_handler)orinoco_ioctl_getfrag),
-	IW_HANDLER(SIOCGIWRETRY,	(iw_handler)orinoco_ioctl_getretry),
+	IW_HANDLER(SIOCSIWRTS,		(iw_handler)cfg80211_wext_siwrts),
+	IW_HANDLER(SIOCGIWRTS,		(iw_handler)cfg80211_wext_giwrts),
+	IW_HANDLER(SIOCSIWFRAG,		(iw_handler)cfg80211_wext_siwfrag),
+	IW_HANDLER(SIOCGIWFRAG,		(iw_handler)cfg80211_wext_giwfrag),
+	IW_HANDLER(SIOCGIWRETRY,	(iw_handler)cfg80211_wext_giwretry),
 	IW_HANDLER(SIOCSIWENCODE,	(iw_handler)orinoco_ioctl_setiwencode),
 	IW_HANDLER(SIOCGIWENCODE,	(iw_handler)orinoco_ioctl_getiwencode),
 	IW_HANDLER(SIOCSIWPOWER,	(iw_handler)orinoco_ioctl_setpower),
-- 
1.6.4.4

