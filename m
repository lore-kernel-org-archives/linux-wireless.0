Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:44629 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbXBSCq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Feb 2007 21:46:57 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HIyWw-0007B3-PK
	for linux-wireless@vger.kernel.org; Sun, 18 Feb 2007 21:45:30 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] rt2x00: fix memory corruption caused by eeprom buffer overflow
To: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Date: Sun, 18 Feb 2007 21:46:54 -0500
Message-ID: <20070219024654.3480.9392.stgit@dl.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

eeprom_93cx6_multiread() expects the last argument to be the buffer
length in words, but kzalloc() expects the length in bytes.  This
results in dangerous kernel memory corruption.

Since there are already occurrences of "EEPROM_SIZE * sizeof(u16)" in
the driver, I'm assuming that EEPROM_SIZE is in words, so the driver
needs to allocate more memory.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/d80211/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/d80211/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/d80211/rt2x00/rt2500usb.c |    2 +-
 drivers/net/wireless/d80211/rt2x00/rt61pci.c   |    2 +-
 drivers/net/wireless/d80211/rt2x00/rt73usb.c   |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/d80211/rt2x00/rt2400pci.c b/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
index 2e3a514..ef47554 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
@@ -2370,7 +2370,7 @@ static int rt2400pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE * sizeof(u16), GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/d80211/rt2x00/rt2500pci.c b/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
index 305cff6..1085978 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
@@ -2526,7 +2526,7 @@ static int rt2500pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE * sizeof(u16), GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/d80211/rt2x00/rt2500usb.c b/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
index 0976c98..0ace302 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
@@ -2386,7 +2386,7 @@ static int rt2500usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE * sizeof(u16), GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/d80211/rt2x00/rt61pci.c b/drivers/net/wireless/d80211/rt2x00/rt61pci.c
index 547c660..46c552f 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt61pci.c
@@ -3015,7 +3015,7 @@ static int rt61pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE * sizeof(u16), GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/d80211/rt2x00/rt73usb.c b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
index be66e2f..6fa5a7e 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
@@ -2705,7 +2705,7 @@ static int rt73usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL * sizeof(u16));
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 

