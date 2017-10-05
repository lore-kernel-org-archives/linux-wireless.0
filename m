Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:10864 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbdJEGF6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 02:05:58 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: block offchannel operations if TDLS session is active
Date: Thu, 5 Oct 2017 11:38:29 +0530
Message-ID: <1507183709-585-2-git-send-email-akolli@qti.qualcomm.com> (sfid-20171005_080601_507405_43666E3D)
In-Reply-To: <1507183709-585-1-git-send-email-akolli@qti.qualcomm.com>
References: <1507183709-585-1-git-send-email-akolli@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

Do not allow off channel operations like scans/roc when
there are active TDLS sessions.

The Current firmware 10.4-3.5.1-00035 on QCA9888 does not
supports any offchannel operations on active TDLS sessions,
either driver needs to block the offchannel operation requests
or should teardown the TDLS connection.

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0f14da73cf64..2f3851e688f4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5641,6 +5641,11 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
+	if (ath10k_mac_tdls_vif_stations_count(hw, vif) > 0) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
 	spin_lock_bh(&ar->data_lock);
 	switch (ar->scan.state) {
 	case ATH10K_SCAN_IDLE:
@@ -6477,6 +6482,11 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
+	if (ath10k_mac_tdls_vif_stations_count(hw, vif) > 0) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
 	spin_lock_bh(&ar->data_lock);
 	switch (ar->scan.state) {
 	case ATH10K_SCAN_IDLE:
-- 
1.7.9.5
