Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:58479 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdAMV0d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:26:33 -0500
Date: Fri, 13 Jan 2017 22:25:51 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 16/40] rt2x00: rt2800lib: add BBP register initialization for
 RT3883
Message-ID: <20170113212547.GA3482@makrotopia.org> (sfid-20170113_222637_715945_65AE459B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 44 ++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index cf9a8cfd4fbc..df0c6dd90735 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5830,6 +5830,47 @@ static void rt2800_init_bbp_3593(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 }
 
+static void rt2800_init_bbp_3883(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_init_bbp_early(rt2x00dev);
+
+	rt2800_bbp_write(rt2x00dev, 4, 0x50);
+	rt2800_bbp_write(rt2x00dev, 47, 0x48);
+
+	rt2800_bbp_write(rt2x00dev, 86, 0x46);
+	rt2800_bbp_write(rt2x00dev, 88, 0x90);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x02);
+
+	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
+	rt2800_bbp_write(rt2x00dev, 104, 0x92);
+	rt2800_bbp_write(rt2x00dev, 105, 0x34);
+	rt2800_bbp_write(rt2x00dev, 106, 0x12);
+	rt2800_bbp_write(rt2x00dev, 120, 0x50);
+	rt2800_bbp_write(rt2x00dev, 137, 0x0f);
+	rt2800_bbp_write(rt2x00dev, 163, 0x9d);
+
+	/* Set ITxBF timeout to 0x9C40=1000msec */
+	rt2800_bbp_write(rt2x00dev, 179, 0x02);
+	rt2800_bbp_write(rt2x00dev, 180, 0x00);
+	rt2800_bbp_write(rt2x00dev, 182, 0x40);
+	rt2800_bbp_write(rt2x00dev, 180, 0x01);
+	rt2800_bbp_write(rt2x00dev, 182, 0x9c);
+
+	rt2800_bbp_write(rt2x00dev, 179, 0x00);
+
+	/* Reprogram the inband interface to put right values in RXWI */
+	rt2800_bbp_write(rt2x00dev, 142, 0x04);
+	rt2800_bbp_write(rt2x00dev, 143, 0x3b);
+	rt2800_bbp_write(rt2x00dev, 142, 0x06);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa0);
+	rt2800_bbp_write(rt2x00dev, 142, 0x07);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa1);
+	rt2800_bbp_write(rt2x00dev, 142, 0x08);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa2);
+	rt2800_bbp_write(rt2x00dev, 148, 0xc8);
+}
+
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 {
 	int ant, div_mode;
@@ -6048,6 +6089,9 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	case RT3593:
 		rt2800_init_bbp_3593(rt2x00dev);
 		return;
+	case RT3883:
+		rt2800_init_bbp_3883(rt2x00dev);
+		return;
 	case RT5390:
 	case RT5392:
 		rt2800_init_bbp_53xx(rt2x00dev);
-- 
2.11.0
