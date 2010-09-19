Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0ISSk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 14:40:57 -0400
Subject: [PATCH] b43/b43legacy - Credit Broadcom with enabling the
 development of the drivers
From: David Woodhouse <dwmw2@infradead.org>
To: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 19:40:51 +0100
Message-ID: <1284921651.24835.11.camel@i7.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom seem bizarrely paranoid about the legal consequences of
"enabling" users to violate regulatory requirements.

For some reason they seem to think that an open source driver is more of
a problem than a closed-source driver. Even though it's often actually
*easier* for end-users to use a hex editor to NOP out certain conditional
jumps or change constants used in comparisons for regulatory enforcement,
than it is for them to patch and rebuild an open source driver.

The reverse engineering is hard, of course, but the end-users don't have
to do that for themselves -- they only need to follow instructions like
'set the byte at 0x4572 to 0x90'. More to the point, the reverse-engineering
part is required *anyway* in order to document the hardware so we can write
the open source drivers. We couldn't do an open driver without *first*
knowing enough about the closed one that we can bypass the regulatory
code in it.

Everything we do in the b43 and b43legacy drivers is enabled by
Broadcom's original binary-only drivers.

So let's make that 'enablement' by Broadcom's binary drivers clear in
our source code -- in the hope that it'll narrow the 'risk gap' that
they falsely perceive between open and closed source drivers.

Or failing that, in the hope that it'll give their crack-addled lawyers
aneurysms, and they'll hire some saner ones to replace them.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
I'd like to see the b43 reverse engineering folks release more such
instructions on bypassing the regulatory requirements (boosting TX
power, using wrong channels, etc.) in the Windows and OSX drivers; that
would be another good way to demonstrate how crack-inspired the Broadcom
position on closed vs. open drivers is.


 drivers/net/wireless/b43/debugfs.c       |    3 +++
 drivers/net/wireless/b43/dma.c           |    3 +++
 drivers/net/wireless/b43/leds.c          |    3 +++
 drivers/net/wireless/b43/lo.c            |    3 +++
 drivers/net/wireless/b43/main.c          |    3 +++
 drivers/net/wireless/b43/main.h          |    3 +++
 drivers/net/wireless/b43/pcmcia.c        |    3 +++
 drivers/net/wireless/b43/phy_a.c         |    3 +++
 drivers/net/wireless/b43/phy_common.c    |    3 +++
 drivers/net/wireless/b43/phy_g.c         |    3 +++
 drivers/net/wireless/b43/phy_lp.c        |    3 +++
 drivers/net/wireless/b43/phy_n.c         |    3 +++
 drivers/net/wireless/b43/pio.c           |    3 +++
 drivers/net/wireless/b43/rfkill.c        |    3 +++
 drivers/net/wireless/b43/sdio.c          |    4 ++++
 drivers/net/wireless/b43/sysfs.c         |    3 +++
 drivers/net/wireless/b43/tables.c        |    3 +++
 drivers/net/wireless/b43/tables_lpphy.c  |    3 +++
 drivers/net/wireless/b43/tables_nphy.c   |    3 +++
 drivers/net/wireless/b43/wa.c            |    3 +++
 drivers/net/wireless/b43/xmit.c          |    3 +++
 drivers/net/wireless/b43legacy/debugfs.c |    3 +++
 drivers/net/wireless/b43legacy/dma.c     |    3 +++
 drivers/net/wireless/b43legacy/ilt.c     |    3 +++
 drivers/net/wireless/b43legacy/leds.c    |    3 +++
 drivers/net/wireless/b43legacy/main.c    |    3 +++
 drivers/net/wireless/b43legacy/main.h    |    3 +++
 drivers/net/wireless/b43legacy/phy.c     |    3 +++
 drivers/net/wireless/b43legacy/phy.h     |    3 +++
 drivers/net/wireless/b43legacy/pio.c     |    3 +++
 drivers/net/wireless/b43legacy/radio.c   |    3 +++
 drivers/net/wireless/b43legacy/radio.h   |    3 +++
 drivers/net/wireless/b43legacy/rfkill.c  |    3 +++
 drivers/net/wireless/b43legacy/sysfs.c   |    3 +++
 drivers/net/wireless/b43legacy/xmit.c    |    3 +++
 35 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/debugfs.c b/drivers/net/wireless/b43/debugfs.c
index 80b19a4..8f573fb 100644
--- a/drivers/net/wireless/b43/debugfs.c
+++ b/drivers/net/wireless/b43/debugfs.c
@@ -21,6 +21,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <linux/fs.h>
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 10d0aaf..5d53092 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -25,6 +25,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/leds.c b/drivers/net/wireless/b43/leds.c
index c587115..7be31f8 100644
--- a/drivers/net/wireless/b43/leds.c
+++ b/drivers/net/wireless/b43/leds.c
@@ -24,6 +24,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 94e4f13..de98656 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -25,6 +25,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 20631ae..882fe74 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -29,6 +29,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <linux/delay.h>
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index 40db036..5260069 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -26,6 +26,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #ifndef B43_MAIN_H_
diff --git a/drivers/net/wireless/b43/pcmcia.c b/drivers/net/wireless/b43/pcmcia.c
index dfbc41d..36abc3d 100644
--- a/drivers/net/wireless/b43/pcmcia.c
+++ b/drivers/net/wireless/b43/pcmcia.c
@@ -19,6 +19,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "pcmcia.h"
diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index b6428ec..45a6909 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -24,6 +24,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <linux/slab.h>
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 8f7d7ef..e46e852 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -24,6 +24,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "phy_common.h"
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 0dc33b6..f703c4e 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -24,6 +24,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index fd50eb1..92a06ae 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -21,6 +21,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <linux/slab.h>
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 5a72570..29d909d 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -20,6 +20,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <linux/delay.h>
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index aa12273..cc45579 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -21,6 +21,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index 78016ae..5874d03 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -20,6 +20,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/sdio.c b/drivers/net/wireless/b43/sdio.c
index 45933cf..a4f676c 100644
--- a/drivers/net/wireless/b43/sdio.c
+++ b/drivers/net/wireless/b43/sdio.c
@@ -10,6 +10,10 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or (at
  * your option) any later version.
+ *
+ *
+ * Broadcom enabled the development of this driver, by providing all required
+ * hardware information in the form of binary software drivers.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/b43/sysfs.c b/drivers/net/wireless/b43/sysfs.c
index f1ae4e0..e9d7df2 100644
--- a/drivers/net/wireless/b43/sysfs.c
+++ b/drivers/net/wireless/b43/sysfs.c
@@ -21,6 +21,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <linux/capability.h>
diff --git a/drivers/net/wireless/b43/tables.c b/drivers/net/wireless/b43/tables.c
index 1ef9a64..2d09230 100644
--- a/drivers/net/wireless/b43/tables.c
+++ b/drivers/net/wireless/b43/tables.c
@@ -23,6 +23,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/tables_lpphy.c b/drivers/net/wireless/b43/tables_lpphy.c
index 61027ee..cf86624 100644
--- a/drivers/net/wireless/b43/tables_lpphy.c
+++ b/drivers/net/wireless/b43/tables_lpphy.c
@@ -21,6 +21,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index d96e870..d6af589 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -20,6 +20,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index 9a335da..ef56e6e 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -22,6 +22,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index e6b0528..c9f1cc7 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -25,6 +25,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "xmit.h"
diff --git a/drivers/net/wireless/b43legacy/debugfs.c b/drivers/net/wireless/b43legacy/debugfs.c
index 1f85ac5..76c430d 100644
--- a/drivers/net/wireless/b43legacy/debugfs.c
+++ b/drivers/net/wireless/b43legacy/debugfs.c
@@ -21,6 +21,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <linux/fs.h>
diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index e03e01d..d738335 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -25,6 +25,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43legacy.h"
diff --git a/drivers/net/wireless/b43legacy/ilt.c b/drivers/net/wireless/b43legacy/ilt.c
index a849078..2c64050 100644
--- a/drivers/net/wireless/b43legacy/ilt.c
+++ b/drivers/net/wireless/b43legacy/ilt.c
@@ -23,6 +23,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43legacy.h"
diff --git a/drivers/net/wireless/b43legacy/leds.c b/drivers/net/wireless/b43legacy/leds.c
index 37e9be8..151986c 100644
--- a/drivers/net/wireless/b43legacy/leds.c
+++ b/drivers/net/wireless/b43legacy/leds.c
@@ -24,6 +24,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43legacy.h"
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 1713f5f..f673229 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -27,6 +27,9 @@
  *  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
  *  Boston, MA 02110-1301, USA.
  *
+ *
+ * Broadcom enabled the development of this driver, by providing all required
+ * hardware information in the form of binary software drivers.
  */
 
 #include <linux/delay.h>
diff --git a/drivers/net/wireless/b43legacy/main.h b/drivers/net/wireless/b43legacy/main.h
index 1f0e2e37..a0697346 100644
--- a/drivers/net/wireless/b43legacy/main.h
+++ b/drivers/net/wireless/b43legacy/main.h
@@ -27,6 +27,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #ifndef B43legacy_MAIN_H_
diff --git a/drivers/net/wireless/b43legacy/phy.c b/drivers/net/wireless/b43legacy/phy.c
index 35033dd..87b18e5 100644
--- a/drivers/net/wireless/b43legacy/phy.c
+++ b/drivers/net/wireless/b43legacy/phy.c
@@ -27,6 +27,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <linux/delay.h>
diff --git a/drivers/net/wireless/b43legacy/phy.h b/drivers/net/wireless/b43legacy/phy.h
index ecbe409..14462e0 100644
--- a/drivers/net/wireless/b43legacy/phy.h
+++ b/drivers/net/wireless/b43legacy/phy.h
@@ -27,6 +27,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #ifndef B43legacy_PHY_H_
diff --git a/drivers/net/wireless/b43legacy/pio.c b/drivers/net/wireless/b43legacy/pio.c
index b033b0e..4642a36 100644
--- a/drivers/net/wireless/b43legacy/pio.c
+++ b/drivers/net/wireless/b43legacy/pio.c
@@ -21,6 +21,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "b43legacy.h"
diff --git a/drivers/net/wireless/b43legacy/radio.c b/drivers/net/wireless/b43legacy/radio.c
index 2df545c..e6c1bec 100644
--- a/drivers/net/wireless/b43legacy/radio.c
+++ b/drivers/net/wireless/b43legacy/radio.c
@@ -27,6 +27,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <linux/delay.h>
diff --git a/drivers/net/wireless/b43legacy/radio.h b/drivers/net/wireless/b43legacy/radio.h
index ec4de28..e74f3d8 100644
--- a/drivers/net/wireless/b43legacy/radio.h
+++ b/drivers/net/wireless/b43legacy/radio.h
@@ -26,6 +26,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #ifndef B43legacy_RADIO_H_
diff --git a/drivers/net/wireless/b43legacy/rfkill.c b/drivers/net/wireless/b43legacy/rfkill.c
index d579df7..77b46c9 100644
--- a/drivers/net/wireless/b43legacy/rfkill.c
+++ b/drivers/net/wireless/b43legacy/rfkill.c
@@ -20,6 +20,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "radio.h"
diff --git a/drivers/net/wireless/b43legacy/sysfs.c b/drivers/net/wireless/b43legacy/sysfs.c
index 56c384f..f741778 100644
--- a/drivers/net/wireless/b43legacy/sysfs.c
+++ b/drivers/net/wireless/b43legacy/sysfs.c
@@ -21,6 +21,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include "sysfs.h"
diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index 7d177d9..384ff7e 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -26,6 +26,9 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+
+  Broadcom enabled the development of this driver, by providing all required
+  hardware information in the form of binary software drivers.
 */
 
 #include <net/dst.h>
-- 
1.7.2.2


