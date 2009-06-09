Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53305 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758891AbZFIKEb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 06:04:31 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 03:04:34 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix tx stuck when connected to aggr disabled HT AP
Date: Tue, 9 Jun 2009 15:28:21 +0530
Message-ID: <1244541501-6446-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch along with my previous patch in mac80211 "Fix the
way ADDBA count..", fixes hang in tx when connected to an HT
AP which rejects/times out on addba req.

AGGR_ADDBA_PROGRESS should be cleared in aggr state when addba
negotiation is terminated due to either addba response is timed out
or addba is denied by the AP. With out clearing this bit,
all frames are queued onto s/w queue for getting tx'd as aggr and
will never be scheduled onto hw queue.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a8def4f..b61a071 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -711,6 +711,7 @@ int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 		return 0;
 
 	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
+		txtid->state &= ~AGGR_ADDBA_PROGRESS;
 		txtid->addba_exchangeattempts = 0;
 		return 0;
 	}
-- 
1.5.5.1

