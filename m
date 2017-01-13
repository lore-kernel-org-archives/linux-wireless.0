Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:54776 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVfC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:35:02 -0500
Date: Fri, 13 Jan 2017 22:34:54 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 40/40] rt2x00: correctly set HT20/HT40 filter
Message-ID: <20170113213445.GA3678@makrotopia.org> (sfid-20170113_223506_287100_AE11E8EA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Serge Vasilugin <vasilugin@yandex.ru>

Simple patch to correct HT20/HT40 switching.
Tested with Rt3290, Rt3352 and Rt5350

Signed-off-by: Serge Vasilugin <vasilugin@yandex.ru>
[daniel@makrotopia.org: fixed code and commit message formatting]
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    |  2 ++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index f49babf2fbee..2fcb3eef65e6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -2319,6 +2319,8 @@ struct mac_iveiv_entry {
 #define RFCSR30_RX_H20M			FIELD8(0x04)
 #define RFCSR30_RX_VCM			FIELD8(0x18)
 #define RFCSR30_RF_CALIBRATION		FIELD8(0x80)
+#define RF3322_RFCSR30_TX_H20M		FIELD8(0x01)
+#define RF3322_RFCSR30_RX_H20M		FIELD8(0x02)
 
 /*
  * RFCSR 31:
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 823bdc1b0322..c4e022edf119 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3562,8 +3562,17 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
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
