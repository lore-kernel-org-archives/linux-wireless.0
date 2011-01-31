Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:40846 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab1AaVpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:45:22 -0500
Date: Mon, 31 Jan 2011 15:45:16 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Wolfgang Kufner <wolfgang.kufner@gmail.com>
Subject: Missing skb_pad() return value checks in rt2x00 driver
Message-ID: <20110131214515.GC6368@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In looking at the following commit:

  commit 739fd9405416e22732e46a9226a8cac379bd57fc
  Author: Wolfgang Kufner <wolfgang.kufner@gmail.com>
  Date:   Mon Dec 13 12:39:12 2010 +0100
  
      rt2x00: Pad beacon to multiple of 32 bits.

I noticed that the skb_pad() calls it introduces are not being checked
for failure. I don't know whether or not it's possible for these calls
to fail in this context; would it make sense to incorporate the patch
below?

Thanks,
Seth

>From 6cebee1731e158df888e5ec19f5c221ac8a1a213 Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Mon, 31 Jan 2011 15:06:47 -0600
Subject: [PATCH] rt2x00: Check for errors from skb_pad() calls

Commit 739fd94 ("rt2x00: Pad beacon to multiple of 32 bits")
added calls to skb_pad() without checking the return value,
which could cause problems if any of those calls does happen
to fail. Add checks to prevent this from happening and move
the padding to the tops of the relevant functions so we can
bail out before writing to any registers.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   13 +++++++++++--
 drivers/net/wireless/rt2x00/rt61pci.c   |   13 +++++++++++--
 drivers/net/wireless/rt2x00/rt73usb.c   |   13 +++++++++++--
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f8ba01c..79d17da 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -776,6 +776,17 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	u32 reg;
 
 	/*
+	 * Pad out the beacon to a 32-bit boundary
+	 */
+	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
+	if (padding_len && skb_pad(entry->skb, padding_len)) {
+		dev_err(rt2x00dev->dev, "Failure padding beacon, aborting\n");
+		/* skb freed by skb_pad() on failure */
+		entry->skb = NULL;
+		return;
+	}
+
+	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
@@ -809,8 +820,6 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	/*
 	 * Write entire beacon with TXWI and padding to register.
 	 */
-	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
-	skb_pad(entry->skb, padding_len);
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
 				   entry->skb->len + padding_len);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 8de44dd..83ac31e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1965,6 +1965,17 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	u32 reg;
 
 	/*
+	 * Pad out the beacon to a 32-bit boundary
+	 */
+	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
+	if (padding_len && skb_pad(entry->skb, padding_len)) {
+		dev_err(rt2x00dev->dev, "Failure padding beacon, aborting\n");
+		/* skb freed by skb_pad() on failure */
+		entry->skb = NULL;
+		return;
+	}
+
+	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
@@ -1985,8 +1996,6 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Write entire beacon with descriptor and padding to register.
 	 */
-	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
-	skb_pad(entry->skb, padding_len);
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
 	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
 				      entry_priv->desc, TXINFO_SIZE);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 029be3c..5b15609 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1550,6 +1550,17 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	u32 reg;
 
 	/*
+	 * Pad out the beacon to a 32-bit boundary
+	 */
+	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
+	if (padding_len && skb_pad(entry->skb, padding_len)) {
+		dev_err(rt2x00dev->dev, "Failure padding beacon, aborting\n");
+		/* skb freed by skb_pad() on failure */
+		entry->skb = NULL;
+		return;
+	}
+
+	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
@@ -1576,8 +1587,6 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	/*
 	 * Write entire beacon with descriptor and padding to register.
 	 */
-	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
-	skb_pad(entry->skb, padding_len);
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
 	rt2x00usb_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
 				      entry->skb->len + padding_len);
-- 
1.7.1

