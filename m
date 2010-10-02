Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63520 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0JBJfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:36 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658520wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:35 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/20] rt2x00: correctly set max_report_rates in rt61pci and rt2800
Date: Sat, 2 Oct 2010 11:32:16 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021131.33951.IvDoorn@gmail.com> <201010021131.56454.IvDoorn@gmail.com>
In-Reply-To: <201010021131.56454.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021132.17888.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

rt61pci and rt2800 devices can use up to 7 different rates per tx frame.
However, the device uses a global fallback table. Hence, the rc
algortihm cannot specify multiple rates to try but the device is able to
report multiple rates (based on the retry table). Specify that behavior
by correctly setting max_report_rates and max_rates.

This makes rt2x00 and minstrel play nicer together.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++--
 drivers/net/wireless/rt2x00/rt61pci.c   |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 99b505f..403e2ed 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3188,12 +3188,13 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 * As rt2800 has a global fallback table we cannot specify
 	 * more then one tx rate per frame but since the hw will
 	 * try several rates (based on the fallback table) we should
-	 * still initialize max_rates to the maximum number of rates
+	 * initialize max_report_rates to the maximum number of rates
 	 * we are going to try. Otherwise mac80211 will truncate our
 	 * reported tx rates and the rc algortihm will end up with
 	 * incorrect data.
 	 */
-	rt2x00dev->hw->max_rates = 7;
+	rt2x00dev->hw->max_rates = 1;
+	rt2x00dev->hw->max_report_rates = 7;
 	rt2x00dev->hw->max_rate_tries = 1;
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 8940070f..ac370f1 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2630,12 +2630,13 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 * As rt61 has a global fallback table we cannot specify
 	 * more then one tx rate per frame but since the hw will
 	 * try several rates (based on the fallback table) we should
-	 * still initialize max_rates to the maximum number of rates
+	 * initialize max_report_rates to the maximum number of rates
 	 * we are going to try. Otherwise mac80211 will truncate our
 	 * reported tx rates and the rc algortihm will end up with
 	 * incorrect data.
 	 */
-	rt2x00dev->hw->max_rates = 7;
+	rt2x00dev->hw->max_rates = 1;
+	rt2x00dev->hw->max_report_rates = 7;
 	rt2x00dev->hw->max_rate_tries = 1;
 
 	/*
-- 
1.7.2.3

