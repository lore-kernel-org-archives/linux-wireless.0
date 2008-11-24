Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:34978 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYKXNwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 08:52:51 -0500
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate02.web.de (Postfix) with ESMTP id 5868DF7066A8
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 14:52:50 +0100 (CET)
Received: from [129.13.72.197] (helo=blech.mobile)
	by smtp08.web.de with esmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226)
	id 1L4bru-0003Yw-00
	for linux-wireless@vger.kernel.org; Mon, 24 Nov 2008 14:52:50 +0100
Received: from localhost (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTP id 2133B17D030
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 14:52:53 +0100 (CET)
Received: from blech.mobile ([127.0.0.1])
	by localhost (blech.mobile [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FZlqoU8l6Ii9 for <linux-wireless@vger.kernel.org>;
	Mon, 24 Nov 2008 14:52:52 +0100 (CET)
Received: from blech.mobile (blech.mobile [127.0.1.1])
	by blech.mobile (Postfix) with ESMTPS id 4FEAF6C00B
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 14:52:52 +0100 (CET)
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: fix wmm queue settings
From: Christian Lamparter <chunkeey@web.de>
Date: Mon, 24 Nov 2008 14:52:51 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811241452.51655.chunkeey@web.de> (sfid-20081124_145255_579319_7804A1DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression (introduced by 453fae72b2f19
"p54: more definitions form lmac_longbow.h and pda.h" )

It turned out that the "ret" variable wasn't initialized and
this caused the following warnings/errors to appear:

wmaster1: failed to set TX queue parameters for queue 2
wmaster1: failed to set TX queue parameters for queue 3
wmaster1: failed to set TX queue parameters for queue 1
wmaster1: failed to set TX queue parameters for queue 0

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
arg, got the wrong mailing list... sorry!
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-24 00:01:27.899490373 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-24 13:07:09.053832187 +0100
@@ -1729,10 +1729,9 @@ static int p54_conf_tx(struct ieee80211_
 	if ((params) && !(queue > 4)) {
 		P54_SET_QUEUE(priv->qos_params[queue], params->aifs,
 			params->cw_min, params->cw_max, params->txop);
+		ret = p54_set_edcf(dev);
 	} else
 		ret = -EINVAL;
-	if (!ret)
-		ret = p54_set_edcf(dev);
 	mutex_unlock(&priv->conf_mutex);
 	return ret;
 }
