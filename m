Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59598 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab1J1WWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 18:22:02 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [wireless-next PATCH v2 4/4] ath9k:  Support modifying AMSDU and AMPDU settings.
Date: Fri, 28 Oct 2011 15:21:14 -0700
Message-Id: <1319840474-2618-4-git-send-email-greearb@candelatech.com> (sfid-20111029_002206_458273_61D9712D)
In-Reply-To: <1319840474-2618-1-git-send-email-greearb@candelatech.com>
References: <1319840474-2618-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The driver appears to function properly with these
values modified from defaults, so add the feature
definitions.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 af1b325... 3f4e679... M	drivers/net/wireless/ath/ath9k/init.c
 drivers/net/wireless/ath/ath9k/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index af1b325..3f4e679 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -673,6 +673,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT |
+		IEEE80211_HW_SUPPORTS_AMPDU_MOD |
+		IEEE80211_HW_SUPPORTS_AMSDU_MOD |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
-- 
1.7.3.4

