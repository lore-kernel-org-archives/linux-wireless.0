Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2340 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177Ab1JDVTh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:37 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 18/26] staging: brcm80211: cleanup of transmit buffer
 size related wrapper function
Date: Tue, 4 Oct 2011 23:19:04 +0200
Message-ID: <1317763152-17607-19-git-send-email-arend@broadcom.com> (sfid-20111004_232040_357401_5BCF6DBE)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Removed brcms_c_xmtfifo_sz_get function.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c  |    7 +------
 drivers/staging/brcm80211/brcmsmac/main.h  |    4 ++--
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 506c392..fc49900 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -383,7 +383,7 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 		return 1;
 
 	/* check if fifo is big enough */
-	if (brcms_c_xmtfifo_sz_get(wlc, fid, &xmtfifo_sz))
+	if (brcms_b_xmtfifo_sz_get(wlc->hw, fid, &xmtfifo_sz))
 		return -1;
 
 	if ((TXFIFO_SIZE_UNIT * (u32) xmtfifo_sz) <= ampdu->ffpld_rsvd)
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 5d3bfda..cbed10c 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -8809,7 +8809,7 @@ void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val, int bands)
 	brcms_b_mhf(wlc->hw, idx, mask, val, bands);
 }
 
-static int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
+int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 			   uint *blocks)
 {
 	if (fifo >= NFIFO)
@@ -8820,11 +8820,6 @@ static int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 	return 0;
 }
 
-int brcms_c_xmtfifo_sz_get(struct brcms_c_info *wlc, uint fifo, uint *blocks)
-{
-	return brcms_b_xmtfifo_sz_get(wlc->hw, fifo, blocks);
-}
-
 void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset, int len,
 			    void *buf)
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 6512e7a..a71c509 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -672,8 +672,8 @@ extern void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 			    struct sk_buff *sdu, uint prec);
 extern void brcms_c_info_init(struct brcms_c_info *wlc, int unit);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
-extern int brcms_c_xmtfifo_sz_get(struct brcms_c_info *wlc, uint fifo,
-				  uint *blocks);
+extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
+		   uint *blocks);
 extern void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset,
 				       int len, void *buf);
 extern void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, u32 req_bit);
-- 
1.7.4.1


