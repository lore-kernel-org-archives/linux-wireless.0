Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:46248 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab1KCGpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 02:45:04 -0400
Received: by bkar19 with SMTP id r19so839437bka.7
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2011 23:45:01 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] wl12xx: increase firmware upload chunk size
Date: Thu,  3 Nov 2011 08:44:43 +0200
Message-Id: <1320302683-23403-4-git-send-email-coelho@ti.com> (sfid-20111103_074510_831169_2E5A6BD7)
In-Reply-To: <1320302683-23403-1-git-send-email-coelho@ti.com>
References: <1320302683-23403-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chunk size used during firmware upload was set to 512, which is
the size of a single SDIO block (or two).  This is very inneficient
because we send one or two blocks only per SDIO transaction and don't
get the full benefits of sdio block transfers.

This patch increases the chunk size to 16K.  This more than doubles
the transfer speed both in wl127x and wl128x chips, with greater
impact on the latter:

wl127x:   512 bytes chunk -> ~132ms
        16384 bytes chunk ->  ~57ms
wl128x:   512 bytes chunk -> ~216ms
        16384 bytes chunk ->  ~37ms

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/reg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/reg.h b/drivers/net/wireless/wl12xx/reg.h
index 3f570f3..df34d59 100644
--- a/drivers/net/wireless/wl12xx/reg.h
+++ b/drivers/net/wireless/wl12xx/reg.h
@@ -408,7 +408,7 @@
 
 
 /* Firmware image load chunk size */
-#define CHUNK_SIZE          512
+#define CHUNK_SIZE	16384
 
 /* Firmware image header size */
 #define FW_HDR_SIZE 8
-- 
1.7.4.1

