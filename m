Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59959 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbZG2Fw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 01:52:58 -0400
Subject: [RFC PATCH] rt61pci: fix module reloading with power saving enabled
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain
Date: Wed, 29 Jul 2009 01:52:41 -0400
Message-Id: <1248846761.18329.20.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unloading rt61pci can leave the device in such state that reloading
rt61pci would fail to reinitialize it.  Bogus data would be read from
the EEPROM and the RF version won't be recognized.  Only reboot would
return the device to a sane state.

It appears that it happens if rt61pci is unloaded while power saving is
active.  To initialize the device properly, SOFT_RESET_CSR should be set
to the same value as rt61pci_config_ps() uses to wake up the device.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

I don't know what 0x00000007 is and I don't want to make up a name for
it.

rt61pci_config_ps() does other things, but this is the minimal required
change.  If anyone has a specification for rt61, it should mention
SOFT_RESET_CSR and possibly other registers to be set before EEPROM may
be accessed.

Please note that unloading rt61pci (as well as rt73usb) can trigger an
oops or panic in sysfs code that I didn't have a chance to fix yet.
It's very elusive and manifests differently every time.  Fortunately
(for everyone not debugging it), it's rare.


 drivers/net/wireless/rt2x00/rt61pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index fb95b8c..f615fe6 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2600,6 +2600,8 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
+	rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000007);
+
 	/*
 	 * Allocate eeprom data.
 	 */

-- 
Regards,
Pavel Roskin
