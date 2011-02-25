Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:58240 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab1BYMBP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 07:01:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 04:00:53 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k: Cancel pll_work while disabling radio.
Date: Fri, 25 Feb 2011 17:31:02 +0530
Message-ID: <1298635263-4883-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1298635263-4883-1-git-send-email-vnatarajan@atheros.com>
References: <1298635263-4883-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pll_work should be cancelled on full_sleep or it may cause
redundant chip reset.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a715500..9b03b5a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -910,6 +910,8 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
 
 	ieee80211_wake_queues(hw);
+	ieee80211_queue_delayed_work(hw, &sc->hw_pll_work, HZ/2);
+
 out:
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
@@ -923,6 +925,8 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	int r;
 
 	ath9k_ps_wakeup(sc);
+	cancel_delayed_work_sync(&sc->hw_pll_work);
+
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	ieee80211_stop_queues(hw);
-- 
1.6.3.3

