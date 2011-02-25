Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:58244 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab1BYMBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 07:01:20 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 04:00:59 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k: Fix compilation warning.
Date: Fri, 25 Feb 2011 17:31:03 +0530
Message-ID: <1298635263-4883-3-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1298635263-4883-2-git-send-email-vnatarajan@atheros.com>
References: <1298635263-4883-1-git-send-email-vnatarajan@atheros.com>
 <1298635263-4883-2-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize txq to avoid this warning:

drivers/net/wireless/ath/ath9k/main.c: In function ‘ath9k_flush’:
drivers/net/wireless/ath/ath9k/main.c:2138: warning: ‘txq’ may be used uninitialized in this function

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9b03b5a..238fb76 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2135,7 +2135,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 {
 #define ATH_FLUSH_TIMEOUT	60 /* ms */
 	struct ath_softc *sc = hw->priv;
-	struct ath_txq *txq;
+	struct ath_txq *txq = NULL;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	int i, j, npend = 0;
-- 
1.6.3.3

