Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52315 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab2B0X6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:58:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 09/11] MIPS: BCM47XX: fix signature of nvram_parse_macaddr
Date: Tue, 28 Feb 2012 00:56:12 +0100
Message-Id: <1330386974-4056-10-git-send-email-hauke@hauke-m.de> (sfid-20120228_005814_201715_6FCCF2E1)
In-Reply-To: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
References: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Explicitly enforce an char array of 6 bytes for the mac address.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/include/asm/mach-bcm47xx/nvram.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/mach-bcm47xx/nvram.h b/arch/mips/include/asm/mach-bcm47xx/nvram.h
index 184d5ec..69ef3ef 100644
--- a/arch/mips/include/asm/mach-bcm47xx/nvram.h
+++ b/arch/mips/include/asm/mach-bcm47xx/nvram.h
@@ -37,7 +37,7 @@ struct nvram_header {
 
 extern int nvram_getenv(char *name, char *val, size_t val_len);
 
-static inline void nvram_parse_macaddr(char *buf, u8 *macaddr)
+static inline void nvram_parse_macaddr(char *buf, u8 macaddr[6])
 {
 	if (strchr(buf, ':'))
 		sscanf(buf, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", &macaddr[0],
-- 
1.7.5.4

