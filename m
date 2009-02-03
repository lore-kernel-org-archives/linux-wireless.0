Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43284 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZBCUlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 15:41:49 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so2846565ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 12:41:49 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 04/17] orinoco: remove unnecessary braces
Date: Tue,  3 Feb 2009 20:40:26 +0000
Message-Id: <1233693639-8608-5-git-send-email-kilroyd@googlemail.com> (sfid-20090203_214152_569863_5AF44308)
In-Reply-To: <1233693639-8608-4-git-send-email-kilroyd@googlemail.com>
References: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-2-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-3-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-4-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the following checkpatch warnings

WARNING: braces {} are not necessary for any arm of this statement
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 5781ee0..120c9d9 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -3497,9 +3497,8 @@ static int orinoco_init(struct net_device *dev)
 	/* Get initial AP density */
 	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFSYSTEMSCALE,
 				  &priv->ap_density);
-	if (err || priv->ap_density < 1 || priv->ap_density > 3) {
+	if (err || priv->ap_density < 1 || priv->ap_density > 3)
 		priv->has_sensitivity = 0;
-	}
 
 	/* Get initial RTS threshold */
 	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFRTSTHRESHOLD,
@@ -3811,9 +3810,8 @@ static int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
 	*numrates = num;
 	num = min(num, max);
 
-	for (i = 0; i < num; i++) {
+	for (i = 0; i < num; i++)
 		rates[i] = (p[i] & 0x7f) * 500000; /* convert to bps */
-	}
 
 	return 0;
 }
@@ -4130,11 +4128,11 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 			index = priv->tx_key;
 
 		/* Adjust key length to a supported value */
-		if (erq->length > SMALL_KEY_SIZE) {
+		if (erq->length > SMALL_KEY_SIZE)
 			xlen = LARGE_KEY_SIZE;
-		} else if (erq->length > 0) {
+		else if (erq->length > 0)
 			xlen = SMALL_KEY_SIZE;
-		} else
+		else
 			xlen = 0;
 
 		/* Switch on WEP if off */
@@ -4256,9 +4254,8 @@ static int orinoco_ioctl_setessid(struct net_device *dev,
 	memset(priv->desired_essid, 0, sizeof(priv->desired_essid));
 
 	/* If not ANY, get the new ESSID */
-	if (erq->flags) {
+	if (erq->flags)
 		memcpy(priv->desired_essid, essidbuf, erq->length);
-	}
 
 	orinoco_unlock(priv, &flags);
 
@@ -4393,9 +4390,8 @@ static int orinoco_ioctl_getfreq(struct net_device *dev,
 
 	/* Locking done in there */
 	tmp = orinoco_hw_get_freq(priv);
-	if (tmp < 0) {
+	if (tmp < 0)
 		return tmp;
-	}
 
 	frq->m = tmp * 100000;
 	frq->e = 1;
-- 
1.6.0.6

