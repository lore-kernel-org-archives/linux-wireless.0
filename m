Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2019 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/13] brcmutil: add macros for setting bitfields using
 mask/shift operations
Date: Sun, 3 Mar 2013 12:45:27 +0100
Message-ID: <1362311132-29561-9-git-send-email-arend@broadcom.com> (sfid-20130303_124600_927400_7325F729)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added inline functions to set bitfields in an unsigned integer variable.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   23 ++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index 477b92a..82fcfe8 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -173,6 +173,29 @@ extern void brcmu_pktq_flush(struct pktq *pq, bool dir,
 /* ip address */
 struct ipv4_addr;
 
+/*
+ * bitfield macros using masking and shift
+ *
+ * remark: the mask parameter should be a shifted mask.
+ */
+static inline void brcmu_maskset32(u32 *var, u32 mask, u8 shift, u32 value)
+{
+	value = (value << shift) & mask;
+	*var = (*var & ~mask) | value;
+}
+static inline u32 brcmu_maskget32(u32 var, u32 mask, u8 shift)
+{
+	return (var & mask) >> shift;
+}
+static inline void brcmu_maskset16(u16 *var, u16 mask, u8 shift, u16 value)
+{
+	value = (value << shift) & mask;
+	*var = (*var & ~mask) | value;
+}
+static inline u16 brcmu_maskget16(u16 var, u16 mask, u8 shift)
+{
+	return (var & mask) >> shift;
+}
 
 /* externs */
 /* format/print */
-- 
1.7.6


