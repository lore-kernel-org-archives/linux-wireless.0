Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:52877 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762283AbYDURAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:00 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2556605fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:00:00 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 3/9] rt2x00: Don't enable short preamble for 1MBs
Date: Mon, 21 Apr 2008 19:00:17 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com>
In-Reply-To: <200804211858.46659.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804211900.17323.IvDoorn@gmail.com> (sfid-20080421_190104_087795_29AD38CB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The timing settings for 1MBs should exclude
the short preamble bit since that only applies
to 2MBs, 5.5MBs and 11MBs.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b41187a..18e599e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -363,7 +363,7 @@ static void rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
-	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00 | preamble_mask);
+	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
 	rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
 	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 10));
 	rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5ade097..c54ea5a 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -370,7 +370,7 @@ static void rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
-	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00 | preamble_mask);
+	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
 	rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
 	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 10));
 	rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);
-- 
1.5.4.5

