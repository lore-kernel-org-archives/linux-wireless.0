Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2950 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab1GEWDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/31] staging: brcm80211: removed asserts from bcmsdh.c
Date: Wed, 6 Jul 2011 00:02:33 +0200
Message-ID: <1309903378-29021-7-git-send-email-arend@broadcom.com> (sfid-20110706_000418_877936_B931D819)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c |   36 ---------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index cecb291..97c0f9d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -119,30 +119,22 @@ brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 
 int brcmf_sdcard_intr_enable(struct brcmf_sdio_card *card)
 {
-	ASSERT(card);
-
 	return brcmf_sdioh_interrupt_set(card->sdioh, true);
 }
 
 int brcmf_sdcard_intr_disable(struct brcmf_sdio_card *card)
 {
-	ASSERT(card);
-
 	return brcmf_sdioh_interrupt_set(card->sdioh, false);
 }
 
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card,
 			  void (*fn)(void *), void *argh)
 {
-	ASSERT(card);
-
 	return brcmf_sdioh_interrupt_register(card->sdioh, fn, argh);
 }
 
 int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card)
 {
-	ASSERT(card);
-
 	return brcmf_sdioh_interrupt_deregister(card->sdioh);
 }
 
@@ -158,8 +150,6 @@ u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 	if (!card)
 		card = l_card;
 
-	ASSERT(card->init_success);
-
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	do {
 		if (retry)	/* wait for 1 ms till bus get settled down */
@@ -193,8 +183,6 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 	if (!card)
 		card = l_card;
 
-	ASSERT(card->init_success);
-
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	do {
 		if (retry)	/* wait for 1 ms till bus get settled down */
@@ -223,8 +211,6 @@ u32 brcmf_sdcard_cfg_read_word(struct brcmf_sdio_card *card, uint fnc_num,
 	if (!card)
 		card = l_card;
 
-	ASSERT(card->init_success);
-
 	status = brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
 		SDIOH_READ, fnc_num, addr, &data, 4);
 
@@ -246,8 +232,6 @@ brcmf_sdcard_cfg_write_word(struct brcmf_sdio_card *card, uint fnc_num,
 	if (!card)
 		card = l_card;
 
-	ASSERT(card->init_success);
-
 	status =
 	    brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, fnc_num, addr, &data, 4);
@@ -272,10 +256,6 @@ int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func, u8 * cis,
 	if (!card)
 		card = l_card;
 
-	ASSERT(card->init_success);
-	ASSERT(cis);
-	ASSERT(length <= SBSDIO_CIS_SIZE_LIMIT);
-
 	status = brcmf_sdioh_cis_read(card->sdioh, func, cis, length);
 
 	if (ascii) {
@@ -330,8 +310,6 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
 	if (!card)
 		card = l_card;
 
-	ASSERT(card->init_success);
-
 	if (bar0 != card->sbwad) {
 		if (brcmf_sdcard_set_sbaddr_window(card, bar0))
 			return 0xFFFFFFFF;
@@ -384,8 +362,6 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
 	if (!card)
 		card = l_card;
 
-	ASSERT(card->init_success);
-
 	if (bar0 != card->sbwad) {
 		err = brcmf_sdcard_set_sbaddr_window(card, bar0);
 		if (err)
@@ -429,14 +405,10 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	ASSERT(card);
-	ASSERT(card->init_success);
-
 	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
 		     __func__, fn, addr, nbytes));
 
 	/* Async not implemented yet */
-	ASSERT(!(flags & SDIO_REQ_ASYNC));
 	if (flags & SDIO_REQ_ASYNC)
 		return -ENOTSUPP;
 
@@ -473,14 +445,10 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	ASSERT(card);
-	ASSERT(card->init_success);
-
 	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
 		     __func__, fn, addr, nbytes));
 
 	/* Async not implemented yet */
-	ASSERT(!(flags & SDIO_REQ_ASYNC));
 	if (flags & SDIO_REQ_ASYNC)
 		return -ENOTSUPP;
 
@@ -506,10 +474,6 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 int brcmf_sdcard_rwdata(struct brcmf_sdio_card *card, uint rw, u32 addr,
 			u8 *buf, uint nbytes)
 {
-	ASSERT(card);
-	ASSERT(card->init_success);
-	ASSERT((addr & SBSDIO_SBWINDOW_MASK) == 0);
-
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-- 
1.7.4.1


