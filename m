Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49284 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab3KFSNu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 13:13:50 -0500
Message-ID: <527A86D6.1030807@hauke-m.de> (sfid-20131106_191354_604960_A9B3DAFC)
Date: Wed, 06 Nov 2013 19:13:42 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: stefani@seibold.net, Gabor Juhos <juhosg@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux-Next <linux-next@vger.kernel.org>
Subject: wrong merge of rt2x00/rt2800pci.c in linux-next
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was looking at linux-next-20131106 and the conflict in
drivers/net/wireless/rt2x00/rt2800pci.c was solved wrong. The function
rt2800pci_txstatus_interrupt() was moved from rt2800pci.c to
rt2800mmio_txstatus_interrupt() in rt2800mmio.c in commit
8d03e77218ff4bc59e4645438acbd3c5c7e0f654 , the change done in
3bbfe1d952cd4d2e29bfcb31f109b5d74d1aa847 should be done there.

This should be added to the merge 749550cb657ae5fb896b3b33070ae48f37813d13:

Hauke

--- a/drivers/net/wireless/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.c
@@ -446,7 +446,7 @@ static void rt2800mmio_txstatus_interrupt(struct
rt2x00_dev *rt2x00dev)
 		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
 			break;

-		if (!kfifo_put(&rt2x00dev->txstatus_fifo, &status)) {
+		if (!kfifo_put(&rt2x00dev->txstatus_fifo, status)) {
 			rt2x00_warn(rt2x00dev, "TX status FIFO overrun, drop tx status
report\n");
 			break;
 		}
