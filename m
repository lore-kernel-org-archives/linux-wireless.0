Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1631 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/24] brcm80211: fmac: remove width parameter from
 brcmf_sdioh_request_buffer
Date: Tue, 22 Nov 2011 17:21:39 -0800
Message-ID: <1322011319-24863-5-git-send-email-frankyl@broadcom.com> (sfid-20111123_022254_220182_62A2A0B2)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function brcmf_sdioh_request_buffer() was requiring a parameter in
its prototype that was not used within the function. It has been
removed consequently.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    6 +++---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    3 +--
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    3 +--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9c27870..e8d1c9e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -288,7 +288,7 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 
 	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
 	err = brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_READ,
-					 fn, addr, width, 0, NULL, pkt);
+					 fn, addr, 0, NULL, pkt);
 
 	return err;
 }
@@ -369,7 +369,7 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	return brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_WRITE, fn,
-					  addr, width, 0, NULL, pkt);
+					  addr, 0, NULL, pkt);
 }
 
 int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
@@ -380,7 +380,7 @@ int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
 
 	return brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_INC,
 		(rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
-		addr, 4, nbytes, buf, NULL);
+		addr, nbytes, buf, NULL);
 }
 
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 4e75c19..271765c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -333,8 +333,7 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
  */
 int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			       uint fix_inc, uint write, uint func, uint addr,
-			       uint reg_width, uint buflen_u, u8 *buffer,
-			       struct sk_buff *pkt)
+			       uint buflen_u, u8 *buffer, struct sk_buff *pkt)
 {
 	int Status;
 	struct sk_buff *mypkt = NULL;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 85694ac..74beffc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -247,8 +247,7 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 /* read or write any buffer using cmd53 */
 extern int
 brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
-			   uint fix_inc, uint rw, uint fnc_num,
-			   u32 addr, uint regwidth,
+			   uint fix_inc, uint rw, uint fnc_num, u32 addr,
 			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
 extern int
 brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
-- 
1.7.5.4


