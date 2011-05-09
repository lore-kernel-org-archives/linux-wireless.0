Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:42184 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408Ab1EIQWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 12:22:17 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so1981508ewy.5
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 09:22:15 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH v2] mac80211: don't drop frames where skb->len < 24 in ieee80211_scan_rx()
Date: Mon,  9 May 2011 19:15:04 +0300
Message-Id: <1304957704-11881-1-git-send-email-coelho@ti.com> (sfid-20110509_182220_582556_27955C71)
In-Reply-To: <1304957635.12586.605.camel@cumari>
References: <1304957635.12586.605.camel@cumari>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seems to be a leftover from the old days, when we didn't support
any frames that didn't contain the full ieee802.11 header.  This is
not the case anymore.  It does not cause problems now, because they
are only dropped during scan.  But when scheduled scans get merged,
this would become a problem because we would drop all small frames
while scheduled scan is running.

To fix this, return RX_CONTINUE instead of RX_DROP_MONITOR.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/mac80211/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 489b6ad..8acce72 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -170,7 +170,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 		return RX_CONTINUE;
 
 	if (skb->len < 24)
-		return RX_DROP_MONITOR;
+		return RX_CONTINUE;
 
 	presp = ieee80211_is_probe_resp(fc);
 	if (presp) {
-- 
1.7.1

