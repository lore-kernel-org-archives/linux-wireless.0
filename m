Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2162 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab3IYLGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 07:06:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/7] brcmfmac: add valid core index check in related
 functions
Date: Wed, 25 Sep 2013 13:05:42 +0200
Message-ID: <1380107146-24026-4-git-send-email-arend@broadcom.com> (sfid-20130925_130618_051070_ABC0E580)
In-Reply-To: <1380107146-24026-1-git-send-email-arend@broadcom.com>
References: <1380107146-24026-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Perform a valid check for core index to avoid illegal address access.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 023ddcb..2096a14 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -137,6 +137,8 @@ brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
 	u8 idx;
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+	if (idx == BRCMF_MAX_CORENUM)
+		return false;
 
 	regdata = brcmf_sdio_regrl(sdiodev,
 				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
@@ -155,6 +157,8 @@ brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
 	bool ret;
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+	if (idx == BRCMF_MAX_CORENUM)
+		return false;
 
 	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 				   NULL);
@@ -262,6 +266,8 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 	u32 regdata;
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+	if (idx == BRCMF_MAX_CORENUM)
+		return;
 
 	/* if core is already in reset, just return */
 	regdata = brcmf_sdio_regrl(sdiodev,
@@ -305,6 +311,8 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 	u8 idx;
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+	if (idx == BRCMF_MAX_CORENUM)
+		return;
 
 	/*
 	 * Must do the disable sequence first to work for
@@ -369,6 +377,8 @@ brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
 	u32 regdata;
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+	if (idx == BRCMF_MAX_CORENUM)
+		return;
 
 	/* must disable first to work for arbitrary current core state */
 	brcmf_sdio_ai_coredisable(sdiodev, ci, coreid, core_bits);
-- 
1.7.10.4


