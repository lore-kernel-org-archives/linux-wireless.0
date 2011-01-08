Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42908 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1AHSbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 13:31:00 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Fix skb-copy failure debug message.
Date: Sat,  8 Jan 2011 10:30:54 -0800
Message-Id: <1294511454-29985-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This particular error isn't about multicast.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 a6701ed... 6d2c59b... M	net/mac80211/rx.c
 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a6701ed..6d2c59b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2692,7 +2692,7 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 		if (!skb) {
 			if (net_ratelimit())
 				wiphy_debug(local->hw.wiphy,
-					"failed to copy multicast frame for %s\n",
+					"failed to copy skb for %s\n",
 					sdata->name);
 			return true;
 		}
-- 
1.7.2.3

