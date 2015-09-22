Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38592 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933535AbbIVNZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:25:00 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Johnny Kim <johnny.kim@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Glen Lee <glen.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH v2] staging: wicl1000: fix dereference after free in wilc_wlan_cleanup()
Date: Tue, 22 Sep 2015 15:24:50 +0200
Message-Id: <1442928290-11484-1-git-send-email-javier@osg.samsung.com> (sfid-20150922_153238_924706_0DE1E231)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wilc_wlan_cleanup() function iterates over the list of transmission
buffers freeing all of them and then iterates over the receive buffers
list to free all of them as well.

But on the receive loop a pointer to struct txq_entry_t is dereferenced
instead of the pointer to a struct rxq_entry_t. This not only causes a
dereference to a pointer already freed but also leaks the memory in the
struct rxq_entry_t buffer.

Also, the buffer is allocated when MEMORY_STATIC is not defined no when
MEMORY_DYNAMIC is defined. So use #ifndef MEMORY_STATIC instead as it's
done in the rest of the driver to avoid leaking the buffer memory.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

Changes in v2:
- Change also the #ifdef MEMORY_DYNAMIC to #ifndef MEMORY_STATIC since buffer
  is allocated when MEMORY_STATIC isn't defined. Suggested by Sudip Mukherjee.

 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4c25179c2fec..fc9028d59dcd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1745,8 +1745,8 @@ static void wilc_wlan_cleanup(void)
 		rqe = wilc_wlan_rxq_remove();
 		if (rqe == NULL)
 			break;
-#ifdef MEMORY_DYNAMIC
-		kfree(tqe->buffer);
+#ifndef MEMORY_STATIC
+		kfree(rqe->buffer);
 #endif
 		kfree(rqe);
 	} while (1);
-- 
2.4.3

