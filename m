Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:48780 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565Ab1ERImO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 04:42:14 -0400
Received: by ewy9 with SMTP id 9so451333ewy.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 01:42:12 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] nl80211: remove some stack variables in trigger_scan and start_sched_scan
Date: Wed, 18 May 2011 11:42:03 +0300
Message-Id: <1305708123-25668-1-git-send-email-coelho@ti.com> (sfid-20110518_104217_859757_3CAA412A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some stack variables (name *ssid and *channel) are only used to define
the size of the memory block that needs to be allocated for the
request structure in the nl80211_trigger_scan() and
nl80211_start_sched_scan() functions.

This is unnecessary because the sizes of the actual elements in the
structure can be used instead.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/wireless/nl80211.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d967073..d24f5c1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3300,8 +3300,6 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct cfg80211_scan_request *request;
-	struct cfg80211_ssid *ssid;
-	struct ieee80211_channel *channel;
 	struct nlattr *attr;
 	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_channels, i;
@@ -3348,8 +3346,8 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	request = kzalloc(sizeof(*request)
-			+ sizeof(*ssid) * n_ssids
-			+ sizeof(channel) * n_channels
+			+ sizeof(*request->ssids) * n_ssids
+			+ sizeof(*request->channels) * n_channels
 			+ ie_len, GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
@@ -3455,8 +3453,6 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct cfg80211_sched_scan_request *request;
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
-	struct cfg80211_ssid *ssid;
-	struct ieee80211_channel *channel;
 	struct nlattr *attr;
 	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_channels, i;
@@ -3513,8 +3509,8 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		return -EINVAL;
 
 	request = kzalloc(sizeof(*request)
-			+ sizeof(*ssid) * n_ssids
-			+ sizeof(channel) * n_channels
+			+ sizeof(*request->ssids) * n_ssids
+			+ sizeof(*request->channels) * n_channels
 			+ ie_len, GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
-- 
1.7.1

