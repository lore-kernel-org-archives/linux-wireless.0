Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753143AbYAZVjQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 16:39:16 -0500
From: Helge Deller <deller@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] use is_valid_ether_addr() macro in wireless drivers
Date: Sat, 26 Jan 2008 22:38:18 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801262238.18719.deller@gmx.de> (sfid-20080126_213919_942850_5B9C718A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use is_valid_ether_addr() macro instead of hand-coded checks for 
valid IP address.

Signed-off-by: Helge Deller <deller@gmx.de>

 airo.c      |    5 +----
 atmel.c     |    5 +----
 ipw2100.c   |   10 +---------
 ipw2200.c   |   10 +---------
 orinoco.c   |    5 +----
 wl3501_cs.c |    3 +--
 6 files changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 074055e..714952b 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5977,13 +5977,10 @@ static int airo_set_wap(struct net_device *dev,
 	Cmd cmd;
 	Resp rsp;
 	APListRid APList_rid;
-	static const u8 any[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-	static const u8 off[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
 	if (awrq->sa_family != ARPHRD_ETHER)
 		return -EINVAL;
-	else if (!memcmp(any, awrq->sa_data, ETH_ALEN) ||
-	         !memcmp(off, awrq->sa_data, ETH_ALEN)) {
+	else if (!is_valid_ether_addr(awrq->sa_data)) {
 		memset(&cmd, 0, sizeof(cmd));
 		cmd.cmd=CMD_LOSE_SYNC;
 		if (down_interruptible(&local->sem))
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 059ce3f..6b7a6a3 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -2440,15 +2440,12 @@ static int atmel_set_wap(struct net_device *dev,
 {
 	struct atmel_private *priv = netdev_priv(dev);
 	int i;
-	static const u8 any[] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-	static const u8 off[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 	unsigned long flags;
 
 	if (awrq->sa_family != ARPHRD_ETHER)
 		return -EINVAL;
 
-	if (!memcmp(any, awrq->sa_data, 6) ||
-	    !memcmp(off, awrq->sa_data, 6)) {
+	if (!is_valid_ether_addr(awrq->sa_data)) {
 		del_timer_sync(&priv->management_timer);
 		spin_lock_irqsave(&priv->irqlock, flags);
 		atmel_scan(priv, 1);
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index fc6cdd8..9a7ff0d 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -6897,13 +6897,6 @@ static int ipw2100_wx_set_wap(struct net_device *dev,
 {
 	struct ipw2100_priv *priv = ieee80211_priv(dev);
 	int err = 0;
-
-	static const unsigned char any[] = {
-		0xff, 0xff, 0xff, 0xff, 0xff, 0xff
-	};
-	static const unsigned char off[] = {
-		0x00, 0x00, 0x00, 0x00, 0x00, 0x00
-	};
 	DECLARE_MAC_BUF(mac);
 
 	// sanity checks
@@ -6916,8 +6909,7 @@ static int ipw2100_wx_set_wap(struct net_device *dev,
 		goto done;
 	}
 
-	if (!memcmp(any, wrqu->ap_addr.sa_data, ETH_ALEN) ||
-	    !memcmp(off, wrqu->ap_addr.sa_data, ETH_ALEN)) {
+	if (!is_valid_ether_addr(wrqu->ap_addr.sa_data)) {
 		/* we disable mandatory BSSID association */
 		IPW_DEBUG_WX("exit - disable mandatory BSSID\n");
 		priv->config &= ~CFG_STATIC_BSSID;
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 003f73f..686fe6a 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -8923,18 +8923,10 @@ static int ipw_wx_set_wap(struct net_device *dev,
 	struct ipw_priv *priv = ieee80211_priv(dev);
 	DECLARE_MAC_BUF(mac);
 
-	static const unsigned char any[] = {
-		0xff, 0xff, 0xff, 0xff, 0xff, 0xff
-	};
-	static const unsigned char off[] = {
-		0x00, 0x00, 0x00, 0x00, 0x00, 0x00
-	};
-
 	if (wrqu->ap_addr.sa_family != ARPHRD_ETHER)
 		return -EINVAL;
 	mutex_lock(&priv->mutex);
-	if (!memcmp(any, wrqu->ap_addr.sa_data, ETH_ALEN) ||
-	    !memcmp(off, wrqu->ap_addr.sa_data, ETH_ALEN)) {
+	if (!is_valid_ether_addr(wrqu->ap_addr.sa_data)) {
 		/* we disable mandatory BSSID association */
 		IPW_DEBUG_WX("Setting AP BSSID to ANY\n");
 		priv->config &= ~CFG_STATIC_BSSID;
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index ca6c2da..890baaf 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -2614,15 +2614,12 @@ static int orinoco_ioctl_setwap(struct net_device *dev,
 	struct orinoco_private *priv = netdev_priv(dev);
 	int err = -EINPROGRESS;		/* Call commit handler */
 	unsigned long flags;
-	static const u8 off_addr[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
-	static const u8 any_addr[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
 	/* Enable automatic roaming - no sanity checks are needed */
-	if (memcmp(&ap_addr->sa_data, off_addr, ETH_ALEN) == 0 ||
-	    memcmp(&ap_addr->sa_data, any_addr, ETH_ALEN) == 0) {
+	if (!is_valid_ether_addr(ap_addr->sa_data)) {
 		priv->bssid_fixed = 0;
 		memset(priv->desired_bssid, 0, ETH_ALEN);
 
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 42a36b3..7251e71 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1577,13 +1577,12 @@ static int wl3501_set_wap(struct net_device *dev, struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
 {
 	struct wl3501_card *this = netdev_priv(dev);
-	static const u8 bcast[ETH_ALEN] = { 255, 255, 255, 255, 255, 255 };
 	int rc = -EINVAL;
 
 	/* FIXME: we support other ARPHRDs...*/
 	if (wrqu->ap_addr.sa_family != ARPHRD_ETHER)
 		goto out;
-	if (!memcmp(bcast, wrqu->ap_addr.sa_data, ETH_ALEN)) {
+	if (!is_valid_ether_addr(wrqu->ap_addr.sa_data)) {
 		/* FIXME: rescan? */
 	} else
 		memcpy(this->bssid, wrqu->ap_addr.sa_data, ETH_ALEN);
