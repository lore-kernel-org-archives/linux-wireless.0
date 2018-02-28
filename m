Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58317 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752466AbeB1J76 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 04:59:58 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.16 V2 1/2] brcmfmac: add possibility to obtain firmware error
Date: Wed, 28 Feb 2018 10:59:45 +0100
Message-Id: <1519811986-25017-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180228_110001_881605_56BAF52A)
In-Reply-To: <1519811986-25017-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519811986-25017-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The feature module needs to evaluate the actual firmware error return
upon a control command. This adds a flag to struct brcmf_if that the
caller can set. This flag is checked to determine the error code that
needs to be returned.

Fixes: b69c1df47281 ("brcmfmac: separate firmware errors from i/o errors")
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 10 ++++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c    |  3 +++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index df8a1ec..232dcbb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -181,6 +181,7 @@ enum brcmf_netif_stop_reason {
  * @netif_stop_lock: spinlock for update netif_stop from multiple sources.
  * @pend_8021x_cnt: tracks outstanding number of 802.1x frames.
  * @pend_8021x_wait: used for signalling change in count.
+ * @fwil_fwerr: flag indicating fwil layer should return firmware error codes.
  */
 struct brcmf_if {
 	struct brcmf_pub *drvr;
@@ -198,6 +199,7 @@ struct brcmf_if {
 	wait_queue_head_t pend_8021x_wait;
 	struct in6_addr ipv6_addr_tbl[NDOL_MAX_ENTRIES];
 	u8 ipv6addr_idx;
+	bool fwil_fwerr;
 };
 
 int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 47de35a..bede7b7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -104,6 +104,9 @@ static void brcmf_feat_iovar_int_get(struct brcmf_if *ifp,
 	u32 data;
 	int err;
 
+	/* we need to know firmware error */
+	ifp->fwil_fwerr = true;
+
 	err = brcmf_fil_iovar_int_get(ifp, name, &data);
 	if (err == 0) {
 		brcmf_dbg(INFO, "enabling feature: %s\n", brcmf_feat_names[id]);
@@ -112,6 +115,8 @@ static void brcmf_feat_iovar_int_get(struct brcmf_if *ifp,
 		brcmf_dbg(TRACE, "%s feature check failed: %d\n",
 			  brcmf_feat_names[id], err);
 	}
+
+	ifp->fwil_fwerr = false;
 }
 
 static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
@@ -120,6 +125,9 @@ static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
 {
 	int err;
 
+	/* we need to know firmware error */
+	ifp->fwil_fwerr = true;
+
 	err = brcmf_fil_iovar_data_set(ifp, name, data, len);
 	if (err != -BRCMF_FW_UNSUPPORTED) {
 		brcmf_dbg(INFO, "enabling feature: %s\n", brcmf_feat_names[id]);
@@ -128,6 +136,8 @@ static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
 		brcmf_dbg(TRACE, "%s feature check failed: %d\n",
 			  brcmf_feat_names[id], err);
 	}
+
+	ifp->fwil_fwerr = false;
 }
 
 #define MAX_CAPS_BUFFER_SIZE	512
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index f2cfdd3..fc57511 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -131,6 +131,9 @@ static const char *brcmf_fil_get_errstr(u32 err)
 			  brcmf_fil_get_errstr((u32)(-fwerr)), fwerr);
 		err = -EBADE;
 	}
+	if (ifp->fwil_fwerr)
+		return fwerr;
+
 	return err;
 }
 
-- 
1.9.1
