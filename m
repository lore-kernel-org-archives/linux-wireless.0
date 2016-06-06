Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.riverbed.com ([208.70.196.45]:14115 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcFFO5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 10:57:10 -0400
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: johannes.berg@intel.com
From: Eduardo Abinader <eduardo.abinader@riverbed.com>
Subject: [PATCH] nl80211: avoid possible memleak on nl80211_set_reg
Message-ID: <57558CCC.7030800@riverbed.com> (sfid-20160606_165714_376632_80401FBE)
Date: Mon, 6 Jun 2016 16:46:36 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
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
@@ -5839,10 +5839,11 @@ static int nl80211_set_reg(struct sk_buff *skb, 
struct genl_info *info)

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
