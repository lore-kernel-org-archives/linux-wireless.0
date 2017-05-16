Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33349 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751987AbdEPKDF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:03:05 -0400
Received: by mail-pg0-f66.google.com with SMTP id s62so20865923pgc.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:03:04 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v3 06/11] rsi: Handle usb multi-byte write failure case properly
Date: Tue, 16 May 2017 15:31:12 +0530
Message-Id: <1494928877-27168-7-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170516_120346_913804_E9E8B3D3)
In-Reply-To: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

In function usb_write_register_multiple, if any intermediate block transfer
is failed, further operations should be terminated. 'else' is removed, as
there is no significance for it after return.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v3: Same as earlier. Below patch has been dropped in this
series(Kalle Valo/Arend van Spriel)
[v2 05/11] rsi: Remove unnecessary buffer allocation
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 9e1359a..a900a72 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -316,11 +316,12 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
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
