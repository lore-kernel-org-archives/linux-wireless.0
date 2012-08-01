Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:63377 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2HBA1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 20:27:25 -0400
Received: by obbwc20 with SMTP id wc20so5564419obb.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2012 17:27:24 -0700 (PDT)
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by wpzn4.hot.corp.google.com (Postfix) with ESMTP id 065B51E0043
	for <linux-wireless@vger.kernel.org>; Wed,  1 Aug 2012 17:27:24 -0700 (PDT)
From: Paul Stewart <pstew@chromium.org>
Date: Wed, 1 Aug 2012 16:54:42 -0700
Subject: [PATCH] cfg80211: Clear "beacon_found" on regulatory restore
To: linux-wireless@vger.kernel.org
Message-Id: <20120802002723.7762E2056A@glenhelen.mtv.corp.google.com> (sfid-20120802_022727_815743_111F3AB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restore the default state to the "beacon_found" flag when
the channel flags are restored.  Otherwise, we can end up
with a channel that we can no longer transmit on even when
we can see beacons on that channel.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 net/wireless/reg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2303ee7..cc6b4c4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1885,6 +1885,7 @@ static void restore_custom_reg_settings(struct wiphy *wiphy)
 			chan->flags = chan->orig_flags;
 			chan->max_antenna_gain = chan->orig_mag;
 			chan->max_power = chan->orig_mpwr;
+			chan->beacon_found = false;
 		}
 	}
 }
-- 
1.7.7.3

