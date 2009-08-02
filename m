Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33255 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZHBSaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 14:30:10 -0400
Subject: [PATCH 1/2] rt61pci: fix module reloading
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com
From: Pavel Roskin <proski@gnu.org>
Date: Sun, 02 Aug 2009 14:30:02 -0400
Message-ID: <20090802183002.16766.4142.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unloading rt61pci can leave the device in such state that reloading
rt61pci would fail to reinitialize it.  Bogus data would be read from
the EEPROM and the RF version won't be recognized.

It appears that unloading rt61pci with power saving enabled would have
such effect.  To initialize the device properly, SOFT_RESET_CSR should
be set to the same value as rt61pci_config_ps() uses to wake up the
device.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index fb95b8c..e20dd74 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2601,6 +2601,11 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	int retval;
 
 	/*
+	 * Disable power saving.
+	 */
+	rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000007);
+
+	/*
 	 * Allocate eeprom data.
 	 */
 	retval = rt61pci_validate_eeprom(rt2x00dev);
