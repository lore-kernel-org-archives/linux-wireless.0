Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D33C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9BE4208E7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9BE4208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbeJEO6b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 10:58:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35288 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbeJEO6a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 10:58:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id e187-v6so998540wmf.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eKBCh7MG/81pkSN6b/oMsvKFkkC6VAUCJYUsVi2Oq7Y=;
        b=gFMCylebpl7PZ1xy9MwiDp1hBuXjK6UISqD81GpjB3IMzsuz8T9iufQBIYVMppwZiy
         mYdqpkwJU2M0KGRuG/FVGoLaFQO+vTLxByoC4T9LkjbiaLeWr6JUQo1Y4ji/g1w1xMoc
         FOCxhlWQd7v508q78QSlkGknBW+lkce5T7E3HvxBycQ6yVm+wKNbLspEk1GeNTa+4OOk
         uuvMwexd2xvaoLPrYJmM65s3SXdtv0lOQXeK6VCbMVlHfj23E0RJVK+hwM5ZBA6eCIrJ
         U5DnE4IlP1V+A4si5eD8kEGdX+gcH+zGF4ZwxbxNxI9UPmuBSDOaXSbm20k4+0/p+s4B
         Cb4w==
X-Gm-Message-State: ABuFfojWW3vK/sRGt/vO0d0vjb15pmcqzWFG3ZLwyF0SSkBZ/fng9mW1
        yMdWM08oldcRPBbZxNUoIYeBCA==
X-Google-Smtp-Source: ACcGV6310L4lBj4X3bUu4RG7qRXcQWhH4XraPCCorqs5anBJjRkAmJzmrJFDMbtMUn5MCO55Bnqciw==
X-Received: by 2002:a1c:1b91:: with SMTP id b139-v6mr7030033wmb.147.1538726454787;
        Fri, 05 Oct 2018 01:00:54 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id d2-v6sm4826947wrn.20.2018.10.05.01.00.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:00:53 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/3] mt76: rename mt76x02_util.h in mt76x02.h
Date:   Fri,  5 Oct 2018 10:00:33 +0200
Message-Id: <15377f3fd622e9f73c917899f3449ea9d699d27b.1538726002.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538726002.git.lorenzo.bianconi@redhat.com>
References: <cover.1538726002.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rename mt76x02_util.h header file in mt76x02.h since now contains
all mt76x02 related definitions and not just utility routines
declarations

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c             | 3 ---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c              | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c             | 3 +--
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h           | 5 +----
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c              | 2 --
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c              | 1 -
 .../net/wireless/mediatek/mt76/{mt76x02_util.h => mt76x02.h} | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c             | 5 +----
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c            | 5 +----
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c            | 5 +----
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c        | 5 +----
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c            | 5 +----
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.c              | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.h              | 3 +--
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c              | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h           | 4 +---
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h          | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c         | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c          | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c          | 2 --
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c         | 2 --
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c          | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c         | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c          | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c           | 2 --
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c         | 3 +--
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c         | 1 -
 27 files changed, 15 insertions(+), 56 deletions(-)
 rename drivers/net/wireless/mediatek/mt76/{mt76x02_util.h => mt76x02.h} (98%)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index d0f2ee6d7040..ee2b8e885608 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -18,9 +18,6 @@
 #include "eeprom.h"
 #include "trace.h"
 #include "mcu.h"
-#include "../mt76x02_util.h"
-#include "../mt76x02_dma.h"
-
 #include "initvals.h"
 
 static void mt76x0_vht_cap_mask(struct ieee80211_supported_band *sband)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 793297cd6bf1..7a422c590211 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -13,10 +13,10 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/etherdevice.h>
+
 #include "mt76x0.h"
 #include "trace.h"
-#include "../mt76x02_util.h"
-#include <linux/etherdevice.h>
 
 void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 			       int ht_mode)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 7803aa00491e..c9cd0254a979 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -13,9 +13,8 @@
  * GNU General Public License for more details.
  */
 
-#include "mt76x0.h"
-#include "../mt76x02_util.h"
 #include <linux/etherdevice.h>
+#include "mt76x0.h"
 
 int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 237407200908..1bff2be45a13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -25,10 +25,7 @@
 #include <net/mac80211.h>
 #include <linux/debugfs.h>
 
-#include "../mt76.h"
-#include "../mt76x02_regs.h"
-#include "../mt76x02_mac.h"
-#include "../mt76x02_util.h"
+#include "../mt76x02.h"
 #include "eeprom.h"
 
 #define MT_CALIBRATE_INTERVAL		(4 * HZ)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 80c6b1ca9065..55c62e40499b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -20,8 +20,6 @@
 
 #include "mt76x0.h"
 #include "mcu.h"
-#include "../mt76x02_dma.h"
-#include "../mt76x02_util.h"
 
 static int mt76x0e_start(struct ieee80211_hw *hw)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 1a9450e6703f..e29fc3af49cf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -18,7 +18,6 @@
 #include "mt76x0.h"
 #include "mcu.h"
 #include "trace.h"
-#include "../mt76x02_util.h"
 #include "../mt76x02_usb.h"
 
 static struct usb_device_id mt76x0_device_table[] = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
similarity index 98%
rename from drivers/net/wireless/mediatek/mt76/mt76x02_util.h
rename to drivers/net/wireless/mediatek/mt76/mt76x02.h
index f492e796613d..fe68cf33aef4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -20,8 +20,11 @@
 
 #include <linux/kfifo.h>
 
+#include "mt76.h"
+#include "mt76x02_regs.h"
 #include "mt76x02_mac.h"
 #include "mt76x02_dfs.h"
+#include "mt76x02_dma.h"
 
 struct mt76x02_mac_stats {
 	u64 rx_stat[6];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index a743f1c5fa55..07b3217ecb51 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -15,10 +15,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "mt76.h"
-#include "mt76x02_regs.h"
-#include "mt76x02_mac.h"
-#include "mt76x02_util.h"
+#include "mt76x02.h"
 
 enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 1146fbfd8df5..af95b6708eaf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -17,10 +17,7 @@
 
 #include <linux/kernel.h>
 
-#include "mt76.h"
-#include "mt76x02_dma.h"
-#include "mt76x02_util.h"
-#include "mt76x02_mac.h"
+#include "mt76x02.h"
 
 static int
 mt76x02_init_tx_queue(struct mt76_dev *dev, struct mt76_queue *q,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index caa9bb107e68..24298b7ddd7d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -17,10 +17,7 @@
 
 #include <linux/kernel.h>
 
-#include "mt76.h"
-#include "mt76x02_regs.h"
-#include "mt76x02_dma.h"
-#include "mt76x02_util.h"
+#include "mt76x02.h"
 
 void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index dea944b43576..a0cd77ddaef3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -14,10 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "mt76.h"
-#include "mt76x02_dma.h"
-#include "mt76x02_mac.h"
-#include "mt76x02_util.h"
+#include "mt76x02.h"
 
 static int mt76x02u_check_skb_rooms(struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 6e123ae3bbe8..5851ab6b7e26 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -16,10 +16,7 @@
  */
 
 #include <linux/module.h>
-#include "mt76.h"
-#include "mt76x02_regs.h"
-#include "mt76x02_mac.h"
-#include "mt76x02_util.h"
+#include "mt76x02.h"
 
 #define CCK_RATE(_idx, _rate) {					\
 	.bitrate = _rate,					\
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index 9ebb219d63ae..e25905c91ee2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -16,7 +16,6 @@
  */
 
 #include "mt76x2.h"
-#include "../mt76x02_util.h"
 
 void mt76x2_mac_stop(struct mt76x02_dev *dev, bool force)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index f1077f96a8a4..6bd04b74e15a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -17,8 +17,7 @@
 #ifndef __MT76x2_MAC_H
 #define __MT76x2_MAC_H
 
-#include "../mt76.h"
-#include "../mt76x02_mac.h"
+#include "mt76x2.h"
 
 struct mt76x02_dev;
 struct mt76x2_sta;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
index 7d944f50956a..134037a227d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
@@ -22,7 +22,6 @@
 #include "mt76x2.h"
 #include "mcu.h"
 #include "eeprom.h"
-#include "../mt76x02_dma.h"
 
 int mt76x2_mcu_set_channel(struct mt76x02_dev *dev, u8 channel, u8 bw,
 			   u8 bw_index, bool scan)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index c7d5e666cc65..62a211563056 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -36,9 +36,7 @@
 
 #define MT_CALIBRATE_INTERVAL	HZ
 
-#include "../mt76.h"
-#include "../mt76x02_regs.h"
-#include "../mt76x02_util.h"
+#include "../mt76x02.h"
 #include "mac.h"
 #include "dfs.h"
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
index b3270b0b0930..6e932b5010ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
@@ -21,7 +21,6 @@
 
 #include "mt76x2.h"
 #include "mcu.h"
-#include "../mt76x02_dma.h"
 
 #define MT7612U_EEPROM_SIZE		512
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
index 6da12fca668c..1738e025a57e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
@@ -17,7 +17,6 @@
 #include <linux/delay.h>
 #include "mt76x2.h"
 #include "trace.h"
-#include "../mt76x02_util.h"
 
 void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
index b36286bc8b69..c0a3485e96f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
@@ -15,7 +15,6 @@
  */
 
 #include "mt76x2.h"
-#include "../mt76x02_util.h"
 
 #define RADAR_SPEC(m, len, el, eh, wl, wh,		\
 		   w_tolerance, tl, th, t_tolerance,	\
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
index 35f0ceb7094b..2859812ac47a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
@@ -15,8 +15,6 @@
  */
 
 #include "mt76x2.h"
-#include "../mt76x02_dma.h"
-#include "../mt76x02_util.h"
 
 void mt76x2_tx_tasklet(unsigned long data)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index c8077d4a62aa..5f6e31f4a69a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -18,8 +18,6 @@
 #include "mt76x2.h"
 #include "eeprom.h"
 #include "mcu.h"
-#include "../mt76x02_util.h"
-#include "../mt76x02_dma.h"
 
 static void
 mt76x2_mac_pbf_init(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 4538afc7e50e..981633cbd527 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -19,7 +19,6 @@
 #include "mcu.h"
 #include "eeprom.h"
 #include "trace.h"
-#include "../mt76x02_util.h"
 
 void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 9f42372acd81..8773ed4af51d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -15,7 +15,6 @@
  */
 
 #include "mt76x2.h"
-#include "../mt76x02_util.h"
 
 static int
 mt76x2_start(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index a17c9a5279ad..898aa229671c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -21,7 +21,6 @@
 #include "mt76x2.h"
 #include "mcu.h"
 #include "eeprom.h"
-#include "../mt76x02_dma.h"
 
 static int
 mt76pci_load_rom_patch(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
index ab9cb632222c..cfc9d3d207df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
@@ -15,8 +15,6 @@
  */
 
 #include "mt76x2.h"
-#include "../mt76x02_util.h"
-#include "../mt76x02_dma.h"
 
 struct beacon_bc_data {
 	struct mt76x02_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 6d12b67cce11..45d628af7d57 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -17,9 +17,8 @@
 #include <linux/delay.h>
 
 #include "mt76x2u.h"
-#include "../mt76x02_util.h"
-#include "../mt76x02_phy.h"
 #include "eeprom.h"
+#include "../mt76x02_phy.h"
 #include "../mt76x02_usb.h"
 
 static void mt76x2u_init_dma(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 6c7699278582..224609d6915f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -15,7 +15,6 @@
  */
 
 #include "mt76x2u.h"
-#include "../mt76x02_util.h"
 
 static int mt76x2u_start(struct ieee80211_hw *hw)
 {
-- 
2.17.1

