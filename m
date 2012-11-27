Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62434 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab2K0Pr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 10:47:28 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so2973168wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:47:27 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
	gwingerde@gmail.com, IvDoorn@gmail.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: Use addr_mask to catch invalid MAC addresses
Date: Tue, 27 Nov 2012 16:47:16 +0100
Message-Id: <1354031236-8191-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121127_164732_197743_77A49FB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ensures that a user cannot accidentally set up a virtual interface
with a MAC address the rt2800 hw cannot handle.

Reported-by: Petr Stetiar <ynezz@true.cz>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c0441a7..7f0df12 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5108,6 +5108,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 				rt2x00_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
 
+	/* Only the last three bits are variable in rt2800 devices. */
+	rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] = 0x7;
+
 	/*
 	 * As rt2800 has a global fallback table we cannot specify
 	 * more then one tx rate per frame but since the hw will
-- 
1.7.7

