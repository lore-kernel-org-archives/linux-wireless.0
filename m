Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45427 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaE0K4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/16] brcmfmac: make brcmf_fw_nvram_strip() static
Date: Tue, 27 May 2014 12:56:24 +0200
Message-ID: <1401188188-16492-13-git-send-email-arend@broadcom.com> (sfid-20140527_125656_566169_2E723D36)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_fw_nvram_strip() is no longer called so
it does not need to be exposed.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/firmware.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index d92fed0..5990017 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -188,7 +188,7 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
  * and converts newlines to NULs. Shortens buffer as needed and pads with NULs.
  * End of buffer is completed with token identifying length of buffer.
  */
-void *brcmf_fw_nvram_strip(const struct firmware *nv, u32 *new_length)
+static void *brcmf_fw_nvram_strip(const struct firmware *nv, u32 *new_length)
 {
 	struct nvram_parser nvp;
 	u32 pad;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
index 25b64bd..6431bfd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
@@ -21,7 +21,6 @@
 #define BRCMF_FW_REQ_FLAGS		0x00F0
 #define  BRCMF_FW_REQ_NV_OPTIONAL	0x0010
 
-void *brcmf_fw_nvram_strip(const struct firmware *nv, u32 *new_length);
 void brcmf_fw_nvram_free(void *nvram);
 /*
  * Request firmware(s) asynchronously. When the asynchronous request
-- 
1.7.9.5

