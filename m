Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbYB2PxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 10:53:24 -0500
Subject: p54: fix EEPROM structure endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 13:56:33 +0100
Message-Id: <1204289793.3938.20.camel@johannes.berg> (sfid-20080229_155329_330042_63F81510)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the EEPROM structure is read from hardware, it is
always little endian, annotate that in the struct and
make sure to convert where applicable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>
---
Does anybody have a p54 card and big endian hardware to test it on? I'm
fairly sure this is a correct change but if it currently works on big
endian the change would be bad (and I'd be rather surprised.)

 drivers/net/wireless/p54common.c |    2 +-
 drivers/net/wireless/p54common.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- everything.orig/drivers/net/wireless/p54common.c	2008-02-28 17:26:23.000000000 +0100
+++ everything/drivers/net/wireless/p54common.c	2008-02-29 13:53:05.000000000 +0100
@@ -212,7 +212,7 @@ int p54_parse_eeprom(struct ieee80211_hw
 	int err;
 
 	wrap = (struct eeprom_pda_wrap *) eeprom;
-	entry = (void *)wrap->data + wrap->len;
+	entry = (void *)wrap->data + le16_to_cpu(wrap->len);
 	i += 2;
 	i += le16_to_cpu(entry->len)*2;
 	while (i < len) {
--- everything.orig/drivers/net/wireless/p54common.h	2008-02-19 23:10:32.000000000 +0100
+++ everything/drivers/net/wireless/p54common.h	2008-02-29 13:53:05.000000000 +0100
@@ -53,10 +53,10 @@ struct pda_entry {
 } __attribute__ ((packed));
 
 struct eeprom_pda_wrap {
-	u32 magic;
-	u16 pad;
-	u16 len;
-	u32 arm_opcode;
+	__le32 magic;
+	__le16 pad;
+	__le16 len;
+	__le32 arm_opcode;
 	u8 data[0];
 } __attribute__ ((packed));
 


