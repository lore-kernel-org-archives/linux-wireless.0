Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4894 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab1IXCJT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 22:09:19 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/20] staging: brcm80211: cleanup structure fields used
 for scanning
Date: Fri, 23 Sep 2011 19:08:56 -0700
Message-ID: <1316830148-28661-9-git-send-email-frankyl@broadcom.com> (sfid-20110924_040939_071751_BEC5C165)
In-Reply-To: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

In the structure brcmf_cfg80211_priv two fields were defined
in which one was allocated and a second was referenced back to
the first for no obvious reasons. Also the name was misleading
giving the impression that the driver was maintaining a list of
BSS entries like cfg80211 does.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   32 ++++++++++++---------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    5 +--
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index b956c90..471f2d7 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1972,7 +1972,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 	s32 err = 0;
 	int i;
 
-	bss_list = cfg_priv->bss_list;
+	bss_list = cfg_priv->scan_list;
 	if (bss_list->version != BRCMF_BSS_INFO_VERSION) {
 		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
 		       bss_list->version);
@@ -2288,12 +2288,18 @@ static void brcmf_cfg80211_iscan_handler(struct work_struct *work)
 	}
 
 	rtnl_lock();
-	if (brcmf_get_iscan_results(iscan, &status, &cfg_priv->bss_list)) {
+	/* obtain scan results in scan_list to be used by iscan handler below */
+	if (brcmf_get_iscan_results(iscan, &status, &cfg_priv->scan_list)) {
 		status = BRCMF_SCAN_RESULTS_ABORTED;
 		WL_ERR("Abort iscan\n");
 	}
 	rtnl_unlock();
 
+	/*
+	 * call handler based upon status provided by dongle.
+	 * The scan_list retrieved from the dongle may be used
+	 * or discarded depending on the status.
+	 */
 	el->handler[status](cfg_priv);
 }
 
@@ -3028,22 +3034,20 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 	scan_channel = le32_to_cpu(channel_inform_le.scan_channel);
 	if (scan_channel)
 		WL_CONN("channel_inform.scan_channel (%d)\n", scan_channel);
-	cfg_priv->bss_list = cfg_priv->scan_results;
-	bss_list_le = (struct brcmf_scan_results_le *) cfg_priv->bss_list;
+	bss_list_le = (struct brcmf_scan_results_le *) cfg_priv->scan_list;
 
-	memset(cfg_priv->scan_results, 0, len);
+	memset(bss_list_le, 0, len);
 	bss_list_le->buflen = cpu_to_le32(len);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN_RESULTS,
-			      cfg_priv->scan_results, len);
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN_RESULTS, bss_list_le, len);
 	if (err) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
 		err = -EINVAL;
 		scan_abort = true;
 		goto scan_done_out;
 	}
-	cfg_priv->scan_results->buflen = le32_to_cpu(bss_list_le->buflen);
-	cfg_priv->scan_results->version = le32_to_cpu(bss_list_le->version);
-	cfg_priv->scan_results->count = le32_to_cpu(bss_list_le->count);
+	cfg_priv->scan_list->buflen = le32_to_cpu(bss_list_le->buflen);
+	cfg_priv->scan_list->version = le32_to_cpu(bss_list_le->version);
+	cfg_priv->scan_list->count = le32_to_cpu(bss_list_le->count);
 
 	err = brcmf_inform_bss(cfg_priv);
 	if (err) {
@@ -3086,8 +3090,8 @@ static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
 
 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	kfree(cfg_priv->scan_results);
-	cfg_priv->scan_results = NULL;
+	kfree(cfg_priv->scan_list);
+	cfg_priv->scan_list = NULL;
 	kfree(cfg_priv->bss_info);
 	cfg_priv->bss_info = NULL;
 	kfree(cfg_priv->conf);
@@ -3108,8 +3112,8 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 
 static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	cfg_priv->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
-	if (!cfg_priv->scan_results)
+	cfg_priv->scan_list = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
+	if (!cfg_priv->scan_list)
 		goto init_priv_mem_out;
 	cfg_priv->conf = kzalloc(sizeof(*cfg_priv->conf), GFP_KERNEL);
 	if (!cfg_priv->conf)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index afc60d9..f40a878 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -285,9 +285,8 @@ struct brcmf_cfg80211_priv {
 	struct list_head evt_q_list;	/* used for event queue */
 	spinlock_t	 evt_q_lock;	/* for event queue synchronization */
 	struct mutex usr_sync;	/* maily for dongle up/down synchronization */
-	struct brcmf_scan_results *bss_list;	/* bss_list holding scanned
-						 ap information */
-	struct brcmf_scan_results *scan_results;
+	struct brcmf_scan_results *scan_list; /* holding bss scan result from
+						dongle */
 	struct brcmf_cfg80211_scan_req *scan_req_int;	/* scan request object
 						 for internal purpose */
 	struct wl_cfg80211_bss_info *bss_info;	/* bss information for
-- 
1.7.1


