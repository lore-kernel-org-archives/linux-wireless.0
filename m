Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35910 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0JILg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 07:36:29 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so23937ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 04:36:28 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/06] rt2x00: Use proper type for rxwi_w2 in rt2800_agc_to_rssi
Date: Sat, 9 Oct 2010 13:34:11 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010091333.17274.IvDoorn@gmail.com> <201010091333.45001.IvDoorn@gmail.com>
In-Reply-To: <201010091333.45001.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010091334.12741.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7f040b0..b9433fe 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -499,7 +499,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2800_write_tx_data);
 
-static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxwi_w2)
+static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, u32 rxwi_w2)
 {
 	int rssi0 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI0);
 	int rssi1 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI1);
-- 
1.7.2.3

