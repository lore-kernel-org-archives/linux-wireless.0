Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:60121 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751707AbeB0Xma (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:42:30 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/2] brcmfmac: add possibility to obtain firmware error
Date: Wed, 28 Feb 2018 00:42:19 +0100
Message-Id: <1519774940-20793-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180228_004234_855538_9D7EF4FB)
In-Reply-To: <1519774940-20793-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519774940-20793-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The feature module needs to evaluate the actual firmware error returned
upon a control command. This adds a field to struct brcmf_if in which
the error code is stored whenever a firmware error occurs.

Fixes: b69c1df47281 ("brcmfmac: separate firmware errors from i/o errors")
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h    | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c    | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index df8a1ec..2607db5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -181,6 +181,7 @@ enum brcmf_netif_stop_reason {
  * @netif_stop_lock: spinlock for update netif_stop from multiple sources.
  * @pend_8021x_cnt: tracks outstanding number of 802.1x frames.
  * @pend_8021x_wait: used for signalling change in count.
+ * @last_fwerr: last firmware error occurred for this interface.
  */
 struct brcmf_if {
 	struct brcmf_pub *drvr;
@@ -198,6 +199,7 @@ struct brcmf_if {
 	wait_queue_head_t pend_8021x_wait;
 	struct in6_addr ipv6_addr_tbl[NDOL_MAX_ENTRIES];
 	u8 ipv6addr_idx;
+	s32 last_fwerr;
 };
 
 int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 47de35a..e044df9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -121,7 +121,7 @@ static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
 	int err;
 
 	err = brcmf_fil_iovar_data_set(ifp, name, data, len);
-	if (err != -BRCMF_FW_UNSUPPORTED) {
+	if (ifp->last_fwerr != -BRCMF_FW_UNSUPPORTED) {
 		brcmf_dbg(INFO, "enabling feature: %s\n", brcmf_feat_names[id]);
 		ifp->drvr->feat_flags |= BIT(id);
 	} else {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index f2cfdd3..e573dcd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -129,6 +129,7 @@ static const char *brcmf_fil_get_errstr(u32 err)
 	} else if (fwerr < 0) {
 		brcmf_dbg(FIL, "Firmware error: %s (%d)\n",
 			  brcmf_fil_get_errstr((u32)(-fwerr)), fwerr);
+		ifp->last_fwerr = fwerr;
 		err = -EBADE;
 	}
 	return err;
-- 
1.9.1
