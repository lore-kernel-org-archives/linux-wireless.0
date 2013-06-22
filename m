Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:43059 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab3FVLN3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 07:13:29 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>, stable@vger.kernel.org
Subject: [PATCH] rt2x00: read 5GHz TX power values from the correct offset
Date: Sat, 22 Jun 2013 13:13:25 +0200
Message-Id: <1371899605-30513-1-git-send-email-juhosg@openwrt.org> (sfid-20130622_131340_975313_658E328D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code uses the same index value both
for the channel information array and for the TX
power table. The index starts from 14, however the
index of the TX power table must start from zero.

Fix it, in order to get the correct TX power value
for a given channel.

The changes in rt61pci.c and rt73usb.c are compile
tested only.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Cc: stable@vger.kernel.org
---
John,

If there is any chance for that, this should go
into 3.10. However the code is wrong since a few
years and nobody noticed that so far, so it is
not a big problem if it will be applied only in
3.11.

-Gabor
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3aa30dd..4072242 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6254,8 +6254,8 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
 
 		for (i = 14; i < spec->num_channels; i++) {
-			info[i].default_power1 = default_power1[i];
-			info[i].default_power2 = default_power2[i];
+			info[i].default_power1 = default_power1[i - 14];
+			info[i].default_power2 = default_power2[i - 14];
 		}
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 53754bc6..54d3ddf 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2825,7 +2825,8 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i - 14]);
 		}
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 1616ed4..1d3880e 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2167,7 +2167,8 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i - 14]);
 		}
 	}
 
-- 
1.7.10

