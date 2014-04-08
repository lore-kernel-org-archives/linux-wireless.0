Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44185 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaDHLjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 07:39:16 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so570978eek.29
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 04:39:15 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath9k: Enable DFS only when ATH9K_DFS_CERTIFIED
Date: Tue,  8 Apr 2014 13:38:43 +0200
Message-Id: <1396957123-11040-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140408_133920_678735_B063E0FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add DFS interface combination only when
CONFIG_ATH9K_DFS_CERTIFIED is set. In other case
user can run CAC/beaconing without proper handling
of pulse events (without radar detection activated).

Reported-by: Cedric Voncken <cedric.voncken@acksys.fr>
Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c0a4e86..cbbb02a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -670,6 +670,7 @@ static const struct ieee80211_iface_combination if_comb[] = {
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
 	},
+#ifdef CONFIG_ATH9K_DFS_CERTIFIED
 	{
 		.limits = if_dfs_limits,
 		.n_limits = ARRAY_SIZE(if_dfs_limits),
@@ -679,6 +680,7 @@ static const struct ieee80211_iface_combination if_comb[] = {
 		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
 					BIT(NL80211_CHAN_WIDTH_20),
 	}
+#endif
 };
 
 static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
-- 
1.7.9.5

