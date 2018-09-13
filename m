Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbeIMLX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 07:23:28 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH] brcmsmac: Use kvmalloc() for ucode allocations
Date: Thu, 13 Sep 2018 08:15:17 +0200
Message-Id: <20180913061517.26295-1-tiwai@suse.de> (sfid-20180913_081531_084262_7BEF6F2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ucode chunk might be relatively large and the allocation with
kmalloc() may fail occasionally.  Since the data isn't DMA-transferred
but by manual loops, we can use vmalloc instead of kmalloc.
For a better performance, though, kvmalloc() would be the best choice
in such a case, so let's replace with it.

Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1103431
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c  | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ecc89e718b9c..6255fb6d97a7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1578,10 +1578,10 @@ int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf, u32 idx)
 			if (le32_to_cpu(hdr->idx) == idx) {
 				pdata = wl->fw.fw_bin[i]->data +
 					le32_to_cpu(hdr->offset);
-				*pbuf = kmemdup(pdata, len, GFP_KERNEL);
+				*pbuf = kvmalloc(len, GFP_KERNEL);
 				if (*pbuf == NULL)
 					goto fail;
-
+				memcpy(*pbuf, pdata, len);
 				return 0;
 			}
 		}
@@ -1629,7 +1629,7 @@ int brcms_ucode_init_uint(struct brcms_info *wl, size_t *n_bytes, u32 idx)
  */
 void brcms_ucode_free_buf(void *p)
 {
-	kfree(p);
+	kvfree(p);
 }
 
 /*
-- 
2.18.0
