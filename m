Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42839 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaJIIMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:12:05 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 4/5] ath9k: Fix offchannel flush timeout
Date: Thu,  9 Oct 2014 13:42:51 +0530
Message-Id: <1412842372-17628-5-git-send-email-sujith@msujith.org> (sfid-20141009_101219_290949_5E0604BD)
In-Reply-To: <1412842372-17628-1-git-send-email-sujith@msujith.org>
References: <1412842372-17628-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

An offchannel operation also needs to have
a flush timeout that doesn't exceed the NoA
absence duration of a GO context, so use
channel_switch_time. The first offchannel
operation is set a flush timeout of 10ms since
channel_switch_time will be zero.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 7e518aa..abc3e2e 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -207,6 +207,26 @@ void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 	if (!ctx)
 		return;
 
+	if (ctx == &sc->offchannel.chan) {
+		spin_lock_bh(&sc->chan_lock);
+
+		if (likely(sc->sched.channel_switch_time))
+			ctx->flush_timeout =
+				usecs_to_jiffies(sc->sched.channel_switch_time);
+		else
+			ctx->flush_timeout =
+				msecs_to_jiffies(10);
+
+		spin_unlock_bh(&sc->chan_lock);
+
+		/*
+		 * There is no need to iterate over the
+		 * active/assigned channel contexts if
+		 * the current context is offchannel.
+		 */
+		return;
+	}
+
 	ictx = ctx;
 
 	list_for_each_entry(avp, &ctx->vifs, list) {
-- 
2.1.2

