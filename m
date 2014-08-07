Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53395 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbaHGJOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:14:31 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so10310082wib.16
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:14:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/5] ath10k: flush hif buffers before recovery
Date: Thu,  7 Aug 2014 11:05:08 +0200
Message-Id: <1407402308-29899-6-git-send-email-michal.kazior@tieto.com> (sfid-20140807_112943_038575_5EB25FCF)
In-Reply-To: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
References: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
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
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b5161c8..5c9620b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -667,6 +667,7 @@ static void ath10k_core_restart(struct work_struct *work)
 		ar->state = ATH10K_STATE_RESTARTING;
 		del_timer_sync(&ar->scan.timeout);
 		ath10k_reset_scan((unsigned long)ar);
+		ath10k_hif_stop(ar);
 		ieee80211_restart_hw(ar->hw);
 		break;
 	case ATH10K_STATE_OFF:
-- 
1.8.5.3

