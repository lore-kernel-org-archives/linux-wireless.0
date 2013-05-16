Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3EPQtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 12:49:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: deepakx.arora@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 3.10] cfg80211: fix sending WoWLAN TCP wakeup settings
Date: Thu, 16 May 2013 18:49:13 +0200
Message-Id: <1368722953-18063-1-git-send-email-johannes@sipsolutions.net> (sfid-20130516_184928_909597_96617181)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code sending the current WoWLAN TCP wakeup settings in
nl80211_send_wowlan_tcp() is not closing the nested attribute,
thus causing the parser to get confused on the receiver side
in userspace (iw). Fix this.

Cc: stable@vger.kernel.org [3.9]
Reported-by: Deepak Arora <deepakx.arora@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0dca987..dfdb5e6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7577,6 +7577,8 @@ static int nl80211_send_wowlan_tcp(struct sk_buff *msg,
 		    &tcp->payload_tok))
 		return -ENOBUFS;
 
+	nla_nest_end(msg, nl_tcp);
+
 	return 0;
 }
 
-- 
1.8.0

