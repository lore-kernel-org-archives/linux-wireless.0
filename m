Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34246 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3KTJmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 04:42:23 -0500
Received: by mail-ee0-f43.google.com with SMTP id c13so3195048eek.16
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 01:42:22 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/4] cfg80211: DFS check dfs_region before usage
Date: Wed, 20 Nov 2013 10:41:55 +0100
Message-Id: <1384940517-6154-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131120_104232_420074_C6330A41)
In-Reply-To: <1384940517-6154-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1384940517-6154-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Check the DFS region before channel availability check.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/nl80211.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dc0a885..62b4efd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5631,8 +5631,13 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_chan_def chandef;
+	enum nl80211_dfs_regions dfs_region;
 	int err;
 
+	dfs_region = reg_get_dfs_region(wdev->wiphy);
+	if (dfs_region == NL80211_DFS_UNSET)
+		return -EINVAL;
+
 	err = nl80211_parse_chandef(rdev, info, &chandef);
 	if (err)
 		return err;
-- 
1.7.9.5

