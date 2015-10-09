Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbbJILLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 07:11:37 -0400
From: Colin King <colin.king@canonical.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix memory leak on mgmt_tx on error return path
Date: Fri,  9 Oct 2015 12:11:33 +0100
Message-Id: <1444389093-10309-1-git-send-email-colin.king@canonical.com> (sfid-20151009_131153_386044_10CC16C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Static analysis with cppcheck found the following memory leak:

[drivers/staging/wilc1000/linux_mon.c:255]: (error) Memory leak: mgmt_tx

Free mgmt_tx on the error return path when mgmt_tx->buff fails to be
allocated.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/linux_mon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index b8d7d04..f35d6ba 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -252,6 +252,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
 	if (mgmt_tx->buff == NULL) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
+		kfree(mgmt_tx);
 		return WILC_FAIL;
 
 	}
-- 
2.5.0

