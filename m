Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34786 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbZHCTZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:00 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:01 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/24] ath9k: propagate hw initialization errors
Date: Mon, 3 Aug 2009 12:24:35 -0700
Message-ID: <1249327496-24629-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were never propagating hw initialization errors, lets
do that now and also use -EOPNOTSUPP when device revision is
not supported yet.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8228f41..2e09204 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1223,7 +1223,7 @@ struct ath_hw *ath9k_hw_attach(u16 devid, struct ath_softc *sc, int *error)
 		ah = ath9k_hw_do_attach(devid, sc, error);
 		break;
 	default:
-		*error = -ENXIO;
+		*error = -EOPNOTSUPP;
 		break;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 292ac2b..ada5fef 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1295,7 +1295,6 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 static int ath_init(u16 devid, struct ath_softc *sc)
 {
 	struct ath_hw *ah = NULL;
-	int status;
 	int error = 0, i;
 	int csz = 0;
 
@@ -1323,11 +1322,11 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	/* XXX assert csz is non-zero */
 	sc->cachelsz = csz << 2;	/* convert to bytes */
 
-	ah = ath9k_hw_attach(devid, sc, &status);
+	ah = ath9k_hw_attach(devid, sc, &error);
 	if (ah == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to attach hardware; HAL status %d\n", status);
-		error = -ENXIO;
+			"Unable to attach hardware; "
+			"initialization status: %d\n", error);
 		goto bad;
 	}
 	sc->sc_ah = ah;
-- 
1.6.3.3

