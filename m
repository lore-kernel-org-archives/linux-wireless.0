Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4508 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3AVVso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 16:48:44 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.8] brcmsmac: fix tx status processing
Date: Tue, 22 Jan 2013 22:47:40 +0100
Message-ID: <1358891260-7100-1-git-send-email-arend@broadcom.com> (sfid-20130122_224848_805124_2FE0D71B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This issue was reported on the wireless list (see [1]) in which
brcmsmac ran into a fatal error:

[  588.284074] brcmsmac bcma0:0: frameid != txh->TxFrameID
[  588.284098] brcmsmac bcma0:0: MI_TFS: fatal
[  588.284103] brcmsmac bcma0:0: wl0: fatal error, reinitializing
[  588.286208] ieee80211 phy0: Hardware restart was requested

The tx status feedback is processed in a loop limiting the number of
frames processed in one run. The code terminate processing when the
limit is reached regardless the txstatus value read from the device
register. When that status is is flagged as being valid it must be
processed as the hardware will clear it after is has been read.

Bisecting was done by Seth Forshee and showed following commit as the
culprit:

commit 57fe504817ccec9b6ac23e973d2925343bf1e3b6
Author: Piotr Haber <phaber@broadcom.com>
Date:   Wed Nov 28 21:44:07 2012 +0100

    brcmsmac: fix bounds checking in tx/rx

[1] http://www.spinics.net/lists/linux-wireless/msg101293.html

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   25 +++++++++---------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 17594de..9f3d7e9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1027,7 +1027,6 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 static bool
 brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 {
-	bool morepending = false;
 	struct bcma_device *core;
 	struct tx_status txstatus, *txs;
 	u32 s1, s2;
@@ -1041,23 +1040,20 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	txs = &txstatus;
 	core = wlc_hw->d11core;
 	*fatal = false;
-	s1 = bcma_read32(core, D11REGOFFS(frmtxstatus));
-	while (!(*fatal)
-	       && (s1 & TXS_V)) {
-		/* !give others some time to run! */
-		if (n >= max_tx_num) {
-			morepending = true;
-			break;
-		}
 
+	while (n < max_tx_num) {
+		s1 = bcma_read32(core, D11REGOFFS(frmtxstatus));
 		if (s1 == 0xffffffff) {
 			brcms_err(core, "wl%d: %s: dead chip\n", wlc_hw->unit,
 				  __func__);
 			*fatal = true;
 			return false;
 		}
-		s2 = bcma_read32(core, D11REGOFFS(frmtxstatus2));
+		/* only process when valid */
+		if (!(s1 & TXS_V))
+			break;
 
+		s2 = bcma_read32(core, D11REGOFFS(frmtxstatus2));
 		txs->status = s1 & TXS_STATUS_MASK;
 		txs->frameid = (s1 & TXS_FID_MASK) >> TXS_FID_SHIFT;
 		txs->sequence = s2 & TXS_SEQ_MASK;
@@ -1065,15 +1061,12 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 		txs->lasttxtime = 0;
 
 		*fatal = brcms_c_dotxstatus(wlc_hw->wlc, txs);
-
-		s1 = bcma_read32(core, D11REGOFFS(frmtxstatus));
+		if (*fatal == true)
+			return false;
 		n++;
 	}
 
-	if (*fatal)
-		return false;
-
-	return morepending;
+	return n >= max_tx_num;
 }
 
 static void brcms_c_tbtt(struct brcms_c_info *wlc)
-- 
1.7.10.4


