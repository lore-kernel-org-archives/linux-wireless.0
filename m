Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:10278 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaC3Ufj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2014 16:35:39 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFCv2 2/6] mac80211: add new RC API to retrieve expected throughput
Date: Sun, 30 Mar 2014 22:35:00 +0200
Message-Id: <1396211704-4677-3-git-send-email-antonio@meshcoding.com> (sfid-20140330_223543_407203_4812AA10)
In-Reply-To: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

In order to make get_station() export the expected
throughput, we need a new API which extracts such
information from the Rate Control algorithm.
Therefore add the get_expected_throughput() member
to the rate_control_ops structure.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/net/mac80211.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 604e279..209e004 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4476,6 +4476,9 @@ struct rate_control_ops {
 	void (*add_sta_debugfs)(void *priv, void *priv_sta,
 				struct dentry *dir);
 	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
+
+	u32 (*get_expected_throughput)(void *priv, void *priv_sta,
+				       struct ieee80211_supported_band *sband);
 };
 
 static inline int rate_supported(struct ieee80211_sta *sta,
-- 
1.8.3.2

