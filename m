Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3429 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab1EIOdp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:45 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/10] staging: brcm80211: fix checkpatch issue
 introduced in dhd_sdio.c
Date: Mon, 9 May 2011 16:33:28 +0200
Message-ID: <1304951609-2493-9-git-send-email-arend@broadcom.com> (sfid-20110509_163741_966913_B680A0CC)
In-Reply-To: <1304951609-2493-1-git-send-email-arend@broadcom.com>
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch "[2349e278] move utility functions into new module" introduced
a checkpatch warning which is resolved with this patch.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 9167ebc..8683eeb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -3690,8 +3690,11 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				} else {
 					/* Give up on data,
 					request rtx of events */
-					DHD_ERROR(("%s (nextlen): bcm_pkt_buf_get_skb failed: len %d rdlen %d " "expected rxseq %d\n",
-						__func__, len, rdlen, rxseq));
+					DHD_ERROR(("%s (nextlen): "
+						   "bcm_pkt_buf_get_skb failed:"
+						   " len %d rdlen %d expected"
+						   " rxseq %d\n", __func__,
+						   len, rdlen, rxseq));
 					/* Just go try again w/normal
 					header read */
 					dhd_os_sdunlock_rxq(bus->dhd);
-- 
1.7.4.1


