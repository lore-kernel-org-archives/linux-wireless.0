Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33007 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0FNUPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:22 -0400
Received: by mail-wy0-f174.google.com with SMTP id 40so4235810wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:22 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/14] rt2x00: Enable fallback rates for rt61pci and rt73usb
Date: Mon, 14 Jun 2010 22:12:54 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142212.02575.IvDoorn@gmail.com> <201006142212.27713.IvDoorn@gmail.com>
In-Reply-To: <201006142212.27713.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142212.55156.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

Explicitly enable the usage of fallback rates for
the transmission of frames with rt61pci and rt73usb hardware.

Note that for txdone reporting, only rt61pci is capable of
reporting the fallback rates, for USB it is not possible
to determine the number of retries. However the device will
use the fallback rates, so it might still help in the performance.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   22 ++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt73usb.c |    3 +++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 243df08..d127011 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -931,6 +931,9 @@ static void rt61pci_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR4, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR4_OFDM_TX_RATE_DOWN, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR4_OFDM_TX_RATE_STEP, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR4_OFDM_TX_FALLBACK_CCK, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR4_LONG_RETRY_LIMIT,
 			   libconf->conf->long_frame_max_tx_count);
 	rt2x00_set_field32(&reg, TXRX_CSR4_SHORT_RETRY_LIMIT,
@@ -2130,6 +2133,13 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		}
 		txdesc.retry = rt2x00_get_field32(reg, STA_CSR4_RETRY_COUNT);
 
+		/*
+		 * the frame was retried at least once
+		 * -> hw used fallback rates
+		 */
+		if (txdesc.retry)
+			__set_bit(TXDONE_FALLBACK, &txdesc.flags);
+
 		rt2x00pci_txdone(entry, &txdesc);
 	}
 }
@@ -2587,6 +2597,18 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 						   EEPROM_MAC_ADDR_0));
 
 	/*
+	 * As rt61 has a global fallback table we cannot specify
+	 * more then one tx rate per frame but since the hw will
+	 * try several rates (based on the fallback table) we should
+	 * still initialize max_rates to the maximum number of rates
+	 * we are going to try. Otherwise mac80211 will truncate our
+	 * reported tx rates and the rc algortihm will end up with
+	 * incorrect data.
+	 */
+	rt2x00dev->hw->max_rates = 7;
+	rt2x00dev->hw->max_rate_tries = 1;
+
+	/*
 	 * Initialize hw_mode information.
 	 */
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 113ad69..d06d90f 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -816,6 +816,9 @@ static void rt73usb_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	rt2x00usb_register_read(rt2x00dev, TXRX_CSR4, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR4_OFDM_TX_RATE_DOWN, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR4_OFDM_TX_RATE_STEP, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR4_OFDM_TX_FALLBACK_CCK, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR4_LONG_RETRY_LIMIT,
 			   libconf->conf->long_frame_max_tx_count);
 	rt2x00_set_field32(&reg, TXRX_CSR4_SHORT_RETRY_LIMIT,
-- 
1.6.6.1

