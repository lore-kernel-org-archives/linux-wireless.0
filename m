Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49339 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZGTPcw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 11:32:52 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2009 08:32:52 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Stephen Chen <stephen.chen@atheros.com>,
	David Quan <david.quan@atheros.com>,
	Tony Yang <tony.yang@atheros.com>
Subject: [PATCH] ath: add support for special 0x8000 regulatory domain
Date: Mon, 20 Jul 2009 08:32:47 -0700
Message-ID: <1248103967-5320-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two users of ar9170 devices have now reported their cards
have been programmed with a regulatory domain of 0x8000.
This is not a valid regulatory domain as such these users were
unable to use these devices. Since this doesn't seem to be
a device EEPROM corruption we must treat it specially. It
may have been possible the manufacturer intended to use 0x0
as the regulatory domain and that would ultimately yield
to US but since we cannot get confirmationf or this we
default this special case to one of our world regulatory
domains, specifically 0x64.

Reported-by: DavidFreeman on #linux-wireless
Reported-by: Joerg Albert <jal2@gmx.de>
Cc: Christian Lamparter <chunkeey@web.de>,
Cc: Stephen Chen <stephen.chen@atheros.com>
Cc: David Quan <david.quan@atheros.com>
Cc: Tony Yang <tony.yang@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/regd.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index f37c832..077bcc1 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -474,6 +474,21 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 	return 0;
 }
 
+/*
+ * Some users have reported their EEPROM programmed with
+ * 0x8000 set, this is not a supported regulatory domain
+ * but since we have more than one user with it we need
+ * a solution for them. We default to 0x64, which is the
+ * default Atheros world regulatory domain.
+ */
+static void ath_regd_sanitize(struct ath_regulatory *reg)
+{
+	if (reg->current_rd != COUNTRY_ERD_FLAG)
+		return;
+	printk(KERN_DEBUG "ath: EEPROM regdomain sanitized\n");
+	reg->current_rd = 0x64;
+}
+
 int
 ath_regd_init(struct ath_regulatory *reg,
 	      struct wiphy *wiphy,
@@ -486,6 +501,8 @@ ath_regd_init(struct ath_regulatory *reg,
 	if (!reg)
 		return -EINVAL;
 
+	ath_regd_sanitize(reg);
+
 	printk(KERN_DEBUG "ath: EEPROM regdomain: 0x%0x\n", reg->current_rd);
 
 	if (!ath_regd_is_eeprom_valid(reg)) {
-- 
1.6.3.3

