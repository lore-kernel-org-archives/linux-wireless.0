Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43136 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab0DVDoD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 23:44:03 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 20:44:03 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19407.50665.276352.887195@gargle.gargle.HOWL>
Date: Thu, 22 Apr 2010 09:13:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 9/9] ath9k_htc: Increase WMI timeout value
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Completion of WMI commands take a longer time
on some platforms. Increase the timeout value
to handle this.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/wmi.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 167e15c..765db5f 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -126,14 +126,14 @@ void ath9k_wmi_tasklet(unsigned long data);
 	do {								\
 		ret = ath9k_wmi_cmd(priv->wmi, _wmi_cmd, NULL, 0,	\
 				    (u8 *) &cmd_rsp,			\
-				    sizeof(cmd_rsp), HZ);		\
+				    sizeof(cmd_rsp), HZ*2);		\
 	} while (0)
 
 #define WMI_CMD_BUF(_wmi_cmd, _buf)					\
 	do {								\
 		ret = ath9k_wmi_cmd(priv->wmi, _wmi_cmd,		\
 				    (u8 *) _buf, sizeof(*_buf),		\
-				    &cmd_rsp, sizeof(cmd_rsp), HZ);	\
+				    &cmd_rsp, sizeof(cmd_rsp), HZ*2);	\
 	} while (0)
 
 #endif /* WMI_H */
-- 
1.7.0.5

