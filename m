Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34239 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbaH0GhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 02:37:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/4] ath9k: Disable fastcc for channel context mode
Date: Wed, 27 Aug 2014 12:07:23 +0530
Message-Id: <1409121445-11484-3-git-send-email-sujith@msujith.org> (sfid-20140827_083755_996212_B818D1CA)
In-Reply-To: <1409121445-11484-1-git-send-email-sujith@msujith.org>
References: <1409121445-11484-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2fcafa6..b823b5a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -303,6 +303,9 @@ int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 	if (!ath_prepare_reset(sc))
 		fastcc = false;
 
+	if (ath9k_is_chanctx_enabled())
+		fastcc = false;
+
 	spin_lock_bh(&sc->chan_lock);
 	sc->cur_chandef = sc->cur_chan->chandef;
 	spin_unlock_bh(&sc->chan_lock);
-- 
2.1.0

