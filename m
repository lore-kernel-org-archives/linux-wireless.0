Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47645 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab3GAHsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 03:48:42 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 19/20] rt2x00: rt2800usb: use correct [RT]XWI size for RT3593
Date: Mon,  1 Jul 2013 09:47:58 +0200
Message-Id: <1372664879-18474-20-git-send-email-juhosg@openwrt.org> (sfid-20130701_094847_815282_50625676)
In-Reply-To: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RT3593 chipset requires different [RT]XWI size
values. Modify the driver to use the correct values.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 1ba797b..a313241 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2814,6 +2814,7 @@ enum rt2800_eeprom_word {
 #define TXWI_DESC_SIZE_5WORDS		(5 * sizeof(__le32))
 
 #define RXWI_DESC_SIZE_4WORDS		(4 * sizeof(__le32))
+#define RXWI_DESC_SIZE_5WORDS		(5 * sizeof(__le32))
 #define RXWI_DESC_SIZE_6WORDS		(6 * sizeof(__le32))
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 840833b..c24c1fd 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -854,7 +854,10 @@ static void rt2800usb_queue_init(struct data_queue *queue)
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	unsigned short txwi_size, rxwi_size;
 
-	if (rt2x00_rt(rt2x00dev, RT5592)) {
+	if (rt2x00_rt(rt2x00dev, RT3593)) {
+		txwi_size = TXWI_DESC_SIZE_4WORDS;
+		rxwi_size = RXWI_DESC_SIZE_5WORDS;
+	} else if (rt2x00_rt(rt2x00dev, RT5592)) {
 		txwi_size = TXWI_DESC_SIZE_5WORDS;
 		rxwi_size = RXWI_DESC_SIZE_6WORDS;
 	} else {
-- 
1.7.10

