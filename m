Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:40204 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752538AbYAIJQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 04:16:11 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 4/6] ath5k: centrally define TSF to TU conversion macro
Date: Wed,  9 Jan 2008 18:16:07 +0900
Message-Id: <1199870169-10476-5-git-send-email-bruno@thinktube.com> (sfid-20080109_091627_599680_20E8AE51)
In-Reply-To: <1199870169-10476-4-git-send-email-bruno@thinktube.com>
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
 <1199870169-10476-2-git-send-email-bruno@thinktube.com>
 <1199870169-10476-3-git-send-email-bruno@thinktube.com>
 <1199870169-10476-4-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

centrally define TSF_TO_TO macro for TSF to TU conversion and use it in all
instances. there will be more usage for this later.

ath5k.h: Changes-licensed-under: ISC
all others: Changes-licensed-under: 3-clause-BSD
Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    9 +++++++++
 drivers/net/wireless/ath5k/base.c  |    4 +---
 drivers/net/wireless/ath5k/debug.c |    2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 0b6694b..52787ea 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -482,6 +482,15 @@ struct ath5k_beacon_state {
 #endif
 
 
+/*
+ * TSF to TU conversion:
+ *
+ * TSF is a 64bit value in usec (microseconds).
+ * TU is a 32bit value in roughly msec (milliseconds): usec / 1024
+ * (1000ms equals 976 TU)
+ */
+#define TSF_TO_TU(_tsf) (u32)((_tsf) >> 10)
+
 
 
 /********************\
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 8d5ffcd..30b16fd 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1989,7 +1989,6 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 static void
 ath5k_beacon_config(struct ath5k_softc *sc)
 {
-#define TSF_TO_TU(_h, _l)	(((_h) << 22) | ((_l) >> 10))
 	struct ath5k_hw *ah = sc->ah;
 	u32 uninitialized_var(nexttbtt), intval, tsftu;
 	u64 tsf;
@@ -2000,7 +1999,7 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 
 	/* current TSF converted to TU */
 	tsf = ath5k_hw_get_tsf64(ah);
-	tsftu = TSF_TO_TU((u32)(tsf >> 32), (u32)tsf);
+	tsftu = TSF_TO_TU(tsf);
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "intval %u hw tsftu %u\n",
 		intval, tsftu);
@@ -2051,7 +2050,6 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 				ath5k_hw_hasveol(ah))
 			ath5k_beacon_send(sc);
 	}
-#undef TSF_TO_TU
 }
 
 /********************\
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index fcdd36e..4ba649e 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -266,7 +266,7 @@ static ssize_t read_file_beacon(struct file *file, char __user *user_buf,
 
 	tsf = ath5k_hw_get_tsf64(sc->ah);
 	len += snprintf(buf+len, sizeof(buf)-len,
-		"TSF\t\t0x%016llx\tTU: %08x\n", tsf, (u32)(tsf >> 10));
+		"TSF\t\t0x%016llx\tTU: %08x\n", tsf, TSF_TO_TU(tsf));
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
-- 
1.5.3.4

