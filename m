Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:37284 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbZCEU3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 15:29:01 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] p54: completely ignore rx'd frames with bad FCS
Date: Thu, 5 Mar 2009 21:28:57 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903052128.58173.chunkeey@web.de> (sfid-20090305_212922_580404_91190E3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Passing frames with a bad FCS to the user is an optional feature.
However it doesn't work reliable and strangely not in the native monitor mode?!

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John, this patch series is > 2.6.31+ material.
There's no hurry.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-03-04 22:15:45.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-03-04 22:18:49.000000000 +0100
@@ -735,10 +735,7 @@ static int p54_rx_data(struct ieee80211_
 		return 0;
 
 	if (!(hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_IN_FCS_GOOD))) {
-		if (priv->filter_flags & FIF_FCSFAIL)
-			rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
-		else
-			return 0;
+		return 0;
 	}
 
 	if (hdr->decrypt_status == P54_DECRYPT_OK)
@@ -2211,9 +2208,7 @@ static void p54_configure_filter(struct 
 	struct p54_common *priv = dev->priv;
 
 	*total_flags &= FIF_PROMISC_IN_BSS |
-			FIF_OTHER_BSS |
-			(*total_flags & FIF_PROMISC_IN_BSS ?
-				FIF_FCSFAIL : 0);
+			FIF_OTHER_BSS;
 
 	priv->filter_flags = *total_flags;
 

