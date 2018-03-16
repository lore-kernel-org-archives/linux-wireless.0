Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44931 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754802AbeCPPl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 11:41:57 -0400
From: Takashi Iwai <tiwai@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH] brcmsmac: allocate ucode with GFP_KERNEL
Date: Fri, 16 Mar 2018 16:41:49 +0100
Message-Id: <20180316154149.16891-1-tiwai@suse.de> (sfid-20180316_170535_734572_834ABD71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcms_ucode_init_buf() duplicates the ucode chunks via kmemdup()
with GFP_ATOMIC as a precondition of wl->lock acquired.  This caused
allocation failures sometimes as reported in the bugzilla below.

When looking at the the real usage, one can find that it's called
solely from brcms_request_fw(), and it's obviously outside the lock.
Hence we can use GFP_KERNEL there safely for avoiding such allocation
errors.

Bugzilla: http://bugzilla.suse.com/show_bug.cgi?id=1085174
Signed-off-by: Takashi Iwai <tiwai@suse.de>

---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ddfdfe177e24..a14fccf8a902 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1563,7 +1563,7 @@ void brcms_free_timer(struct brcms_timer *t)
 }
 
 /*
- * precondition: perimeter lock has been acquired
+ * precondition: no locking required
  */
 int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf, u32 idx)
 {
@@ -1578,7 +1578,7 @@ int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf, u32 idx)
 			if (le32_to_cpu(hdr->idx) == idx) {
 				pdata = wl->fw.fw_bin[i]->data +
 					le32_to_cpu(hdr->offset);
-				*pbuf = kmemdup(pdata, len, GFP_ATOMIC);
+				*pbuf = kmemdup(pdata, len, GFP_KERNEL);
 				if (*pbuf == NULL)
 					goto fail;
 
-- 
2.16.2
