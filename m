Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYB2W2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 17:28:51 -0500
Subject: [PATCH] p54: fix eeprom parser length sanity checks
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 23:28:25 +0100
Message-Id: <1204324105.3938.49.camel@johannes.berg> (sfid-20080229_222856_996001_02EB6205)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I called p54_parse_eeprom() on a hand-coded structure
I managed to make a small mistake with wrap->len which caused
a segfault a few lines down when trying to read entry->len.
This patch changes the validation code to avoid such problems.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/p54common.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- everything.orig/drivers/net/wireless/p54common.c	2008-02-29 23:00:30.000000000 +0100
+++ everything/drivers/net/wireless/p54common.c	2008-02-29 23:27:55.000000000 +0100
@@ -206,18 +206,23 @@ int p54_parse_eeprom(struct ieee80211_hw
 	struct p54_common *priv = dev->priv;
 	struct eeprom_pda_wrap *wrap = NULL;
 	struct pda_entry *entry;
-	int i = 0;
 	unsigned int data_len, entry_len;
 	void *tmp;
 	int err;
+	u8 *end = (u8 *)eeprom + len;
 
 	wrap = (struct eeprom_pda_wrap *) eeprom;
 	entry = (void *)wrap->data + le16_to_cpu(wrap->len);
-	i += 2;
-	i += le16_to_cpu(entry->len)*2;
-	while (i < len) {
+
+	/* verify that at least the entry length/code fits */
+	while ((u8 *)entry <= end - sizeof(*entry)) {
 		entry_len = le16_to_cpu(entry->len);
 		data_len = ((entry_len - 1) << 1);
+
+		/* abort if entry exceeds whole structure */
+		if ((u8 *)entry + sizeof(*entry) + data_len > end)
+			break;
+
 		switch (le16_to_cpu(entry->code)) {
 		case PDR_MAC_ADDRESS:
 			SET_IEEE80211_PERM_ADDR(dev, entry->data);
@@ -289,7 +294,8 @@ int p54_parse_eeprom(struct ieee80211_hw
 			priv->version = *(u8 *)(entry->data + 1);
 			break;
 		case PDR_END:
-			i = len;
+			/* make it overrun */
+			entry_len = len;
 			break;
 		default:
 			printk(KERN_INFO "p54: unknown eeprom code : 0x%x\n",
@@ -298,8 +304,6 @@ int p54_parse_eeprom(struct ieee80211_hw
 		}
 
 		entry = (void *)entry + (entry_len + 1)*2;
-		i += 2;
-		i += entry_len*2;
 	}
 
 	if (!priv->iq_autocal || !priv->output_limit || !priv->curve_data) {


