Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63520 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0JBJfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:14 -0400
Received: by wyb28 with SMTP id 28so3658520wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:13 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/20] rt2x00: Don't overwrite beacon buffers in pairwise key setup
Date: Sat, 2 Oct 2010 11:26:17 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010021126.18748.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

rt2800 devices use parts of the pariwise key table to store the beacon
frames for beacon 6 and 7. To not overwrite the beacon frame buffers
limit the number of entries we store in the pairwise key table to 222.

Also add some descriptive comments about this shared memory usage.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   21 ++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 2edc774..e1583cf 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1435,6 +1435,24 @@
 
 /*
  * Security key table memory.
+ *
+ * The pairwise key table shares some memory with the beacon frame
+ * buffers 6 and 7. That basically means that when beacon 6 & 7
+ * are used we should only use the reduced pairwise key table which
+ * has a maximum of 222 entries.
+ *
+ * ---------------------------------------------
+ * |0x4000 | Pairwise Key   | Reduced Pairwise |
+ * |       | Table          | Key Table        |
+ * |       | Size: 256 * 32 | Size: 222 * 32   |
+ * |0x5BC0 |                |-------------------
+ * |       |                | Beacon 6         |
+ * |0x5DC0 |                |-------------------
+ * |       |                | Beacon 7         |
+ * |0x5FC0 |                |-------------------
+ * |0x5FFF |                |
+ * --------------------------
+ *
  * MAC_WCID_BASE: 8-bytes (use only 6 bytes) * 256 entry
  * PAIRWISE_KEY_TABLE_BASE: 32-byte * 256 entry
  * MAC_IVEIV_TABLE_BASE: 8-byte * 256-entry
@@ -1584,7 +1602,8 @@ struct mac_iveiv_entry {
  * 2. Extract memory from FCE table for BCN 4~5
  * 3. Extract memory from Pair-wise key table for BCN 6~7
  *    It occupied those memory of wcid 238~253 for BCN 6
- *    and wcid 222~237 for BCN 7
+ *    and wcid 222~237 for BCN 7 (see Security key table memory
+ *    for more info).
  *
  * IMPORTANT NOTE: Not sure why legacy driver does this,
  * but HW_BEACON_BASE7 is 0x0200 bytes below HW_BEACON_BASE6.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c7076de..daa32ae 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1031,8 +1031,12 @@ int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		 * 1 pairwise key is possible per AID, this means that the AID
 		 * equals our hw_key_idx. Make sure the WCID starts _after_ the
 		 * last possible shared key entry.
+		 *
+		 * Since parts of the pairwise key table might be shared with
+		 * the beacon frame buffers 6 & 7 we should only write into the
+		 * first 222 entries.
 		 */
-		if (crypto->aid > (256 - 32))
+		if (crypto->aid > (222 - 32))
 			return -ENOSPC;
 
 		key->hw_key_idx = 32 + crypto->aid;
-- 
1.7.2.3

