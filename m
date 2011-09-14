Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58751 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726Ab1INTYf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:35 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 10/12] ath9k: remove a redundant check in ath_tx_form_aggr
Date: Wed, 14 Sep 2011 21:24:25 +0200
Message-Id: <1316028267-34187-10-git-send-email-nbd@openwrt.org> (sfid-20110914_212454_929965_9DAD8B26)
In-Reply-To: <1316028267-34187-9-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
 <1316028267-34187-3-git-send-email-nbd@openwrt.org>
 <1316028267-34187-4-git-send-email-nbd@openwrt.org>
 <1316028267-34187-5-git-send-email-nbd@openwrt.org>
 <1316028267-34187-6-git-send-email-nbd@openwrt.org>
 <1316028267-34187-7-git-send-email-nbd@openwrt.org>
 <1316028267-34187-8-git-send-email-nbd@openwrt.org>
 <1316028267-34187-9-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_lookup_legacy now checks all the tx rate flags for MCS vs legacy

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7f8191e..634a29a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -790,8 +790,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		}
 
 		tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
-		if (nframes && ((tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) ||
-			!(tx_info->control.rates[0].flags & IEEE80211_TX_RC_MCS)))
+		if (nframes && (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE))
 			break;
 
 		/* do not exceed subframe limit */
-- 
1.7.3.2

