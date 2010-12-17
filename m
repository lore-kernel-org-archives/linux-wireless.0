Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23799 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab0LQPOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 10:14:43 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 07:14:27 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Properly initialize channel table for 2GHz
Date: Fri, 17 Dec 2010 20:44:36 +0530
Message-ID: <1292598876-8242-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

ath9k channel table for 2Ghz does not seems to initialize the 'band'
parameter.Though it does not seems to cause any visible issue it looks
odd when we initialize the 'band' parameter for 5Ghz channel table while
not so for 2Ghz.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1238795..b0e5e71 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -48,6 +48,7 @@ MODULE_PARM_DESC(pmqos, "User specified PM-QOS value");
 /* We use the hw_value as an index into our private channel structure */
 
 #define CHAN2G(_freq, _idx)  { \
+	.band = IEEE80211_BAND_2GHZ, \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
 	.max_power = 20, \
-- 
1.7.0.4

