Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4926 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab2IPU35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2012 16:29:57 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/5] rt2x00: Code clean up in rt2800lib.
Date: Sun, 16 Sep 2012 22:29:49 +0200
Message-Id: <1347827393-26948-2-git-send-email-gwingerde@gmail.com> (sfid-20120916_223059_476447_50C0A3EF)
In-Reply-To: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
References: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the code in rt2800_get_default_vgc more understandable and
readable, especially for the 5GHz band values.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9e09367..cec4a99 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2896,6 +2896,8 @@ EXPORT_SYMBOL_GPL(rt2800_link_stats);
 
 static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
+	u8 vgc;
+
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
 		    rt2x00_rt(rt2x00dev, RT3071) ||
@@ -2904,15 +2906,17 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		    rt2x00_rt(rt2x00dev, RT3390) ||
 		    rt2x00_rt(rt2x00dev, RT5390) ||
 		    rt2x00_rt(rt2x00dev, RT5392))
-			return 0x1c + (2 * rt2x00dev->lna_gain);
+			vgc = 0x1c + (2 * rt2x00dev->lna_gain);
+		else
+			vgc = 0x2e + rt2x00dev->lna_gain;
+	} else { /* 5GHZ band */
+		if (!test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
+			vgc = 0x32 + (rt2x00dev->lna_gain * 5) / 3;
 		else
-			return 0x2e + rt2x00dev->lna_gain;
+			vgc = 0x3a + (rt2x00dev->lna_gain * 5) / 3;
 	}
 
-	if (!test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
-		return 0x32 + (rt2x00dev->lna_gain * 5) / 3;
-	else
-		return 0x3a + (rt2x00dev->lna_gain * 5) / 3;
+	return vgc;
 }
 
 static inline void rt2800_set_vgc(struct rt2x00_dev *rt2x00dev,
-- 
1.7.11.1

