Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49985 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab3F1TN1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:27 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 18/19] rt2x00: rt2800usb: use correct [RT]XWI size for RT3593
Date: Fri, 28 Jun 2013 21:12:32 +0200
Message-Id: <1372446753-11408-19-git-send-email-juhosg@openwrt.org> (sfid-20130628_211340_763988_2C757BA0)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
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

