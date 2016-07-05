Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32910 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbcGEMXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:23:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  5 Jul 2016 15:23:10 +0300
Message-Id: <1467721394-8195-4-git-send-email-luca@coelho.fi> (sfid-20160705_142330_166092_0664416C)
In-Reply-To: <1467721394-8195-1-git-send-email-luca@coelho.fi>
References: <1467721394-8195-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 3/7] cfg80211: handle failed skb allocation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Handle the case when dev_alloc_skb returns NULL.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2443ee3..b7d1592 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -721,6 +721,8 @@ __ieee80211_amsdu_copy(struct sk_buff *skb, unsigned int hlen,
 	 * alignment since sizeof(struct ethhdr) is 14.
 	 */
 	frame = dev_alloc_skb(hlen + sizeof(struct ethhdr) + 2 + cur_len);
+	if (!frame)
+		return NULL;
 
 	skb_reserve(frame, hlen + sizeof(struct ethhdr) + 2);
 	skb_copy_bits(skb, offset, skb_put(frame, cur_len), cur_len);
-- 
2.8.1

