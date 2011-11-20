Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1KTH5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 02:57:50 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so5187685bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 23:57:50 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 08/13] ath5k: We always do full calibration on AR5210
Date: Sun, 20 Nov 2011 09:56:23 +0200
Message-Id: <1321775788-12520-9-git-send-email-mickflemm@gmail.com> (sfid-20111120_085754_664857_D670C574)
In-Reply-To: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no short calibration on AR5210, make sure we treat it always
as full calibration.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 3bb42a4..1a166d7 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1674,6 +1674,9 @@ ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	u32 phy_sig, phy_agc, phy_sat, beacon;
 	int ret;
 
+	if (!(ah->ah_cal_mask & AR5K_CALIBRATION_FULL))
+		return 0;
+
 	/*
 	 * Disable beacons and RX/TX queues, wait
 	 */
-- 
1.7.8.rc1

