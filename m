Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab2GIMmM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 08:42:12 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	"Woody Hung" <Woody.Hung@mediatek.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] rt2800lib: merge same defines
Date: Mon,  9 Jul 2012 14:41:48 +0200
Message-Id: <1341837708-22689-2-git-send-email-sgruszka@redhat.com> (sfid-20120709_144215_648137_12947093)
In-Reply-To: <1341837708-22689-1-git-send-email-sgruszka@redhat.com>
References: <1341837708-22689-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge 3290 and 5390 POWER_BOUND and FREQ_OFFSET_BOUND defines.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 068276e..e76f03c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1940,10 +1940,8 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 }
 
-#define RT3290_POWER_BOUND     0x27
-#define RT3290_FREQ_OFFSET_BOUND       0x5f
-#define RT5390_POWER_BOUND     0x27
-#define RT5390_FREQ_OFFSET_BOUND       0x5f
+#define POWER_BOUND		0x27
+#define FREQ_OFFSET_BOUND	0x5f
 
 static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
@@ -1959,16 +1957,15 @@ static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
-	if (info->default_power1 > RT3290_POWER_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR49_TX, RT3290_POWER_BOUND);
+	if (info->default_power1 > POWER_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX, POWER_BOUND);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
 	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	if (rt2x00dev->freq_offset > RT3290_FREQ_OFFSET_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE,
-				  RT3290_FREQ_OFFSET_BOUND);
+	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
@@ -2002,17 +1999,16 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
-	if (info->default_power1 > RT5390_POWER_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR49_TX, RT5390_POWER_BOUND);
+	if (info->default_power1 > POWER_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX, POWER_BOUND);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
 	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
 
 	if (rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
-		if (info->default_power1 > RT5390_POWER_BOUND)
-			rt2x00_set_field8(&rfcsr, RFCSR50_TX,
-					  RT5390_POWER_BOUND);
+		if (info->default_power1 > POWER_BOUND)
+			rt2x00_set_field8(&rfcsr, RFCSR50_TX, POWER_BOUND);
 		else
 			rt2x00_set_field8(&rfcsr, RFCSR50_TX,
 					  info->default_power2);
@@ -2031,9 +2027,8 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	if (rt2x00dev->freq_offset > RT5390_FREQ_OFFSET_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE,
-				  RT5390_FREQ_OFFSET_BOUND);
+	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
-- 
1.7.1

