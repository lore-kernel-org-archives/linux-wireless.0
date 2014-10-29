Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41600 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934103AbaJ2Qus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 12:50:48 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211-hwsim: remove un-used variable
Date: Wed, 29 Oct 2014 09:50:40 -0700
Message-Id: <1414601440-9983-1-git-send-email-greearb@candelatech.com> (sfid-20141029_175051_039528_FD1CD71B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Remove un-used variable added in recent patch.  Can re-add
this when we have an idea how to deal with receiving pkts
from user-space on channels not supported by current operating
mode of the virual radio.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b40435c..9dd07f7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2424,7 +2424,6 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	int frame_data_len;
 	void *frame_data;
 	struct sk_buff *skb = NULL;
-	u32 freq;
 
 	if (info->snd_portid != wmediumd_portid) {
 		printk(KERN_DEBUG "mac80211-hwsim: port-id mismatch: %d %d\n",
-- 
1.7.11.7

