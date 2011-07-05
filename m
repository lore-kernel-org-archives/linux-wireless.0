Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2950 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1GEWDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 25/31] staging: brcm80211: removed #ifdef
 SDIOH_API_ACCESS_RETRY_LIMIT
Date: Wed, 6 Jul 2011 00:02:52 +0200
Message-ID: <1309903378-29021-26-git-send-email-arend@broadcom.com> (sfid-20110706_000337_586602_3605D03E)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

SDIOH_API_ACCESS_RETRY_LIMIT is always defined.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index c9e20e1..f4e72ed 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -189,26 +189,20 @@ u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 			 int *err)
 {
 	int status;
-#ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
-#endif
 	u8 data = 0;
 
 	if (!card)
 		card = l_card;
 
-#ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	do {
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
-#endif
 		status =
 		    brcmf_sdioh_cfg_read(card->sdioh, fnc_num, addr,
 				   (u8 *) &data);
-#ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
-#endif
 	if (err)
 		*err = status;
 
@@ -223,25 +217,19 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 		       u8 data, int *err)
 {
 	int status;
-#ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
-#endif
 
 	if (!card)
 		card = l_card;
 
-#ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	do {
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
-#endif
 		status =
 		    brcmf_sdioh_cfg_write(card->sdioh, fnc_num, addr,
 				    (u8 *) &data);
-#ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
-#endif
 	if (err)
 		*err = status;
 
-- 
1.7.4.1


