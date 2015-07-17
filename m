Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36807 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977AbbGQHNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 03:13:43 -0400
Received: by widjy10 with SMTP id jy10so33791638wid.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 00:13:42 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 2/4] mwifiex: remove redundant reset of cmd_wait_q status
Date: Fri, 17 Jul 2015 09:13:04 +0200
Message-Id: <1437117186-25243-3-git-send-email-afenkart@gmail.com> (sfid-20150717_091347_074803_BEB08172)
In-Reply-To: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
References: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex_cancel_pending_ioctl is called only from
mwifiex_cmd_timeout_func. There the wait_q status is set to
-ETIMEDWAIT before calling this function. Whether we reset the status
to -1 or leave it at -ETIMEDWAIT at end doesn't matter since both
are != 0 hence mean failure

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 2f4715e..87b6dee 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1123,7 +1123,6 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 			}
 		}
 	}
-	adapter->cmd_wait_q.status = -1;
 }
 
 /*
-- 
2.1.4

