Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:30051 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaDNOEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 10:04:05 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 3/7] mac80211: add new RC API to retrieve expected throughput
Date: Mon, 14 Apr 2014 16:03:21 +0200
Message-Id: <1397484205-20905-3-git-send-email-antonio@meshcoding.com> (sfid-20140414_160418_481694_E038FEE2)
In-Reply-To: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

In order to make mac80211 export the expected throughput,
a new API which extracts such information from any mac80211
SW RC algorithm is needed.
Therefore add the new get_expected_throughput() member
to the rate_control_ops structure.

The exported value is expressed in Mbps/100. Such unit has
been chosen because it is the highest precision that
MinstrelHT can return.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/net/mac80211.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0efe37c..47b891a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4480,6 +4480,9 @@ struct rate_control_ops {
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

