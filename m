Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33230 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbbK0Ih0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:26 -0500
Received: by lfaz4 with SMTP id z4so121313988lfa.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:25 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 02/13] ath9k: print real timer value
Date: Fri, 27 Nov 2015 09:37:07 +0100
Message-Id: <1448613438-5173-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_093733_069365_4707F8B8)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of low HZ before this patch we saw wrong
values in debug message. Print real timeout value.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 35802c9..dddaaea 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -356,14 +356,16 @@ static void ath_chanctx_setup_timer(struct ath_softc *sc, u32 tsf_time)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_hw *ah = sc->sc_ah;
+	unsigned long timeout;
 
 	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, tsf_time, 1000000);
 	tsf_time -= ath9k_hw_gettsf32(ah);
-	tsf_time = msecs_to_jiffies(tsf_time / 1000) + 1;
-	mod_timer(&sc->sched.timer, jiffies + tsf_time);
+	timeout = msecs_to_jiffies(tsf_time / 1000) + 1;
+	mod_timer(&sc->sched.timer, jiffies + timeout);
 
 	ath_dbg(common, CHAN_CTX,
-		"Setup chanctx timer with timeout: %d ms\n", jiffies_to_msecs(tsf_time));
+		"Setup chanctx timer with timeout: %d (%d) ms\n",
+		tsf_time / 1000, jiffies_to_msecs(timeout));
 }
 
 static void ath_chanctx_handle_bmiss(struct ath_softc *sc,
-- 
1.9.1

