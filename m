Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:36228 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbbCTN4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:56:52 -0400
Received: by labe2 with SMTP id e2so12274022lab.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 06:56:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/9] ath10k: drop RATETAB_ENT macro
Date: Fri, 20 Mar 2015 13:54:09 +0000
Message-Id: <1426859655-11797-4-git-send-email-michal.kazior@tieto.com> (sfid-20150320_145704_951894_EE8B0917)
In-Reply-To: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
References: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was superfluous and confusing. It's better to
define the structure explicitly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5721196..f4e76e7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -34,27 +34,22 @@
 /* Rates */
 /*********/
 
-#define RATETAB_ENT(_rate, _rateid, _flags) { \
-	.bitrate		= (_rate), \
-	.flags			= (_flags), \
-	.hw_value		= (_rateid), \
-}
-
 static struct ieee80211_rate ath10k_rates[] = {
 	/* CCK */
-	RATETAB_ENT(10,  0, 0),
-	RATETAB_ENT(20,  0, 0),
-	RATETAB_ENT(55,  0, 0),
-	RATETAB_ENT(110, 0, 0),
+	{ .bitrate = 10 },
+	{ .bitrate = 20 },
+	{ .bitrate = 55 },
+	{ .bitrate = 110 },
+
 	/* OFDM */
-	RATETAB_ENT(60,  0, 0),
-	RATETAB_ENT(90,  0, 0),
-	RATETAB_ENT(120, 0, 0),
-	RATETAB_ENT(180, 0, 0),
-	RATETAB_ENT(240, 0, 0),
-	RATETAB_ENT(360, 0, 0),
-	RATETAB_ENT(480, 0, 0),
-	RATETAB_ENT(540, 0, 0),
+	{ .bitrate = 60 },
+	{ .bitrate = 90 },
+	{ .bitrate = 120 },
+	{ .bitrate = 180 },
+	{ .bitrate = 240 },
+	{ .bitrate = 360 },
+	{ .bitrate = 480 },
+	{ .bitrate = 540 },
 };
 
 #define ath10k_a_rates (ath10k_rates + 4)
-- 
2.1.4

