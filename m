Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.resortinternet.net ([65.114.208.136]:58093 "EHLO
	smtp.resortinternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab1AKAU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 19:20:56 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 3/4] ath9k: reinitialize block ack window data when starting aggregation
Date: Mon, 10 Jan 2011 17:05:49 -0700
Message-Id: <1294704350-50621-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1294704350-50621-2-git-send-email-nbd@openwrt.org>
References: <1294704350-50621-1-git-send-email-nbd@openwrt.org>
 <1294704350-50621-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There might be some old stale data left, which could confuse tracking
of pending tx frames.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6ddba4b..ab4f7b4 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -858,6 +858,9 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	txtid->paused = true;
 	*ssn = txtid->seq_start = txtid->seq_next;
 
+	memset(txtid->tx_buf, 0, sizeof(txtid->tx_buf));
+	txtid->baw_head = txtid->baw_tail = 0;
+
 	return 0;
 }
 
-- 
1.7.3.2

