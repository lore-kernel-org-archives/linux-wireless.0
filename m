Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:49480 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751627AbdAPDJI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Jan 2017 22:09:08 -0500
Date: Mon, 16 Jan 2017 04:08:38 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 10/14] rt2x00: rt2800lib: correctly set HT20/HT40 filter
Message-ID: <20170116030820.GA32255@makrotopia.org> (sfid-20170116_040912_183027_781A6223)
References: <874m114lwq.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874m114lwq.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Serge Vasilugin <vasilugin@yandex.ru>

Simple patch to correct HT20/HT40 filter setting.
Tested with Rt3290, Rt3352 and Rt5350

Signed-off-by: Serge Vasilugin <vasilugin@yandex.ru>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    |  2 ++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 02ed0d512734..8024fc1a6ae2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -2303,6 +2303,8 @@ struct mac_iveiv_entry {
 #define RFCSR30_RX_H20M			FIELD8(0x04)
 #define RFCSR30_RX_VCM			FIELD8(0x18)
 #define RFCSR30_RF_CALIBRATION		FIELD8(0x80)
+#define RF3322_RFCSR30_TX_H20M		FIELD8(0x01)
+#define RF3322_RFCSR30_RX_H20M		FIELD8(0x02)
 
 /*
  * RFCSR 31:
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index ff653f0d43d2..4f454e143266 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3299,8 +3299,17 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	    rt2x00_rf(rt2x00dev, RF5390) ||
 	    rt2x00_rf(rt2x00dev, RF5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR30_TX_H20M, 0);
-		rt2x00_set_field8(&rfcsr, RFCSR30_RX_H20M, 0);
+		if (rt2x00_rf(rt2x00dev, RF3322)) {
+			rt2x00_set_field8(&rfcsr, RF3322_RFCSR30_TX_H20M,
+					  conf_is_ht40(conf));
+			rt2x00_set_field8(&rfcsr, RF3322_RFCSR30_RX_H20M,
+					  conf_is_ht40(conf));
+		} else {
+			rt2x00_set_field8(&rfcsr, RFCSR30_TX_H20M,
+					  conf_is_ht40(conf));
+			rt2x00_set_field8(&rfcsr, RFCSR30_RX_H20M,
+					  conf_is_ht40(conf));
+		}
 		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
 		rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
-- 
2.11.0
