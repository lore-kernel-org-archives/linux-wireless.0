Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45228 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab2K0R1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 12:27:13 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so4737886wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 09:27:12 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
	gwingerde@gmail.com, IvDoorn@gmail.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: Use addr_mask to catch invalid MAC addresses (rt61pci, rt73usb)
Date: Tue, 27 Nov 2012 18:27:05 +0100
Message-Id: <1354037225-30237-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121127_182716_560865_4538D1B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt61pci and rt73usb support up to four MAC addresses but only the last
two bits may differ. Hence, tell mac80211 an addr_mask of 0x3.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    3 +++
 drivers/net/wireless/rt2x00/rt73usb.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index d6582a2..ee8b44f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2771,6 +2771,9 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 				rt2x00_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
 
+	/* Only the last two bits are variable in rt61pci devices. */
+	rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] = 0x3;
+
 	/*
 	 * As rt61 has a global fallback table we cannot specify
 	 * more then one tx rate per frame but since the hw will
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 24eec66..6014cfe 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2126,6 +2126,9 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 				rt2x00_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
 
+	/* Only the last two bits are variable in rt73usb devices. */
+	rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] = 0x3;
+
 	/*
 	 * Initialize hw_mode information.
 	 */
-- 
1.7.7

