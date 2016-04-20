Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:34781 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbcDTEVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 00:21:05 -0400
Received: by mail-qg0-f44.google.com with SMTP id c6so22093387qga.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2016 21:21:04 -0700 (PDT)
From: Marty Faltesek <mfaltesek@google.com>
To: linux-wireless@vger.kernel.org
Cc: akarwar@marvell.com
Subject: [PATCH v2] mwifiex: fw download does not release sdio bus during failure
Date: Wed, 20 Apr 2016 00:20:52 -0400
Message-Id: <1461126052-12164-1-git-send-email-mfaltesek@google.com> (sfid-20160420_062109_447422_08F997B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Marty Faltesek <mfaltesek@google.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 4c8cae6..d6ef34f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1026,13 +1026,12 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		offset += txlen;
 	} while (true);
 
-	sdio_release_host(card->func);
-
 	mwifiex_dbg(adapter, MSG,
 		    "info: FW download over, size %d bytes\n", offset);
 
 	ret = 0;
 done:
+	sdio_release_host(card->func);
 	kfree(fwbuf);
 	return ret;
 }
-- 
2.8.0.rc3.226.g39d4020

