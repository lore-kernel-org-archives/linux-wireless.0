Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp114.plus.mail.re1.yahoo.com ([69.147.102.77]:29079 "HELO
	smtp114.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758651Ab0BYBBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 20:01:43 -0500
Message-ID: <4B85CA62.8080208@yahoo.com>
Date: Thu, 25 Feb 2010 01:54:58 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH 2/2] rt2x00 : fix txdone implementation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Properly move to the headroom position in dma mapped skb. The hw extra
headroom is now taken into account.

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
---
  drivers/net/wireless/rt2x00/rt2800pci.c |    6 +++---
  1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 3ac1df0..4e62e84 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -718,8 +718,8 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
  	rt2x00_desc_write(txd, 1, word);
  
  	rt2x00_desc_read(txd, 2, &word);
-	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
-			   skbdesc->skb_dma + rt2x00dev->ops->extra_tx_headroom);
+	rt2x00_set_field32(&word, TXD_W2_SD_PTR1, skbdesc->skb_dma
+			   + rt2x00dev->ops->extra_tx_headroom);
  	rt2x00_desc_write(txd, 2, word);
  
  	rt2x00_desc_read(txd, 3, &word);
@@ -966,7 +966,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
  		/* Check if we got a match by looking at WCID/ACK/PID
  		 * fields */
  		txwi = (__le32 *)(entry->skb->data -
-				  rt2x00dev->hw->extra_tx_headroom);
+				  rt2x00dev->ops->extra_tx_headroom);
  
  		rt2x00_desc_read(txwi, 1, &word);
  		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
-- 
1.7.0

