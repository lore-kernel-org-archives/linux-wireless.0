Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2398 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/26] staging: brcm80211: made NULL ethernet address
 const
Date: Tue, 4 Oct 2011 23:18:59 +0200
Message-ID: <1317763152-17607-14-git-send-email-arend@broadcom.com> (sfid-20111004_232009_337930_5C2C3093)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index dc95ba0..6a0a5d0 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -2646,7 +2646,7 @@ static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 
 static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
 {
-	u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
+	const u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
 
 	if (on) {
 		/* suspend tx fifos */
-- 
1.7.4.1


