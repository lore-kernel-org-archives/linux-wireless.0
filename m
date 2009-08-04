Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46992 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945AbZHDWoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 18:44:23 -0400
Received: by fxm17 with SMTP id 17so3570650fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 15:44:23 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Aug 2009 00:44:23 +0200
Message-ID: <83a869cd0908041544i304ea12ctdc5777ec8b20a5b7@mail.gmail.com>
Subject: [PATCH V2] remove wrong probe_resp_plcp write
From: gregor kowski <gregor.kowski@gmail.com>
To: bcm43xx-dev@lists.berlios.de
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tkip hw support uncovered a bug in b43_write_probe_resp_template : it is
writing at the wrong shm offset, it is in the B43_SHM_SH_TKIPTSCTTAK
zone. Remove b43_write_probe_resp_template,  b43_write_probe_resp_plcp
and b43_write_probe_resp_plcp because the probe response offload is
currently not supported by mac80211.

Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>

Index: linux-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/main.c	2009-08-04
22:28:09.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/main.c	2009-08-04
22:39:59.000000000 +0000
@@ -1431,113 +1431,6 @@
 	b43dbg(dev->wl, "Updated beacon template at 0x%x\n", ram_offset);
 }

-static void b43_write_probe_resp_plcp(struct b43_wldev *dev,
-				      u16 shm_offset, u16 size,
-				      struct ieee80211_rate *rate)
-{
-	struct b43_plcp_hdr4 plcp;
-	u32 tmp;
-	__le16 dur;
-
-	plcp.data = 0;
-	b43_generate_plcp_hdr(&plcp, size + FCS_LEN, rate->hw_value);
-	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->vif, size,
-					       rate);
-	/* Write PLCP in two parts and timing for packet transfer */
-	tmp = le32_to_cpu(plcp.data);
-	b43_shm_write16(dev, B43_SHM_SHARED, shm_offset, tmp & 0xFFFF);
-	b43_shm_write16(dev, B43_SHM_SHARED, shm_offset + 2, tmp >> 16);
-	b43_shm_write16(dev, B43_SHM_SHARED, shm_offset + 6, le16_to_cpu(dur));
-}
-
-/* Instead of using custom probe response template, this function
- * just patches custom beacon template by:
- * 1) Changing packet type
- * 2) Patching duration field
- * 3) Stripping TIM
- */
-static const u8 *b43_generate_probe_resp(struct b43_wldev *dev,
-					 u16 *dest_size,
-					 struct ieee80211_rate *rate)
-{
-	const u8 *src_data;
-	u8 *dest_data;
-	u16 src_size, elem_size, src_pos, dest_pos;
-	__le16 dur;
-	struct ieee80211_hdr *hdr;
-	size_t ie_start;
-
-	src_size = dev->wl->current_beacon->len;
-	src_data = (const u8 *)dev->wl->current_beacon->data;
-
-	/* Get the start offset of the variable IEs in the packet. */
-	ie_start = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
-	B43_WARN_ON(ie_start != offsetof(struct ieee80211_mgmt, u.beacon.variable));
-
-	if (B43_WARN_ON(src_size < ie_start))
-		return NULL;
-
-	dest_data = kmalloc(src_size, GFP_ATOMIC);
-	if (unlikely(!dest_data))
-		return NULL;
-
-	/* Copy the static data and all Information Elements, except the TIM. */
-	memcpy(dest_data, src_data, ie_start);
-	src_pos = ie_start;
-	dest_pos = ie_start;
-	for ( ; src_pos < src_size - 2; src_pos += elem_size) {
-		elem_size = src_data[src_pos + 1] + 2;
-		if (src_data[src_pos] == 5) {
-			/* This is the TIM. */
-			continue;
-		}
-		memcpy(dest_data + dest_pos, src_data + src_pos,
-		       elem_size);
-		dest_pos += elem_size;
-	}
-	*dest_size = dest_pos;
-	hdr = (struct ieee80211_hdr *)dest_data;
-
-	/* Set the frame control. */
-	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					 IEEE80211_STYPE_PROBE_RESP);
-	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->vif, *dest_size,
-					       rate);
-	hdr->duration_id = dur;
-
-	return dest_data;
-}
-
-static void b43_write_probe_resp_template(struct b43_wldev *dev,
-					  u16 ram_offset,
-					  u16 shm_size_offset,
-					  struct ieee80211_rate *rate)
-{
-	const u8 *probe_resp_data;
-	u16 size;
-
-	size = dev->wl->current_beacon->len;
-	probe_resp_data = b43_generate_probe_resp(dev, &size, rate);
-	if (unlikely(!probe_resp_data))
-		return;
-
-	/* Looks like PLCP headers plus packet timings are stored for
-	 * all possible basic rates
-	 */
-	b43_write_probe_resp_plcp(dev, 0x31A, size, &b43_b_ratetable[0]);
-	b43_write_probe_resp_plcp(dev, 0x32C, size, &b43_b_ratetable[1]);
-	b43_write_probe_resp_plcp(dev, 0x33E, size, &b43_b_ratetable[2]);
-	b43_write_probe_resp_plcp(dev, 0x350, size, &b43_b_ratetable[3]);
-
-	size = min((size_t) size, 0x200 - sizeof(struct b43_plcp_hdr6));
-	b43_write_template_common(dev, probe_resp_data,
-				  size, ram_offset, shm_size_offset,
-				  rate->hw_value);
-	kfree(probe_resp_data);
-}
-
 static void b43_upload_beacon0(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
@@ -1545,10 +1438,6 @@
 	if (wl->beacon0_uploaded)
 		return;
 	b43_write_beacon_template(dev, 0x68, 0x18);
-	/* FIXME: Probe resp upload doesn't really belong here,
-	 *        but we don't use that feature anyway. */
-	b43_write_probe_resp_template(dev, 0x268, 0x4A,
-				      &__b43_ratetable[3]);
 	wl->beacon0_uploaded = 1;
 }
