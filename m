Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36717 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809Ab1EIOTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:19:24 -0400
Received: by mail-ey0-f181.google.com with SMTP id 5so1849504eyh.40
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 07:19:22 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] mac80211: don't drop frames where skb->len < 24 in ieee80211_scan_rx()
Date: Mon,  9 May 2011 17:19:13 +0300
Message-Id: <1304950753-2952-1-git-send-email-coelho@ti.com> (sfid-20110509_161928_964688_156F5757)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seems to be a leftover from the old days, when we didn't support
any frames that didn't contain the full ieee802.11 header.  This is
not the case anymore.  It does not cause problems now, because they
are only dropped during scan.  But when scheduled scans get merged,
this would become a problem because we would drop all small frames
while scheduled scan is running.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/mac80211/scan.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 489b6ad..b7a39c4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -169,9 +169,6 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	if (ieee80211_is_ctl(fc))
 		return RX_CONTINUE;
 
-	if (skb->len < 24)
-		return RX_DROP_MONITOR;
-
 	presp = ieee80211_is_probe_resp(fc);
 	if (presp) {
 		/* ignore ProbeResp to foreign address */
-- 
1.7.1

