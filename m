Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:30440 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbYBQQft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:35:49 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1391418fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:35:46 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 01/11] rt2x00: Send frames out with configured TX power
Date: Sun, 17 Feb 2008 17:31:48 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802171730.44353.IvDoorn@gmail.com>
In-Reply-To: <200802171730.44353.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200802171731.48259.IvDoorn@gmail.com> (sfid-20080217_163607_809408_3F99F59D)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 sends the txpower to use during config(),
we already store it in the rt2x00_dev structure.
When writing the descriptor correctly initialize
the txpower field with this value to make sure
all frames are send out with the correct tx power.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    4 +---
 drivers/net/wireless/rt2x00/rt73usb.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 43d5dd3..bc8a6e4 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1500,10 +1500,8 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 5, &word);
-/* XXX: removed for now
 	rt2x00_set_field32(&word, TXD_W5_TX_POWER,
-			   TXPOWER_TO_DEV(control->power_level));
- */
+			   TXPOWER_TO_DEV(rt2x00dev->tx_power));
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index af1bb91..63f7604 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1236,10 +1236,8 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 5, &word);
-/* XXX: removed for now
 	rt2x00_set_field32(&word, TXD_W5_TX_POWER,
-			   TXPOWER_TO_DEV(control->power_level));
- */
+			   TXPOWER_TO_DEV(rt2x00dev->tx_power));
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
-- 
1.5.4

