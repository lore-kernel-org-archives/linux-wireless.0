Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33926 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaEVOPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:15:13 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so2682600eek.20
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 07:15:12 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v6 6/6] cfg80211: remove channel_switch combination check
Date: Thu, 22 May 2014 16:07:56 +0200
Message-Id: <1400767676-15994-7-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161523_302237_02026465)
In-Reply-To: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
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
index 49adf58..d290afd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6001,17 +6001,6 @@ skip_beacons:
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

