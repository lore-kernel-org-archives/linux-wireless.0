Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:24181 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab2F3MIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 08:08:21 -0400
Date: Sat, 30 Jun 2012 15:07:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>,
	Eliad Peller <eliad@wizery.com>, Ido Yariv <ido@wizery.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] wlcore: fix a couple small memory leaks
Message-ID: <20120630120755.GC22767@elgon.mountain> (sfid-20120630_140827_613889_EE166787)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should free "chunk" here before returning the error code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 8965960..48b2fee 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -141,7 +141,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	partition.mem.start = dest;
 	ret = wlcore_set_partition(wl, &partition);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	/* 10.1 set partition limit and chunk num */
 	chunk_num = 0;
@@ -157,7 +157,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 			partition.mem.start = addr;
 			ret = wlcore_set_partition(wl, &partition);
 			if (ret < 0)
-				return ret;
+				goto out;
 		}
 
 		/* 10.3 upload the chunk */
