Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:38055 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaAPOjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 09:39:13 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so38078eae.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 06:39:12 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] cfg80211: fix wiphy freq hint nl80211 policy
Date: Thu, 16 Jan 2014 15:34:45 +0100
Message-Id: <1389882885-6950-1-git-send-email-michal.kazior@tieto.com> (sfid-20140116_153917_182776_CC4A5E96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The attribute name was mistyped. Actual nl80211
policy for NL80211_ATTR_WIPHY_FREQ_HINT was
missing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

I've spoted this while rebasing some of my
patches. This should apply on top of
mac80211-next/master.

 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fa5368a..6e78c62 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -385,7 +385,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_QOS_MAP] = { .type = NLA_BINARY,
 				   .len = IEEE80211_QOS_MAP_LEN_MAX },
 	[NL80211_ATTR_MAC_HINT] = { .len = ETH_ALEN },
-	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_FREQ_HINT] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
-- 
1.8.4.rc3

