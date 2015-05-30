Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34797 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbE3XYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2015 19:24:46 -0400
Received: by pdbki1 with SMTP id ki1so79895382pdb.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2015 16:24:46 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH] cfg80211: Don't re-use the skb for larger NL messages.
Date: Sun, 31 May 2015 04:54:35 +0530
Message-Id: <1433028275-9576-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150531_012832_771928_8471DF71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This improves the time to get the DUMP response across to user space.
Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
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
