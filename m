Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33873 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbHCIzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 04:55:04 -0400
Received: by lbqc9 with SMTP id c9so48707317lbq.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 01:55:02 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] cfg80211: propagate set_wiphy failure to userspace
Date: Mon,  3 Aug 2015 10:55:24 +0200
Message-Id: <1438592124-30803-1-git-send-email-michal.kazior@tieto.com> (sfid-20150803_105513_083290_54A97248)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If driver failed to setup wiphy params (e.g. rts
threshold, fragmentation treshold) userspace
wasn't properly notified about this. This could
lead to user confusion who would think the command
succeeded even if that wasn't the case.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 76b41578a838..5849fa199f77 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2321,6 +2321,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.frag_threshold = old_frag_threshold;
 			rdev->wiphy.rts_threshold = old_rts_threshold;
 			rdev->wiphy.coverage_class = old_coverage_class;
+			return result;
 		}
 	}
 	return 0;
-- 
2.1.4

