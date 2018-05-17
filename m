Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbeEQNZL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 09:25:11 -0400
Received: from DLANSKY (unknown [185.23.60.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: dlansky@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4EC3060A4E
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2018 13:25:06 +0000 (UTC)
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211: fix nlmsg allocation in cfg80211_ft_event
Date: Thu, 17 May 2018 16:25:03 +0300
Message-ID: <000901d3ede2$78a3aa20$69eafe60$@codeaurora.org> (sfid-20180517_152515_723617_698FEC81)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <dlansky@codeaurora.org>

Allocation size of nlmsg in cfg80211_ft_event is based on ric_ies_len
and doesn't take into account ies_len. This leads to
NL80211_CMD_FT_EVENT message construction failure in case ft_event
contains large enough ies buffer.
Add ies_len to the nlmsg allocation size.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index afbe510..64afd04 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15755,7 +15755,8 @@ void cfg80211_ft_event(struct net_device *netdev,
 	if (!ft_event->target_ap)
 		return;
 
-	msg = nlmsg_new(100 + ft_event->ric_ies_len, GFP_KERNEL);
+	msg = nlmsg_new(100 + ft_event->ies_len + ft_event->ric_ies_len,
+			GFP_KERNEL);
 	if (!msg)
 		return;
 
-- 
1.9.1
