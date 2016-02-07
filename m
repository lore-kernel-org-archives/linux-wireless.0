Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:60891 "EHLO m50-135.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbcBGDbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 22:31:02 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] staging: rtl8723au: use list_for_each_entry*()
Date: Sun,  7 Feb 2016 11:29:58 +0800
Message-Id: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com> (sfid-20160207_043240_428820_7B98FCCE)
In-Reply-To: <wrfjk2mmsvlq.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use list_for_each_entry*() instead of list_for_each*() to simplify
the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
Changes in v3:
 - split it into three patches.
Changes in v2:
 - drop the coding style fixing in v1.
---
 drivers/staging/rtl8723au/core/rtw_ap.c           | 55 ++++++++-----------
 drivers/staging/rtl8723au/core/rtw_mlme.c         | 26 ++++-----
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c     | 10 ++--
 drivers/staging/rtl8723au/core/rtw_recv.c         | 22 ++++----
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c      | 25 ++++-----
 drivers/staging/rtl8723au/core/rtw_xmit.c         | 64 ++++++++++-------------
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 14 +++--
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c  |  9 ++--
 8 files changed, 96 insertions(+), 129 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index 1aa9b26..4bcd617 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -173,9 +173,9 @@ static u8 chk_sta_is_alive(struct sta_info *psta)
 
 void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 {
-	struct list_head *phead, *plist, *ptmp;
+	struct list_head *phead;
 	u8 updated = 0;
-	struct sta_info *psta;
+	struct sta_info *psta, *ptmp;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	u8 chk_alive_num = 0;
 	struct sta_info *chk_alive_list[NUM_STA];
@@ -186,8 +186,7 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 	phead = &pstapriv->auth_list;
 
 	/* check auth_queue */
-	list_for_each_safe(plist, ptmp, phead) {
-		psta = container_of(plist, struct sta_info, auth_list);
+	list_for_each_entry_safe(psta, ptmp, phead, auth_list) {
 
 		if (psta->expire_to > 0) {
 			psta->expire_to--;
@@ -216,8 +215,7 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 	phead = &pstapriv->asoc_list;
 
 	/* check asoc_queue */
-	list_for_each_safe(plist, ptmp, phead) {
-		psta = container_of(plist, struct sta_info, asoc_list);
+	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
 
 		if (chk_sta_is_alive(psta) || !psta->expire_to) {
 			psta->expire_to = pstapriv->expire_to;
@@ -1059,7 +1057,7 @@ void rtw_set_macaddr_acl23a(struct rtw_adapter *padapter, int mode)
 
 int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
 {
-	struct list_head *plist, *phead;
+	struct list_head *phead;
 	u8 added = false;
 	int i, ret = 0;
 	struct rtw_wlan_acl_node *paclnode;
@@ -1076,8 +1074,7 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
 
 	phead = get_list_head(pacl_node_q);
 
-	list_for_each(plist, phead) {
-		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
+	list_for_each_entry(paclnode, phead, list) {
 
 		if (!memcmp(paclnode->addr, addr, ETH_ALEN)) {
 			if (paclnode->valid == true) {
@@ -1121,8 +1118,8 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
 
 int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
 {
-	struct list_head *plist, *phead, *ptmp;
-	struct rtw_wlan_acl_node *paclnode;
+	struct list_head *phead;
+	struct rtw_wlan_acl_node *paclnode, *ptmp;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct wlan_acl_pool *pacl_list = &pstapriv->acl_list;
 	struct rtw_queue *pacl_node_q = &pacl_list->acl_node_q;
@@ -1133,8 +1130,7 @@ int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
 
 	phead = get_list_head(pacl_node_q);
 
-	list_for_each_safe(plist, ptmp, phead) {
-		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
+	list_for_each_entry_safe(paclnode, ptmp, phead, list) {
 
 		if (!memcmp(paclnode->addr, addr, ETH_ALEN)) {
 			if (paclnode->valid) {
@@ -1354,16 +1350,15 @@ void associated_clients_update23a(struct rtw_adapter *padapter, u8 updated)
 {
 	/* update associated stations cap. */
 	if (updated == true) {
-		struct list_head *phead, *plist, *ptmp;
-		struct sta_info *psta;
+		struct list_head *phead;
+		struct sta_info *psta, *ptmp;
 		struct sta_priv *pstapriv = &padapter->stapriv;
 
 		spin_lock_bh(&pstapriv->asoc_list_lock);
 
 		phead = &pstapriv->asoc_list;
 
-		list_for_each_safe(plist, ptmp, phead) {
-			psta = container_of(plist, struct sta_info, asoc_list);
+		list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
 
 			VCS_update23a(padapter, psta);
 		}
@@ -1627,7 +1622,7 @@ u8 ap_free_sta23a(struct rtw_adapter *padapter, struct sta_info *psta, bool acti
 
 int rtw_ap_inform_ch_switch23a(struct rtw_adapter *padapter, u8 new_ch, u8 ch_offset)
 {
-	struct list_head *phead, *plist;
+	struct list_head *phead;
 	struct sta_info *psta = NULL;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
@@ -1643,8 +1638,7 @@ int rtw_ap_inform_ch_switch23a(struct rtw_adapter *padapter, u8 new_ch, u8 ch_of
 	spin_lock_bh(&pstapriv->asoc_list_lock);
 	phead = &pstapriv->asoc_list;
 
-	list_for_each(plist, phead) {
-		psta = container_of(plist, struct sta_info, asoc_list);
+	list_for_each_entry(psta, phead, asoc_list) {
 
 		issue_action_spct_ch_switch23a(padapter, psta->hwaddr, new_ch, ch_offset);
 		psta->expire_to = ((pstapriv->expire_to * 2) > 5) ? 5 : (pstapriv->expire_to * 2);
@@ -1658,8 +1652,8 @@ int rtw_ap_inform_ch_switch23a(struct rtw_adapter *padapter, u8 new_ch, u8 ch_of
 
 int rtw_sta_flush23a(struct rtw_adapter *padapter)
 {
-	struct list_head *phead, *plist, *ptmp;
-	struct sta_info *psta;
+	struct list_head *phead;
+	struct sta_info *psta, *ptmp;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
@@ -1676,8 +1670,7 @@ int rtw_sta_flush23a(struct rtw_adapter *padapter)
 	spin_lock_bh(&pstapriv->asoc_list_lock);
 	phead = &pstapriv->asoc_list;
 
-	list_for_each_safe(plist, ptmp, phead) {
-		psta = container_of(plist, struct sta_info, asoc_list);
+	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
 
 		/* Remove sta from asoc_list */
 		list_del_init(&psta->asoc_list);
@@ -1744,9 +1737,9 @@ void rtw_ap_restore_network(struct rtw_adapter *padapter)
 	struct mlme_priv *mlmepriv = &padapter->mlmepriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct sta_priv *pstapriv = &padapter->stapriv;
-	struct sta_info *psta;
+	struct sta_info *psta, *ptmp;
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
-	struct list_head *phead, *plist, *ptmp;
+	struct list_head *phead;
 	u8 chk_alive_num = 0;
 	struct sta_info *chk_alive_list[NUM_STA];
 	int i;
@@ -1778,8 +1771,7 @@ void rtw_ap_restore_network(struct rtw_adapter *padapter)
 
 	phead = &pstapriv->asoc_list;
 
-	list_for_each_safe(plist, ptmp, phead) {
-		psta = container_of(plist, struct sta_info, asoc_list);
+	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
 
 		chk_alive_list[chk_alive_num++] = psta;
 	}
@@ -1841,8 +1833,8 @@ void start_ap_mode23a(struct rtw_adapter *padapter)
 
 void stop_ap_mode23a(struct rtw_adapter *padapter)
 {
-	struct list_head *phead, *plist, *ptmp;
-	struct rtw_wlan_acl_node *paclnode;
+	struct list_head *phead;
+	struct rtw_wlan_acl_node *paclnode, *ptmp;
 	struct sta_info *psta = NULL;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -1865,8 +1857,7 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
 	spin_lock_bh(&pacl_node_q->lock);
 	phead = get_list_head(pacl_node_q);
 
-	list_for_each_safe(plist, ptmp, phead) {
-		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
+	list_for_each_entry_safe(paclnode, ptmp, phead, list) {
 
 		if (paclnode->valid == true) {
 			paclnode->valid = false;
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 3c09ea9..6cc1f33 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -171,8 +171,8 @@ exit:
 
 void rtw_free_network_queue23a(struct rtw_adapter *padapter)
 {
-	struct list_head *phead, *plist, *ptmp;
-	struct wlan_network *pnetwork;
+	struct list_head *phead;
+	struct wlan_network *pnetwork, *ptmp;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct rtw_queue *scanned_queue = &pmlmepriv->scanned_queue;
 
@@ -180,8 +180,7 @@ void rtw_free_network_queue23a(struct rtw_adapter *padapter)
 
 	phead = get_list_head(scanned_queue);
 
-	list_for_each_safe(plist, ptmp, phead) {
-		pnetwork = container_of(plist, struct wlan_network, list);
+	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
 
 		_rtw_free_network23a(pmlmepriv, pnetwork);
 	}
@@ -329,14 +328,13 @@ int is_same_network23a(struct wlan_bssid_ex *src, struct wlan_bssid_ex *dst)
 struct wlan_network *
 rtw_get_oldest_wlan_network23a(struct rtw_queue *scanned_queue)
 {
-	struct list_head *plist, *phead;
+	struct list_head *phead;
 	struct wlan_network *pwlan;
 	struct wlan_network *oldest = NULL;
 
 	phead = get_list_head(scanned_queue);
 
-	list_for_each(plist, phead) {
-		pwlan = container_of(plist, struct wlan_network, list);
+	list_for_each_entry(pwlan, phead, list) {
 
 		if (pwlan->fixed != true) {
 			if (!oldest || time_after(oldest->last_scanned,
@@ -710,17 +708,16 @@ rtw_surveydone_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 
 static void free_scanqueue(struct mlme_priv *pmlmepriv)
 {
-	struct wlan_network *pnetwork;
+	struct wlan_network *pnetwork, *ptemp;
 	struct rtw_queue *scan_queue = &pmlmepriv->scanned_queue;
-	struct list_head *plist, *phead, *ptemp;
+	struct list_head *phead;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_, "+free_scanqueue\n");
 	spin_lock_bh(&scan_queue->lock);
 
 	phead = get_list_head(scan_queue);
 
-	list_for_each_safe(plist, ptemp, phead) {
-		pnetwork = container_of(plist, struct wlan_network, list);
+	list_for_each_entry_safe(pnetwork, ptemp, phead, list) {
 		pnetwork->fixed = false;
 		_rtw_free_network23a(pmlmepriv, pnetwork);
 	}
@@ -1625,15 +1622,14 @@ exit:
 static struct wlan_network *
 rtw_select_candidate_from_queue(struct mlme_priv *pmlmepriv)
 {
-	struct wlan_network *pnetwork, *candidate = NULL;
+	struct wlan_network *pnetwork, *ptmp, *candidate = NULL;
 	struct rtw_queue *queue = &pmlmepriv->scanned_queue;
-	struct list_head *phead, *plist, *ptmp;
+	struct list_head *phead;
 
 	spin_lock_bh(&pmlmepriv->scanned_queue.lock);
 	phead = get_list_head(queue);
 
-	list_for_each_safe(plist, ptmp, phead) {
-		pnetwork = container_of(plist, struct wlan_network, list);
+	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
 		if (!pnetwork) {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 				 "%s: return _FAIL:(pnetwork == NULL)\n",
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index d28f29a..1b94031 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -6082,8 +6082,8 @@ int tx_beacon_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 #ifdef CONFIG_8723AU_AP_MODE
 	else { /* tx bc/mc frames after update TIM */
 		struct sta_info *psta_bmc;
-		struct list_head *plist, *phead, *ptmp;
-		struct xmit_frame *pxmitframe;
+		struct list_head *phead;
+		struct xmit_frame *pxmitframe, *ptmp;
 		struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 		struct sta_priv  *pstapriv = &padapter->stapriv;
 
@@ -6099,10 +6099,8 @@ int tx_beacon_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 
 			phead = get_list_head(&psta_bmc->sleep_q);
 
-			list_for_each_safe(plist, ptmp, phead) {
-				pxmitframe = container_of(plist,
-							  struct xmit_frame,
-							  list);
+			list_for_each_entry_safe(pxmitframe, ptmp,
+						 phead, list) {
 
 				list_del_init(&pxmitframe->list);
 
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 404b618..18b7d03 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -88,13 +88,13 @@ int _rtw_init_recv_priv23a(struct recv_priv *precvpriv,
 void _rtw_free_recv_priv23a (struct recv_priv *precvpriv)
 {
 	struct rtw_adapter *padapter = precvpriv->adapter;
-	struct recv_frame *precvframe;
-	struct list_head *plist, *ptmp;
+	struct recv_frame *precvframe, *ptmp;
 
 	rtw_free_uc_swdec_pending_queue23a(padapter);
 
-	list_for_each_safe(plist, ptmp, &precvpriv->free_recv_queue.queue) {
-		precvframe = container_of(plist, struct recv_frame, list);
+	list_for_each_entry_safe(precvframe, ptmp,
+				 &precvpriv->free_recv_queue.queue,
+				 list) {
 		list_del_init(&precvframe->list);
 		kfree(precvframe);
 	}
@@ -195,16 +195,15 @@ using spinlock to protect
 
 static void rtw_free_recvframe23a_queue(struct rtw_queue *pframequeue)
 {
-	struct recv_frame *hdr;
-	struct list_head *plist, *phead, *ptmp;
+	struct recv_frame *hdr, *ptmp;
+	struct list_head *phead;
 
 	spin_lock(&pframequeue->lock);
 
 	phead = get_list_head(pframequeue);
 	plist = phead->next;
 
-	list_for_each_safe(plist, ptmp, phead) {
-		hdr = container_of(plist, struct recv_frame, list);
+	list_for_each_entry_safe(hdr, ptmp, phead, list) {
 		rtw_free_recvframe23a(hdr);
 	}
 
@@ -1567,10 +1566,10 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 				    struct rtw_queue *defrag_q)
 {
-	struct list_head *plist, *phead, *ptmp;
+	struct list_head *plist, *phead;
 	u8	*data, wlanhdr_offset;
 	u8	curfragnum;
-	struct recv_frame *pnfhdr;
+	struct recv_frame *pnfhdr, *ptmp;
 	struct recv_frame *prframe, *pnextrframe;
 	struct rtw_queue	*pfree_recv_queue;
 	struct sk_buff *skb;
@@ -1601,8 +1600,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 
 	data = prframe->pkt->data;
 
-	list_for_each_safe(plist, ptmp, phead) {
-		pnfhdr = container_of(plist, struct recv_frame, list);
+	list_for_each_entry_safe(pnfhdr, ptmp, phead, list) {
 		pnextrframe = (struct recv_frame *)pnfhdr;
 		/* check the fragment sequence  (2nd ~n fragment frame) */
 
diff --git a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
index b06bff7..232f245 100644
--- a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
@@ -83,8 +83,8 @@ int _rtw_init_sta_priv23a(struct sta_priv *pstapriv)
 
 int _rtw_free_sta_priv23a(struct sta_priv *pstapriv)
 {
-	struct list_head *phead, *plist, *ptmp;
-	struct sta_info *psta;
+	struct list_head *phead;
+	struct sta_info *psta, *ptmp;
 	struct recv_reorder_ctrl *preorder_ctrl;
 	int index;
 
@@ -94,11 +94,9 @@ int _rtw_free_sta_priv23a(struct sta_priv *pstapriv)
 		for (index = 0; index < NUM_STA; index++) {
 			phead = &pstapriv->sta_hash[index];
 
-			list_for_each_safe(plist, ptmp, phead) {
+			list_for_each_entry_safe(psta, ptmp, phead, hash_list) {
 				int i;
 
-				psta = container_of(plist, struct sta_info,
-						    hash_list);
 				for (i = 0; i < 16 ; i++) {
 					preorder_ctrl = &psta->recvreorder_ctrl[i];
 					del_timer_sync(&preorder_ctrl->reordering_ctrl_timer);
@@ -325,8 +323,8 @@ exit:
 /*  free all stainfo which in sta_hash[all] */
 void rtw_free_all_stainfo23a(struct rtw_adapter *padapter)
 {
-	struct list_head *plist, *phead, *ptmp;
-	struct sta_info *psta;
+	struct list_head *phead;
+	struct sta_info *psta, *ptmp;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct sta_info *pbcmc_stainfo = rtw_get_bcmc_stainfo23a(padapter);
 	s32 index;
@@ -339,8 +337,7 @@ void rtw_free_all_stainfo23a(struct rtw_adapter *padapter)
 	for (index = 0; index < NUM_STA; index++) {
 		phead = &pstapriv->sta_hash[index];
 
-		list_for_each_safe(plist, ptmp, phead) {
-			psta = container_of(plist, struct sta_info, hash_list);
+		list_for_each_entry_safe(psta, ptmp, phead, hash_list) {
 
 			if (pbcmc_stainfo != psta)
 				rtw_free_stainfo23a(padapter, psta);
@@ -352,7 +349,7 @@ void rtw_free_all_stainfo23a(struct rtw_adapter *padapter)
 /* any station allocated can be searched by hash list */
 struct sta_info *rtw_get_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr)
 {
-	struct list_head *plist, *phead;
+	struct list_head *phead;
 	struct sta_info *psta = NULL;
 	u32	index;
 	const u8 *addr;
@@ -371,8 +368,7 @@ struct sta_info *rtw_get_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr)
 
 	phead = &pstapriv->sta_hash[index];
 
-	list_for_each(plist, phead) {
-		psta = container_of(plist, struct sta_info, hash_list);
+	list_for_each_entry(psta, phead, hash_list) {
 
 		/*  if found the matched address */
 		if (ether_addr_equal(psta->hwaddr, addr))
@@ -418,7 +414,7 @@ bool rtw_access_ctrl23a(struct rtw_adapter *padapter, u8 *mac_addr)
 {
 	bool res = true;
 #ifdef CONFIG_8723AU_AP_MODE
-	struct list_head *plist, *phead;
+	struct list_head *phead;
 	struct rtw_wlan_acl_node *paclnode;
 	bool match = false;
 	struct sta_priv *pstapriv = &padapter->stapriv;
@@ -428,8 +424,7 @@ bool rtw_access_ctrl23a(struct rtw_adapter *padapter, u8 *mac_addr)
 	spin_lock_bh(&pacl_node_q->lock);
 	phead = get_list_head(pacl_node_q);
 
-	list_for_each(plist, phead) {
-		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
+	list_for_each_entry(paclnode, phead, list) {
 
 		if (ether_addr_equal(paclnode->addr, mac_addr)) {
 			if (paclnode->valid) {
diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index a4b6bb6..668806b 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -196,36 +196,35 @@ fail:
 void _rtw_free_xmit_priv23a (struct xmit_priv *pxmitpriv)
 {
 	struct rtw_adapter *padapter = pxmitpriv->adapter;
-	struct xmit_frame *pxframe;
-	struct xmit_buf *pxmitbuf;
-	struct list_head *plist, *ptmp;
+	struct xmit_frame *pxframe, *ptmp;
+	struct xmit_buf *pxmitbuf, *ptmp2;
 
-	list_for_each_safe(plist, ptmp, &pxmitpriv->free_xmit_queue.queue) {
-		pxframe = container_of(plist, struct xmit_frame, list);
+	list_for_each_entry_safe(pxframe, ptmp,
+				 &pxmitpriv->free_xmit_queue.queue, list) {
 		list_del_init(&pxframe->list);
 		rtw_os_xmit_complete23a(padapter, pxframe);
 		kfree(pxframe);
 	}
 
-	list_for_each_safe(plist, ptmp, &pxmitpriv->xmitbuf_list) {
-		pxmitbuf = container_of(plist, struct xmit_buf, list2);
+	list_for_each_entry_safe(pxmitbuf, ptmp2,
+				 &pxmitpriv->xmitbuf_list, list2) {
 		list_del_init(&pxmitbuf->list2);
 		rtw_os_xmit_resource_free23a(padapter, pxmitbuf);
 		kfree(pxmitbuf);
 	}
 
 	/* free xframe_ext queue,  the same count as extbuf  */
-	list_for_each_safe(plist, ptmp,
-			   &pxmitpriv->free_xframe_ext_queue.queue) {
-		pxframe = container_of(plist, struct xmit_frame, list);
+	list_for_each_entry_safe(pxframe, ptmp,
+				 &pxmitpriv->free_xframe_ext_queue.queue,
+				 list) {
 		list_del_init(&pxframe->list);
 		rtw_os_xmit_complete23a(padapter, pxframe);
 		kfree(pxframe);
 	}
 
 	/*  free xmit extension buff */
-	list_for_each_safe(plist, ptmp, &pxmitpriv->xmitextbuf_list) {
-		pxmitbuf = container_of(plist, struct xmit_buf, list2);
+	list_for_each_entry_safe(pxmitbuf, ptmp2,
+				 &pxmitpriv->xmitextbuf_list, list2) {
 		list_del_init(&pxmitbuf->list2);
 		rtw_os_xmit_resource_free23a(padapter, pxmitbuf);
 		kfree(pxmitbuf);
@@ -1563,15 +1562,14 @@ exit:
 void rtw_free_xmitframe_queue23a(struct xmit_priv *pxmitpriv,
 				 struct rtw_queue *pframequeue)
 {
-	struct list_head *plist, *phead, *ptmp;
-	struct	xmit_frame *pxmitframe;
+	struct list_head *phead;
+	struct xmit_frame *pxmitframe, *ptmp;
 
 	spin_lock_bh(&pframequeue->lock);
 
 	phead = get_list_head(pframequeue);
 
-	list_for_each_safe(plist, ptmp, phead) {
-		pxmitframe = container_of(plist, struct xmit_frame, list);
+	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
 
 		rtw_free_xmitframe23a(pxmitpriv, pxmitframe);
 	}
@@ -1612,9 +1610,9 @@ struct xmit_frame *
 rtw_dequeue_xframe23a(struct xmit_priv *pxmitpriv, struct hw_xmit *phwxmit_i,
 		   int entry)
 {
-	struct list_head *sta_plist, *sta_phead, *ptmp;
+	struct list_head *sta_phead;
 	struct hw_xmit *phwxmit;
-	struct tx_servq *ptxservq = NULL;
+	struct tx_servq *ptxservq = NULL, *ptmp;
 	struct rtw_queue *pframe_queue = NULL;
 	struct xmit_frame *pxmitframe = NULL;
 	struct rtw_adapter *padapter = pxmitpriv->adapter;
@@ -1639,9 +1637,8 @@ rtw_dequeue_xframe23a(struct xmit_priv *pxmitpriv, struct hw_xmit *phwxmit_i,
 
 		sta_phead = get_list_head(phwxmit->sta_queue);
 
-		list_for_each_safe(sta_plist, ptmp, sta_phead) {
-			ptxservq = container_of(sta_plist, struct tx_servq,
-						tx_pending);
+		list_for_each_entry_safe(ptxservq, ptmp, sta_phead,
+					 tx_pending) {
 
 			pframe_queue = &ptxservq->sta_pending;
 
@@ -2052,17 +2049,16 @@ dequeue_xmitframes_to_sleeping_queue(struct rtw_adapter *padapter,
 				     struct rtw_queue *pframequeue)
 {
 	int ret;
-	struct list_head *plist, *phead, *ptmp;
+	struct list_head *phead;
 	u8	ac_index;
 	struct tx_servq	*ptxservq;
 	struct pkt_attrib	*pattrib;
-	struct xmit_frame	*pxmitframe;
+	struct xmit_frame	*pxmitframe, *ptmp;
 	struct hw_xmit *phwxmits =  padapter->xmitpriv.hwxmits;
 
 	phead = get_list_head(pframequeue);
 
-	list_for_each_safe(plist, ptmp, phead) {
-		pxmitframe = container_of(plist, struct xmit_frame, list);
+	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
 
 		ret = xmitframe_enqueue_for_sleeping_sta23a(padapter, pxmitframe);
 
@@ -2124,8 +2120,8 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
 {
 	u8 update_mask = 0, wmmps_ac = 0;
 	struct sta_info *psta_bmc;
-	struct list_head *plist, *phead, *ptmp;
-	struct xmit_frame *pxmitframe = NULL;
+	struct list_head *phead;
+	struct xmit_frame *pxmitframe = NULL, *ptmp;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
@@ -2133,8 +2129,7 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
 
 	phead = get_list_head(&psta->sleep_q);
 
-	list_for_each_safe(plist, ptmp, phead) {
-		pxmitframe = container_of(plist, struct xmit_frame, list);
+	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
 		list_del_init(&pxmitframe->list);
 
 		switch (pxmitframe->attrib.priority) {
@@ -2209,9 +2204,7 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
 
 		phead = get_list_head(&psta_bmc->sleep_q);
 
-		list_for_each_safe(plist, ptmp, phead) {
-			pxmitframe = container_of(plist, struct xmit_frame,
-						  list);
+		list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
 
 			list_del_init(&pxmitframe->list);
 
@@ -2245,8 +2238,8 @@ void xmit_delivery_enabled_frames23a(struct rtw_adapter *padapter,
 				  struct sta_info *psta)
 {
 	u8 wmmps_ac = 0;
-	struct list_head *plist, *phead, *ptmp;
-	struct xmit_frame *pxmitframe;
+	struct list_head *phead;
+	struct xmit_frame *pxmitframe, *ptmp;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
@@ -2255,8 +2248,7 @@ void xmit_delivery_enabled_frames23a(struct rtw_adapter *padapter,
 
 	phead = get_list_head(&psta->sleep_q);
 
-	list_for_each_safe(plist, ptmp, phead) {
-		pxmitframe = container_of(plist, struct xmit_frame, list);
+	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
 
 		switch (pxmitframe->attrib.priority) {
 		case 1:
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 0ae2180..26cb279 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1270,17 +1270,16 @@ void rtw_cfg80211_indicate_scan_done(struct rtw_wdev_priv *pwdev_priv,
 
 void rtw_cfg80211_surveydone_event_callback(struct rtw_adapter *padapter)
 {
-	struct list_head *plist, *phead, *ptmp;
+	struct list_head *phead;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct rtw_queue *queue = &pmlmepriv->scanned_queue;
-	struct wlan_network *pnetwork;
+	struct wlan_network *pnetwork, *ptmp;
 
 	spin_lock_bh(&pmlmepriv->scanned_queue.lock);
 
 	phead = get_list_head(queue);
 
-	list_for_each_safe(plist, ptmp, phead) {
-		pnetwork = container_of(plist, struct wlan_network, list);
+	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
 
 		/* report network only if the current channel set
 		   contains the channel to which this network belongs */
@@ -2850,9 +2849,9 @@ static int cfg80211_rtw_del_station(struct wiphy *wiphy,
 {
 	const u8 *mac = params->mac;
 	int ret = 0;
-	struct list_head *phead, *plist, *ptmp;
+	struct list_head *phead;
 	u8 updated = 0;
-	struct sta_info *psta;
+	struct sta_info *psta, *ptmp;
 	struct rtw_adapter *padapter = netdev_priv(ndev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct sta_priv *pstapriv = &padapter->stapriv;
@@ -2885,8 +2884,7 @@ static int cfg80211_rtw_del_station(struct wiphy *wiphy,
 	phead = &pstapriv->asoc_list;
 
 	/* check asoc_queue */
-	list_for_each_safe(plist, ptmp, phead) {
-		psta = container_of(plist, struct sta_info, asoc_list);
+	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
 
 		if (ether_addr_equal(mac, psta->hwaddr)) {
 			if (psta->dot8021xalg == 1 &&
diff --git a/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c b/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
index 0cdaef0..cf4a506 100644
--- a/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
@@ -210,22 +210,21 @@ exit:
 void rtl8723au_write_port_cancel(struct rtw_adapter *padapter)
 {
 	struct xmit_buf *pxmitbuf;
-	struct list_head *plist;
 	int j;
 
 	DBG_8723A("%s\n", __func__);
 
 	padapter->bWritePortCancel = true;
 
-	list_for_each(plist, &padapter->xmitpriv.xmitbuf_list) {
-		pxmitbuf = container_of(plist, struct xmit_buf, list2);
+	list_for_each_entry(pxmitbuf, &padapter->xmitpriv.xmitbuf_list,
+			    list2) {
 		for (j = 0; j < 8; j++) {
 			if (pxmitbuf->pxmit_urb[j])
 				usb_kill_urb(pxmitbuf->pxmit_urb[j]);
 		}
 	}
-	list_for_each(plist, &padapter->xmitpriv.xmitextbuf_list) {
-		pxmitbuf = container_of(plist, struct xmit_buf, list2);
+	list_for_each_entry(pxmitbuf, &padapter->xmitpriv.xmitextbuf_list,
+			    list2) {
 		for (j = 0; j < 8; j++) {
 			if (pxmitbuf->pxmit_urb[j])
 				usb_kill_urb(pxmitbuf->pxmit_urb[j]);
-- 
2.5.0


