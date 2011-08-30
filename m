Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5281 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1H3TCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:02:24 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 08/22] ath6kl: Request P2P capabilities during target init
Date: Tue, 30 Aug 2011 21:57:57 +0300
Message-ID: <1314730691-12089-9-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210227_554476_7753D2D6)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index ad9716c..48c82e9 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -417,6 +417,7 @@ void ath6kl_target_failure(struct ath6kl *ar)
 static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 {
 	int status = 0;
+	int ret;
 
 	/*
 	 * Configure the device for rx dot11 header rules. "0,0" are the
@@ -461,6 +462,15 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 			status = -EIO;
 		}
 
+	ret = ath6kl_wmi_info_req_cmd(ar->wmi, P2P_FLAG_CAPABILITIES_REQ |
+				      P2P_FLAG_MACADDR_REQ |
+				      P2P_FLAG_HMODEL_REQ);
+	if (ret) {
+		ath6kl_dbg(ATH6KL_DBG_TRC, "failed to request P2P "
+			   "capabilities (%d) - assuming P2P not supported\n",
+			   ret);
+	}
+
 	return status;
 }
 
-- 
1.7.4.1

