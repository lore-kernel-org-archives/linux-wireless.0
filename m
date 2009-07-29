Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:55704 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZG2HQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 03:16:51 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [PATCH] orinoco: enable cfg80211 "set_channel" operation
Date: Wed, 29 Jul 2009 09:16:31 +0200
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	orinoco-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
References: <200907281634.26104.hs4233@mail.mn-solutions.de> <4A6F270A.7030002@gmail.com>
In-Reply-To: <4A6F270A.7030002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907290916.31603.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 28 July 2009 18:27:54 Dave wrote:
> You can also eliminate orinoco_ioctl_setfreq from wext.c with
> this change.

You mean this ?!?

--- linux-wl.orig/drivers/net/wireless/orinoco/wext.c
+++ linux-wl/drivers/net/wireless/orinoco/wext.c
@@ -372,55 +372,6 @@
 	return 0;
 }
 
-static int orinoco_ioctl_setfreq(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_freq *frq,
-				 char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int chan = -1;
-	unsigned long flags;
-	int err = -EINPROGRESS;		/* Call commit handler */
-
-	/* In infrastructure mode the AP sets the channel */
-	if (priv->iw_mode == NL80211_IFTYPE_STATION)
-		return -EBUSY;
-
-	if ((frq->e == 0) && (frq->m <= 1000)) {
-		/* Setting by channel number */
-		chan = frq->m;
-	} else {
-		/* Setting by frequency */
-		int denom = 1;
-		int i;
-
-		/* Calculate denominator to rescale to MHz */
-		for (i = 0; i < (6 - frq->e); i++)
-			denom *= 10;
-
-		chan = ieee80211_freq_to_dsss_chan(frq->m / denom);
-	}
-
-	if ((chan < 1) || (chan > NUM_CHANNELS) ||
-	     !(priv->channel_mask & (1 << (chan-1))))
-		return -EINVAL;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	priv->channel = chan;
-	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
-		/* Fast channel change - no commit if successful */
-		hermes_t *hw = &priv->hw;
-		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
-					    HERMES_TEST_SET_CHANNEL,
-					chan, NULL);
-	}
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
 static int orinoco_ioctl_getfreq(struct net_device *dev,
 				 struct iw_request_info *info,
 				 struct iw_freq *frq,
@@ -1481,7 +1432,6 @@
 static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCSIWCOMMIT,	orinoco_ioctl_commit),
 	STD_IW_HANDLER(SIOCGIWNAME,	cfg80211_wext_giwname),
-	STD_IW_HANDLER(SIOCSIWFREQ,	orinoco_ioctl_setfreq),
 	STD_IW_HANDLER(SIOCGIWFREQ,	orinoco_ioctl_getfreq),
 	STD_IW_HANDLER(SIOCSIWMODE,	cfg80211_wext_siwmode),
 	STD_IW_HANDLER(SIOCGIWMODE,	cfg80211_wext_giwmode),

I tried, but with then an "iwconfig eth1 channel 1" gave me an 
error. I did not investigate this further.

-- 
http://www.holgerschurig.de
