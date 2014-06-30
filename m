Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51878 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbaF3QSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 12:18:36 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so5997397wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 09:18:35 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 2/7] rtl818x_pci: Fix rtl8185 excessive IFS after CTS-to-self
Date: Mon, 30 Jun 2014 18:18:25 +0200
Message-Id: <1404145105-15954-1-git-send-email-andrea.merello@gmail.com> (sfid-20140630_181839_837412_B9E1A6EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Measuring time between _end_ of CTS-to-self and _end_ of datapacket (with a
prism54 board and mac80211 hacked to let the MAC timestamp stay untouched in the
radiotap header) resulted in about 300uS, while the datapacket itself should be
by far shorter (less than 100uS) and IFS should be SIFS (10uS).
This measure was confirmed whith a scope: about 250uS IFS has been seen between
the two packets.

This situation causes the CTS-to-self protection mechanism to work incorrectly
due to the NAV expiring during, or even before beginning, the packet
transmission, and it also causes the performances to be anyway reduced due to
time waste.

This problem has been seen at every packet TXed with CTS-to-self enabled on
rtl8185 board.
rtl8187se seems not affected (and rtl8180, being a 802.11b card, does not have
CTS-to-self mechaninsm).

This patch fixes this by adding a magic register write, making the board wait
for correct SIFS after CTS-to-self packet.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index e2dcede..73baf26 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -879,6 +879,8 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 		rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | (1 << 2));
 		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+		/* fix eccessive IFS after CTS-to-self */
+		rtl818x_iowrite8(priv, REG_ADDR1(0x1ff), 0x35);
 	}
 
 	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
-- 
1.9.1

