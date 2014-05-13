Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53422 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968AbaEMKcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 06:32:18 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so252118eei.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 03:32:17 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] ath: add JP DFS pattern detector
Date: Tue, 13 May 2014 12:32:06 +0200
Message-Id: <1399977126-8343-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140513_123238_862992_6F0E11E0)
In-Reply-To: <1399977126-8343-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1399977126-8343-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add initial values for JP DFS pattern detector.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 6269f4e..650be79 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -96,9 +96,29 @@ static const struct radar_types fcc_radar_types = {
 	.radar_types		= fcc_radar_ref_types,
 };
 
+#define JP_PATTERN FCC_PATTERN
+static const struct radar_detector_specs jp_radar_ref_types[] = {
+	JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18),
+	JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18),
+	JP_PATTERN(2, 0, 1, 1388, 1388, 1, 18),
+	JP_PATTERN(3, 1, 2, 4000, 4000, 1, 18),
+	JP_PATTERN(4, 0, 5, 150, 230, 1, 23),
+	JP_PATTERN(5, 6, 10, 200, 500, 1, 16),
+	JP_PATTERN(6, 11, 20, 200, 500, 1, 12),
+	JP_PATTERN(7, 50, 100, 1000, 2000, 20, 1),
+	JP_PATTERN(5, 0, 1, 333, 333, 1, 9),
+};
+
+static const struct radar_types jp_radar_types = {
+	.region			= NL80211_DFS_JP,
+	.num_radar_types	= ARRAY_SIZE(jp_radar_ref_types),
+	.radar_types		= jp_radar_ref_types,
+};
+
 static const struct radar_types *dfs_domains[] = {
 	&etsi_radar_types_v15,
 	&fcc_radar_types,
+	&jp_radar_types,
 };
 
 /**
-- 
1.7.9.5

