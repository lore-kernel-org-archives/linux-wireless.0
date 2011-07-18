Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4232 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1GROaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 10:30:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Franky Lin" <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/19] staging: brcm80211: remove global wait queue head
 sdioh_spinwait_sleep
Date: Mon, 18 Jul 2011 16:29:57 +0200
Message-ID: <1310999405-10062-12-git-send-email-arend@broadcom.com> (sfid-20110718_163053_413054_0C10940E)
In-Reply-To: <1310999405-10062-1-git-send-email-arend@broadcom.com>
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove global wait queue head sdioh_spinwait_sleep in fullmac.

Cc: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h      |   22 ----------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   21 +++++++++++----------
 2 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 9afd9ff..3c950cc 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -619,28 +619,6 @@ struct bcmevent_name {
 	const char *name;
 };
 
-#if defined(CONFIG_PM_SLEEP)
-#define BRCMF_SPINWAIT_SLEEP_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
-#define BRCMF_SPINWAIT_SLEEP(a, exp, us) do { \
-		uint countdown = (us) + 9999; \
-		while ((exp) && (countdown >= 10000)) { \
-			wait_event_timeout(a, false, HZ/100); \
-			countdown -= 10000; \
-		} \
-	} while (0)
-
-#else
-#define BRCMF_SPINWAIT_SLEEP_INIT(a)
-#define BRCMF_SPINWAIT_SLEEP(a, exp, us)  do { \
-		uint countdown = (us) + 9; \
-		while ((exp) && (countdown >= 10)) { \
-			udelay(10);  \
-			countdown -= 10;  \
-		} \
-	} while (0)
-
-#endif	/* defined(CONFIG_PM_SLEEP) */
-
 /*
  * Insmod parameters for debug/test
  */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 7a0d036..e9806c3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -444,8 +444,6 @@ struct rte_console {
 	(((prio) == PRIO_8021D_NONE || (prio) == PRIO_8021D_BE) ? \
 	((prio^2)) : (prio))
 
-BRCMF_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
-
 /*
  * Core reg address translation.
  * Both macro's returns a 32 bits byte address on the backplane bus.
@@ -1033,6 +1031,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 	int err;
 	u8 clkctl, clkreq, devctl;
 	struct brcmf_sdio_card *card;
+	unsigned long timeout;
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
@@ -1102,14 +1101,16 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		}
 
 		/* Otherwise, wait here (polling) for HT Avail */
-		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			BRCMF_SPINWAIT_SLEEP(sdioh_spinwait_sleep,
-			       ((clkctl =
-				 brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
-					 SBSDIO_FUNC1_CHIPCLKCSR,
-						 &err)),
-				!SBSDIO_CLKAV(clkctl, bus->alp_only)),
-			       PMU_MAX_TRANSITION_DLY);
+		timeout = jiffies +
+			  msecs_to_jiffies(PMU_MAX_TRANSITION_DLY/1000);
+		while (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
+			clkctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+						       SBSDIO_FUNC1_CHIPCLKCSR,
+						       &err);
+			if (time_after(jiffies, timeout))
+				break;
+			else
+				usleep_range(5000, 10000);
 		}
 		if (err) {
 			BRCMF_ERROR(("%s: HT Avail request error: %d\n",
-- 
1.7.4.1


