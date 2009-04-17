Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:51912 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbZDQNNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 09:13:46 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: deactivate broken powersave function
Date: Fri, 17 Apr 2009 15:14:22 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904171514.22708.chunkeey@web.de> (sfid-20090417_151350_369497_6005CA13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch deactivates powersave in station mode.

It does not work correctly yet, so the code does more harm than good.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 716c8a0..5368aa3 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -2641,11 +2641,8 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	priv->basic_rate_mask = 0x15f;
 	skb_queue_head_init(&priv->tx_queue);
 	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_SUPPORTS_PS |
-		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_SIGNAL_DBM |
-		     IEEE80211_HW_NOISE_DBM |
-		     IEEE80211_HW_BEACON_FILTER;
+		     IEEE80211_HW_NOISE_DBM;
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				      BIT(NL80211_IFTYPE_ADHOC) |
