Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42067 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3LPSBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 13:01:18 -0500
Received: by mail-pb0-f43.google.com with SMTP id rq2so5792109pbb.30
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 10:01:18 -0800 (PST)
From: Javier Lopez <jlopex@cozybit.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net, j@w1.fi,
	danicamps81@yahoo.com, Javier Lopez <jlopex@cozybit.com>
Subject: [PATCH v2] mac80211_hwsim: Fix NULL pointer dereference
Date: Mon, 16 Dec 2013 10:01:07 -0800
Message-Id: <1387216867-26146-1-git-send-email-jlopex@cozybit.com> (sfid-20131216_190121_989118_F99A042C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211_hwsim was crashing when receiving tx information from user
space. Crash happens because txi->rate_driver_data[0] is pointing to a
non valid memory address.

This code path is only used by wmediumd and wmediumd doesn't provide
multiple channel support, so we can pass the channel struct
(data2->channel) directly to mac80211_hwsim_monitor_ack function.

Signed-off-by: Javier Lopez <jlopex@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9c0cc8d..fa41a77 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2018,7 +2018,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	   (hwsim_flags & HWSIM_TX_STAT_ACK)) {
 		if (skb->len >= 16) {
 			hdr = (struct ieee80211_hdr *) skb->data;
-			mac80211_hwsim_monitor_ack(txi->rate_driver_data[0],
+			mac80211_hwsim_monitor_ack(data2->channel,
 						   hdr->addr2);
 		}
 		txi->flags |= IEEE80211_TX_STAT_ACK;
-- 
1.7.9.5

