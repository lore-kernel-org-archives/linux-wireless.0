Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46531 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449AbaDINwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:52:02 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so1906062eek.37
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:52:01 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 5/5] cfg80211: remove channel_switch combination check
Date: Wed,  9 Apr 2014 15:45:37 +0200
Message-Id: <1397051137-26201-6-git-send-email-michal.kazior@tieto.com> (sfid-20140409_155238_630703_4469498F)
In-Reply-To: <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
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
index 232d15c..84aeb80 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5932,17 +5932,6 @@ skip_beacons:
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

