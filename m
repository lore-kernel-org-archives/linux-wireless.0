Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49407 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab0FNUPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:20 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so4215976wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:20 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/14] rt2x00: provide mac80211 a suitable max_rates value
Date: Mon, 14 Jun 2010 22:12:01 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142211.09880.IvDoorn@gmail.com> <201006142211.33421.IvDoorn@gmail.com>
In-Reply-To: <201006142211.33421.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142212.02575.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Set up max_rates and max_rate_tries with suitable values even if we do not
support the whole functionality.

As rt2800 has a global fallback table we cannot specify more then one tx rate
per frame but since the hw will try several different rates (based on the
fallback table) we should still initialize max_rates to the maximum number of
rates we are going to try. Otherwise mac80211 will truncate our reported tx
rates and the rc algortihm will end up with incorrect data choosing unsuitable
rates for tx.

This improves throughput on rt2800 devices considerable.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f158322..6d4df3e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2497,6 +2497,18 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 				rt2x00_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
 
+	/*
+	 * As rt2800 has a global fallback table we cannot specify
+	 * more then one tx rate per frame but since the hw will
+	 * try several rates (based on the fallback table) we should
+	 * still initialize max_rates to the maximum number of rates
+	 * we are going to try. Otherwise mac80211 will truncate our
+	 * reported tx rates and the rc algortihm will end up with
+	 * incorrect data.
+	 */
+	rt2x00dev->hw->max_rates = 7;
+	rt2x00dev->hw->max_rate_tries = 1;
+
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
 
 	/*
-- 
1.6.6.1

