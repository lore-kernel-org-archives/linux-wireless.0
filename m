Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab3HZNSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 09:18:43 -0400
Date: Mon, 26 Aug 2013 15:18:53 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com, Fabien ADAM <id2ndr@crocobox.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3.11] rt2800: fix wrong TX power compensation
Message-ID: <20130826131851.GB10525@redhat.com> (sfid-20130826_151846_980974_625E9CB3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not do temperature compensation on devices without
EXTERNAL_TX_ALC bit set (called DynamicTxAgcControl on vendor driver).
Such devices can have totally bogus TSSI parameters on the EEPROM,
but still threaded by us as valid and result doing wrong TX power
calculations.

This fix inability to connect to AP on slightly longer distance on
some Ralink chips/devices.

Reported-and-tested-by: Fabien ADAM <id2ndr@crocobox.org>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 7 +++++++
 1 file changed, 7 insertions(+)

John,

If possible this should go to 3.11, -next & cc -stable is also fine as
ususal.

Note that in -next version of the patch rt2x00_eeprom_read() should
be changed to rt2800_eeprom_read() do to commit
3e38d3daf881a78ac13e93504a8ac5777040797e
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1f80ea5..a0119d3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2790,6 +2790,13 @@ static int rt2800_get_gain_calibration_delta(struct rt2x00_dev *rt2x00dev)
 	int i;
 
 	/*
+	 * First check if temperature compensation is supported.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+	if (!rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_TX_ALC))
+		return 0;
+
+	/*
 	 * Read TSSI boundaries for temperature compensation from
 	 * the EEPROM.
 	 *
-- 
1.7.11.7

