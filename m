Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63520 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab0JBJfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:25 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658520wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:25 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/20] rt2x00: Don't initialize MM40 HT protection to RTS/CTS on PCI devices
Date: Sat, 2 Oct 2010 11:29:08 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021128.03722.IvDoorn@gmail.com> <201010021128.35449.IvDoorn@gmail.com>
In-Reply-To: <201010021128.35449.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021129.09422.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since HT protection is now configurable via mac80211 we don't need this
special case for PCI devices anymore. The HT protection config will be
overwritten as soon as mac80211 sends us a HT operation mode. Hence,
bring the HT MM40 protection config in sync with the other HT protection
registers and initialize it to no protection.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 4ecacea..76b8783 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2016,8 +2016,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL,
-			   !rt2x00_is_usb(rt2x00dev));
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-- 
1.7.2.3

