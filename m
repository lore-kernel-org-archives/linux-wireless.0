Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079AbZFRWXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:23:00 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:23:02 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 23/23] orinoco: remove WE nickname support
Date: Thu, 18 Jun 2009 23:21:35 +0100
Message-Id: <1245363695-8289-24-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/wext.c |   43 -----------------------------------
 1 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 21db578..b6ff3db 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -372,47 +372,6 @@ static int orinoco_ioctl_getessid(struct net_device *dev,
 	return 0;
 }
 
-static int orinoco_ioctl_setnick(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_point *nrq,
-				 char *nickbuf)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	unsigned long flags;
-
-	if (nrq->length > IW_ESSID_MAX_SIZE)
-		return -E2BIG;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	memset(priv->nick, 0, sizeof(priv->nick));
-	memcpy(priv->nick, nickbuf, nrq->length);
-
-	orinoco_unlock(priv, &flags);
-
-	return -EINPROGRESS;		/* Call commit handler */
-}
-
-static int orinoco_ioctl_getnick(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_point *nrq,
-				 char *nickbuf)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	unsigned long flags;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	memcpy(nickbuf, priv->nick, IW_ESSID_MAX_SIZE);
-	orinoco_unlock(priv, &flags);
-
-	nrq->length = strlen(priv->nick);
-
-	return 0;
-}
-
 static int orinoco_ioctl_setfreq(struct net_device *dev,
 				 struct iw_request_info *info,
 				 struct iw_freq *frq,
@@ -1539,8 +1498,6 @@ static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCGIWSCAN,	cfg80211_wext_giwscan),
 	STD_IW_HANDLER(SIOCSIWESSID,	orinoco_ioctl_setessid),
 	STD_IW_HANDLER(SIOCGIWESSID,	orinoco_ioctl_getessid),
-	STD_IW_HANDLER(SIOCSIWNICKN,	orinoco_ioctl_setnick),
-	STD_IW_HANDLER(SIOCGIWNICKN,	orinoco_ioctl_getnick),
 	STD_IW_HANDLER(SIOCSIWRATE,	orinoco_ioctl_setrate),
 	STD_IW_HANDLER(SIOCGIWRATE,	orinoco_ioctl_getrate),
 	STD_IW_HANDLER(SIOCSIWRTS,	orinoco_ioctl_setrts),
-- 
1.6.0.6

