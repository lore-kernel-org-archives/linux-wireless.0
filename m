Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2818 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbbBTOfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 09:35:42 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 2/2] mac80211_hwsim: Add ifindex to the example vendor event
Date: Fri, 20 Feb 2015 16:35:25 +0200
Message-ID: <1424442925-10778-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20150220_153544_685879_DAF98353)
In-Reply-To: <1424442925-10778-1-git-send-email-jouni@qca.qualcomm.com>
References: <1424442925-10778-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This provides an example of a vendor event that is associated with a
single vif and allows user space tools to process it in the context of
that specified vif rather than full wiphy.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d2bba4c..580eaab 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -367,7 +367,7 @@ static int mac80211_hwsim_vendor_cmd_test(struct wiphy *wiphy,
 	 *
 	 * event_idx = 0 (index in mac80211_hwsim_vendor_commands)
 	 */
-	skb = cfg80211_vendor_event_alloc(wiphy, 100, 0, GFP_KERNEL);
+	skb = cfg80211_vendor_event_alloc_ext(wiphy, 100, 0, GFP_KERNEL, wdev);
 	if (skb) {
 		/* skb_put() or nla_put() will fill up data within
 		 * NL80211_ATTR_VENDOR_DATA.
-- 
1.9.1

