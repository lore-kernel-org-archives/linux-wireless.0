Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33152 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcBAM1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:07 -0500
Received: by mail-pa0-f67.google.com with SMTP id pv5so7176175pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:06 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/11] staging: wilc1000: linux_mon: remove blank line before a close brace '}'
Date: Mon,  1 Feb 2016 21:26:39 +0900
Message-Id: <1454329607-9486-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132710_891788_3FF367E4)
In-Reply-To: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank lines before a close brace found by
checkpatch.pl
CHECK: Blank lines aren't necessary before a close brace '}'

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 73c8113..bd0b17e 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -119,7 +119,6 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 				(1 << IEEE80211_RADIOTAP_RATE);                   /* | */
 		PRINT_INFO(HOSTAPD_DBG, "Presentflags %d\n", hdr->hdr.it_present);
 		hdr->rate = 5; /* txrate->bitrate / 5; */
-
 	}
 
 
@@ -132,8 +131,6 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 	memset(skb->cb, 0, sizeof(skb->cb));
 
 	netif_rx(skb);
-
-
 }
 
 struct tx_complete_mon_data {
@@ -183,7 +180,6 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 		PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 		kfree(mgmt_tx);
 		return -EFAULT;
-
 	}
 
 	mgmt_tx->size = len;
@@ -325,7 +321,6 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 	if (!wilc_wfi_mon) {
 		PRINT_ER("failed to allocate memory\n");
 		return NULL;
-
 	}
 
 	wilc_wfi_mon->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -379,5 +374,4 @@ int WILC_WFI_deinit_mon_interface(void)
 		wilc_wfi_mon = NULL;
 	}
 	return 0;
-
 }
-- 
2.7.0

