Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35254 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbbFHMPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 08:15:43 -0400
Received: by wiga1 with SMTP id a1so84188859wig.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 05:15:41 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: print htt op_version upon driver boot
Date: Mon,  8 Jun 2015 14:15:34 +0200
Message-Id: <1433765734-646-2-git-send-email-michal.kazior@tieto.com> (sfid-20150608_141547_224225_C2A1EC4E)
In-Reply-To: <1433765734-646-1-git-send-email-michal.kazior@tieto.com>
References: <1433765734-646-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HTT version itself isn't sufficient to know what
HTT version given firmware blob uses. Hence print
the recently introduced HTT op version code.

While at it make the info string a bit more
consistent and clear.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8a4edfd36e47..edf6047997a7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -128,7 +128,7 @@ void ath10k_print_driver_info(struct ath10k *ar)
 
 	ath10k_core_get_fw_features_str(ar, fw_features, sizeof(fw_features));
 
-	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d features %s\n",
+	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt-ver %d.%d wmi-op %d htt-op %d cal %s max-sta %d features %s\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
@@ -141,6 +141,7 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    ar->htt.target_version_major,
 		    ar->htt.target_version_minor,
 		    ar->wmi.op_version,
+		    ar->htt.op_version,
 		    ath10k_cal_mode_str(ar->cal_mode),
 		    ar->max_num_stations,
 		    fw_features);
-- 
2.1.4

