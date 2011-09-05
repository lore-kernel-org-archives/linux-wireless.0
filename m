Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:39970 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752694Ab1IEMDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:03:09 -0400
Received: by mail-gw0-f54.google.com with SMTP id 15so3830943gwb.27
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 05:03:08 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [RFC 4/5] mac80211: adding intermediate scan result event call.
Date: Mon,  5 Sep 2011 15:02:30 +0300
Message-Id: <1315224151-16552-5-git-send-email-VictorG@ti.com> (sfid-20110905_140312_734886_30920200)
In-Reply-To: <1315224151-16552-1-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding "cfg80211_send_intermediate_result" call on reception
of new beacon/probe response.

Signed-off-by: Victor Goldenshtein <VictorG@ti.com>
---
 net/mac80211/scan.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 6f09eca..1204165 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -159,6 +159,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	__le16 fc;
 	bool presp, beacon = false;
 	struct ieee802_11_elems elems;
+	struct cfg80211_bss *cbss = NULL;
 
 	if (skb->len < 2)
 		return RX_DROP_UNUSABLE;
@@ -209,8 +210,11 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	bss = ieee80211_bss_info_update(sdata->local, rx_status,
 					mgmt, skb->len, &elems,
 					channel, beacon);
-	if (bss)
+	if (bss) {
+		cbss = container_of((void *)bss, struct cfg80211_bss, priv);
+		cfg80211_send_intermediate_result(sdata->dev, cbss);
 		ieee80211_rx_bss_put(sdata->local, bss);
+	}
 
 	/* If we are on-operating-channel, and this packet is for the
 	 * current channel, pass the pkt on up the stack so that
-- 
1.7.0.4

