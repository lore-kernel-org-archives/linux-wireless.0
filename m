Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59417 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaKXOLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:11:11 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so5747672wib.16
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:11:10 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: fix offchannel cancel failures
Date: Mon, 24 Nov 2014 14:58:33 +0100
Message-Id: <1416837513-13386-3-git-send-email-michal.kazior@tieto.com> (sfid-20141124_151117_263423_6A735F5F)
In-Reply-To: <1416837513-13386-1-git-send-email-michal.kazior@tieto.com>
References: <1416837513-13386-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 requests driver to cancel a hw roc
the driver must not call the expired() callback or
else roc will fail in some cases depending on how
things get scheduled.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 272a9d9..42b5982 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2184,10 +2184,10 @@ void __ath10k_scan_finish(struct ath10k *ar)
 	case ATH10K_SCAN_IDLE:
 		break;
 	case ATH10K_SCAN_RUNNING:
-	case ATH10K_SCAN_ABORTING:
 		if (ar->scan.is_roc)
 			ieee80211_remain_on_channel_expired(ar->hw);
-		else
+	case ATH10K_SCAN_ABORTING:
+		if (!ar->scan.is_roc)
 			ieee80211_scan_completed(ar->hw,
 						 (ar->scan.state ==
 						  ATH10K_SCAN_ABORTING));
-- 
1.8.5.3

