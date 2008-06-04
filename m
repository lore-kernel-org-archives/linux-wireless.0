Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38671 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbYFDDKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:10:21 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Date: Wed,  4 Jun 2008 00:10:06 -0300
Message-Id: <1212549017-30144-2-git-send-email-hmh@hmh.eng.br> (sfid-20080604_051031_143352_40508FA6)
In-Reply-To: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill really should have been named rfswitch.  As it is, one can get
confused whether RFKILL_STATE_ON means the KILL switch is on (and
therefore, the radio is being *blocked* from operating), or whether it
means the RADIO rf output is on.

Clearly state that RFKILL_STATE_ON means the radio is *unblocked* from
operating (i.e. there is no rf killing going on).

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 Documentation/rfkill.txt |    7 +++++++
 include/linux/rfkill.h   |    6 +++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index a83ff23..ec75d6d 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -8,6 +8,13 @@ rfkill - RF switch subsystem support
 ===============================================================================
 1: Implementation details
 
+The rfkill switch subsystem exists to add a generic interface to circuitry that
+can enable or disable the RF output of a radio *transmitter* of any type.
+
+When a rfkill switch is in the RFKILL_STATE_ON, the radio transmitter is
+*enabled*.  When the rfkill switch is in the RFKILL_STATE_OFF, the radio
+transmitter is *disabled*.
+
 The rfkill switch subsystem offers support for keys often found on laptops
 to enable wireless devices like WiFi and Bluetooth.
 
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index e3ab21d..ca89ae1 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -44,8 +44,8 @@ enum rfkill_type {
 };
 
 enum rfkill_state {
-	RFKILL_STATE_OFF	= 0,
-	RFKILL_STATE_ON		= 1,
+	RFKILL_STATE_OFF	= 0,	/* Radio output blocked */
+	RFKILL_STATE_ON		= 1,	/* Radio output active */
 };
 
 /**
@@ -53,7 +53,7 @@ enum rfkill_state {
  * @name: Name of the switch.
  * @type: Radio type which the button controls, the value stored
  *	here should be a value from enum rfkill_type.
- * @state: State of the switch (on/off).
+ * @state: State of the switch, "ON" means radio can operate.
  * @user_claim_unsupported: Whether the hardware supports exclusive
  *	RF-kill control by userspace. Set this before registering.
  * @user_claim: Set when the switch is controlled exlusively by userspace.
-- 
1.5.5.3

