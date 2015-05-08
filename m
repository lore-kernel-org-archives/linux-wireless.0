Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33131 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbEHJRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 05:17:03 -0400
Received: by lbbzk7 with SMTP id zk7so49019941lbb.0
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2015 02:17:02 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: fix idle power consumption
Date: Fri,  8 May 2015 09:13:07 +0000
Message-Id: <1431076388-24800-3-git-send-email-michal.kazior@tieto.com> (sfid-20150508_111711_527667_11F29696)
In-Reply-To: <1431076388-24800-1-git-send-email-michal.kazior@tieto.com>
References: <1431076388-24800-1-git-send-email-michal.kazior@tieto.com>
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

