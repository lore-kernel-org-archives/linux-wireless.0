Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4307 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab1GNVaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:30:03 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 34/35] staging: brcm80211: remove volatile keyword used
 in struct rte_console
Date: Thu, 14 Jul 2011 14:29:30 -0700
Message-ID: <1310678971-28952-35-git-send-email-frankyl@broadcom.com> (sfid-20110714_233054_305476_925213D4)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

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
index 3e7d5b2..8cb34d6 100644
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
1.7.1


