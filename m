Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:8416 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaKYT4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 14:56:01 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 1/2] brcmutil: add helper function to format board revision
Date: Tue, 25 Nov 2014 20:55:53 +0100
Message-ID: <1416945354-23346-2-git-send-email-arend@broadcom.com> (sfid-20141125_205613_782797_289D97EA)
In-Reply-To: <1416945354-23346-1-git-send-email-arend@broadcom.com>
References: <1416945354-23346-1-git-send-email-arend@broadcom.com>
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
index 0f7e1c7..906e89d 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -261,6 +261,21 @@ struct sk_buff *brcmu_pktq_mdeq(struct pktq *pq, uint prec_bmp,
 }
 EXPORT_SYMBOL(brcmu_pktq_mdeq);
 
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
 #if defined(DEBUG)
 /* pretty hex print a pkt buffer chain */
 void brcmu_prpkt(const char *msg, struct sk_buff *p0)
@@ -292,4 +307,5 @@ void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
 	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, data, size);
 }
 EXPORT_SYMBOL(brcmu_dbg_hex_dump);
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

