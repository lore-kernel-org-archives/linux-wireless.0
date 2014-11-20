Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:1738 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaKTV1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 16:27:05 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/4] brcmutil: add helper function to format board revision
Date: Thu, 20 Nov 2014 22:27:00 +0100
Message-ID: <1416518822-29585-3-git-send-email-arend@broadcom.com> (sfid-20141120_222719_427687_C0D87AFB)
In-Reply-To: <1416518822-29585-1-git-send-email-arend@broadcom.com>
References: <1416518822-29585-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The board revision that is available in hardware can be translated
so it matches the labelling on the board. This is accomplished by
this helper function.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmutil/utils.c      | 16 ++++++++++++++++
 drivers/net/wireless/brcm80211/include/brcmu_utils.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 0f7e1c7..af97f8b 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -292,4 +292,20 @@ void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
 	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, data, size);
 }
 EXPORT_SYMBOL(brcmu_dbg_hex_dump);
+
+/* Produce a human-readable string for boardrev */
+char *brcmu_boardrev_str(u32 brev, char *buf)
+{
+	char c;
+
+	if (brev < 0x100) {
+		snprintf(buf, 8, "%d.%d", (brev & 0xf0) >> 4, brev & 0xf);
+	} else {
+		c = (brev & 0xf000) == 0x1000 ? 'P' : 'A';
+		snprintf(buf, 8, "%c%03x", c, brev & 0xfff);
+	}
+	return buf;
+}
+EXPORT_SYMBOL(brcmu_boardrev_str);
+
 #endif				/* defined(DEBUG) */
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index 8ba445b..a043e29 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -218,4 +218,6 @@ void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
 }
 #endif
 
+char *brcmu_boardrev_str(u32 brev, char *buf);
+
 #endif				/* _BRCMU_UTILS_H_ */
-- 
1.9.1

