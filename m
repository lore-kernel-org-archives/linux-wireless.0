Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48067 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755821Ab0KNOUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:22 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 11/13] ath9k: block new AMPDU sessions if SC_OP_TXAGGR is not set
Date: Sun, 14 Nov 2010 15:20:11 +0100
Message-Id: <1289744413-20789-11-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-10-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
 <1289744413-20789-4-git-send-email-nbd@openwrt.org>
 <1289744413-20789-5-git-send-email-nbd@openwrt.org>
 <1289744413-20789-6-git-send-email-nbd@openwrt.org>
 <1289744413-20789-7-git-send-email-nbd@openwrt.org>
 <1289744413-20789-8-git-send-email-nbd@openwrt.org>
 <1289744413-20789-9-git-send-email-nbd@openwrt.org>
 <1289744413-20789-10-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes further tx path cleanups easier

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8464ca3..50bdb5d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1992,6 +1992,9 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		break;
 	case IEEE80211_AMPDU_TX_START:
+		if (!(sc->sc_flags & SC_OP_TXAGGR))
+			return -EOPNOTSUPP;
+
 		ath9k_ps_wakeup(sc);
 		ret = ath_tx_aggr_start(sc, sta, tid, ssn);
 		if (!ret)
-- 
1.7.3.2

