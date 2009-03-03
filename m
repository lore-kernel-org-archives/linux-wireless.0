Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:60930 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZCCJuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 04:50:08 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: fix AR_TXCFG_DMASZ_MASK value
Date: Tue,  3 Mar 2009 10:49:59 +0100
Message-Id: <1236073799-27668-1-git-send-email-juhosg@openwrt.org> (sfid-20090303_105013_125433_9D19EADA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current bitmask is invalid, because the tx dma size is a 3 bit wide
value.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath9k/reg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index 8d85106..91442da 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -67,7 +67,7 @@
 #define AR_DMASIZE_512B      0x00000007
 
 #define AR_TXCFG             0x0030
-#define AR_TXCFG_DMASZ_MASK  0x00000003
+#define AR_TXCFG_DMASZ_MASK  0x00000007
 #define AR_TXCFG_DMASZ_4B    0
 #define AR_TXCFG_DMASZ_8B    1
 #define AR_TXCFG_DMASZ_16B   2
-- 
1.5.3.2

