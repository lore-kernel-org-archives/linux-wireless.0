Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34237 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbFHFm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 01:42:29 -0400
Received: by wgv5 with SMTP id 5so93872131wgv.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2015 22:42:28 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: enable VHT for IBSS
Date: Mon,  8 Jun 2015 07:42:24 +0200
Message-Id: <1433742144-19876-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150608_074423_950871_592DCD3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable VHT support for IBSS.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f4de717..14a8f25 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6949,6 +6949,8 @@ int ath10k_mac_register(struct ath10k *ar)
 		goto err_free;
 	}
 
+	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
-- 
1.9.1

