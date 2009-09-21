Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx38.mail.ru ([94.100.176.52]:65262 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZIUUZr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 16:25:47 -0400
Subject: [PATCH v2] mac80211: Fix [re]association power saving issue on AP
 side
From: Igor Perminov <igor.perminov@inbox.ru>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 22 Sep 2009 00:25:44 +0400
Message-Id: <1253564744.4477.18.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Consider the following step-by step:
1. A STA authenticates and associates with the AP and exchanges
traffic.
2. The STA reports to the AP that it is going to PS state.
3. Some time later the STA device goes to the stand-by mode (not only
its wi-fi card, but the device itself) and drops the association state
without sending a disassociation frame.
4. The STA device wakes up and begins authentication with an
Auth frame as it hasn't been authenticated/associated previously.
 
At the step 4 the AP "remembers" the STA and considers it is still in
the PS state, so the AP buffers frames, which it has to send to the STA.
But the STA isn't actually in the PS state and so it neither checks
TIM bits nor reports to the AP that it isn't power saving.
Because of that authentication/[re]association fails.

To fix authentication/[re]association stage of this issue, Auth, Assoc
Resp and Reassoc Resp frames are transmitted disregarding of STA's power
saving state.

N.B. This patch doesn't fix further data frame exchange after
authentication/[re]association. A patch in hostapd is required to fix
that.

Signed-off-by: Igor Perminov <igor.perminov@inbox.ru>
---
 net/mac80211/tx.c       |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 10a1099..4d981e7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -367,7 +367,10 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	u32 staflags;
 
-	if (unlikely(!sta || ieee80211_is_probe_resp(hdr->frame_control)))
+	if (unlikely(!sta || ieee80211_is_probe_resp(hdr->frame_control)
+			|| ieee80211_is_auth(hdr->frame_control)
+			|| ieee80211_is_assoc_resp(hdr->frame_control)
+			|| ieee80211_is_reassoc_resp(hdr->frame_control)))
 		return TX_CONTINUE;
 
 	staflags = get_sta_flags(sta);


