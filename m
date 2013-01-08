Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34949 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab3AHOSx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 09:18:53 -0500
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: fix delayed ADDBA response
Date: Tue, 8 Jan 2013 16:16:37 +0200
Message-ID: <1357654597-8493-1-git-send-email-victorg@ti.com> (sfid-20130108_151857_188509_7B0CEE39)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Block frame processing during scan might delay the
ADDBA response, which eventually timeouts and
significantly reduces the device throughput.
Remove this constrain as it's not required for the
HW scan.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 net/mac80211/iface.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 06fac29..a26ee36 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1063,7 +1063,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		return;
 
-	if (local->scanning)
+	if (local->scanning && !local->ops->hw_scan)
 		return;
 
 	/*
-- 
1.7.5.4

