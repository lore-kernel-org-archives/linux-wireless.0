Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1450 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 27/31] staging: brcm80211: remove several externs from
 dhd_linux.c
Date: Wed, 6 Jul 2011 00:02:54 +0200
Message-ID: <1309903378-29021-28-git-send-email-arend@broadcom.com> (sfid-20110706_000355_890875_0AFB8091)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The script checkpatch.pl flagged for some extern variables in
dhd_linux.c source. Several have been fixed in this patch. Two
remaining are in macro conditional code that needs cleanup so
they are not resolved here.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h   |    7 +++++++
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    3 ---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index a94152e..653cf0d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -29,6 +29,13 @@
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
 
+/* dongle ram module parameter */
+extern int brcmf_dongle_memsize;
+
+/* Tx/Rx bounds module parameters */
+extern uint brcmf_txbound;
+extern uint brcmf_rxbound;
+
 /* Watchdog timer interval */
 extern uint brcmf_watchdog_ms;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 43a5b14..380447f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -113,7 +113,6 @@ module_param(brcmf_pkt_filter_init, uint, 0);
 uint brcmf_master_mode = true;
 module_param(brcmf_master_mode, uint, 1);
 
-extern int brcmf_dongle_memsize;
 module_param(brcmf_dongle_memsize, int, 0);
 
 /* Contorl fw roaming */
@@ -148,8 +147,6 @@ uint brcmf_sdiod_drive_strength = 6;
 module_param(brcmf_sdiod_drive_strength, uint, 0);
 
 /* Tx/Rx bounds */
-extern uint brcmf_txbound;
-extern uint brcmf_rxbound;
 module_param(brcmf_txbound, uint, 0);
 module_param(brcmf_rxbound, uint, 0);
 
-- 
1.7.4.1


