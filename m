Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:34129 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab1KPMza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:55:30 -0500
Received: by mail-yx0-f180.google.com with SMTP id l8so5540607yen.11
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 04:55:29 -0800 (PST)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Yoni Divinsky <yoni.divinsky@ti.com>
Subject: [PATCH] iw: fix wifi wmm ie print function
Date: Wed, 16 Nov 2011 14:55:11 +0200
Message-Id: <1321448111-24476-1-git-send-email-yoni.divinsky@ti.com> (sfid-20111116_135533_879145_B1F0AEB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When printing the acm bit of the wifi wmm ie, the incorrect bit
was being printed.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
---
 scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scan.c b/scan.c
index bde2276..8b8407e 100644
--- a/scan.c
+++ b/scan.c
@@ -740,7 +740,7 @@ static bool print_wifi_wmm_param(const uint8_t *data, uint8_t len)
 
 	for (i = 0; i < 4; i++) {
 		printf("\n\t\t * %s:", aci_tbl[(data[0] >> 5) & 3]);
-		if (data[4] & 0x10)
+		if (data[0] & 0x10)
 			printf(" acm");
 		printf(" CW %d-%d", (1 << (data[1] & 0xf)) - 1,
 				    (1 << (data[1] >> 4)) - 1);
-- 
1.7.0.4

