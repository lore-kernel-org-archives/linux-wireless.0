Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59854 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2LLV4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 16:56:47 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 6/6] ath9k: Allow using ath9k-rate-control without forcing it.
Date: Wed, 12 Dec 2012 13:54:55 -0800
Message-Id: <1355349295-30960-6-git-send-email-greearb@candelatech.com> (sfid-20121212_225651_541173_9A11561A)
In-Reply-To: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Let user still pick the rate control method by setting the
mac80211 module option, ie:

# cat /etc/modprobe.d/mac80211.conf
options mac80211 ieee80211_default_rc_algo=ath9k_rate_control

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f69ef5d..772b69f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -818,7 +818,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	sc->ant_tx = hw->wiphy->available_antennas_tx;
 
 #ifdef CONFIG_ATH9K_RATE_CONTROL
-	hw->rate_control_algorithm = "ath9k_rate_control";
+	/* hw->rate_control_algorithm = "ath9k_rate_control"; */
 #endif
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-- 
1.7.3.4

