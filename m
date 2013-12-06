Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54358 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3LFBxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 20:53:40 -0500
Received: by mail-pb0-f45.google.com with SMTP id rp16so107995pbb.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 17:53:39 -0800 (PST)
From: Javier Lopez <jlopex@cozybit.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net, j@w1.fi,
	danicamps81@yahoo.com, Javier Lopez <jlopex@cozybit.com>
Subject: [PATCH] mac80211_hwsim: Fix NULL pointer dereference
Date: Thu,  5 Dec 2013 17:53:26 -0800
Message-Id: <1386294806-18083-1-git-send-email-jlopex@cozybit.com> (sfid-20131206_025343_415862_CB33E533)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211_hwsim was crashing when receiving tx information from user
space. Crash happens because txi->rate_driver_data[0] is pointing to a
non valid memory address.

This code path is only used by wmediumd and wmediumd doesn't provide
multiple channel support, so we can update txi->rate_driver_data[0]
to point to the mac80211_hwsim_data channel information struct
(data2->channel).

Signed-off-by: Javier Lopez <jlopex@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9c0cc8d..eddf7bf 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2013,6 +2013,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	}
 
 	txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
+	txi->rate_driver_data[0] = data2->channel;
 
 	if (!(hwsim_flags & HWSIM_TX_CTL_NO_ACK) &&
 	   (hwsim_flags & HWSIM_TX_STAT_ACK)) {
-- 
1.7.9.5

