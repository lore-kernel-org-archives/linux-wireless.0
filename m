Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34957 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2JOIOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 04:14:53 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 12/12] ath9k: Add new BT profile info A2DP_Voice
Date: Mon, 15 Oct 2012 13:25:38 +0530
Message-ID: <1350287738-18687-13-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_103930_438753_25D819E6)
In-Reply-To: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the BT connection is initiated by headset, it's possible that headset
requests to make one A2DP and one Voice connection over the same link.
BT firmware will send a new profile A2DP_Voice in this case. So WLAN
has to take care of this new profile for tuning BTCOEX parameters.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.h | 1 +
 drivers/net/wireless/ath/ath9k/mci.h        | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 3e51f54..66d7ab9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -126,6 +126,7 @@ enum ath_mci_gpm_coex_profile_type {
 	MCI_GPM_COEX_PROFILE_HID,
 	MCI_GPM_COEX_PROFILE_BNEP,
 	MCI_GPM_COEX_PROFILE_VOICE,
+	MCI_GPM_COEX_PROFILE_A2DPVO,
 	MCI_GPM_COEX_PROFILE_MAX
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
index e5f170a..0695883 100644
--- a/drivers/net/wireless/ath/ath9k/mci.h
+++ b/drivers/net/wireless/ath/ath9k/mci.h
@@ -70,6 +70,7 @@
 			_mci->num_pan++;	 \
 			break;			 \
 		case MCI_GPM_COEX_PROFILE_VOICE: \
+		case MCI_GPM_COEX_PROFILE_A2DPVO:\
 			_mci->num_sco++;	 \
 			break;			 \
 		default:			 \
@@ -94,6 +95,7 @@
 			_mci->num_pan--;	 \
 			break;			 \
 		case MCI_GPM_COEX_PROFILE_VOICE: \
+		case MCI_GPM_COEX_PROFILE_A2DPVO:\
 			_mci->num_sco--;	 \
 			break;			 \
 		default:			 \
-- 
1.7.12.2

