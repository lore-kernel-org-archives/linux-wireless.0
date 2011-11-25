Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33480 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1KYSlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:41:07 -0500
Received: by mail-ey0-f174.google.com with SMTP id k14so988570eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:41:07 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 07/12] ath5k: We always do full calibration on AR5210
Date: Fri, 25 Nov 2011 20:40:26 +0200
Message-Id: <1322246431-10825-8-git-send-email-mickflemm@gmail.com> (sfid-20111125_194117_645068_4AC876B3)
In-Reply-To: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no short calibration on AR5210, make sure we treat it always
as full calibration.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index a635441..e1f8613 100644
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
1.7.8.rc3

