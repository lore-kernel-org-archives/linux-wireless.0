Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:30440 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYBQQfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:35:51 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1391418fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:35:51 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 04/11] rt2x00: Filter ACK_CTS based on FIF_CONTROL
Date: Sun, 17 Feb 2008 17:33:13 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802171730.44353.IvDoorn@gmail.com>
In-Reply-To: <200802171730.44353.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802171733.13851.IvDoorn@gmail.com> (sfid-20080217_163610_510368_BCE529EA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ACK_CTS frame is a control frame, this means
dropping the frame depends on the FIF_CONTROL flag
for filtering.

This also fixes an obvious typo in register definition.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    5 +++--
 drivers/net/wireless/rt2x00/rt61pci.h |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index a7aebb4..722d734 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2328,8 +2328,9 @@ static void rt61pci_configure_filter(struct ieee80211_hw *hw,
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
 			   !(*total_flags & FIF_ALLMULTI));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BORADCAST, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BROADCAST, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS,
+			   !(*total_flags & FIF_CONTROL));
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 2f9a889..d504e70 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -405,7 +405,7 @@ struct hw_pairwise_ta_entry {
 #define TXRX_CSR0_DROP_TO_DS		FIELD32(0x00200000)
 #define TXRX_CSR0_DROP_VERSION_ERROR	FIELD32(0x00400000)
 #define TXRX_CSR0_DROP_MULTICAST	FIELD32(0x00800000)
-#define TXRX_CSR0_DROP_BORADCAST	FIELD32(0x01000000)
+#define TXRX_CSR0_DROP_BROADCAST	FIELD32(0x01000000)
 #define TXRX_CSR0_DROP_ACK_CTS		FIELD32(0x02000000)
 #define TXRX_CSR0_TX_WITHOUT_WAITING	FIELD32(0x04000000)
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 3ccf4fd..615415a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1925,7 +1925,8 @@ static void rt73usb_configure_filter(struct ieee80211_hw *hw,
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
 			   !(*total_flags & FIF_ALLMULTI));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BROADCAST, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS,
+			   !(*total_flags & FIF_CONTROL));
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 }
 
-- 
1.5.4

