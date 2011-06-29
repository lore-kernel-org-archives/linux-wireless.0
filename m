Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1909 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab1F2Xsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 031/119] staging: brcm80211: remove unnecessary null
 check
Date: Wed, 29 Jun 2011 16:46:55 -0700
Message-ID: <1309391303-22741-32-git-send-email-frankyl@broadcom.com> (sfid-20110630_014907_422964_A1B46003)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

kfree(NULL) is safe, and the rest of the cleanup should be done regardless
to make sure the state is consistent.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 48550f3..0fae0b1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -5567,11 +5567,9 @@ static void dhdsdio_release_malloc(dhd_bus_t *bus)
 	if (bus->dhd && bus->dhd->dongle_reset)
 		return;
 
-	if (bus->rxbuf) {
-		kfree(bus->rxbuf);
-		bus->rxctl = bus->rxbuf = NULL;
-		bus->rxlen = 0;
-	}
+	kfree(bus->rxbuf);
+	bus->rxctl = bus->rxbuf = NULL;
+	bus->rxlen = 0;
 
 	kfree(bus->databuf);
 	bus->databuf = NULL;
-- 
1.7.1


