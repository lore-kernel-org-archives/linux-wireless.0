Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37110 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301AbaHVMnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:43:12 -0400
Received: by mail-lb0-f179.google.com with SMTP id v6so9330483lbi.38
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:43:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 5/5] ath10k: flush hif buffers before recovery
Date: Fri, 22 Aug 2014 14:33:18 +0200
Message-Id: <1408710798-25198-6-git-send-email-michal.kazior@tieto.com> (sfid-20140822_144318_175215_167ADFE2)
In-Reply-To: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
References: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Transport buffers weren't flushed and processed
before queueing hw recovery request to mac80211.

This could in theory result in an unwanted htt/wmi
rx events being processed while mac80211 recovers
the device and possibly interfere or even crash
the system.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * rebased with scan fixes
     * move hif_stop() before scan_finish()

 drivers/net/wireless/ath/ath10k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 23ba321..157dcf9 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -665,6 +665,7 @@ static void ath10k_core_restart(struct work_struct *work)
 	switch (ar->state) {
 	case ATH10K_STATE_ON:
 		ar->state = ATH10K_STATE_RESTARTING;
+		ath10k_hif_stop(ar);
 		ath10k_scan_finish(ar);
 		ieee80211_restart_hw(ar->hw);
 		break;
-- 
1.8.5.3

