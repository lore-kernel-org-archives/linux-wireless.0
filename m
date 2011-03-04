Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45341 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab1CDA0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 19:26:06 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH Resend] ath9k: Fix txq memory address printing in debugfs.
Date: Thu,  3 Mar 2011 16:25:59 -0800
Message-Id: <1299198359-28594-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

No use printing addresses of pointers, just print the
pointers themselves.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 e803b5c... 2cb42f9... M	drivers/net/wireless/ath/ath9k/debug.c
 drivers/net/wireless/ath/ath9k/debug.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index e803b5c..2cb42f9 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -549,10 +549,10 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("hw-tx-proc-desc: ", txprocdesc);
 	len += snprintf(buf + len, size - len,
 			"%s%11p%11p%10p%10p\n", "txq-memory-address:",
-			&(sc->tx.txq_map[WME_AC_BE]),
-			&(sc->tx.txq_map[WME_AC_BK]),
-			&(sc->tx.txq_map[WME_AC_VI]),
-			&(sc->tx.txq_map[WME_AC_VO]));
+			sc->tx.txq_map[WME_AC_BE],
+			sc->tx.txq_map[WME_AC_BK],
+			sc->tx.txq_map[WME_AC_VI],
+			sc->tx.txq_map[WME_AC_VO]);
 	if (len >= size)
 		goto done;
 
-- 
1.7.2.3

