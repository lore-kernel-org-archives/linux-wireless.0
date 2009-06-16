Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51453 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZFPNyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 09:54:05 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so6028523ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 06:54:08 -0700 (PDT)
Message-ID: <4A37A3FC.9060206@tuffmail.co.uk>
Date: Tue, 16 Jun 2009 14:54:04 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] rfkill: export persistent attribute in sysfs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This information allows userspace to implement a hybrid policy where
it can store the rfkill soft-blocked state in platform non-volatile
storage if available, and if not then file-based storage can be used.

Some users prefer platform non-volatile storage because of the behaviour
when dual-booting multiple versions of Linux, or if the rfkill setting
is changed in the BIOS setting screens, or if the BIOS responds to
wireless-toggle hotkeys itself before the relevant platform driver has
been loaded.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 Documentation/rfkill.txt |    2 ++
 include/linux/rfkill.h   |    5 +++--
 net/rfkill/core.c        |   10 ++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index c8acd86..b486050 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -111,6 +111,8 @@ following attributes:
 
 	name: Name assigned by driver to this key (interface or driver name).
 	type: Driver type string ("wlan", "bluetooth", etc).
+	persistent: Whether the soft blocked state is initialised from
+	            non-volatile storage at startup.
 	state: Current state of the transmitter
 		0: RFKILL_STATE_SOFT_BLOCKED
 			transmitter is turned off by software
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 84b6b9c..0592552 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -259,8 +259,9 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
  * userspace) of their initial state.  It should only be used before
  * registration.
  *
- * In addition, it marks the device as "persistent".  Persistent devices
- * are expected to preserve preserve their own state when suspended.
+ * In addition, it marks the device as "persistent", an attribute which
+ * can be read by userspace.  Persistent devices are expected to preserve
+ * preserve their own state when suspended.
  */
 void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked);
 
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index dcf8df7..79693fe 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -610,6 +610,15 @@ static ssize_t rfkill_idx_show(struct device *dev,
 	return sprintf(buf, "%d\n", rfkill->idx);
 }
 
+static ssize_t rfkill_persistent_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+
+	return sprintf(buf, "%d\n", rfkill->persistent);
+}
+
 static u8 user_state_from_blocked(unsigned long state)
 {
 	if (state & RFKILL_BLOCK_HW)
@@ -668,6 +677,7 @@ static struct device_attribute rfkill_dev_attrs[] = {
 	__ATTR(name, S_IRUGO, rfkill_name_show, NULL),
 	__ATTR(type, S_IRUGO, rfkill_type_show, NULL),
 	__ATTR(index, S_IRUGO, rfkill_idx_show, NULL),
+	__ATTR(persistent, S_IRUGO, rfkill_persistent_show, NULL),
 	__ATTR(state, S_IRUGO|S_IWUSR, rfkill_state_show, rfkill_state_store),
 	__ATTR(claim, S_IRUGO|S_IWUSR, rfkill_claim_show, rfkill_claim_store),
 	__ATTR_NULL


