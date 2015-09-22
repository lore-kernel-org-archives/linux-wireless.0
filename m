Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38553 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbbIVKZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 06:25:00 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Johnny Kim <johnny.kim@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Glen Lee <glen.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH] staging: wicl1000: fix dereference after free in wilc_wlan_cleanup()
Date: Tue, 22 Sep 2015 12:24:50 +0200
Message-Id: <1442917490-26574-1-git-send-email-javier@osg.samsung.com> (sfid-20150922_122546_476289_40043D33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wilc_wlan_cleanup() function iterates over the list of transmission
buffers freeing all of them and then iterates over the receive buffers
list to free all of them as well.

But on the receive loop a pointer to struct txq_entry_t is dereferenced
instead of the pointer to a struct rxq_entry_t. This not only causes a
dereference to a pointer already freed but also leaks the memory in the
struct rxq_entry_t buffer.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/staging/wilc1000/wilc_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4c25179c2fec..c40f143b00b7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1746,7 +1746,7 @@ static void wilc_wlan_cleanup(void)
 		if (rqe == NULL)
 			break;
 #ifdef MEMORY_DYNAMIC
-		kfree(tqe->buffer);
+		kfree(rqe->buffer);
 #endif
 		kfree(rqe);
 	} while (1);
-- 
2.4.3

