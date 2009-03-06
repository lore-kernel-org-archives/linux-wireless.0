Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:35989 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZCFBPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 20:15:25 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 8/7] p54: enable power save support
Date: Fri, 6 Mar 2009 02:15:08 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903060215.08580.chunkeey@web.de> (sfid-20090306_021529_185937_DEB1F7ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables power save support on all p54 devices.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
also 2.6.31+ material
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-03-06 01:41:23.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-03-06 02:08:11.000000000 +0100
@@ -2543,6 +2543,8 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->basic_rate_mask = 0x15f;
 	skb_queue_head_init(&priv->tx_queue);
 	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		     IEEE80211_HW_SUPPORTS_PS |
+		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_NOISE_DBM;
 
