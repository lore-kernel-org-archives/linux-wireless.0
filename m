Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32321 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbEDWMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 18:12:01 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 1/7] wil6210: increase timeout for the "echo" command
Date: Tue,  5 May 2015 01:11:50 +0300
Message-Id: <1430777516-439-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150505_001236_423521_1D009F9E)
In-Reply-To: <1430777516-439-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1430777516-439-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes it takes for the firmware more than 20ms to
react on "echo" command after reset. Increase timeout
from 20 to 50ms

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 9fe2085..04fad5f 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -844,7 +844,7 @@ int wmi_echo(struct wil6210_priv *wil)
 	};
 
 	return wmi_call(wil, WMI_ECHO_CMDID, &cmd, sizeof(cmd),
-			 WMI_ECHO_RSP_EVENTID, NULL, 0, 20);
+			WMI_ECHO_RSP_EVENTID, NULL, 0, 50);
 }
 
 int wmi_set_mac_address(struct wil6210_priv *wil, void *addr)
-- 
2.1.0

