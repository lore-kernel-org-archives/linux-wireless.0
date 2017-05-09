Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35037 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbdEINbm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:31:42 -0400
Received: by mail-pf0-f193.google.com with SMTP id u26so51566pfd.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 06:31:42 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 01/11] rsi: Rename file rsi_91x_pkt.c to rsi_91x_hal.c
Date: Tue,  9 May 2017 19:00:04 +0530
Message-Id: <1494336614-2107-2-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170509_153146_994584_CAA76D6B)
In-Reply-To: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

The file rsi_91x_hal.c is going to contain device specific code i.e new
firmware loading method for RS9113 chipset. As the file rsi_91x_pkt.c
contains code to prepare device specific descriptors for transmit packet,
this file is renamed to rsi_91x_hal.c which is more relevant as per it's
functionality.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/Makefile                         | 2 +-
 drivers/net/wireless/rsi/{rsi_91x_pkt.c => rsi_91x_hal.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/net/wireless/rsi/{rsi_91x_pkt.c => rsi_91x_hal.c} (100%)

diff --git a/drivers/net/wireless/rsi/Makefile b/drivers/net/wireless/rsi/Makefile
index 25828b6..a475c81 100644
--- a/drivers/net/wireless/rsi/Makefile
+++ b/drivers/net/wireless/rsi/Makefile
@@ -2,7 +2,7 @@ rsi_91x-y			+= rsi_91x_main.o
 rsi_91x-y			+= rsi_91x_core.o
 rsi_91x-y			+= rsi_91x_mac80211.o
 rsi_91x-y			+= rsi_91x_mgmt.o
-rsi_91x-y			+= rsi_91x_pkt.o
+rsi_91x-y			+= rsi_91x_hal.o
 rsi_91x-$(CONFIG_RSI_DEBUGFS)	+= rsi_91x_debugfs.o
 
 rsi_usb-y			+= rsi_91x_usb.o rsi_91x_usb_ops.o
diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
similarity index 100%
rename from drivers/net/wireless/rsi/rsi_91x_pkt.c
rename to drivers/net/wireless/rsi/rsi_91x_hal.c
-- 
2.7.4
