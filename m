Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:43836 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab3GENPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 15/16] ath10k: abort scan properly if wmi_scan_stop fails
Date: Fri,  5 Jul 2013 16:15:16 +0300
Message-Id: <1373030117-18077-16-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_152039_448368_FCEC2442)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index def1e68..4867f30 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1587,6 +1587,10 @@ static int ath10k_abort_scan(struct ath10k *ar)
 	ret = ath10k_wmi_stop_scan(ar, &arg);
 	if (ret) {
 		ath10k_warn("could not submit wmi stop scan (%d)\n", ret);
+		spin_lock_bh(&ar->data_lock);
+		ar->scan.in_progress = false;
+		ath10k_offchan_tx_purge(ar);
+		spin_unlock_bh(&ar->data_lock);
 		return -EIO;
 	}
 
-- 
1.7.9.5

