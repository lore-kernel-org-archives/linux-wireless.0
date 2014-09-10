Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56611 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaIJHS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 03:18:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [RFC 3/5] ath9k: Clear offchannel duration properly
Date: Wed, 10 Sep 2014 12:48:46 +0530
Message-Id: <1410333528-28022-4-git-send-email-sujith@msujith.org> (sfid-20140910_091831_282383_4E99E4E0)
In-Reply-To: <1410333528-28022-1-git-send-email-sujith@msujith.org>
References: <1410333528-28022-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Clearing the offchannel duration value in the
scheduler unconditionally breaks NoA when
multiple contexts are active and an offchannel
request is deferred, for example, in a scan run.

Fix this by clearing the duration only if there
is no pending offchannel request.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index ab3d29d..09ff8a6 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1065,7 +1065,10 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 	sc->cur_chan = sc->next_chan;
 	sc->cur_chan->stopped = false;
 	sc->next_chan = NULL;
-	sc->sched.offchannel_duration = 0;
+
+	if (!sc->sched.offchannel_pending)
+		sc->sched.offchannel_duration = 0;
+
 	if (sc->sched.state != ATH_CHANCTX_STATE_FORCE_ACTIVE)
 		sc->sched.state = ATH_CHANCTX_STATE_IDLE;
 
-- 
2.1.0

