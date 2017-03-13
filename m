Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:7509 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932291AbdCMVHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Mar 2017 17:07:24 -0400
From: Alban <albeu@free.fr>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: John Crispin <john@phrozen.org>, Alban <albeu@free.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] ath9k: hw: Reset the device with the external reset before init
Date: Mon, 13 Mar 2017 22:05:15 +0100
Message-Id: <1489439116-4233-7-git-send-email-albeu@free.fr> (sfid-20170313_220902_063485_F3B3D2B9)
In-Reply-To: <1489439116-4233-1-git-send-email-albeu@free.fr>
References: <1489439116-4233-1-git-send-email-albeu@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the SoC platform the board code often manually reset the device
before registering it. To allow the same to happen on DT platforms
let the driver call the reset before init.

Signed-off-by: Alban <albeu@free.fr>
---
 drivers/net/wireless/ath/ath9k/hw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index efc0435..dfb13bc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -576,6 +576,13 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
+	/* Reset the device before using it */
+	r = ath9k_hw_external_reset(ah);
+	if (r) {
+		ath_err(common, "Failed to reset chip\n");
+		return r;
+	}
+
 	ath9k_hw_read_revisions(ah);
 
 	switch (ah->hw_version.macVersion) {
-- 
2.7.4
