Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:63136 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYJCUss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:48:48 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1801100wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 13:48:47 -0700 (PDT)
Subject: [PATCH 1/8] b43: removed open-coded unaligned accesses, use common
 helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 13:48:45 -0700
Message-Id: <1223066925.6512.26.camel@brick> (sfid-20081003_224853_495782_6442E505)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allows removal of some temporary variables as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/main.c |   54 ++++++++------------------------------
 1 files changed, 12 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 3bf74e2..6df9b65 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -640,23 +640,14 @@ static
 void b43_macfilter_set(struct b43_wldev *dev, u16 offset, const u8 * mac)
 {
 	static const u8 zero_addr[ETH_ALEN] = { 0 };
-	u16 data;
 
 	if (!mac)
 		mac = zero_addr;
 
-	offset |= 0x0020;
-	b43_write16(dev, B43_MMIO_MACFILTER_CONTROL, offset);
-
-	data = mac[0];
-	data |= mac[1] << 8;
-	b43_write16(dev, B43_MMIO_MACFILTER_DATA, data);
-	data = mac[2];
-	data |= mac[3] << 8;
-	b43_write16(dev, B43_MMIO_MACFILTER_DATA, data);
-	data = mac[4];
-	data |= mac[5] << 8;
-	b43_write16(dev, B43_MMIO_MACFILTER_DATA, data);
+	b43_write16(dev, B43_MMIO_MACFILTER_CONTROL, offset | 0x0020);
+	b43_write16(dev, B43_MMIO_MACFILTER_DATA, get_unaligned_le16(mac + 0));
+	b43_write16(dev, B43_MMIO_MACFILTER_DATA, get_unaligned_le16(mac + 2));
+	b43_write16(dev, B43_MMIO_MACFILTER_DATA, get_unaligned_le16(mac + 4));
 }
 
 static void b43_write_mac_bssid_templates(struct b43_wldev *dev)
@@ -665,7 +656,6 @@ static void b43_write_mac_bssid_templates(struct b43_wldev *dev)
 	const u8 *bssid;
 	u8 mac_bssid[ETH_ALEN * 2];
 	int i;
-	u32 tmp;
 
 	bssid = dev->wl->bssid;
 	mac = dev->wl->mac_addr;
@@ -677,11 +667,8 @@ static void b43_write_mac_bssid_templates(struct b43_wldev *dev)
 
 	/* Write our MAC address and BSSID to template ram */
 	for (i = 0; i < ARRAY_SIZE(mac_bssid); i += sizeof(u32)) {
-		tmp = (u32) (mac_bssid[i + 0]);
-		tmp |= (u32) (mac_bssid[i + 1]) << 8;
-		tmp |= (u32) (mac_bssid[i + 2]) << 16;
-		tmp |= (u32) (mac_bssid[i + 3]) << 24;
-		b43_ram_write(dev, 0x20 + i, tmp);
+		b43_ram_write(dev, 0x20 + i,
+			      get_unaligned_le32(mac_bssid + i));
 	}
 }
 
@@ -868,12 +855,8 @@ static void keymac_write(struct b43_wldev *dev, u8 index, const u8 * addr)
 	index -= per_sta_keys_start;
 
 	if (addr) {
-		addrtmp[0] = addr[0];
-		addrtmp[0] |= ((u32) (addr[1]) << 8);
-		addrtmp[0] |= ((u32) (addr[2]) << 16);
-		addrtmp[0] |= ((u32) (addr[3]) << 24);
-		addrtmp[1] = addr[4];
-		addrtmp[1] |= ((u32) (addr[5]) << 8);
+		addrtmp[0] = get_unaligned_le32(addr);
+		addrtmp[1] = get_unaligned_le16(addr + 4);
 	}
 
 	if (dev->dev->id.revision >= 5) {
@@ -1299,14 +1282,8 @@ static void b43_write_template_common(struct b43_wldev *dev,
 	b43_ram_write(dev, ram_offset, tmp);
 	ram_offset += sizeof(u32);
 	for (i = 2; i < size; i += sizeof(u32)) {
-		tmp = (u32) (data[i + 0]);
-		if (i + 1 < size)
-			tmp |= (u32) (data[i + 1]) << 8;
-		if (i + 2 < size)
-			tmp |= (u32) (data[i + 2]) << 16;
-		if (i + 3 < size)
-			tmp |= (u32) (data[i + 3]) << 24;
-		b43_ram_write(dev, ram_offset + i - 2, tmp);
+		b43_ram_write(dev, ram_offset + i - 2,
+			      get_unaligned_le32(data + i));
 	}
 	b43_shm_write16(dev, B43_SHM_SHARED, shm_size_offset,
 			size + sizeof(struct b43_plcp_hdr6));
@@ -1695,19 +1672,12 @@ static void b43_update_templates(struct b43_wl *wl)
 
 static void b43_set_ssid(struct b43_wldev *dev, const u8 * ssid, u8 ssid_len)
 {
-	u32 tmp;
 	u16 i, len;
 
 	len = min((u16) ssid_len, (u16) 0x100);
 	for (i = 0; i < len; i += sizeof(u32)) {
-		tmp = (u32) (ssid[i + 0]);
-		if (i + 1 < len)
-			tmp |= (u32) (ssid[i + 1]) << 8;
-		if (i + 2 < len)
-			tmp |= (u32) (ssid[i + 2]) << 16;
-		if (i + 3 < len)
-			tmp |= (u32) (ssid[i + 3]) << 24;
-		b43_shm_write32(dev, B43_SHM_SHARED, 0x380 + i, tmp);
+		b43_shm_write32(dev, B43_SHM_SHARED, 0x380 + i,
+				get_unaligned_le32(ssid + i));
 	}
 	b43_shm_write16(dev, B43_SHM_SHARED, 0x48, len);
 }
-- 
1.6.0.2.471.g47a76


