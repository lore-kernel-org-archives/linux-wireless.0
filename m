Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:7765 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbbFJSKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 14:10:39 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH] mt7601u: don't warn about devices without per-rate power table
Date: Wed, 10 Jun 2015 20:10:09 +0200
Message-Id: <1433959809-919-1-git-send-email-moorray3@wp.pl> (sfid-20150610_201043_059791_38F11DBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

We expect EEPROM per-rate power table to be filled with
s6 values and warn user if values are invalid.  However,
there appear to be devices which don't have this section
of EEPROM initialized.  In such case we should ignore
the values and leave the driver power tables set to zero.

Note that vendor driver doesn't care about this case but
mt76x2 skips 0xff per value.  We take mt76x2's approach.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
Kalle, I tried my best with patchwork settings but if my name still
contains a question mark on this submission you can go ahead and
apply automatically anyway.  The patch itself does not have any hairy
characters and Johannes said on IRC yesterday that pwclient ends up
doing the right thing in this case.
---
drivers/net/wireless/mediatek/mt7601u/eeprom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
index ce3837f270f0..8d8ee0344f7b 100644
--- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
@@ -277,6 +277,10 @@ mt7601u_extra_power_over_mac(struct mt7601u_dev *dev)
 static void
 mt7601u_set_power_rate(struct power_per_rate *rate, s8 delta, u8 value)
 {
+	/* Invalid? Note: vendor driver does not handle this */
+	if (value == 0xff)
+		return;
+
 	rate->raw = s6_validate(value);
 	rate->bw20 = s6_to_int(value);
 	/* Note: vendor driver does cap the value to s6 right away */
-- 
2.1.0

