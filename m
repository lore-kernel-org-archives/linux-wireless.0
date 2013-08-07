Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43003 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab3HGFYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 01:24:53 -0400
Received: by mail-ee0-f41.google.com with SMTP id d17so597154eek.14
        for <linux-wireless@vger.kernel.org>; Tue, 06 Aug 2013 22:24:51 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: setup peer UAPSD flag correctly
Date: Wed,  7 Aug 2013 07:23:56 +0200
Message-Id: <1375853036-2418-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20130807_072517_652297_371B09D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup UAPSD peer rate control (FW flag)
correctly.

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

