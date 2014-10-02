Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42618 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaJBBCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 21:02:47 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 02/10] ath9k: Print RoC expiration
Date: Thu,  2 Oct 2014 06:33:12 +0530
Message-Id: <1412211800-24344-3-git-send-email-sujith@msujith.org> (sfid-20141002_030249_801290_728CD180)
In-Reply-To: <1412211800-24344-1-git-send-email-sujith@msujith.org>
References: <1412211800-24344-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index b93f83c..d088f06 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -761,6 +761,13 @@ void ath_offchannel_next(struct ath_softc *sc)
 
 void ath_roc_complete(struct ath_softc *sc, bool abort)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	if (abort)
+		ath_dbg(common, CHAN_CTX, "RoC aborted\n");
+	else
+		ath_dbg(common, CHAN_CTX, "RoC expired\n");
+
 	sc->offchannel.roc_vif = NULL;
 	sc->offchannel.roc_chan = NULL;
 	if (!abort)
-- 
2.1.1

