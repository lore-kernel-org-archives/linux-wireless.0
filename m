Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35499 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbE3X2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2015 19:28:24 -0400
Received: by padjw17 with SMTP id jw17so10615542pad.2
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2015 16:28:24 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH v2] cfg80211: Don't re-use the skb for larger NL messages.
Date: Sun, 31 May 2015 04:58:14 +0530
Message-Id: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150531_012833_345042_D47379D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 reuses the skb before asking for a fresh on from genl framework, 
this works efficiently for smaller messages but NLM_F_DUMP is normally 
used to transport larger data normally > PAGE_SIZE, so if the message 
occupies more than GOODSIZE its better to ask for a new, saves couple
of hanshakes with the driver.

This improves the time to get the DUMP response across to user space.
Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
V2: no new line, so commit log was cut off. Updated now.
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c264eff..152bd0c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7636,6 +7636,10 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 		}
 
 		genlmsg_end(skb, hdr);
+
+		/* Don't re-use skb, when we know nla_put fails*/
+		if (skb->len > NLMSG_GOODSIZE / 2)
+			break;
 	}
 
 	err = skb->len;
