Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35983 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbcFFO4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 10:56:20 -0400
Received: by mail-wm0-f53.google.com with SMTP id n184so96554476wmn.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2016 07:56:19 -0700 (PDT)
From: Eduardo Abinader <eabinader@ocedo.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Eduardo Abinader <eduardo.abinader@riverbed.com>,
	johannes.berg@intel.com
Subject: [PATCH] nl80211: avoid possible memleak on nl80211_set_reg
Date: Mon,  6 Jun 2016 16:56:07 +0200
Message-Id: <1465224967-26892-1-git-send-email-eduardo.abinader@riverbed.com> (sfid-20160606_165624_510008_B14F5B70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting NULL just after freeing regdomain.

Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d120449..39d107d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5839,10 +5839,11 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	r = set_regdom(rd, REGD_SOURCE_CRDA);
 	/* set_regdom took ownership */
-	rd = NULL;
 
  bad_reg:
 	kfree(rd);
+	rd = NULL;
+
 	return r;
 }
 #endif /* CONFIG_CFG80211_CRDA_SUPPORT */
-- 
2.5.0

