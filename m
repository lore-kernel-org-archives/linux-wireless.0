Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33666 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbFUF00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2015 01:26:26 -0400
Date: Sun, 21 Jun 2015 10:56:21 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Rachel Kim <rachel.kim@atmel.com>, Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] Staging: wilc1000: Replace memset with eth_zero_addr
Message-ID: <20150621052620.GA14059@vaishali-Ideapad-Z570> (sfid-20150621_072641_979793_B9BB2756)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use eth_zero_addr to assign the zero address to the given address
array instead of memset when second argument is address of zero.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@eth_zero_addr@
expression e;
@@

-memset(e,0x00,ETH_ALEN);
+eth_zero_addr(e);
// </smpl>

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index f5296f5..2a3d875 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -495,7 +495,7 @@ static void WILC_WFI_mon_setup(struct net_device *dev)
 	ether_setup(dev);
 	dev->tx_queue_len = 0;
 	dev->type = ARPHRD_IEEE80211_RADIOTAP;
-	memset(dev->dev_addr, 0, ETH_ALEN);
+	eth_zero_addr(dev->dev_addr);
 
 	#ifdef USE_WIRELESS
 	{
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
