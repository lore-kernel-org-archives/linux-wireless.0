Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64934 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965722AbaCUN6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:58:18 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so1872235eei.28
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:58:18 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 7/7] cfg80211: remove channel_switch combination check
Date: Fri, 21 Mar 2014 14:52:21 +0100
Message-Id: <1395409941-26303-8-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145828_279873_57DD408C)
In-Reply-To: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
 <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the driver responsible for making sure it is
capable of performing the switch. It might as well
accept a request but then disconnect an interface
if some requirements are not met.

In that case userspace should be prepared for an
appropriate event (AP/IBSS/mesh being stopped/left).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/nl80211.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5465e0e..6b7ded9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5921,17 +5921,6 @@ skip_beacons:
 		params.radar_required = true;
 	}
 
-	/* TODO: I left this here for now.  With channel switch, the
-	 * verification is a bit more complicated, because we only do
-	 * it later when the channel switch really happens.
-	 */
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					   params.chandef.chan,
-					   CHAN_MODE_SHARED,
-					   radar_detect_width);
-	if (err)
-		return err;
-
 	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
 		params.block_tx = true;
 
-- 
1.8.5.3

