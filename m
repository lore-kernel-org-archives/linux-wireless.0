Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4184 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab1GNV3z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:55 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 30/35] staging: brcm80211: move sdio related variables
 to dhd_sdio.c
Date: Thu, 14 Jul 2011 14:29:26 -0700
Message-ID: <1310678971-28952-31-git-send-email-frankyl@broadcom.com> (sfid-20110714_233309_734184_1AC2BEED)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In fullmac some variables are used by sdio layer declared in
dhd_linux.c. Move them to dhd_sdio.c for clean up.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |   13 -------------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   22 ----------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   18 ++++++++++++++++++
 3 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 537eb00..1f203fb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -669,12 +669,6 @@ extern atomic_t brcmf_mmc_suspend;
  * Insmod parameters for debug/test
  */
 
-/* Use interrupts */
-extern uint brcmf_intr;
-
-/* Use polling */
-extern uint brcmf_poll;
-
 /* ARP offload agent mode */
 extern uint brcmf_arp_mode;
 
@@ -696,13 +690,6 @@ extern uint brcmf_roam;
 /* Roaming mode control */
 extern uint brcmf_radio_up;
 
-/* Initial idletime ticks (may be -1 for immediate idle, 0 for no idle) */
-extern int brcmf_idletime;
-#define BRCMF_IDLETIME_TICKS 1
-
-/* SDIO Drive Strength */
-extern uint brcmf_sdiod_drive_strength;
-
 /* Override to force tx queueing all the time */
 extern uint brcmf_force_tx_queueing;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 9c79e05..94bcf2d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -114,8 +114,6 @@ module_param(brcmf_pkt_filter_init, uint, 0);
 uint brcmf_master_mode = true;
 module_param(brcmf_master_mode, uint, 0);
 
-module_param(brcmf_dongle_memsize, int, 0);
-
 /* Contorl fw roaming */
 uint brcmf_roam = 1;
 
@@ -131,26 +129,6 @@ module_param_string(iface_name, iface_name, IFNAMSIZ, 0);
 /* IOCTL response timeout */
 int brcmf_ioctl_timeout_msec = IOCTL_RESP_TIMEOUT;
 
-/* Idle timeout for backplane clock */
-int brcmf_idletime = BRCMF_IDLETIME_TICKS;
-module_param(brcmf_idletime, int, 0);
-
-/* Use polling */
-uint brcmf_poll;
-module_param(brcmf_poll, uint, 0);
-
-/* Use interrupts */
-uint brcmf_intr = true;
-module_param(brcmf_intr, uint, 0);
-
-/* SDIO Drive Strength (in milliamps) */
-uint brcmf_sdiod_drive_strength = 6;
-module_param(brcmf_sdiod_drive_strength, uint, 0);
-
-/* Tx/Rx bounds */
-module_param(brcmf_txbound, uint, 0);
-module_param(brcmf_rxbound, uint, 0);
-
 #ifdef SDTEST
 /* Echo packet generator (pkts/s) */
 uint brcmf_pktgen;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 705b57c..2f33f37 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -838,11 +838,29 @@ module_param(brcmf_console_ms, uint, 0);
 /* Tx/Rx bounds */
 uint brcmf_txbound;
 uint brcmf_rxbound;
+module_param(brcmf_txbound, uint, 0);
+module_param(brcmf_rxbound, uint, 0);
 uint brcmf_txminmax;
 
+int brcmf_idletime = 1;
+module_param(brcmf_idletime, int, 0);
+
+/* SDIO Drive Strength (in milliamps) */
+uint brcmf_sdiod_drive_strength = 6;
+module_param(brcmf_sdiod_drive_strength, uint, 0);
+
+/* Use polling */
+uint brcmf_poll;
+module_param(brcmf_poll, uint, 0);
+
+/* Use interrupts */
+uint brcmf_intr = true;
+module_param(brcmf_intr, uint, 0);
+
 /* override the RAM size if possible */
 #define DONGLE_MIN_MEMSIZE (128 * 1024)
 int brcmf_dongle_memsize;
+module_param(brcmf_dongle_memsize, int, 0);
 
 static bool brcmf_alignctl;
 
-- 
1.7.1


