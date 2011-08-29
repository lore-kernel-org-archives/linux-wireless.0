Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48282 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1H2M2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:28:32 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 08/20] ath6kl: Request P2P capabilities during target init
Date: Mon, 29 Aug 2011 15:23:49 +0300
Message-ID: <1314620641-24257-9-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_142834_623528_7287A562)
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index ad9716c..aa7440d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -417,6 +417,7 @@ void ath6kl_target_failure(struct ath6kl *ar)
 static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 {
 	int status = 0;
+	int ret;
 
 	/*
 	 * Configure the device for rx dot11 header rules. "0,0" are the
@@ -461,6 +462,14 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 			status = -EIO;
 		}
 
+	ret = ath6kl_wmi_info_req_cmd(ar->wmi, P2P_FLAG_CAPABILITIES_REQ |
+				      P2P_FLAG_MACADDR_REQ |
+				      P2P_FLAG_HMODEL_REQ);
+	if (ret) {
+		printk(KERN_DEBUG "ath6l: Failed to request P2P capabilities "
+		       "(%d) - assuming P2P not supported\n", ret);
+	}
+
 	return status;
 }
 
-- 
1.7.4.1

