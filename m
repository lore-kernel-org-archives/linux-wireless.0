Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4708 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 052/119] staging: brcm80211: remove conditional
 SIMPLE_ISCAN code
Date: Wed, 29 Jun 2011 16:47:16 -0700
Message-ID: <1309391303-22741-53-git-send-email-frankyl@broadcom.com> (sfid-20110630_015010_961114_50482BC2)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Code between #ifdef SIMPLE_ISCAN is not enabled and unnecessary.
It has been removed from the fullmac driver.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |  391 -----------------------
 1 files changed, 0 insertions(+), 391 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 70d2591..a255d3d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -35,11 +35,6 @@ int brcmf_msg_level;
 char brcmf_fw_path[MOD_PARAM_PATHLEN];
 char brcmf_nv_path[MOD_PARAM_PATHLEN];
 
-extern void dhd_ind_scan_confirm(void *h, bool status);
-extern int dhd_wl_ioctl(dhd_pub_t *dhd, uint cmd, char *buf, uint buflen);
-void dhd_iscan_lock(void);
-void dhd_iscan_unlock(void);
-
 /* Packet alignment for most efficient SDIO (can change based on platform) */
 #ifndef DHD_SDALIGN
 #define DHD_SDALIGN	32
@@ -1325,392 +1320,6 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	return 0;
 }
 
-#ifdef SIMPLE_ISCAN
-uint iscan_thread_id;
-iscan_buf_t *iscan_chain;
-
-iscan_buf_t *dhd_iscan_allocate_buf(dhd_pub_t *dhd, iscan_buf_t **iscanbuf)
-{
-	iscan_buf_t *iscanbuf_alloc = 0;
-	iscan_buf_t *iscanbuf_head;
-
-	dhd_iscan_lock();
-
-	iscanbuf_alloc = kmalloc(sizeof(iscan_buf_t), GFP_ATOMIC);
-	if (iscanbuf_alloc == NULL)
-		goto fail;
-
-	iscanbuf_alloc->next = NULL;
-	iscanbuf_head = *iscanbuf;
-
-	DHD_ISCAN(("%s: addr of allocated node = 0x%X"
-		   "addr of iscanbuf_head = 0x%X dhd = 0x%X\n",
-		   __func__, iscanbuf_alloc, iscanbuf_head, dhd));
-
-	if (iscanbuf_head == NULL) {
-		*iscanbuf = iscanbuf_alloc;
-		DHD_ISCAN(("%s: Head is allocated\n", __func__));
-		goto fail;
-	}
-
-	while (iscanbuf_head->next)
-		iscanbuf_head = iscanbuf_head->next;
-
-	iscanbuf_head->next = iscanbuf_alloc;
-
-fail:
-	dhd_iscan_unlock();
-	return iscanbuf_alloc;
-}
-
-void dhd_iscan_free_buf(void *dhdp, iscan_buf_t *iscan_delete)
-{
-	iscan_buf_t *iscanbuf_free = 0;
-	iscan_buf_t *iscanbuf_prv = 0;
-	iscan_buf_t *iscanbuf_cur = iscan_chain;
-	dhd_pub_t *dhd = dhd_bus_pub(dhdp);
-
-	dhd_iscan_lock();
-	/* If iscan_delete is null then delete the entire
-	 * chain or else delete specific one provided
-	 */
-	if (!iscan_delete) {
-		while (iscanbuf_cur) {
-			iscanbuf_free = iscanbuf_cur;
-			iscanbuf_cur = iscanbuf_cur->next;
-			iscanbuf_free->next = 0;
-			kfree(iscanbuf_free);
-		}
-		iscan_chain = 0;
-	} else {
-		while (iscanbuf_cur) {
-			if (iscanbuf_cur == iscan_delete)
-				break;
-			iscanbuf_prv = iscanbuf_cur;
-			iscanbuf_cur = iscanbuf_cur->next;
-		}
-		if (iscanbuf_prv)
-			iscanbuf_prv->next = iscan_delete->next;
-
-		iscan_delete->next = 0;
-		kfree(iscan_delete);
-
-		if (!iscanbuf_prv)
-			iscan_chain = 0;
-	}
-	dhd_iscan_unlock();
-}
-
-iscan_buf_t *dhd_iscan_result_buf(void)
-{
-	return iscan_chain;
-}
-
-/*
-* print scan cache
-* print partial iscan_skip list differently
-*/
-int dhd_iscan_print_cache(iscan_buf_t *iscan_skip)
-{
-	int i = 0, l = 0;
-	iscan_buf_t *iscan_cur;
-	wl_iscan_results_t *list;
-	wl_scan_results_t *results;
-	wl_bss_info_t UNALIGNED *bi;
-
-	dhd_iscan_lock();
-
-	iscan_cur = dhd_iscan_result_buf();
-
-	while (iscan_cur) {
-		list = (wl_iscan_results_t *)iscan_cur->iscan_buf;
-		if (!list)
-			break;
-
-		results = (wl_scan_results_t *)&list->results;
-		if (!results)
-			break;
-
-		if (results->version != WL_BSS_INFO_VERSION) {
-			DHD_ISCAN(("%s: results->version %d != "
-				"WL_BSS_INFO_VERSION\n",
-				__func__, results->version));
-			goto done;
-		}
-
-		bi = results->bss_info;
-		for (i = 0; i < results->count; i++) {
-			if (!bi)
-				break;
-
-			DHD_ISCAN(("%s[%2.2d:%2.2d] %X:%X:%X:%X:%X:%X\n",
-				   iscan_cur != iscan_skip ? "BSS" : "bss", l,
-				   i, bi->BSSID.octet[0], bi->BSSID.octet[1],
-				   bi->BSSID.octet[2], bi->BSSID.octet[3],
-				   bi->BSSID.octet[4], bi->BSSID.octet[5]));
-
-			bi = (wl_bss_info_t *)((unsigned long)bi + bi->length);
-		}
-		iscan_cur = iscan_cur->next;
-		l++;
-	}
-
-done:
-	dhd_iscan_unlock();
-	return 0;
-}
-
-/*
-* delete disappeared AP from specific scan cache but skip partial
-* list in iscan_skip
-*/
-int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
-{
-	int i = 0, j = 0, l = 0;
-	iscan_buf_t *iscan_cur;
-	wl_iscan_results_t *list;
-	wl_scan_results_t *results;
-	wl_bss_info_t UNALIGNED *bi, *bi_new, *bi_next;
-
-	unsigned char *s_addr = addr;
-
-	dhd_iscan_lock();
-	DHD_ISCAN(("%s: BSS to remove %X:%X:%X:%X:%X:%X\n",
-		   __func__, s_addr[0], s_addr[1], s_addr[2],
-		   s_addr[3], s_addr[4], s_addr[5]));
-
-	iscan_cur = dhd_iscan_result_buf();
-
-	while (iscan_cur) {
-		if (iscan_cur != iscan_skip) {
-			list = (wl_iscan_results_t *)iscan_cur->iscan_buf;
-			if (!list)
-				break;
-
-			results = (wl_scan_results_t *)&list->results;
-			if (!results)
-				break;
-
-			if (results->version != WL_BSS_INFO_VERSION) {
-				DHD_ERROR(("%s: results->version %d != "
-					"WL_BSS_INFO_VERSION\n",
-					__func__, results->version));
-				goto done;
-			}
-
-			bi = results->bss_info;
-			for (i = 0; i < results->count; i++) {
-				if (!bi)
-					break;
-
-				if (!memcmp
-				    (bi->BSSID.octet, addr, ETH_ALEN)) {
-					DHD_ISCAN(("%s: Del BSS[%2.2d:%2.2d] "
-					"%X:%X:%X:%X:%X:%X\n",
-					__func__, l, i, bi->BSSID.octet[0],
-					bi->BSSID.octet[1], bi->BSSID.octet[2],
-					bi->BSSID.octet[3], bi->BSSID.octet[4],
-					bi->BSSID.octet[5]));
-
-					bi_new = bi;
-					bi = (wl_bss_info_t *)((unsigned long)
-							       bi + bi->length);
-/*
-			if(bi && bi_new) {
-				memcpy(bi_new, bi, results->buflen -
-				bi_new->length);
-				results->buflen -= bi_new->length;
-			}
-*/
-					results->buflen -= bi_new->length;
-					results->count--;
-
-					for (j = i; j < results->count; j++) {
-						if (bi && bi_new) {
-							DHD_ISCAN(("%s: Moved up BSS[%2.2d:%2.2d]" "%X:%X:%X:%X:%X:%X\n",
-							__func__, l, j,
-							bi->BSSID.octet[0],
-							bi->BSSID.octet[1],
-							bi->BSSID.octet[2],
-							bi->BSSID.octet[3],
-							bi->BSSID.octet[4],
-							bi->BSSID.octet[5]));
-
-							bi_next =
-							    (wl_bss_info_t *)((unsigned long)bi +
-								 bi->length);
-							memcpy(bi_new, bi,
-							      bi->length);
-							bi_new =
-							    (wl_bss_info_t *)((unsigned long)bi_new +
-								 bi_new->
-								  length);
-							bi = bi_next;
-						}
-					}
-
-					if (results->count == 0) {
-						/* Prune now empty partial
-						scan list */
-						dhd_iscan_free_buf(dhdp,
-								   iscan_cur);
-						goto done;
-					}
-					break;
-				}
-				bi = (wl_bss_info_t *)((unsigned long)bi +
-							bi->length);
-			}
-		}
-		iscan_cur = iscan_cur->next;
-		l++;
-	}
-
-done:
-	dhd_iscan_unlock();
-	return 0;
-}
-
-int dhd_iscan_remove_duplicates(void *dhdp, iscan_buf_t *iscan_cur)
-{
-	int i = 0;
-	wl_iscan_results_t *list;
-	wl_scan_results_t *results;
-	wl_bss_info_t UNALIGNED *bi, *bi_new, *bi_next;
-
-	dhd_iscan_lock();
-
-	DHD_ISCAN(("%s: Scan cache before delete\n", __func__));
-	dhd_iscan_print_cache(iscan_cur);
-
-	if (!iscan_cur)
-		goto done;
-
-	list = (wl_iscan_results_t *)iscan_cur->iscan_buf;
-	if (!list)
-		goto done;
-
-	results = (wl_scan_results_t *)&list->results;
-	if (!results)
-		goto done;
-
-	if (results->version != WL_BSS_INFO_VERSION) {
-		DHD_ERROR(("%s: results->version %d != WL_BSS_INFO_VERSION\n",
-			   __func__, results->version));
-		goto done;
-	}
-
-	bi = results->bss_info;
-	for (i = 0; i < results->count; i++) {
-		if (!bi)
-			break;
-
-		DHD_ISCAN(("%s: Find dups for BSS[%2.2d] %X:%X:%X:%X:%X:%X\n",
-			   __func__, i, bi->BSSID.octet[0],
-			   bi->BSSID.octet[1], bi->BSSID.octet[2],
-			   bi->BSSID.octet[3], bi->BSSID.octet[4],
-			   bi->BSSID.octet[5]));
-
-		dhd_iscan_delete_bss(dhdp, bi->BSSID.octet, iscan_cur);
-
-		bi = (wl_bss_info_t *)((unsigned long)bi + bi->length);
-	}
-
-done:
-	DHD_ISCAN(("%s: Scan cache after delete\n", __func__));
-	dhd_iscan_print_cache(iscan_cur);
-	dhd_iscan_unlock();
-	return 0;
-}
-
-void dhd_iscan_ind_scan_confirm(void *dhdp, bool status)
-{
-
-	dhd_ind_scan_confirm(dhdp, status);
-}
-
-int dhd_iscan_request(void *dhdp, u16 action)
-{
-	int rc;
-	wl_iscan_params_t params;
-	dhd_pub_t *dhd = dhd_bus_pub(dhdp);
-	char buf[BRCMF_C_IOCTL_SMLEN];
-
-	memset(&params, 0, sizeof(wl_iscan_params_t));
-	memcpy(&params.params.bssid, &ether_bcast, ETH_ALEN);
-
-	params.params.bss_type = DOT11_BSSTYPE_ANY;
-	params.params.scan_type = DOT11_SCANTYPE_ACTIVE;
-
-	params.params.nprobes = -1;
-	params.params.active_time = -1;
-	params.params.passive_time = -1;
-	params.params.home_time = -1;
-	params.params.channel_num = 0;
-
-	params.version = ISCAN_REQ_VERSION;
-	params.action = action;
-	params.scan_duration = 0;
-
-	brcmu_mkiovar("iscan", (char *)&params, sizeof(wl_iscan_params_t), buf,
-		    BRCMF_C_IOCTL_SMLEN);
-	rc = dhd_wl_ioctl(dhdp, BRCMF_C_SET_VAR, buf, BRCMF_C_IOCTL_SMLEN);
-
-	return rc;
-}
-
-static int dhd_iscan_get_partial_result(void *dhdp, uint *scan_count)
-{
-	wl_iscan_results_t *list_buf;
-	wl_iscan_results_t list;
-	wl_scan_results_t *results;
-	iscan_buf_t *iscan_cur;
-	int status = -1;
-	dhd_pub_t *dhd = dhd_bus_pub(dhdp);
-	int rc;
-
-	iscan_cur = dhd_iscan_allocate_buf(dhd, &iscan_chain);
-	if (!iscan_cur) {
-		DHD_ERROR(("%s: Failed to allocate node\n", __func__));
-		dhd_iscan_free_buf(dhdp, 0);
-		dhd_iscan_request(dhdp, WL_SCAN_ACTION_ABORT);
-		goto fail;
-	}
-
-	dhd_iscan_lock();
-
-	memset(iscan_cur->iscan_buf, 0, WLC_IW_ISCAN_MAXLEN);
-	list_buf = (wl_iscan_results_t *) iscan_cur->iscan_buf;
-	results = &list_buf->results;
-	results->buflen = WL_ISCAN_RESULTS_FIXED_SIZE;
-	results->version = 0;
-	results->count = 0;
-
-	memset(&list, 0, sizeof(list));
-	list.results.buflen = WLC_IW_ISCAN_MAXLEN;
-	brcmu_mkiovar("iscanresults", (char *)&list,
-		      WL_ISCAN_RESULTS_FIXED_SIZE,
-		      iscan_cur->iscan_buf, WLC_IW_ISCAN_MAXLEN);
-	rc = dhd_wl_ioctl(dhdp, BRCMF_C_GET_VAR, iscan_cur->iscan_buf,
-			  WLC_IW_ISCAN_MAXLEN);
-
-	results->buflen = results->buflen;
-	results->version = results->version;
-	*scan_count = results->count = results->count;
-	status = list_buf->status;
-
-	dhd_iscan_unlock();
-
-	if (!(*scan_count))
-		dhd_iscan_free_buf(dhdp, iscan_cur);
-	else
-		dhd_iscan_remove_duplicates(dhdp, iscan_cur);
-
-fail:
-	return status;
-}
-#endif				/* SIMPLE_ISCAN */
-
 #ifdef PNO_SUPPORT
 int dhd_pno_clean(dhd_pub_t *dhd)
 {
-- 
1.7.1


