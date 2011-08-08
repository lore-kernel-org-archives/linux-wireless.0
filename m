Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2809 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab1HHN70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 34/82] staging: brcm80211: remove volatile keyword
 used in struct rte_console
Date: Mon, 8 Aug 2011 15:58:18 +0200
Message-ID: <1312811946-16713-35-git-send-email-arend@broadcom.com> (sfid-20110808_160232_447578_769E8E32)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two members vcons_in and vcons_out were declared using the volatile
keyword. However, there is no reason for doing so. The member is
used only to calculate the backplane address to access using offsetof.
This address is passed to subsequent read function. Use of volatile
is not warranted.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index eb6d78e..8576e33 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -126,8 +126,8 @@ struct rte_console {
 	 * (at risk of conflicting with
 	 * the real UART).  vcons_out is currently unused.
 	 */
-	volatile uint vcons_in;
-	volatile uint vcons_out;
+	uint vcons_in;
+	uint vcons_out;
 
 	/* Output (logging) buffer
 	 * Console output is written to a ring buffer log_buf at index log_idx.
-- 
1.7.4.1


