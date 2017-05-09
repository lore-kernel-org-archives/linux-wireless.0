Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35962 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbdEINcE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:32:04 -0400
Received: by mail-pg0-f65.google.com with SMTP id 64so7573969pgb.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 06:32:04 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 06/11] rsi: Handle usb multi-byte write failure case properly
Date: Tue,  9 May 2017 19:00:09 +0530
Message-Id: <1494336614-2107-7-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170509_153214_747513_6CB43C45)
In-Reply-To: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

In function usb_write_register_multiple, if any intermediate block transfer
is failed, further operations should be terminated. 'else' is removed, as
there is no significance for it after return.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 8eb7407..634f726 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -306,11 +306,12 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 			rsi_dbg(ERR_ZONE,
 				"Reg write failed with error code :%d\n",
 				status);
-		} else {
-			count -= transfer;
-			data += transfer;
-			addr += transfer;
+			kfree(buf);
+			return status;
 		}
+		count -= transfer;
+		data += transfer;
+		addr += transfer;
 	}
 
 	kfree(buf);
-- 
2.7.4
