Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:27415 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932576Ab0BYNw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 08:52:28 -0500
Message-ID: <4B868099.9000405@yahoo.com>
Date: Thu, 25 Feb 2010 14:52:25 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Pavel Roskin <proski@gnu.org>,
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
  drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 46b06af..fbeff5c 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
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

