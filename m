Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526AA4718DD;
	Fri, 16 Oct 2026 10:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792145767; cv=none; b=qaGd5RZ5NO4+/luw9x5IWgjsGWhKIEWwBzK21hYcfdOH85t/DWRX7Za4nCYG+Js62vN5wN2kNCW/MVmANrRK50qsIwuONX2WYc/CBcX4m9XZNnm8xEtAS/+4BFCyQCTReyZPDabexIx7FREZyq7NypyYQk9NIYGypCaKWzEne4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792145767; c=relaxed/simple;
	bh=SX/Nyoc10AmqAYlg50EdZr87bP49HkQR6YwD3NAPz18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qc5vFj4KNIo0xxh1tzkNAF7cvMwCW7dR8bGw9LCMj8bZCwCSDQjp5fnKBbTZzO2lGiVYt3a5LBxU4FEk6LeIJu7j9PlTtDpYx01c7sVZWMrmG1HL9/0HotmKo+q5p6DltATiJ4Y7Yqs9zslKkBz8OeKHVv/t1dLwlekd4loooXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gi/mW4N1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gi/mW4N1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A161F000C4;
	Fri, 16 Oct 2026 10:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792145766;
	bh=/ZymMoga3oZlL86CdCNHp64V7x9A2HNJCoca2j34WpQ=;
	h=From:To:Cc:Subject:Date;
	b=gi/mW4N1s5oOsispE4u++1MDG1h5qiB39ZaDdJdxpIW/Oxyx63XAySOUhMEDayX68
	 fF4A9b/e1CPc371JkjBNrnd38TY0ki3ZmGcGh+jT+zJNnHJDZrEBar5Byq/FEMLhkY
	 32Z6fj9Qz3kBXwj6r9hkgwlV/mA9lph/GZQt7S/Ig/ptHrr/J1mp7pwJmEzYGIz+cJ
	 R3Jdgs/0GhUfS3sN+shaTzreSpW6mrPdDE+Bv4eHiJEyTbN2yFnKEn8f/r3GBuQEQq
	 ZXXyEa6s+MoeMBnCzeV5DamloAkOczsNlpzE8BpOnExqOg8qUIBzNLmkgGOU28jKUg
	 o7kN7atk/H4Kg==
From: Eric Dumazet <edumazet@kernel.org>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Eric Dumazet <edumazet@kernel.org>
Subject: [PATCH -next] wifi: rt2x00: use skb_put_padto() for beacon padding
Date: Fri, 16 Oct 2026 12:16:02 +0200
Message-ID: <20261016101602.2770015-1-edumazet@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rt2800_write_beacon(), rt61pci_write_beacon() and rt73usb_write_beacon()
pad the beacon with skb_pad(), which does not change skb->len, and
then have to add the padding length again when writing the beacon
to the hardware.

Use skb_put_padto() instead, and remove the padding_len variables.

No functional change: the beacon skb is freed right after
being written to the hardware.

Signed-off-by: Eric Dumazet <edumazet@kernel.org>
---
Part of a medium term plan to get rid of skb_pad(), source of many mistakes.

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 8 +++-----
 drivers/net/wireless/ralink/rt2x00/rt61pci.c   | 9 +++------
 drivers/net/wireless/ralink/rt2x00/rt73usb.c   | 8 +++-----
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 2e2e382b624757ffcd826f37faebc36f38d04f11..4f7beca668bb032ef469e19e8919afd6316fe3eb 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1414,7 +1414,6 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
-	unsigned int padding_len;
 	u32 orig_reg, reg;
 	const int txwi_desc_size = entry->queue->winfo_size;
 
@@ -1452,10 +1451,9 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	/*
 	 * Write entire beacon with TXWI and padding to register.
 	 */
-	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
-	if (padding_len && skb_pad(entry->skb, padding_len)) {
+	if (skb_put_padto(entry->skb, roundup(entry->skb->len, 4))) {
 		rt2x00_err(rt2x00dev, "Failure padding beacon, aborting\n");
-		/* skb freed by skb_pad() on failure */
+		/* skb freed by skb_put_padto() on failure */
 		entry->skb = NULL;
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, orig_reg);
 		return;
@@ -1464,7 +1462,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	beacon_base = rt2800_hw_beacon_base(rt2x00dev, entry->entry_idx);
 
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
-				   entry->skb->len + padding_len);
+				   entry->skb->len);
 	__set_bit(ENTRY_BCN_ENABLED, &entry->flags);
 
 	/*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index d4783658b2c5dbb69ab6c715a23ac8814ef3afb0..974a6d85b37b600f9cac22055c7a0fe0e17e2d5f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -1875,7 +1875,6 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	unsigned int beacon_base;
-	unsigned int padding_len;
 	u32 orig_reg, reg;
 
 	/*
@@ -1900,10 +1899,9 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Write entire beacon with descriptor and padding to register.
 	 */
-	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
-	if (padding_len && skb_pad(entry->skb, padding_len)) {
+	if (skb_put_padto(entry->skb, roundup(entry->skb->len, 4))) {
 		rt2x00_err(rt2x00dev, "Failure padding beacon, aborting\n");
-		/* skb freed by skb_pad() on failure */
+		/* skb freed by skb_put_padto() on failure */
 		entry->skb = NULL;
 		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
 		return;
@@ -1913,8 +1911,7 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	rt2x00mmio_register_multiwrite(rt2x00dev, beacon_base,
 				       entry_priv->desc, TXINFO_SIZE);
 	rt2x00mmio_register_multiwrite(rt2x00dev, beacon_base + TXINFO_SIZE,
-				       entry->skb->data,
-				       entry->skb->len + padding_len);
+				       entry->skb->data, entry->skb->len);
 
 	/*
 	 * Enable beaconing again.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
index d6b7174d087a26c7a403b8b743d59f9fb5f9fb62..ee308bcf0bed00edea24278deb1770f035012998 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -1523,7 +1523,6 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	unsigned int beacon_base;
-	unsigned int padding_len;
 	u32 orig_reg, reg;
 
 	/*
@@ -1554,10 +1553,9 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	/*
 	 * Write entire beacon with descriptor and padding to register.
 	 */
-	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
-	if (padding_len && skb_pad(entry->skb, padding_len)) {
+	if (skb_put_padto(entry->skb, roundup(entry->skb->len, 4))) {
 		rt2x00_err(rt2x00dev, "Failure padding beacon, aborting\n");
-		/* skb freed by skb_pad() on failure */
+		/* skb freed by skb_put_padto() on failure */
 		entry->skb = NULL;
 		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
 		return;
@@ -1565,7 +1563,7 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
 	rt2x00usb_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
-				      entry->skb->len + padding_len);
+				      entry->skb->len);
 
 	/*
 	 * Enable beaconing again.
-- 
2.53.0

