Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:44409 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031Ab1ERIVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 04:21:14 -0400
Received: by mail-ew0-f44.google.com with SMTP id 19so417884ewy.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 01:21:13 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] nl80211: remove unnecessary cfg80211_ssid pointer in nl80211_trigger_scan
Date: Wed, 18 May 2011 11:21:05 +0300
Message-Id: <1305706865-17672-1-git-send-email-coelho@ti.com> (sfid-20110518_102121_795195_8FF6B136)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The struct cfg80211_ssid *ssid variable was only used to figure out
the size of the struct when allocating memory.  This is not necessary,
because sizeof(*request->ssids) can be used instead.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/wireless/nl80211.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d967073..ebcfcf2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3300,7 +3300,6 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct cfg80211_scan_request *request;
-	struct cfg80211_ssid *ssid;
 	struct ieee80211_channel *channel;
 	struct nlattr *attr;
 	struct wiphy *wiphy;
@@ -3348,7 +3347,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	request = kzalloc(sizeof(*request)
-			+ sizeof(*ssid) * n_ssids
+			+ sizeof(*request->ssids) * n_ssids
 			+ sizeof(channel) * n_channels
 			+ ie_len, GFP_KERNEL);
 	if (!request)
-- 
1.7.1

