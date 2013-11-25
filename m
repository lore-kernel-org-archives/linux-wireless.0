Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:52233 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3KYT4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 14:56:23 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so2796584ead.36
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 11:56:23 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3 2/4] cfg80211: DFS check dfs_region before usage
Date: Mon, 25 Nov 2013 20:56:10 +0100
Message-Id: <1385409372-4229-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131125_205628_357420_CD8B2AEE)
In-Reply-To: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com>
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
index 70290f8..81579ae 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5650,8 +5650,13 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
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

