Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44616 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932404AbeE2JT4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 05:19:56 -0400
From: Srinivas Dasari <dasaris@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@codeaurora.org>
Subject: [PATCH] nl80211: Include ies_len for nlmsg from ft_event
Date: Tue, 29 May 2018 14:49:41 +0530
Message-Id: <1527585581-23277-1-git-send-email-dasaris@codeaurora.org> (sfid-20180529_112025_151237_4826D15A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Length of the ies is not considered while allocating nl
message for ft_event, though they are filled.
Hence, consider the length also for nl_msg.

Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bc40a78..8ad0bc0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15817,7 +15817,8 @@ void cfg80211_ft_event(struct net_device *netdev,
 	if (!ft_event->target_ap)
 		return;
 
-	msg = nlmsg_new(100 + ft_event->ric_ies_len, GFP_KERNEL);
+	msg = nlmsg_new(100 + ft_event->ric_ies_len + ft_event->ies_len,
+			GFP_KERNEL);
 	if (!msg)
 		return;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
