Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33050 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbYHBSLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 14:11:15 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Date: Sat,  2 Aug 2008 15:11:04 -0300
Message-Id: <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> (sfid-20080802_201122_064360_071330B0)
In-Reply-To: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, rfkill would stand in the way of properly supporting wireless
devices that are capable of waking the system up from sleep or hibernation
when they receive a special wireless message.

Since rfkill attempts to soft-block any transmitters during class suspend,
it would be difficult for the wireless device driver to know whether it is
allowed to keep the transmitter active or not, and since the state of the
transmitter might impact on functionality needed by the device to be able
to know it has to wake the system, this is not good.

In order to properly support these devices, add a flag that requests the
class suspend handlers to NOT attempt to block the transmitter on suspend.
This way, the wireless device driver can be sure that if it is in any of
the blocked states when entering suspend it MUST keep its transmitter
disabled (even if that breaks wake-on-wireless-packet).

Note that if the transmitter does not need to be functioning for
wake-on-wireless-packet, the new flag should not be used.  If the
wake-on-wireless-packet is not enabled for the current suspend or
hibernation cycle, and the wireless driver requested that rfkill do not
block the transmitter, it MUST block the transmitter by itself when the
system attempts to enter the suspend/hibernation state.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 Documentation/rfkill.txt |   29 ++++++++++++++++++++++++++++-
 include/linux/rfkill.h   |    4 ++++
 net/rfkill/rfkill.c      |    3 ++-
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index 6fcb306..888d756 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -341,6 +341,8 @@ key that does nothing by itself, as well as any hot key that is type-specific
 3.1 Guidelines for wireless device drivers
 ------------------------------------------
 
+(in this text, rfkill->foo means the foo field of struct rfkill).
+
 1. Each independent transmitter in a wireless device (usually there is only one
 transmitter per device) should have a SINGLE rfkill class attached to it.
 
@@ -364,10 +366,35 @@ when possible) the overall transmitter rfkill state, not of a particular rfkill
 line.
 
 5. During suspend, the rfkill class will attempt to soft-block the radio
-through a call to rfkill->toggle_radio, and will try to restore its previous
+through a call to the rfkill->toggle_radio callback (unless the
+rfkill->no_block_on_pm_sleep flag set), and will try to restore its previous
 state during resume.  After a rfkill class is suspended, it will *not* call
 rfkill->toggle_radio until it is resumed.
 
+rfkill->no_block_on_pm_sleep is to be used by devices that need to handle
+suspend by themselves (e.g. due to wake-on-wireless-packet functionality) in
+such a way that the automated soft-block would get in the way.
+
+The wireless device driver MUST NOT leave the transmitter enabled during
+suspend and hibernation unless:
+
+	5.1. The transmitter has to be enabled for the
+	wake-on-wireless-packet functionality to work, and that
+	functionality is enabled for this suspend/hibernation cycle.
+
+AND
+
+	5.2. The device was not on a user-requested BLOCKED state before
+	the suspend (i.e. the driver must NOT unblock a device, not even
+	to support wake-on-wireless-packet).
+
+In other words, there is absolutely no allowed scenario where a driver can
+automatically take action to unblock a rfkill controller (obviously, this deals
+with scenarios where soft-blocking or both soft and hard blocking is happening.
+Scenarios where hardware rfkill lines are the only ones blocking the
+transmitter are outside of this rule, since the wireless device driver does not
+control its input hardware rfkill lines in the first place).
+
 Example of a WLAN wireless driver connected to the rfkill subsystem:
 --------------------------------------------------------------------
 
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 4cd64b0..97b767b 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -84,6 +84,8 @@ enum rfkill_state {
  * @dev: Device structure integrating the switch into device tree.
  * @node: Used to place switch into list of all switches known to the
  *	the system.
+ * @no_block_on_pm_sleep: Whether the rfkill class should block
+ *	the wireless transmitter during suspend.
  *
  * This structure represents a RF switch located on a network device.
  */
@@ -108,6 +110,8 @@ struct rfkill {
 
 	struct device dev;
 	struct list_head node;
+
+	bool no_block_on_pm_sleep;
 };
 #define to_rfkill(d)	container_of(d, struct rfkill, dev)
 
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 22da6e8..e92828b 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -514,7 +514,8 @@ static int rfkill_suspend(struct device *dev, pm_message_t state)
 	struct rfkill *rfkill = to_rfkill(dev);
 
 	if (dev->power.power_state.event != state.event) {
-		if (state.event & PM_EVENT_SLEEP) {
+		if (state.event & PM_EVENT_SLEEP &&
+		    !rfkill->no_block_on_pm_sleep) {
 			/* Stop transmitter, keep state, no notifies */
 			update_rfkill_state(rfkill);
 
-- 
1.5.6.3

