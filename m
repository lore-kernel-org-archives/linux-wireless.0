Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51279 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaIACA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2014 22:00:29 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Fix NoA start time calculation
Date: Mon,  1 Sep 2014 07:30:41 +0530
Message-Id: <1409536841-19600-1-git-send-email-sujith@msujith.org> (sfid-20140901_040056_429400_66C1DF45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The start time field in the NoA attribute needs to be
updated based on the TSF timer when an absence notification
is sent by the P2P GO. When two channel contexts are active,
continuous, cyclic NoA is announced by setting the count value to 255,
but the start time is updated only once, for one beacon and
the same value is sent in all subsequent beacons, even
though the timestamp keeps moving.

Fix this by removing the check for 'periodic_noa_duration'
and assign the interface's start_time/duration values directly
when there is more than one active context.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 409f912..047a76f 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -377,13 +377,13 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		    tsf_time - avp->periodic_noa_start > BIT(30))
 			avp->periodic_noa_duration = 0;
 
-		if (ctx->active && !avp->periodic_noa_duration) {
+		if (ctx->active) {
 			avp->periodic_noa_start = tsf_time;
 			avp->periodic_noa_duration =
 				TU_TO_USEC(cur_conf->beacon_interval) / 2 -
 				sc->sched.channel_switch_time;
 			noa_changed = true;
-		} else if (!ctx->active && avp->periodic_noa_duration) {
+		} else if (!ctx->active) {
 			avp->periodic_noa_duration = 0;
 			noa_changed = true;
 		}
-- 
2.1.0

