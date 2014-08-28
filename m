Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44333 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965592AbaH1IJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 04:09:28 -0400
Received: by mail-lb0-f181.google.com with SMTP id n15so452313lbi.26
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 01:09:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix num_legacy_stations tracking
Date: Thu, 28 Aug 2014 09:59:39 +0200
Message-Id: <1409212779-5212-1-git-send-email-michal.kazior@tieto.com> (sfid-20140828_100955_029754_869F98CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a station was reassociated, i.e. due to change
of supported rates update via sta_rc_update() the
num_legacy_stations would be (incorrectly) bumped
up leading to unbalanced usage of the var. This in
turn could lock rtscts protection up as enabled.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b858c82..4e30e57 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1615,7 +1615,7 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 		return ret;
 	}
 
-	if (!sta->wme) {
+	if (!sta->wme && !reassoc) {
 		arvif->num_legacy_stations++;
 		ret  = ath10k_recalc_rtscts_prot(arvif);
 		if (ret) {
-- 
1.8.5.3

