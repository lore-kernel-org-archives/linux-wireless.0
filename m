Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52340 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaBPOcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 09:32:22 -0500
Received: by mail-pd0-f173.google.com with SMTP id y10so13845422pdj.32
        for <linux-wireless@vger.kernel.org>; Sun, 16 Feb 2014 06:32:21 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>
Subject: [PATCH 2/2] b43: return true / false instead of numbers in functions which return bool value
Date: Sun, 16 Feb 2014 22:31:38 +0800
Message-Id: <b71acbe0697d6aad7a894efd84e4f931702d7b33.1392560760.git.gamerh2o@gmail.com> (sfid-20140216_153239_075912_2CE4DB39)
In-Reply-To: <fe0bba2d6b5b1d3b5021755aa8dc169d8e8f4655.1392560760.git.gamerh2o@gmail.com>
References: <fe0bba2d6b5b1d3b5021755aa8dc169d8e8f4655.1392560760.git.gamerh2o@gmail.com>
In-Reply-To: <fe0bba2d6b5b1d3b5021755aa8dc169d8e8f4655.1392560760.git.gamerh2o@gmail.com>
References: <fe0bba2d6b5b1d3b5021755aa8dc169d8e8f4655.1392560760.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/b43/debugfs.h    |  2 +-
 drivers/net/wireless/b43/phy_common.c |  4 ++--
 drivers/net/wireless/b43/pio.c        | 10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/debugfs.h b/drivers/net/wireless/b43/debugfs.h
index 822aad88..50517b8 100644
--- a/drivers/net/wireless/b43/debugfs.h
+++ b/drivers/net/wireless/b43/debugfs.h
@@ -86,7 +86,7 @@ void b43_debugfs_log_txstat(struct b43_wldev *dev,
 
 static inline bool b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature)
 {
-	return 0;
+	return false;
 }
 
 static inline void b43_debugfs_init(void)
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index f01676a..dbaa518 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -133,9 +133,9 @@ void b43_phy_exit(struct b43_wldev *dev)
 bool b43_has_hardware_pctl(struct b43_wldev *dev)
 {
 	if (!dev->phy.hardware_power_control)
-		return 0;
+		return false;
 	if (!dev->phy.ops->supports_hwpctl)
-		return 0;
+		return false;
 	return dev->phy.ops->supports_hwpctl(dev);
 }
 
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index a73ff8c..a4ff5e2 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -637,7 +637,7 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 
 		ctl = b43_piorx_read32(q, B43_PIO8_RXCTL);
 		if (!(ctl & B43_PIO8_RXCTL_FRAMERDY))
-			return 0;
+			return false;
 		b43_piorx_write32(q, B43_PIO8_RXCTL,
 				  B43_PIO8_RXCTL_FRAMERDY);
 		for (i = 0; i < 10; i++) {
@@ -651,7 +651,7 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 
 		ctl = b43_piorx_read16(q, B43_PIO_RXCTL);
 		if (!(ctl & B43_PIO_RXCTL_FRAMERDY))
-			return 0;
+			return false;
 		b43_piorx_write16(q, B43_PIO_RXCTL,
 				  B43_PIO_RXCTL_FRAMERDY);
 		for (i = 0; i < 10; i++) {
@@ -662,7 +662,7 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 		}
 	}
 	b43dbg(q->dev->wl, "PIO RX timed out\n");
-	return 1;
+	return true;
 data_ready:
 
 	/* Get the preamble (RX header) */
@@ -759,7 +759,7 @@ data_ready:
 
 	b43_rx(q->dev, skb, rxhdr);
 
-	return 1;
+	return true;
 
 rx_error:
 	if (err_msg)
@@ -769,7 +769,7 @@ rx_error:
 	else
 		b43_piorx_write16(q, B43_PIO_RXCTL, B43_PIO_RXCTL_DATARDY);
 
-	return 1;
+	return true;
 }
 
 void b43_pio_rx(struct b43_pio_rxqueue *q)
-- 
1.8.5.3

