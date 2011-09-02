Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4340 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1IBOBC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:01:02 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/12] staging: brcm80211: remove extern keyword from
 function definition
Date: Fri, 2 Sep 2011 16:00:28 +0200
Message-ID: <1314972039-27098-2-git-send-email-rvossen@broadcom.com> (sfid-20110902_160119_813031_1890E61C)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Sparse warning was given when using the extern keyword in the function
definition. This patch removes those instances.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   25 +++++++++-----------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 5482005..6adf5c0 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -76,9 +76,8 @@ brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t wq)
 #endif
 }
 
-extern int
-brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
-			 uint regaddr, u8 *byte)
+int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
+			     uint regaddr, u8 *byte)
 {
 	int err_ret;
 
@@ -173,9 +172,9 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 	return err_ret;
 }
 
-extern int
-brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint rw,
-			 uint func, uint addr, u32 *word, uint nbytes)
+int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
+			     uint rw, uint func, uint addr, u32 *word,
+			     uint nbytes)
 {
 	int err_ret = -EIO;
 
@@ -304,11 +303,10 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
  * aligned packet.
  *
  */
-extern int
-brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
-			   uint fix_inc, uint write, uint func, uint addr,
-			   uint reg_width, uint buflen_u, u8 *buffer,
-			   struct sk_buff *pkt)
+int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
+			       uint fix_inc, uint write, uint func, uint addr,
+			       uint reg_width, uint buflen_u, u8 *buffer,
+			       struct sk_buff *pkt)
 {
 	int Status;
 	struct sk_buff *mypkt = NULL;
@@ -425,9 +423,8 @@ static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 	return scratch;
 }
 
-extern int
-brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
-		     u8 *cisd, u32 length)
+int brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
+			 u8 *cisd, u32 length)
 {
 	u32 count;
 	int offset;
-- 
1.7.4.1


