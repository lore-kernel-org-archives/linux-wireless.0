Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:32776 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbaEMKcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 06:32:17 -0400
Received: by mail-ee0-f54.google.com with SMTP id b57so259375eek.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 03:32:16 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/2] ath: add DFS FCC pattern detector
Date: Tue, 13 May 2014 12:32:05 +0200
Message-Id: <1399977126-8343-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140513_123246_567249_54F38B5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add initial values for DFS FCC pattern detector.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c |   25 ++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index a1a69c5..6269f4e 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -73,9 +73,32 @@ static const struct radar_types etsi_radar_types_v15 = {
 	.radar_types		= etsi_radar_ref_types_v15,
 };
 
-/* for now, we support ETSI radar types, FCC and JP are TODO */
+#define FCC_PATTERN(ID, WMIN, WMAX, PMIN, PMAX, PRF, PPB)	\
+{								\
+	ID, WIDTH_LOWER(WMIN), WIDTH_UPPER(WMAX),		\
+	PMIN - PRI_TOLERANCE,					\
+	PMAX * PRF + PRI_TOLERANCE, PRF, PPB * PRF,		\
+	PPB_THRESH(PPB), PRI_TOLERANCE,				\
+}
+
+static const struct radar_detector_specs fcc_radar_ref_types[] = {
+	FCC_PATTERN(0, 0, 1, 1428, 1428, 1, 18),
+	FCC_PATTERN(1, 0, 5, 150, 230, 1, 23),
+	FCC_PATTERN(2, 6, 10, 200, 500, 1, 16),
+	FCC_PATTERN(3, 11, 20, 200, 500, 1, 12),
+	FCC_PATTERN(4, 50, 100, 1000, 2000, 20, 1),
+	FCC_PATTERN(5, 0, 1, 333, 333, 1, 9),
+};
+
+static const struct radar_types fcc_radar_types = {
+	.region			= NL80211_DFS_FCC,
+	.num_radar_types	= ARRAY_SIZE(fcc_radar_ref_types),
+	.radar_types		= fcc_radar_ref_types,
+};
+
 static const struct radar_types *dfs_domains[] = {
 	&etsi_radar_types_v15,
+	&fcc_radar_types,
 };
 
 /**
-- 
1.7.9.5

