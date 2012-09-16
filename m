Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1917 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab2IPU35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2012 16:29:57 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/5] rt2x00: rt2800 - Fix default vgc values for RT3572
Date: Sun, 16 Sep 2012 22:29:50 +0200
Message-Id: <1347827393-26948-3-git-send-email-gwingerde@gmail.com> (sfid-20120916_223058_831585_A009E212)
In-Reply-To: <1347827393-26948-2-git-send-email-gwingerde@gmail.com>
References: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
 <1347827393-26948-2-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align with the values used by the RT3572 Ralink vendor driver v2.5.0.0.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index cec4a99..17b8a28 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2904,16 +2904,21 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		    rt2x00_rt(rt2x00dev, RT3090) ||
 		    rt2x00_rt(rt2x00dev, RT3290) ||
 		    rt2x00_rt(rt2x00dev, RT3390) ||
+		    rt2x00_rt(rt2x00dev, RT3572) ||
 		    rt2x00_rt(rt2x00dev, RT5390) ||
 		    rt2x00_rt(rt2x00dev, RT5392))
 			vgc = 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			vgc = 0x2e + rt2x00dev->lna_gain;
 	} else { /* 5GHZ band */
-		if (!test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
-			vgc = 0x32 + (rt2x00dev->lna_gain * 5) / 3;
-		else
-			vgc = 0x3a + (rt2x00dev->lna_gain * 5) / 3;
+		if (rt2x00_rt(rt2x00dev, RT3572))
+			vgc = 0x22 + (rt2x00dev->lna_gain * 5) / 3;
+		else {
+			if (!test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
+				vgc = 0x32 + (rt2x00dev->lna_gain * 5) / 3;
+			else
+				vgc = 0x3a + (rt2x00dev->lna_gain * 5) / 3;
+		}
 	}
 
 	return vgc;
-- 
1.7.11.1

