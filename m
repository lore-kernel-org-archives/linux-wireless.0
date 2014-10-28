Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:46500 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaJ1OvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:51:07 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 4/5] wil6210: improve dmesg for fw error handling
Date: Tue, 28 Oct 2014 16:50:09 +0200
Message-ID: <1414507810-23141-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141028_155128_663370_1854C93D)
In-Reply-To: <1414507810-23141-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1414507810-23141-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of FW error, make it clear (in dmesg) what branch is taken
in the error recovery code.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index b3a84ae..92705c0 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -267,9 +267,12 @@ static void wil_fw_error_worker(struct work_struct *work)
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
+		wil_info(wil, "No recovery for AP-like interface\n");
 		/* recovery in these modes is done by upper layers */
 		break;
 	default:
+		wil_err(wil, "No recovery - unknown interface type %d\n",
+			wdev->iftype);
 		break;
 	}
 	mutex_unlock(&wil->mutex);
-- 
2.1.0

