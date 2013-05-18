Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:41293 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab3ERMC1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:27 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:24 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 02/32] rt2800: prepare for rt2800_init_bbp spit
Date: Sat, 18 May 2013 14:03:25 +0200
Message-Id: <1368878635-4455-3-git-send-email-stf_xl@wp.pl> (sfid-20130518_140231_384841_56AF8454)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   57 ++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f431dcb..e04b1fa 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3953,6 +3953,34 @@ static void rt2800_init_bbp_early(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 }
 
+static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
+{
+}
+
+static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
+{
+}
+
+static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
+{
+}
+
+static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
+{
+}
+
+static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
+{
+}
+
+static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
+{
+}
+
+static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
+{
+}
+
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
 {
 	int ant, div_mode;
@@ -4034,7 +4062,34 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	u8 reg_id;
 	u8 value;
 
-	if (rt2x00_rt(rt2x00dev, RT5592)) {
+	switch (rt2x00dev->chip.rt) {
+	case RT2860:
+	case RT2872:
+	case RT2883:
+		rt2800_init_bbp_28xx(rt2x00dev);
+		break;
+	case RT3070:
+	case RT3071:
+	case RT3090:
+		rt2800_init_bbp_30xx(rt2x00dev);
+		break;
+	case RT3290:
+		rt2800_init_bbp_3290(rt2x00dev);
+		break;
+	case RT3352:
+		rt2800_init_bbp_3352(rt2x00dev);
+		break;
+	case RT3390:
+		rt2800_init_bbp_3390(rt2x00dev);
+		break;
+	case RT3572:
+		rt2800_init_bbp_3572(rt2x00dev);
+		break;
+	case RT5390:
+	case RT5392:
+		rt2800_init_bbp_53xx(rt2x00dev);
+		break;
+	case RT5592:
 		rt2800_init_bbp_5592(rt2x00dev);
 		return;
 	}
-- 
1.7.4.4

