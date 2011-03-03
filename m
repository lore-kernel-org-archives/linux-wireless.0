Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1CCSs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:57 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1356532wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:57 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/19] rt2x00: Fix rt2800 key assignment in multi bssid setups
Date: Thu, 3 Mar 2011 19:44:33 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031943.50656.IvDoorn@gmail.com> <201103031944.11965.IvDoorn@gmail.com>
In-Reply-To: <201103031944.11965.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031944.33950.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

When setting up multiple BSSIDs in AP mode on an rt2800pci device we
previously used the STAs AID to select an appropriate key slot. But
since the AID is per VIF we can end up with two STAs having the same AID
and thus using the same key index. This resulted in one STA overwriting
the key information of another STA.

Fix this by simply searching for the next unused entry in the pairwise
key table.

Also bring the key table init in sync with deleting keys by initializing
the key table entries to 0 instead of 1.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   43 +++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d789d5b..ba87662 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1093,27 +1093,44 @@ int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2800_config_shared_key);
 
+static inline int rt2800_find_pairwise_keyslot(struct rt2x00_dev *rt2x00dev)
+{
+	int idx;
+	u32 offset, reg;
+
+	/*
+	 * Search for the first free pairwise key entry and return the
+	 * corresponding index.
+	 *
+	 * Make sure the WCID starts _after_ the last possible shared key
+	 * entry (>32).
+	 *
+	 * Since parts of the pairwise key table might be shared with
+	 * the beacon frame buffers 6 & 7 we should only write into the
+	 * first 222 entries.
+	 */
+	for (idx = 33; idx <= 222; idx++) {
+		offset = MAC_WCID_ATTR_ENTRY(idx);
+		rt2800_register_read(rt2x00dev, offset, &reg);
+		if (!reg)
+			return idx;
+	}
+	return -1;
+}
+
 int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 			       struct rt2x00lib_crypto *crypto,
 			       struct ieee80211_key_conf *key)
 {
 	struct hw_key_entry key_entry;
 	u32 offset;
+	int idx;
 
 	if (crypto->cmd == SET_KEY) {
-		/*
-		 * 1 pairwise key is possible per AID, this means that the AID
-		 * equals our hw_key_idx. Make sure the WCID starts _after_ the
-		 * last possible shared key entry.
-		 *
-		 * Since parts of the pairwise key table might be shared with
-		 * the beacon frame buffers 6 & 7 we should only write into the
-		 * first 222 entries.
-		 */
-		if (crypto->aid > (222 - 32))
+		idx = rt2800_find_pairwise_keyslot(rt2x00dev);
+		if (idx < 0)
 			return -ENOSPC;
-
-		key->hw_key_idx = 32 + crypto->aid;
+		key->hw_key_idx = idx;
 
 		memcpy(key_entry.key, crypto->key,
 		       sizeof(key_entry.key));
@@ -2443,7 +2460,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
 					      wcid, sizeof(wcid));
 
-		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
+		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 0);
 		rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
 	}
 
-- 
1.7.2.3

