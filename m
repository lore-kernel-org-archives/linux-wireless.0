Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:42714 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZDRQaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 12:30:15 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] p54: fix ps-poll delivery in ap mode
Date: Sat, 18 Apr 2009 18:30:13 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200904181830.13889.chunkeey@web.de> (sfid-20090418_183031_237451_8D21C929)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PS-Polled frames must be sent with OUT_NOCANCEL flag set,
or the firmware will reject all of them, at the station is still blacklisted. 

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 2c98904..62ac751 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1533,7 +1533,8 @@ static int p54_tx_fill(struct ieee80211_hw *dev, struct sk_buff *skb,
 
 		if (info->control.sta)
 			*aid = info->control.sta->aid;
-		else
+
+		if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
 			*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 		break;
 	}
