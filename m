Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52135 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab3KHKlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 05:41:45 -0500
Received: by mail-ea0-f182.google.com with SMTP id o10so968306eaj.41
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 02:41:43 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/3] cfg80211: DFS check dfs_region before CAC
Date: Fri,  8 Nov 2013 11:41:25 +0100
Message-Id: <1383907287-2925-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131108_114149_556053_78DBF64A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before we will start radar detection check
if we have correct DFS region. Fail in case
we don't know DFS region (don't know CAC/NOP
timing and how to configure DFS pattern detector).

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/nl80211.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 076ed55..635842b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5628,8 +5628,21 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_chan_def chandef;
+	const struct ieee80211_regdomain *regdom;
+	u8 dfs_region;
 	int err;
 
+	if (!cfg80211_regdomain)
+		return -EINVAL;
+
+	rcu_read_lock();
+	regdom = rcu_dereference(cfg80211_regdomain);
+	dfs_region = regdom->dfs_region;
+	rcu_read_unlock();
+
+	if (dfs_region == NL80211_DFS_UNSET)
+		return -EINVAL;
+
 	err = nl80211_parse_chandef(rdev, info, &chandef);
 	if (err)
 		return err;
-- 
1.7.9.5

