Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39855 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaIJHSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 03:18:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [RFC 4/5] ath9k: Fix channel switch time duration
Date: Wed, 10 Sep 2014 12:48:47 +0530
Message-Id: <1410333528-28022-5-git-send-email-sujith@msujith.org> (sfid-20140910_091838_385991_02CE6745)
In-Reply-To: <1410333528-28022-1-git-send-email-sujith@msujith.org>
References: <1410333528-28022-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since the NoA duration is the maximum time the GO interface
can be offline, it needs to include the time take to
switch channels in the HW.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 09ff8a6..a42fd85 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -419,7 +419,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			avp->noa_index++;
 			avp->noa_start = tsf_time;
 			avp->noa_duration =
-				TU_TO_USEC(cur_conf->beacon_interval) / 2 -
+				TU_TO_USEC(cur_conf->beacon_interval) / 2 +
 				sc->sched.channel_switch_time;
 
 			if (test_bit(ATH_OP_SCANNING, &common->op_flags))
-- 
2.1.0

