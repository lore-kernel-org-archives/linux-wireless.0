Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2733 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab1HONem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:42 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/15] staging: brcm80211: Fix handling of firmware and
 inits on big-endian platforms
Date: Mon, 15 Aug 2011 15:34:23 +0200
Message-ID: <1313415267-5264-12-git-send-email-arend@broadcom.com> (sfid-20110815_153502_607069_12EA2D13)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

The firmware files are encoded as little-endian.  Do the appropriate swapping
for big-endian platforms.

Tested on Mac G5 PPC and BCM63281.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   24 ++++++++++++---------
 drivers/staging/brcm80211/brcmsmac/main.c        |   21 ++++++++++++------
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index e465749..7179edd 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -1722,15 +1722,17 @@ int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf, u32 idx)
 		hdr = (struct firmware_hdr *)wl->fw.fw_hdr[i]->data;
 		for (entry = 0; entry < wl->fw.hdr_num_entries[i];
 		     entry++, hdr++) {
-			if (hdr->idx == idx) {
-				pdata = wl->fw.fw_bin[i]->data + hdr->offset;
-				*pbuf = kmalloc(hdr->len, GFP_ATOMIC);
+			u32 len = le32_to_cpu(hdr->len);
+			if (le32_to_cpu(hdr->idx) == idx) {
+				pdata = wl->fw.fw_bin[i]->data +
+					le32_to_cpu(hdr->offset);
+				*pbuf = kmalloc(len, GFP_ATOMIC);
 				if (*pbuf == NULL) {
 					wiphy_err(wl->wiphy, "fail to alloc %d"
-						  " bytes\n", hdr->len);
+						  " bytes\n", len);
 					goto fail;
 				}
-				memcpy(*pbuf, pdata, hdr->len);
+				memcpy(*pbuf, pdata, len);
 				return 0;
 			}
 		}
@@ -1755,14 +1757,15 @@ int brcms_ucode_init_uint(struct brcms_info *wl, u32 *data, u32 idx)
 		hdr = (struct firmware_hdr *)wl->fw.fw_hdr[i]->data;
 		for (entry = 0; entry < wl->fw.hdr_num_entries[i];
 		     entry++, hdr++) {
-			if (hdr->idx == idx) {
-				pdata = wl->fw.fw_bin[i]->data + hdr->offset;
-				if (hdr->len != 4) {
+			if (le32_to_cpu(hdr->idx) == idx) {
+				pdata = wl->fw.fw_bin[i]->data +
+					le32_to_cpu(hdr->offset);
+				if (le32_to_cpu(hdr->len) != 4) {
 					wiphy_err(wl->wiphy,
 						  "ERROR: fw hdr len\n");
 					return -ENOMSG;
 				}
-				*data = *((u32 *) pdata);
+				*data = le32_to_cpu(*((u32 *) pdata));
 				return 0;
 			}
 		}
@@ -1868,7 +1871,8 @@ int brcms_check_firmwares(struct brcms_info *wl)
 			ucode_hdr = (struct firmware_hdr *)fw_hdr->data;
 			for (entry = 0; entry < wl->fw.hdr_num_entries[i] &&
 			     !rc; entry++, ucode_hdr++) {
-				if (ucode_hdr->offset + ucode_hdr->len >
+				if (le32_to_cpu(ucode_hdr->offset) +
+				    le32_to_cpu(ucode_hdr->len) >
 				    fw->size) {
 					wiphy_err(wl->wiphy,
 						  "%s: conflicting bin/hdr\n",
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d6837d3..c625c25 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -2033,7 +2033,8 @@ static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
 	W_REG(&regs->objaddr, (OBJADDR_AUTO_INC | OBJADDR_UCM_SEL));
 	(void)R_REG(&regs->objaddr);
 	for (i = 0; i < count; i++)
-		W_REG(&regs->objdata, ucode[i]);
+		W_REG(&regs->objdata, le32_to_cpu(ucode[i]));
+
 }
 
 static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
@@ -2041,18 +2042,24 @@ static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 {
 	int i;
 	u8 *base;
+	u8 *addr;
+	u16 size;
+	u32 value;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	base = (u8 *)wlc_hw->regs;
 
 	for (i = 0; inits[i].addr != 0xffff; i++) {
-		if (inits[i].size == 2)
-			W_REG((u16 *)(base + inits[i].addr),
-			      inits[i].value);
-		else if (inits[i].size == 4)
-			W_REG((u32 *)(base + inits[i].addr),
-			      inits[i].value);
+		size = le16_to_cpu(inits[i].size);
+		addr = base + le16_to_cpu(inits[i].addr);
+		value = le32_to_cpu(inits[i].value);
+		if (size == 2)
+			W_REG((u16 *)addr, value);
+		else if (size == 4)
+			W_REG((u32 *)addr, value);
+		else
+			break;
 	}
 }
 
-- 
1.7.4.1


