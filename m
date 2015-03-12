Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44032 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbbCLMMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:12:36 -0400
Received: by lbvn10 with SMTP id n10so15403211lbv.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 05:12:35 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: setup maximum number of supported stations
Date: Thu, 12 Mar 2015 13:11:41 +0100
Message-Id: <1426162301-27066-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150312_131247_444410_001CC312)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup maximum number of associated stations supported in
AP/P2P_GO mode.

This allow hostapd/wpa_supplicant to play with that limit
and set more information (eg. P2P group limit bit for P2P_GO).

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1138f4f..80f19fc 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5766,6 +5766,8 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 	ar->hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
 
+	ar->hw->wiphy->max_ap_assoc_sta = ar->max_num_stations;
+
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
-- 
1.9.1

