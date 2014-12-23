Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49227 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbaLWOgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 09:36:42 -0500
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	<janusz.dziedzic@tieto.com>, <johannes@sipsolutions.net>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH] cfg80211: check for carrier state only when offchanel CAC supported
Date: Wed, 24 Dec 2014 01:35:59 +0530
Message-ID: <1419365159-6577-1-git-send-email-patila@marvell.com> (sfid-20141223_153645_886702_7A953FFA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checking for carrier state during start_radar_detection is needed
only for devices which support offchannel CAC.
This patch adds one more condition while checking for carrier state
to see if offchanel CAC is supported, else we need not check carrier
state.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 include/net/cfg80211.h | 2 ++
 net/wireless/nl80211.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4ebb816..1b80302 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2740,6 +2740,7 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
  * @WIPHY_FLAG_HAS_CHANNEL_SWITCH: Device supports channel switch in
  *	beaconing mode (AP, IBSS, Mesh, ...).
+ * @WIPHY_FLAG_OFFCHAN_CAC: Device supports offchannel CAC.
  */
 enum wiphy_flags {
 	/* use hole at 0 */
@@ -2765,6 +2766,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
+	WIPHY_FLAG_OFFCHAN_CAC			= BIT(24),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a17d6bc..40290a5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6133,7 +6133,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if (netif_carrier_ok(dev))
+	if ((rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_CAC) &&
+	    netif_carrier_ok(dev))
 		return -EBUSY;
 
 	if (wdev->cac_started)
-- 
1.8.1.4

