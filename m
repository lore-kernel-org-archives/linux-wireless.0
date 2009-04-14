Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:59518 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750846AbZDNEp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 00:45:29 -0400
Date: Tue, 14 Apr 2009 06:32:56 +0200
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] mac80211: Fragmentation threshold (typo)
Message-ID: <20090414043256.GA6715@gerrit.erg.abdn.ac.uk> (sfid-20090414_064532_632889_E9518F3B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211: Fragmentation threshold (typo)

ieee80211_ioctl_siwfrag() sets the fragmentation_threshold to 2352
when frame fragmentation is to be disabled, yet the corresponding
'get' function tests for 2353 bytes instead.

This causes user-space tools to display a fragmentation threshold 
of 2352 bytes even if fragmentation has been disabled.

Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
---
 wext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -530,7 +530,7 @@ static int ieee80211_ioctl_giwfrag(struct net_device *dev,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
 	frag->value = local->fragmentation_threshold;
-	frag->disabled = (frag->value >= IEEE80211_MAX_RTS_THRESHOLD);
+	frag->disabled = (frag->value >= IEEE80211_MAX_FRAG_THRESHOLD);
 	frag->fixed = 1;
 
 	return 0;
