Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:60502 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbcA0NqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 08:46:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hostap: avoid uninitialized variable use in hfa384x_get_rid
Date: Wed, 27 Jan 2016 14:45:26 +0100
Message-Id: <1453902342-3420391-1-git-send-email-arnd@arndb.de> (sfid-20160127_144639_297089_3DA92CE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver reads a value from hfa384x_from_bap(), which may fail,
and then assigns the value to a local variable. gcc detects that
in in the failure case, the 'rlen' variable now contains
uninitialized data:

In file included from ../drivers/net/wireless/intersil/hostap/hostap_pci.c:220:0:
drivers/net/wireless/intersil/hostap/hostap_hw.c: In function 'hfa384x_get_rid':
drivers/net/wireless/intersil/hostap/hostap_hw.c:842:5: warning: 'rec' may be used uninitialized in this function [-Wmaybe-uninitialized]
  if (le16_to_cpu(rec.len) == 0) {

To ensure we get consistent error handling here, this changes the code
to only set rlen if we actually read data correctly, which also takes
care of the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intersil/hostap/hostap_hw.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index 6df3ee561d52..6dbf8ee9490a 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -839,12 +839,15 @@ static int hfa384x_get_rid(struct net_device *dev, u16 rid, void *buf, int len,
 	if (!res)
 		res = hfa384x_from_bap(dev, BAP0, &rec, sizeof(rec));
 
-	if (le16_to_cpu(rec.len) == 0) {
-		/* RID not available */
-		res = -ENODATA;
+	if (!res) {
+		if (le16_to_cpu(rec.len) == 0) {
+			/* RID not available */
+			res = -ENODATA;
+		}
+
+		rlen = (le16_to_cpu(rec.len) - 1) * 2;
 	}
 
-	rlen = (le16_to_cpu(rec.len) - 1) * 2;
 	if (!res && exact_len && rlen != len) {
 		printk(KERN_DEBUG "%s: hfa384x_get_rid - RID len mismatch: "
 		       "rid=0x%04x, len=%d (expected %d)\n",
-- 
2.7.0

