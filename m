Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.resortinternet.net ([65.114.208.136]:42873 "EHLO
	smtp.resortinternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab1AKAVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 19:21:11 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 2/4] ath9k: fix initial sequence number after starting an ampdu session
Date: Mon, 10 Jan 2011 17:05:48 -0700
Message-Id: <1294704350-50621-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1294704350-50621-1-git-send-email-nbd@openwrt.org>
References: <1294704350-50621-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

txtid->seq_start may not always be up to date, when there is HT non-AMPDU
traffic just before starting an AMPDU session. Relying on txtid->seq_next
is better, since it is also used to generate the sequence numbers for
all QoS data frames.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 1adfebc..6ddba4b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -856,7 +856,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 
 	txtid->state |= AGGR_ADDBA_PROGRESS;
 	txtid->paused = true;
-	*ssn = txtid->seq_start;
+	*ssn = txtid->seq_start = txtid->seq_next;
 
 	return 0;
 }
-- 
1.7.3.2

