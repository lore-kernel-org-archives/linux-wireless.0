Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34253 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbbERJif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 05:38:35 -0400
Received: by wicmc15 with SMTP id mc15so84645246wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 02:38:34 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/3] ath10k: fix idle power consumption
Date: Mon, 18 May 2015 09:38:17 +0000
Message-Id: <1431941898-13591-3-git-send-email-michal.kazior@tieto.com> (sfid-20150518_113840_868119_E3717F39)
In-Reply-To: <1431941898-13591-1-git-send-email-michal.kazior@tieto.com>
References: <1431076388-24800-1-git-send-email-michal.kazior@tieto.com>
 <1431941898-13591-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>

mac80211 can update vif powersave state while
disconnected. Firmware doesn't behave nicely and
consumes more power than necessary if PS is
disabled on a non-started vdev. Hence
force-enable PS for non-running vdevs.

This reduces power drain on QCA61X4 from 88mA to
36mA when interface is up and not associated.
QCA988X wasn't measured.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 425dbe271495..9f576ca99f86 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1735,7 +1735,14 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 		enable_ps = false;
 	}
 
-	if (enable_ps) {
+	if (!arvif->is_started) {
+		/* mac80211 can update vif powersave state while disconnected.
+		 * Firmware doesn't behave nicely and consumes more power than
+		 * necessary if PS is disabled on a non-started vdev. Hence
+		 * force-enable PS for non-running vdevs.
+		 */
+		psmode = WMI_STA_PS_MODE_ENABLED;
+	} else if (enable_ps) {
 		psmode = WMI_STA_PS_MODE_ENABLED;
 		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
 
-- 
2.1.4

