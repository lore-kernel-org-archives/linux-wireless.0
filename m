Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:46621 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbcBGDbF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 22:31:05 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] staging: rtl8723au: whitespace and blank line cleaning
Date: Sun,  7 Feb 2016 11:30:00 +0800
Message-Id: <2c43b083b87c55fd061f453e8e9c4caaf87c66b7.1454815347.git.geliangtang@163.com> (sfid-20160207_043201_808316_8CA09DD9)
In-Reply-To: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com>
References: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com>
In-Reply-To: <eab3a03d1254ca4e8089a72fdd31620b35d8f46f.1454815347.git.geliangtang@163.com>
References: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com> <eab3a03d1254ca4e8089a72fdd31620b35d8f46f.1454815347.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans whitespaces and blank lines surrounding
list_for_each_entry*().

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
Changes in v3:
 - split it into three patches.
Changes in v2:
 - drop the coding style fixing in v1.
---
 drivers/staging/rtl8723au/core/rtw_ap.c           | 41 ++---------------------
 drivers/staging/rtl8723au/core/rtw_mlme.c         | 14 +-------
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c     |  3 +-
 drivers/staging/rtl8723au/core/rtw_recv.c         | 18 +++-------
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c      | 11 +-----
 drivers/staging/rtl8723au/core/rtw_xmit.c         | 30 ++++-------------
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c |  8 -----
 7 files changed, 17 insertions(+), 108 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index 4bcd617..ce4b589 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -171,7 +171,7 @@ static u8 chk_sta_is_alive(struct sta_info *psta)
 	return ret;
 }
 
-void	expire_timeout_chk23a(struct rtw_adapter *padapter)
+void expire_timeout_chk23a(struct rtw_adapter *padapter)
 {
 	struct list_head *phead;
 	u8 updated = 0;
@@ -182,12 +182,9 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 	int i;
 
 	spin_lock_bh(&pstapriv->auth_list_lock);
-
 	phead = &pstapriv->auth_list;
-
 	/* check auth_queue */
 	list_for_each_entry_safe(psta, ptmp, phead, auth_list) {
-
 		if (psta->expire_to > 0) {
 			psta->expire_to--;
 			if (psta->expire_to == 0) {
@@ -205,18 +202,13 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 				spin_lock_bh(&pstapriv->auth_list_lock);
 			}
 		}
-
 	}
-
 	spin_unlock_bh(&pstapriv->auth_list_lock);
 
 	spin_lock_bh(&pstapriv->asoc_list_lock);
-
 	phead = &pstapriv->asoc_list;
-
 	/* check asoc_queue */
 	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
-
 		if (chk_sta_is_alive(psta) || !psta->expire_to) {
 			psta->expire_to = pstapriv->expire_to;
 			psta->keep_alive_trycnt = 0;
@@ -281,7 +273,6 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
 			}
 		}
 	}
-
 	spin_unlock_bh(&pstapriv->asoc_list_lock);
 
 	if (chk_alive_num) {
@@ -1071,11 +1062,8 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
 		return -1;
 
 	spin_lock_bh(&pacl_node_q->lock);
-
 	phead = get_list_head(pacl_node_q);
-
 	list_for_each_entry(paclnode, phead, list) {
-
 		if (!memcmp(paclnode->addr, addr, ETH_ALEN)) {
 			if (paclnode->valid == true) {
 				added = true;
@@ -1084,7 +1072,6 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
 			}
 		}
 	}
-
 	spin_unlock_bh(&pacl_node_q->lock);
 
 	if (added)
@@ -1127,11 +1114,8 @@ int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
 	DBG_8723A("%s(acl_num =%d) = %pM\n", __func__, pacl_list->num, addr);
 
 	spin_lock_bh(&pacl_node_q->lock);
-
 	phead = get_list_head(pacl_node_q);
-
 	list_for_each_entry_safe(paclnode, ptmp, phead, list) {
-
 		if (!memcmp(paclnode->addr, addr, ETH_ALEN)) {
 			if (paclnode->valid) {
 				paclnode->valid = false;
@@ -1142,7 +1126,6 @@ int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
 			}
 		}
 	}
-
 	spin_unlock_bh(&pacl_node_q->lock);
 
 	DBG_8723A("%s, acl_num =%d\n", __func__, pacl_list->num);
@@ -1355,14 +1338,9 @@ void associated_clients_update23a(struct rtw_adapter *padapter, u8 updated)
 		struct sta_priv *pstapriv = &padapter->stapriv;
 
 		spin_lock_bh(&pstapriv->asoc_list_lock);
-
 		phead = &pstapriv->asoc_list;
-
-		list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
-
+		list_for_each_entry_safe(psta, ptmp, phead, asoc_list)
 			VCS_update23a(padapter, psta);
-		}
-
 		spin_unlock_bh(&pstapriv->asoc_list_lock);
 	}
 }
@@ -1637,9 +1615,7 @@ int rtw_ap_inform_ch_switch23a(struct rtw_adapter *padapter, u8 new_ch, u8 ch_of
 
 	spin_lock_bh(&pstapriv->asoc_list_lock);
 	phead = &pstapriv->asoc_list;
-
 	list_for_each_entry(psta, phead, asoc_list) {
-
 		issue_action_spct_ch_switch23a(padapter, psta->hwaddr, new_ch, ch_offset);
 		psta->expire_to = ((pstapriv->expire_to * 2) > 5) ? 5 : (pstapriv->expire_to * 2);
 	}
@@ -1669,9 +1645,7 @@ int rtw_sta_flush23a(struct rtw_adapter *padapter)
 
 	spin_lock_bh(&pstapriv->asoc_list_lock);
 	phead = &pstapriv->asoc_list;
-
 	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
-
 		/* Remove sta from asoc_list */
 		list_del_init(&psta->asoc_list);
 		pstapriv->asoc_list_cnt--;
@@ -1768,14 +1742,9 @@ void rtw_ap_restore_network(struct rtw_adapter *padapter)
 	}
 
 	spin_lock_bh(&pstapriv->asoc_list_lock);
-
 	phead = &pstapriv->asoc_list;
-
-	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
-
+	list_for_each_entry_safe(psta, ptmp, phead, asoc_list)
 		chk_alive_list[chk_alive_num++] = psta;
-	}
-
 	spin_unlock_bh(&pstapriv->asoc_list_lock);
 
 	for (i = 0; i < chk_alive_num; i++) {
@@ -1856,14 +1825,10 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
 	/* for ACL */
 	spin_lock_bh(&pacl_node_q->lock);
 	phead = get_list_head(pacl_node_q);
-
 	list_for_each_entry_safe(paclnode, ptmp, phead, list) {
-
 		if (paclnode->valid == true) {
 			paclnode->valid = false;
-
 			list_del_init(&paclnode->list);
-
 			pacl_list->num--;
 		}
 	}
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 6cc1f33..3adda55 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -177,14 +177,9 @@ void rtw_free_network_queue23a(struct rtw_adapter *padapter)
 	struct rtw_queue *scanned_queue = &pmlmepriv->scanned_queue;
 
 	spin_lock_bh(&scanned_queue->lock);
-
 	phead = get_list_head(scanned_queue);
-
-	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
-
+	list_for_each_entry_safe(pnetwork, ptmp, phead, list)
 		_rtw_free_network23a(pmlmepriv, pnetwork);
-	}
-
 	spin_unlock_bh(&scanned_queue->lock);
 }
 
@@ -333,9 +328,7 @@ rtw_get_oldest_wlan_network23a(struct rtw_queue *scanned_queue)
 	struct wlan_network *oldest = NULL;
 
 	phead = get_list_head(scanned_queue);
-
 	list_for_each_entry(pwlan, phead, list) {
-
 		if (pwlan->fixed != true) {
 			if (!oldest || time_after(oldest->last_scanned,
 						  pwlan->last_scanned))
@@ -443,7 +436,6 @@ static void rtw_update_scanned_network(struct rtw_adapter *adapter,
 
 	spin_lock_bh(&queue->lock);
 	phead = get_list_head(queue);
-
 	list_for_each(plist, phead) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 
@@ -714,14 +706,11 @@ static void free_scanqueue(struct mlme_priv *pmlmepriv)
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_, "+free_scanqueue\n");
 	spin_lock_bh(&scan_queue->lock);
-
 	phead = get_list_head(scan_queue);
-
 	list_for_each_entry_safe(pnetwork, ptemp, phead, list) {
 		pnetwork->fixed = false;
 		_rtw_free_network23a(pmlmepriv, pnetwork);
 	}
-
 	spin_unlock_bh(&scan_queue->lock);
 }
 
@@ -1628,7 +1617,6 @@ rtw_select_candidate_from_queue(struct mlme_priv *pmlmepriv)
 
 	spin_lock_bh(&pmlmepriv->scanned_queue.lock);
 	phead = get_list_head(queue);
-
 	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
 		if (!pnetwork) {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index 1b94031..61fbd10 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -6085,7 +6085,7 @@ int tx_beacon_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 		struct list_head *phead;
 		struct xmit_frame *pxmitframe, *ptmp;
 		struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
-		struct sta_priv  *pstapriv = &padapter->stapriv;
+		struct sta_priv *pstapriv = &padapter->stapriv;
 
 		/* for BC/MC Frames */
 		psta_bmc = rtw_get_bcmc_stainfo23a(padapter);
@@ -6117,7 +6117,6 @@ int tx_beacon_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 				rtl8723au_hal_xmitframe_enqueue(padapter,
 								pxmitframe);
 			}
-
 			/* spin_unlock_bh(&psta_bmc->sleep_q.lock); */
 			spin_unlock_bh(&pxmitpriv->lock);
 		}
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index b36bc6b..de1226e 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -85,7 +85,7 @@ int _rtw_init_recv_priv23a(struct recv_priv *precvpriv,
 	return res;
 }
 
-void _rtw_free_recv_priv23a (struct recv_priv *precvpriv)
+void _rtw_free_recv_priv23a(struct recv_priv *precvpriv)
 {
 	struct rtw_adapter *padapter = precvpriv->adapter;
 	struct recv_frame *precvframe, *ptmp;
@@ -199,13 +199,9 @@ static void rtw_free_recvframe23a_queue(struct rtw_queue *pframequeue)
 	struct list_head *phead;
 
 	spin_lock(&pframequeue->lock);
-
 	phead = get_list_head(pframequeue);
-
-	list_for_each_entry_safe(hdr, ptmp, phead, list) {
+	list_for_each_entry_safe(hdr, ptmp, phead, list)
 		rtw_free_recvframe23a(hdr);
-	}
-
 	spin_unlock(&pframequeue->lock);
 }
 
@@ -1566,15 +1562,13 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 				    struct rtw_queue *defrag_q)
 {
 	struct list_head *plist, *phead;
-	u8	wlanhdr_offset;
-	u8	curfragnum;
+	u8 wlanhdr_offset;
+	u8 curfragnum;
 	struct recv_frame *pnfhdr, *ptmp;
 	struct recv_frame *prframe, *pnextrframe;
-	struct rtw_queue	*pfree_recv_queue;
+	struct rtw_queue *pfree_recv_queue;
 	struct sk_buff *skb;
 
-
-
 	curfragnum = 0;
 	pfree_recv_queue = &adapter->recvpriv.free_recv_queue;
 
@@ -1637,8 +1631,6 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 	RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
 		 "Performance defrag!!!!!\n");
 
-
-
 	return prframe;
 }
 
diff --git a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
index 232f245..22d857b 100644
--- a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
@@ -93,7 +93,6 @@ int _rtw_free_sta_priv23a(struct sta_priv *pstapriv)
 		spin_lock_bh(&pstapriv->sta_hash_lock);
 		for (index = 0; index < NUM_STA; index++) {
 			phead = &pstapriv->sta_hash[index];
-
 			list_for_each_entry_safe(psta, ptmp, phead, hash_list) {
 				int i;
 
@@ -333,12 +332,9 @@ void rtw_free_all_stainfo23a(struct rtw_adapter *padapter)
 		return;
 
 	spin_lock_bh(&pstapriv->sta_hash_lock);
-
 	for (index = 0; index < NUM_STA; index++) {
 		phead = &pstapriv->sta_hash[index];
-
 		list_for_each_entry_safe(psta, ptmp, phead, hash_list) {
-
 			if (pbcmc_stainfo != psta)
 				rtw_free_stainfo23a(padapter, psta);
 		}
@@ -351,7 +347,7 @@ struct sta_info *rtw_get_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr)
 {
 	struct list_head *phead;
 	struct sta_info *psta = NULL;
-	u32	index;
+	u32 index;
 	const u8 *addr;
 
 	if (hwaddr == NULL)
@@ -365,11 +361,8 @@ struct sta_info *rtw_get_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr)
 	index = wifi_mac_hash(addr);
 
 	spin_lock_bh(&pstapriv->sta_hash_lock);
-
 	phead = &pstapriv->sta_hash[index];
-
 	list_for_each_entry(psta, phead, hash_list) {
-
 		/*  if found the matched address */
 		if (ether_addr_equal(psta->hwaddr, addr))
 			break;
@@ -423,9 +416,7 @@ bool rtw_access_ctrl23a(struct rtw_adapter *padapter, u8 *mac_addr)
 
 	spin_lock_bh(&pacl_node_q->lock);
 	phead = get_list_head(pacl_node_q);
-
 	list_for_each_entry(paclnode, phead, list) {
-
 		if (ether_addr_equal(paclnode->addr, mac_addr)) {
 			if (paclnode->valid) {
 				match = true;
diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index 668806b..b82b182 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -193,7 +193,7 @@ fail:
 	goto exit;
 }
 
-void _rtw_free_xmit_priv23a (struct xmit_priv *pxmitpriv)
+void _rtw_free_xmit_priv23a(struct xmit_priv *pxmitpriv)
 {
 	struct rtw_adapter *padapter = pxmitpriv->adapter;
 	struct xmit_frame *pxframe, *ptmp;
@@ -1566,13 +1566,9 @@ void rtw_free_xmitframe_queue23a(struct xmit_priv *pxmitpriv,
 	struct xmit_frame *pxmitframe, *ptmp;
 
 	spin_lock_bh(&pframequeue->lock);
-
 	phead = get_list_head(pframequeue);
-
-	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
-
+	list_for_each_entry_safe(pxmitframe, ptmp, phead, list)
 		rtw_free_xmitframe23a(pxmitpriv, pxmitframe);
-	}
 	spin_unlock_bh(&pframequeue->lock);
 
 }
@@ -1636,10 +1632,8 @@ rtw_dequeue_xframe23a(struct xmit_priv *pxmitpriv, struct hw_xmit *phwxmit_i,
 		phwxmit = phwxmit_i + inx[i];
 
 		sta_phead = get_list_head(phwxmit->sta_queue);
-
 		list_for_each_entry_safe(ptxservq, ptmp, sta_phead,
 					 tx_pending) {
-
 			pframe_queue = &ptxservq->sta_pending;
 
 			pxmitframe = dequeue_one_xmitframe(pxmitpriv, phwxmit, ptxservq, pframe_queue);
@@ -2050,16 +2044,14 @@ dequeue_xmitframes_to_sleeping_queue(struct rtw_adapter *padapter,
 {
 	int ret;
 	struct list_head *phead;
-	u8	ac_index;
+	u8 ac_index;
 	struct tx_servq	*ptxservq;
-	struct pkt_attrib	*pattrib;
-	struct xmit_frame	*pxmitframe, *ptmp;
-	struct hw_xmit *phwxmits =  padapter->xmitpriv.hwxmits;
+	struct pkt_attrib *pattrib;
+	struct xmit_frame *pxmitframe, *ptmp;
+	struct hw_xmit *phwxmits = padapter->xmitpriv.hwxmits;
 
 	phead = get_list_head(pframequeue);
-
 	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
-
 		ret = xmitframe_enqueue_for_sleeping_sta23a(padapter, pxmitframe);
 
 		if (ret == true) {
@@ -2126,9 +2118,7 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
 	spin_lock_bh(&pxmitpriv->lock);
-
 	phead = get_list_head(&psta->sleep_q);
-
 	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
 		list_del_init(&pxmitframe->list);
 
@@ -2189,7 +2179,6 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
 
 		pstapriv->sta_dz_bitmap &= ~CHKBIT(psta->aid);
 	}
-
 	/* spin_unlock_bh(&psta->sleep_q.lock); */
 	spin_unlock_bh(&pxmitpriv->lock);
 
@@ -2201,11 +2190,8 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
 	if ((pstapriv->sta_dz_bitmap&0xfffe) == 0x0) {
 		/* no any sta in ps mode */
 		spin_lock_bh(&pxmitpriv->lock);
-
 		phead = get_list_head(&psta_bmc->sleep_q);
-
 		list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
-
 			list_del_init(&pxmitframe->list);
 
 			psta_bmc->sleepq_len--;
@@ -2225,7 +2211,6 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
 			/* update_BCNTIM(padapter); */
 			update_mask |= BIT(1);
 		}
-
 		/* spin_unlock_bh(&psta_bmc->sleep_q.lock); */
 		spin_unlock_bh(&pxmitpriv->lock);
 	}
@@ -2245,11 +2230,8 @@ void xmit_delivery_enabled_frames23a(struct rtw_adapter *padapter,
 
 	/* spin_lock_bh(&psta->sleep_q.lock); */
 	spin_lock_bh(&pxmitpriv->lock);
-
 	phead = get_list_head(&psta->sleep_q);
-
 	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
-
 		switch (pxmitframe->attrib.priority) {
 		case 1:
 		case 2:
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 26cb279..908b84c 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1276,11 +1276,8 @@ void rtw_cfg80211_surveydone_event_callback(struct rtw_adapter *padapter)
 	struct wlan_network *pnetwork, *ptmp;
 
 	spin_lock_bh(&pmlmepriv->scanned_queue.lock);
-
 	phead = get_list_head(queue);
-
 	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
-
 		/* report network only if the current channel set
 		   contains the channel to which this network belongs */
 		if (rtw_ch_set_search_ch23a
@@ -1288,7 +1285,6 @@ void rtw_cfg80211_surveydone_event_callback(struct rtw_adapter *padapter)
 		     pnetwork->network.DSConfig) >= 0)
 			rtw_cfg80211_inform_bss(padapter, pnetwork);
 	}
-
 	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
 	/* call this after other things have been done */
@@ -2880,12 +2876,9 @@ static int cfg80211_rtw_del_station(struct wiphy *wiphy,
 		return -EINVAL;
 
 	spin_lock_bh(&pstapriv->asoc_list_lock);
-
 	phead = &pstapriv->asoc_list;
-
 	/* check asoc_queue */
 	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
-
 		if (ether_addr_equal(mac, psta->hwaddr)) {
 			if (psta->dot8021xalg == 1 &&
 			    psta->bpairwise_key_installed == false) {
@@ -2910,7 +2903,6 @@ static int cfg80211_rtw_del_station(struct wiphy *wiphy,
 			}
 		}
 	}
-
 	spin_unlock_bh(&pstapriv->asoc_list_lock);
 
 	associated_clients_update23a(padapter, updated);
-- 
2.5.0


