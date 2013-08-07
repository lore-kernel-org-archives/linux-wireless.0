Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:49479 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab3HGKLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 06:11:41 -0400
Received: by mail-ea0-f169.google.com with SMTP id z7so756253eaf.28
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 03:11:40 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] ath10k: setup peer UAPSD flag correctly
Date: Wed,  7 Aug 2013 12:10:49 +0200
Message-Id: <1375870249-29316-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20130807_121147_788098_1AC437B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup UAPSD peer/peer rate flags correctly.
WMI_RC_UAPSD_FLAG is a peer rate capabilities flag
and should not be set as a peer flag.
Found during code review, doesn't fix a known
issues.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cf2ba4d..505be82 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -973,7 +973,7 @@ static void ath10k_peer_assoc_h_qos_ap(struct ath10k *ar,
 			   sta->uapsd_queues, sta->max_sp);
 
 		arg->peer_flags |= WMI_PEER_APSD;
-		arg->peer_flags |= WMI_RC_UAPSD_FLAG;
+		arg->peer_rate_caps |= WMI_RC_UAPSD_FLAG;
 
 		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
 			uapsd |= WMI_AP_PS_UAPSD_AC3_DELIVERY_EN |
-- 
1.7.9.5

