Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1173 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958Ab1JDVTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:36 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/26] staging: brcm80211: remove fullmac module_param
 for intr/poll mode
Date: Tue, 4 Oct 2011 23:18:54 +0200
Message-ID: <1317763152-17607-9-git-send-email-arend@broadcom.com> (sfid-20111004_231943_072624_ABDF58F7)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use constant for interrupt/polling mode configuration.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 5423280..6c2391b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -725,14 +725,6 @@ module_param(brcmf_dpc_prio, int, 0);
 
 #define SDIO_DRIVE_STRENGTH	6	/* in milliamps */
 
-/* Use polling */
-uint brcmf_poll;
-module_param(brcmf_poll, uint, 0);
-
-/* Use interrupts */
-uint brcmf_intr = true;
-module_param(brcmf_intr, uint, 0);
-
 #define RETRYCHAN(chan) ((chan) == SDPCM_EVENT_CHANNEL)
 
 /* Retry count for register access failures */
@@ -4324,8 +4316,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 				    BRCMF_SDALIGN);
 
 	/* Set the poll and/or interrupt flags */
-	bus->intr = (bool) brcmf_intr;
-	bus->poll = (bool) brcmf_poll;
+	bus->intr = true;
+	bus->poll = false;
 	if (bus->poll)
 		bus->pollrate = 1;
 
-- 
1.7.4.1


