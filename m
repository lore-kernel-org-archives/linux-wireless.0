Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28761 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaINIOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 04:14:48 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH] fixup! wil6210: fix usage of print_hex_dump_debug
Date: Sun, 14 Sep 2014 11:14:10 +0300
Message-ID: <1410682450-5493-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140914_101455_464553_DE1DA5A5)
In-Reply-To: <1410682450-5493-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410682450-5493-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use empty inline functions instead of empty #define. Fix for "unused variable"
as reported below:

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   167bf96dd87d2a8360cb9e9783006876dac4f579
commit: 871d8c4bbb0f23c29a21b63b1801071766f69b51 [45/62] wil6210: fix usage of print_hex_dump_debug
config: i386-allyesconfig
reproduce:
  git checkout 871d8c4bbb0f23c29a21b63b1801071766f69b51
  make ARCH=i386  allyesconfig
  make ARCH=i386

All warnings:

   drivers/net/wireless/ath/wil6210/wmi.c: In function 'wmi_evt_rx_mgmt':

>> drivers/net/wireless/ath/wil6210/wmi.c:341:10: warning: unused variable 'ie_len' [-Wunused-variable]
      size_t ie_len = d_len - offsetof(struct ieee80211_mgmt,
             ^

>> drivers/net/wireless/ath/wil6210/wmi.c:340:13: warning: unused variable 'ie_buf' [-Wunused-variable]
      const u8 *ie_buf = rx_mgmt_frame->u.beacon.variable;
                ^

vim +/ie_len +341 drivers/net/wireless/ath/wil6210/wmi.c

2be7d22f Vladimir Kondratiev 2012-12-20  334
2be7d22f Vladimir Kondratiev 2012-12-20  335    if (ieee80211_is_beacon(fc) || ieee80211_is_probe_resp(fc)) {
2be7d22f Vladimir Kondratiev 2012-12-20  336            struct cfg80211_bss *bss;
8eea944a Vladimir Kondratiev 2014-06-16  337            u64 tsf = le64_to_cpu(rx_mgmt_frame->u.beacon.timestamp);
8eea944a Vladimir Kondratiev 2014-06-16  338            u16 cap = le16_to_cpu(rx_mgmt_frame->u.beacon.capab_info);
8eea944a Vladimir Kondratiev 2014-06-16  339            u16 bi = le16_to_cpu(rx_mgmt_frame->u.beacon.beacon_int);
8eea944a Vladimir Kondratiev 2014-06-16  340            const u8 *ie_buf = rx_mgmt_frame->u.beacon.variable;
8eea944a Vladimir Kondratiev 2014-06-16  341            size_t ie_len = d_len - offsetof(struct ieee80211_mgmt,
8eea944a Vladimir Kondratiev 2014-06-16  342                                             u.beacon.variable);
8eea944a Vladimir Kondratiev 2014-06-16  343            wil_dbg_wmi(wil, "Capability info : 0x%04x\n", cap);
8eea944a Vladimir Kondratiev 2014-06-16  344            wil_dbg_wmi(wil, "TSF : 0x%016llx\n", tsf);

:::::: The code at line 341 was first introduced by commit
:::::: 8eea944af0efcdba09dac1ad220c9bfa68293279 wil6210: print more info about BSS found

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0ff0dd9..133eeb8 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -476,12 +476,19 @@ int wil_info(struct wil6210_priv *wil, const char *fmt, ...);
 			 print_hex_dump_debug("DBG[ WMI]" prefix_str,\
 					prefix_type, rowsize,	\
 					groupsize, buf, len, ascii)
-#else
-#define wil_hex_dump_txrx(prefix_str, prefix_type, rowsize,	\
-			  groupsize, buf, len, ascii)
-#define wil_hex_dump_wmi(prefix_str, prefix_type, rowsize,	\
-			 groupsize, buf, len, ascii)
-#endif
+#else /* defined(CONFIG_DYNAMIC_DEBUG) */
+static inline
+void wil_hex_dump_txrx(const char *prefix_str, int prefix_type, int rowsize,
+		       int groupsize, const void *buf, size_t len, bool ascii)
+{
+}
+
+static inline
+void wil_hex_dump_wmi(const char *prefix_str, int prefix_type, int rowsize,
+		      int groupsize, const void *buf, size_t len, bool ascii)
+{
+}
+#endif /* defined(CONFIG_DYNAMIC_DEBUG) */
 
 void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
 			  size_t count);
-- 
1.9.1

