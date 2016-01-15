Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [195.130.137.88] ([195.130.137.88]:34192 "EHLO
	michel.telenet-ops.be" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbcAONlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 08:41:53 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] ath9k: Drop useless const on chanctx_event_delta() return type
Date: Fri, 15 Jan 2016 14:41:30 +0100
Message-Id: <1452865290-32314-1-git-send-email-geert@linux-m68k.org> (sfid-20160115_144233_794802_3798A50E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath9k/channel.c:230: warning: type qualifiers ignored on function return type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 50e614b915f1b1b5..7c452af6da39605a 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -226,7 +226,7 @@ static const char *chanctx_state_string(enum ath_chanctx_state state)
 	}
 }
 
-static const u32 chanctx_event_delta(struct ath_softc *sc)
+static u32 chanctx_event_delta(struct ath_softc *sc)
 {
 	u64 ms;
 	struct timespec ts, *old;
-- 
1.9.1

