Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3H0IPc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:15:32 -0400
Date: Tue, 27 Aug 2013 10:13:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Fabien ADAM <id2ndr@crocobox.org>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com,
	Paul Menzel <paulepanter@users.sourceforge.net>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3.11 v2] rt2800: fix wrong TX power compensation
Message-ID: <20130827081340.GB2609@redhat.com> (sfid-20130827_101540_717758_DB8248F7)
References: <20130826131851.GB10525@redhat.com>
 <1377548398.4408.4.camel@mattotaupa>
 <20130827080001.GA2609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130827080001.GA2609@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not do temperature compensation on devices without
EXTERNAL_TX_ALC bit set (called DynamicTxAgcControl on vendor driver).
Such devices can have totally bogus TSSI parameters on the EEPROM,
but are still treated by us as valid and results in wrong TX power
calculations.

This fixes inability to connect to AP on slightly longer distance on
some Ralink chips/devices without EXTERNAL_TX_ALC configured.

Reference:
http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/2263

Reported-and-tested-by: Fabien ADAM <id2ndr@crocobox.org>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 7 +++++++
 1 file changed, 7 insertions(+)

v1 -> v2: fix changelog

John,

If possible this should go to 3.11, -next & cc -stable is also fine as
usual.

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

