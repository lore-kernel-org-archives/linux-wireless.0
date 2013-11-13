Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43949 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab3KMKI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 05:08:28 -0500
Received: by mail-ee0-f52.google.com with SMTP id l10so96415eei.39
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 02:08:26 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: allow dynamic bandwidth in hw rate control
Date: Wed, 13 Nov 2013 11:05:10 +0100
Message-Id: <1384337110-9417-1-git-send-email-michal.kazior@tieto.com> (sfid-20131113_110854_742924_107962EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames were never retransmitted with
different/lower bandwidths, e.g. only 80MHz
bandwidth was used when dealing with a VHT80
peer.

Allow HW rate control to try out different
bandwidths when retransmitting. This increases
robustness.

Also, document the parameter properly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 drivers/net/wireless/ath/ath10k/wmi.h | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 56f030e..db81942 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1964,7 +1964,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		ath10k_warn("could not enable WMI_PDEV_PARAM_PMF_QOS (%d)\n",
 			    ret);
 
-	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->dynamic_bw, 0);
+	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->dynamic_bw, 1);
 	if (ret)
 		ath10k_warn("could not init WMI_PDEV_PARAM_DYNAMIC_BW (%d)\n",
 			    ret);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 81e33a7..8b824f9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2234,7 +2234,12 @@ enum wmi_pdev_param {
 	 * 0: no protection 1:use CTS-to-self 2: use RTS/CTS
 	 */
 	WMI_PDEV_PARAM_PROTECTION_MODE,
-	/* Dynamic bandwidth 0: disable 1: enable */
+	/*
+	 * Dynamic bandwidth - 0: disable, 1: enable
+	 *
+	 * When enabled HW rate control tries different bandwidths when
+	 * retransmitting frames.
+	 */
 	WMI_PDEV_PARAM_DYNAMIC_BW,
 	/* Non aggregrate/ 11g sw retry threshold.0-disable */
 	WMI_PDEV_PARAM_NON_AGG_SW_RETRY_TH,
-- 
1.8.4.rc3

