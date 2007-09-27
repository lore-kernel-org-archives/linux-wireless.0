Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34693
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759565AbXI0TfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 15:35:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rfkill: Add support for hardware-only rfkill buttons
Date: Thu, 27 Sep 2007 21:34:23 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709272134.23888.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Buttons that work directly on hardware cannot support
the "user_claim" functionality. Add a flag to signal
this and return -EOPNOTSUPP in this case.
b43 is such a device.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/include/linux/rfkill.h
===================================================================
--- wireless-2.6.orig/include/linux/rfkill.h	2007-09-27 16:21:37.000000000 +0200
+++ wireless-2.6/include/linux/rfkill.h	2007-09-27 20:54:25.000000000 +0200
@@ -52,6 +52,8 @@ enum rfkill_state {
  * @type: Radio type which the button controls, the value stored
  *	here should be a value from enum rfkill_type.
  * @state: State of the switch (on/off).
+ * @user_claim_unsupported: Whether the hardware supports exclusive
+ *	RF-kill control by userspace. Set this before registering.
  * @user_claim: Set when the switch is controlled exlusively by userspace.
  * @mutex: Guards switch state transitions
  * @data: Pointer to the RF button drivers private data which will be
@@ -69,6 +71,7 @@ struct rfkill {
 	enum rfkill_type type;
 
 	enum rfkill_state state;
+	bool user_claim_unsupported;
 	bool user_claim;
 
 	struct mutex mutex;
Index: wireless-2.6/net/rfkill/rfkill.c
===================================================================
--- wireless-2.6.orig/net/rfkill/rfkill.c	2007-09-27 16:32:30.000000000 +0200
+++ wireless-2.6/net/rfkill/rfkill.c	2007-09-27 20:54:50.000000000 +0200
@@ -190,6 +190,10 @@ static ssize_t rfkill_claim_store(struct
 	if (error)
 		return error;
 
+	if (rfkill->user_claim_unsupported) {
+		error = -EOPNOTSUPP;
+		goto out_unlock;
+	}
 	if (rfkill->user_claim != claim) {
 		if (!claim)
 			rfkill_toggle_radio(rfkill,
@@ -197,9 +201,10 @@ static ssize_t rfkill_claim_store(struct
 		rfkill->user_claim = claim;
 	}
 
+out_unlock:
 	mutex_unlock(&rfkill_mutex);
 
-	return count;
+	return error ? error : count;
 }
 
 static struct device_attribute rfkill_dev_attrs[] = {
