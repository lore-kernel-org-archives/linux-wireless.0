Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1795 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162009Ab3DEI6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:09 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/16] brcmfmac: firmware shared data version fix
Date: Fri, 5 Apr 2013 10:57:43 +0200
Message-ID: <1365152274-4252-6-git-send-email-arend@broadcom.com> (sfid-20130405_105833_501867_6059AD7F)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Firware shared data structure is backward compatible for fields
we are interested in.
Allow reading of shared data in case of version mismatch.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index ac9f650..5d5c02c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2721,8 +2721,8 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	sh->console_addr = le32_to_cpu(sh_le.console_addr);
 	sh->msgtrace_addr = le32_to_cpu(sh_le.msgtrace_addr);
 
-	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
-		brcmf_err("sdpcm_shared version mismatch: dhd %d dongle %d\n",
+	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) > SDPCM_SHARED_VERSION) {
+		brcmf_err("sdpcm shared version unsupported: dhd %d dongle %d\n",
 			  SDPCM_SHARED_VERSION,
 			  sh->flags & SDPCM_SHARED_VERSION_MASK);
 		return -EPROTO;
-- 
1.7.10.4


