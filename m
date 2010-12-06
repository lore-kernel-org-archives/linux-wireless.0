Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33590 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0LFVTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 16:19:02 -0500
Received: by vws16 with SMTP id 16so2941922vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 13:19:01 -0800 (PST)
From: greearb@gmail.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Make DMA warning in ath_stoprecv WARN_ON_ONCE.
Date: Mon,  6 Dec 2010 13:13:07 -0800
Message-Id: <1291669987-23434-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This decreases spammage in the log.  A single line message
will still be printed, so users can be aware that problem
exists.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 b4417d2... 082b16d... M	drivers/net/wireless/ath/ath9k/recv.c
:100644 100644 f207007... 10cf682... M	drivers/net/wireless/ath/debug.h
 drivers/net/wireless/ath/ath9k/recv.c |    8 ++++++--
 drivers/net/wireless/ath/debug.h      |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b4417d2..082b16d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -527,8 +527,12 @@ bool ath_stoprecv(struct ath_softc *sc)
 		sc->rx.rxlink = NULL;
 	spin_unlock_bh(&sc->rx.rxbuflock);
 
-	ATH_DBG_WARN(!stopped, "Could not stop RX, we could be "
-		     "confusing the DMA engine when we start RX up\n");
+	if (unlikely(!stopped)) {
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "Could not stop RX, we could be "
+			  "confusing the DMA engine when we start RX up\n");
+		ATH_DBG_WARN_ON_ONCE(!stopped);
+	}
 	return stopped;
 }
 
diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
index f207007..10cf682 100644
--- a/drivers/net/wireless/ath/debug.h
+++ b/drivers/net/wireless/ath/debug.h
@@ -71,12 +71,14 @@ enum ATH_DEBUG {
 void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 #define ATH_DBG_WARN(foo, arg...) WARN(foo, arg)
+#define ATH_DBG_WARN_ON_ONCE(foo) WARN_ON_ONCE(foo)
 #else
 static inline void __attribute__ ((format (printf, 3, 4)))
 ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 {
 }
 #define ATH_DBG_WARN(foo, arg)
+#define ATH_DBG_WARN_ON_ONCE(foo)
 #endif /* CONFIG_ATH_DEBUG */
 
 /** Returns string describing opmode, or NULL if unknown mode. */
-- 
1.7.2.3

