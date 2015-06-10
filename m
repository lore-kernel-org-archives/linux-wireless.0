Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36573 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbbFJFO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 01:14:58 -0400
Received: by wgbgq6 with SMTP id gq6so26724157wgb.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 22:14:57 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] ath10k: enable VHT for IBSS
Date: Wed, 10 Jun 2015 07:14:44 +0200
Message-Id: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150610_071501_448137_94CB2EC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable VHT support for IBSS, while mac80211/cfg80211 and
wpa_supplicant already support this.

In my test env, ath10k 2x2 I get:
(udp) ath10k-1 >>>> ath10k-2 (server) -  speed: 419 Mbits/sec
(tcp) ath10k-1 >>>> ath10k-2 (server) -  speed: 404 Mbits/sec

During tests I used wpa_supplicant (current version), which
already support IBSS VHT, and choose highest available BW.

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

