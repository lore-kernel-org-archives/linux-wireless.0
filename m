Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4713 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaIJNf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:28 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 10/22] wil6210: fix usage of print_hex_dump_debug
Date: Wed, 10 Sep 2014 16:34:39 +0300
Message-ID: <1410356091-19219-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153533_409590_90DEEBFF)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When CONFIG_DYNAMIC_DEBUG is not defined, print_hex_dump_debug
is mapped directly to print_hex_dump which might cause
printout to exist all the time

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index d2e710e..e51531b 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -468,6 +468,7 @@ int wil_info(struct wil6210_priv *wil, const char *fmt, ...);
 #define wil_dbg_wmi(wil, fmt, arg...) wil_dbg(wil, "DBG[ WMI]" fmt, ##arg)
 #define wil_dbg_misc(wil, fmt, arg...) wil_dbg(wil, "DBG[MISC]" fmt, ##arg)
 
+#if defined(CONFIG_DYNAMIC_DEBUG)
 #define wil_hex_dump_txrx(prefix_str, prefix_type, rowsize,	\
 			  groupsize, buf, len, ascii)		\
 			  print_hex_dump_debug("DBG[TXRX]" prefix_str,\
@@ -479,6 +480,12 @@ int wil_info(struct wil6210_priv *wil, const char *fmt, ...);
 			 print_hex_dump_debug("DBG[ WMI]" prefix_str,\
 					prefix_type, rowsize,	\
 					groupsize, buf, len, ascii)
+#else
+#define wil_hex_dump_txrx(prefix_str, prefix_type, rowsize,	\
+			  groupsize, buf, len, ascii)
+#define wil_hex_dump_wmi(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)
+#endif
 
 void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
 			  size_t count);
-- 
1.9.1

