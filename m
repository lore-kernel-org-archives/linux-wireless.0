Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:50638 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613AbZKWHQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 02:16:43 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 6/6] mac80211: Allow extra TX headroom to be consumed by drivers.
Date: Mon, 23 Nov 2009 08:16:05 +0100
Message-Id: <1258960565-26736-7-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258960565-26736-6-git-send-email-gwingerde@gmail.com>
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-2-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-3-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-4-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-5-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-6-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow drivers to consume the extra TX headroom they are requesting instead
of assuming they will give it back. This specifically is the case for
the rt2x00 driver, as a large part of the requested extra TX headroom is
used to properly align the frame for DMA usage, and the frame is never
moved back to the original location.
Fix this by reserving TX headroom accounting for both the driver requested
amount and the special monitor interface header that needs to be added,
instead of just the maximum of the two.

See http://marc.info/?l=linux-kernel&m=125892467801662&w=2 for details.

Reported-by: David Ellingsworth <david@identd.dyndns.org>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Tested-by: David Ellingsworth <david@identd.dyndns.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index dd8ec8d..e666b66 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -515,8 +515,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	 * and we need some headroom for passing the frame to monitor
 	 * interfaces, but never both at the same time.
 	 */
-	local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
-				   sizeof(struct ieee80211_tx_status_rtap_hdr));
+	local->tx_headroom = local->hw.extra_tx_headroom +
+				   sizeof(struct ieee80211_tx_status_rtap_hdr);
 
 	debugfs_hw_add(local);
 
-- 
1.6.5.3

