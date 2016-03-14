Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36762 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbcCNXTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2016 19:19:36 -0400
Received: by mail-qk0-f174.google.com with SMTP id s68so101798qkh.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2016 16:19:36 -0700 (PDT)
From: Marty Faltesek <mfaltesek@google.com>
To: akarwar@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mwifiex: fw download does not release sdio bus during failure
Date: Mon, 14 Mar 2016 19:19:21 -0400
Message-Id: <1457997561-14357-1-git-send-email-mfaltesek@google.com> (sfid-20160315_001946_211813_BC1799A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
2.7.0.rc3.207.g0ac5344

