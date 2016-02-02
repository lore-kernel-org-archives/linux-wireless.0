Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbcBBUa7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 15:30:59 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Geliang Tang <geliangtang@163.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8723au: use list_for_each_entry*()
References: <89753e627161eacd4e5a718353f82fdde0ccb842.1454335082.git.geliangtang@163.com>
Date: Tue, 02 Feb 2016 15:30:57 -0500
In-Reply-To: <89753e627161eacd4e5a718353f82fdde0ccb842.1454335082.git.geliangtang@163.com>
	(Geliang Tang's message of "Mon, 1 Feb 2016 22:10:10 +0800")
Message-ID: <wrfjk2mmsvlq.fsf@redhat.com> (sfid-20160202_213121_870987_6E309B8A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geliang Tang <geliangtang@163.com> writes:
> Use list_for_each_entry*() instead of list_for_each*() to simplify
> the code.
>
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> ---
> Changes in v2:
>  - drop the coding style fixing in v1.
> ---
>  drivers/staging/rtl8723au/core/rtw_ap.c           | 92 ++++++-----------------
>  drivers/staging/rtl8723au/core/rtw_mlme.c         | 38 +++-------
>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c     | 15 +---
>  drivers/staging/rtl8723au/core/rtw_recv.c         | 43 ++++-------
>  drivers/staging/rtl8723au/core/rtw_sta_mgt.c      | 36 +++------
>  drivers/staging/rtl8723au/core/rtw_xmit.c         | 90 ++++++++--------------
>  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 22 ++----
>  drivers/staging/rtl8723au/os_dep/usb_ops_linux.c  |  9 +--
>  8 files changed, 106 insertions(+), 239 deletions(-)

You still include too much whitespace and blank line cleaning with the
actual code changes. Please split this into two patches, one that
changes the code, and one that does the whitespace cleanups.

Jes

>
> diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
> index 1aa9b26..ce4b589 100644
> --- a/drivers/staging/rtl8723au/core/rtw_ap.c
> +++ b/drivers/staging/rtl8723au/core/rtw_ap.c
> @@ -171,24 +171,20 @@ static u8 chk_sta_is_alive(struct sta_info *psta)
>  	return ret;
>  }
>  
> -void	expire_timeout_chk23a(struct rtw_adapter *padapter)
> +void expire_timeout_chk23a(struct rtw_adapter *padapter)
>  {
> -	struct list_head *phead, *plist, *ptmp;
> +	struct list_head *phead;
>  	u8 updated = 0;
> -	struct sta_info *psta;
> +	struct sta_info *psta, *ptmp;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
>  	u8 chk_alive_num = 0;
>  	struct sta_info *chk_alive_list[NUM_STA];
>  	int i;
>  
>  	spin_lock_bh(&pstapriv->auth_list_lock);
> -
>  	phead = &pstapriv->auth_list;
> -
>  	/* check auth_queue */
> -	list_for_each_safe(plist, ptmp, phead) {
> -		psta = container_of(plist, struct sta_info, auth_list);
> -
> +	list_for_each_entry_safe(psta, ptmp, phead, auth_list) {
>  		if (psta->expire_to > 0) {
>  			psta->expire_to--;
>  			if (psta->expire_to == 0) {
> @@ -206,19 +202,13 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
>  				spin_lock_bh(&pstapriv->auth_list_lock);
>  			}
>  		}
> -
>  	}
> -
>  	spin_unlock_bh(&pstapriv->auth_list_lock);
>  
>  	spin_lock_bh(&pstapriv->asoc_list_lock);
> -
>  	phead = &pstapriv->asoc_list;
> -
>  	/* check asoc_queue */
> -	list_for_each_safe(plist, ptmp, phead) {
> -		psta = container_of(plist, struct sta_info, asoc_list);
> -
> +	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
>  		if (chk_sta_is_alive(psta) || !psta->expire_to) {
>  			psta->expire_to = pstapriv->expire_to;
>  			psta->keep_alive_trycnt = 0;
> @@ -283,7 +273,6 @@ void	expire_timeout_chk23a(struct rtw_adapter *padapter)
>  			}
>  		}
>  	}
> -
>  	spin_unlock_bh(&pstapriv->asoc_list_lock);
>  
>  	if (chk_alive_num) {
> @@ -1059,7 +1048,7 @@ void rtw_set_macaddr_acl23a(struct rtw_adapter *padapter, int mode)
>  
>  int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
>  {
> -	struct list_head *plist, *phead;
> +	struct list_head *phead;
>  	u8 added = false;
>  	int i, ret = 0;
>  	struct rtw_wlan_acl_node *paclnode;
> @@ -1073,12 +1062,8 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
>  		return -1;
>  
>  	spin_lock_bh(&pacl_node_q->lock);
> -
>  	phead = get_list_head(pacl_node_q);
> -
> -	list_for_each(plist, phead) {
> -		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
> -
> +	list_for_each_entry(paclnode, phead, list) {
>  		if (!memcmp(paclnode->addr, addr, ETH_ALEN)) {
>  			if (paclnode->valid == true) {
>  				added = true;
> @@ -1087,7 +1072,6 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
>  			}
>  		}
>  	}
> -
>  	spin_unlock_bh(&pacl_node_q->lock);
>  
>  	if (added)
> @@ -1121,8 +1105,8 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
>  
>  int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
>  {
> -	struct list_head *plist, *phead, *ptmp;
> -	struct rtw_wlan_acl_node *paclnode;
> +	struct list_head *phead;
> +	struct rtw_wlan_acl_node *paclnode, *ptmp;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
>  	struct wlan_acl_pool *pacl_list = &pstapriv->acl_list;
>  	struct rtw_queue *pacl_node_q = &pacl_list->acl_node_q;
> @@ -1130,12 +1114,8 @@ int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
>  	DBG_8723A("%s(acl_num =%d) = %pM\n", __func__, pacl_list->num, addr);
>  
>  	spin_lock_bh(&pacl_node_q->lock);
> -
>  	phead = get_list_head(pacl_node_q);
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
> -
> +	list_for_each_entry_safe(paclnode, ptmp, phead, list) {
>  		if (!memcmp(paclnode->addr, addr, ETH_ALEN)) {
>  			if (paclnode->valid) {
>  				paclnode->valid = false;
> @@ -1146,7 +1126,6 @@ int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
>  			}
>  		}
>  	}
> -
>  	spin_unlock_bh(&pacl_node_q->lock);
>  
>  	DBG_8723A("%s, acl_num =%d\n", __func__, pacl_list->num);
> @@ -1354,20 +1333,14 @@ void associated_clients_update23a(struct rtw_adapter *padapter, u8 updated)
>  {
>  	/* update associated stations cap. */
>  	if (updated == true) {
> -		struct list_head *phead, *plist, *ptmp;
> -		struct sta_info *psta;
> +		struct list_head *phead;
> +		struct sta_info *psta, *ptmp;
>  		struct sta_priv *pstapriv = &padapter->stapriv;
>  
>  		spin_lock_bh(&pstapriv->asoc_list_lock);
> -
>  		phead = &pstapriv->asoc_list;
> -
> -		list_for_each_safe(plist, ptmp, phead) {
> -			psta = container_of(plist, struct sta_info, asoc_list);
> -
> +		list_for_each_entry_safe(psta, ptmp, phead, asoc_list)
>  			VCS_update23a(padapter, psta);
> -		}
> -
>  		spin_unlock_bh(&pstapriv->asoc_list_lock);
>  	}
>  }
> @@ -1627,7 +1600,7 @@ u8 ap_free_sta23a(struct rtw_adapter *padapter, struct sta_info *psta, bool acti
>  
>  int rtw_ap_inform_ch_switch23a(struct rtw_adapter *padapter, u8 new_ch, u8 ch_offset)
>  {
> -	struct list_head *phead, *plist;
> +	struct list_head *phead;
>  	struct sta_info *psta = NULL;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
>  	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
> @@ -1642,10 +1615,7 @@ int rtw_ap_inform_ch_switch23a(struct rtw_adapter *padapter, u8 new_ch, u8 ch_of
>  
>  	spin_lock_bh(&pstapriv->asoc_list_lock);
>  	phead = &pstapriv->asoc_list;
> -
> -	list_for_each(plist, phead) {
> -		psta = container_of(plist, struct sta_info, asoc_list);
> -
> +	list_for_each_entry(psta, phead, asoc_list) {
>  		issue_action_spct_ch_switch23a(padapter, psta->hwaddr, new_ch, ch_offset);
>  		psta->expire_to = ((pstapriv->expire_to * 2) > 5) ? 5 : (pstapriv->expire_to * 2);
>  	}
> @@ -1658,8 +1628,8 @@ int rtw_ap_inform_ch_switch23a(struct rtw_adapter *padapter, u8 new_ch, u8 ch_of
>  
>  int rtw_sta_flush23a(struct rtw_adapter *padapter)
>  {
> -	struct list_head *phead, *plist, *ptmp;
> -	struct sta_info *psta;
> +	struct list_head *phead;
> +	struct sta_info *psta, *ptmp;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
>  	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
>  	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
> @@ -1675,10 +1645,7 @@ int rtw_sta_flush23a(struct rtw_adapter *padapter)
>  
>  	spin_lock_bh(&pstapriv->asoc_list_lock);
>  	phead = &pstapriv->asoc_list;
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		psta = container_of(plist, struct sta_info, asoc_list);
> -
> +	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
>  		/* Remove sta from asoc_list */
>  		list_del_init(&psta->asoc_list);
>  		pstapriv->asoc_list_cnt--;
> @@ -1744,9 +1711,9 @@ void rtw_ap_restore_network(struct rtw_adapter *padapter)
>  	struct mlme_priv *mlmepriv = &padapter->mlmepriv;
>  	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
> -	struct sta_info *psta;
> +	struct sta_info *psta, *ptmp;
>  	struct security_priv *psecuritypriv = &padapter->securitypriv;
> -	struct list_head *phead, *plist, *ptmp;
> +	struct list_head *phead;
>  	u8 chk_alive_num = 0;
>  	struct sta_info *chk_alive_list[NUM_STA];
>  	int i;
> @@ -1775,15 +1742,9 @@ void rtw_ap_restore_network(struct rtw_adapter *padapter)
>  	}
>  
>  	spin_lock_bh(&pstapriv->asoc_list_lock);
> -
>  	phead = &pstapriv->asoc_list;
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		psta = container_of(plist, struct sta_info, asoc_list);
> -
> +	list_for_each_entry_safe(psta, ptmp, phead, asoc_list)
>  		chk_alive_list[chk_alive_num++] = psta;
> -	}
> -
>  	spin_unlock_bh(&pstapriv->asoc_list_lock);
>  
>  	for (i = 0; i < chk_alive_num; i++) {
> @@ -1841,8 +1802,8 @@ void start_ap_mode23a(struct rtw_adapter *padapter)
>  
>  void stop_ap_mode23a(struct rtw_adapter *padapter)
>  {
> -	struct list_head *phead, *plist, *ptmp;
> -	struct rtw_wlan_acl_node *paclnode;
> +	struct list_head *phead;
> +	struct rtw_wlan_acl_node *paclnode, *ptmp;
>  	struct sta_info *psta = NULL;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
>  	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
> @@ -1864,15 +1825,10 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
>  	/* for ACL */
>  	spin_lock_bh(&pacl_node_q->lock);
>  	phead = get_list_head(pacl_node_q);
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
> -
> +	list_for_each_entry_safe(paclnode, ptmp, phead, list) {
>  		if (paclnode->valid == true) {
>  			paclnode->valid = false;
> -
>  			list_del_init(&paclnode->list);
> -
>  			pacl_list->num--;
>  		}
>  	}
> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
> index 3c09ea9..3adda55 100644
> --- a/drivers/staging/rtl8723au/core/rtw_mlme.c
> +++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
> @@ -171,21 +171,15 @@ exit:
>  
>  void rtw_free_network_queue23a(struct rtw_adapter *padapter)
>  {
> -	struct list_head *phead, *plist, *ptmp;
> -	struct wlan_network *pnetwork;
> +	struct list_head *phead;
> +	struct wlan_network *pnetwork, *ptmp;
>  	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
>  	struct rtw_queue *scanned_queue = &pmlmepriv->scanned_queue;
>  
>  	spin_lock_bh(&scanned_queue->lock);
> -
>  	phead = get_list_head(scanned_queue);
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		pnetwork = container_of(plist, struct wlan_network, list);
> -
> +	list_for_each_entry_safe(pnetwork, ptmp, phead, list)
>  		_rtw_free_network23a(pmlmepriv, pnetwork);
> -	}
> -
>  	spin_unlock_bh(&scanned_queue->lock);
>  }
>  
> @@ -329,15 +323,12 @@ int is_same_network23a(struct wlan_bssid_ex *src, struct wlan_bssid_ex *dst)
>  struct wlan_network *
>  rtw_get_oldest_wlan_network23a(struct rtw_queue *scanned_queue)
>  {
> -	struct list_head *plist, *phead;
> +	struct list_head *phead;
>  	struct wlan_network *pwlan;
>  	struct wlan_network *oldest = NULL;
>  
>  	phead = get_list_head(scanned_queue);
> -
> -	list_for_each(plist, phead) {
> -		pwlan = container_of(plist, struct wlan_network, list);
> -
> +	list_for_each_entry(pwlan, phead, list) {
>  		if (pwlan->fixed != true) {
>  			if (!oldest || time_after(oldest->last_scanned,
>  						  pwlan->last_scanned))
> @@ -445,7 +436,6 @@ static void rtw_update_scanned_network(struct rtw_adapter *adapter,
>  
>  	spin_lock_bh(&queue->lock);
>  	phead = get_list_head(queue);
> -
>  	list_for_each(plist, phead) {
>  		pnetwork = container_of(plist, struct wlan_network, list);
>  
> @@ -710,21 +700,17 @@ rtw_surveydone_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
>  
>  static void free_scanqueue(struct mlme_priv *pmlmepriv)
>  {
> -	struct wlan_network *pnetwork;
> +	struct wlan_network *pnetwork, *ptemp;
>  	struct rtw_queue *scan_queue = &pmlmepriv->scanned_queue;
> -	struct list_head *plist, *phead, *ptemp;
> +	struct list_head *phead;
>  
>  	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_, "+free_scanqueue\n");
>  	spin_lock_bh(&scan_queue->lock);
> -
>  	phead = get_list_head(scan_queue);
> -
> -	list_for_each_safe(plist, ptemp, phead) {
> -		pnetwork = container_of(plist, struct wlan_network, list);
> +	list_for_each_entry_safe(pnetwork, ptemp, phead, list) {
>  		pnetwork->fixed = false;
>  		_rtw_free_network23a(pmlmepriv, pnetwork);
>  	}
> -
>  	spin_unlock_bh(&scan_queue->lock);
>  }
>  
> @@ -1625,15 +1611,13 @@ exit:
>  static struct wlan_network *
>  rtw_select_candidate_from_queue(struct mlme_priv *pmlmepriv)
>  {
> -	struct wlan_network *pnetwork, *candidate = NULL;
> +	struct wlan_network *pnetwork, *ptmp, *candidate = NULL;
>  	struct rtw_queue *queue = &pmlmepriv->scanned_queue;
> -	struct list_head *phead, *plist, *ptmp;
> +	struct list_head *phead;
>  
>  	spin_lock_bh(&pmlmepriv->scanned_queue.lock);
>  	phead = get_list_head(queue);
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		pnetwork = container_of(plist, struct wlan_network, list);
> +	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
>  		if (!pnetwork) {
>  			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
>  				 "%s: return _FAIL:(pnetwork == NULL)\n",
> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> index d28f29a..c392d22 100644
> --- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> +++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> @@ -6082,10 +6082,10 @@ int tx_beacon_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
>  #ifdef CONFIG_8723AU_AP_MODE
>  	else { /* tx bc/mc frames after update TIM */
>  		struct sta_info *psta_bmc;
> -		struct list_head *plist, *phead, *ptmp;
> -		struct xmit_frame *pxmitframe;
> +		struct list_head *phead;
> +		struct xmit_frame *pxmitframe, *tmp;
>  		struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
> -		struct sta_priv  *pstapriv = &padapter->stapriv;
> +		struct sta_priv *pstapriv = &padapter->stapriv;
>  
>  		/* for BC/MC Frames */
>  		psta_bmc = rtw_get_bcmc_stainfo23a(padapter);
> @@ -6096,14 +6096,8 @@ int tx_beacon_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
>  			msleep(10);/*  10ms, ATIM(HIQ) Windows */
>  			/* spin_lock_bh(&psta_bmc->sleep_q.lock); */
>  			spin_lock_bh(&pxmitpriv->lock);
> -
>  			phead = get_list_head(&psta_bmc->sleep_q);
> -
> -			list_for_each_safe(plist, ptmp, phead) {
> -				pxmitframe = container_of(plist,
> -							  struct xmit_frame,
> -							  list);
> -
> +			list_for_each_entry_safe(pxmitframe, tmp, phead, list) {
>  				list_del_init(&pxmitframe->list);
>  
>  				psta_bmc->sleepq_len--;
> @@ -6119,7 +6113,6 @@ int tx_beacon_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
>  				rtl8723au_hal_xmitframe_enqueue(padapter,
>  								pxmitframe);
>  			}
> -
>  			/* spin_unlock_bh(&psta_bmc->sleep_q.lock); */
>  			spin_unlock_bh(&pxmitpriv->lock);
>  		}
> diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
> index 404b618..de1226e 100644
> --- a/drivers/staging/rtl8723au/core/rtw_recv.c
> +++ b/drivers/staging/rtl8723au/core/rtw_recv.c
> @@ -85,16 +85,16 @@ int _rtw_init_recv_priv23a(struct recv_priv *precvpriv,
>  	return res;
>  }
>  
> -void _rtw_free_recv_priv23a (struct recv_priv *precvpriv)
> +void _rtw_free_recv_priv23a(struct recv_priv *precvpriv)
>  {
>  	struct rtw_adapter *padapter = precvpriv->adapter;
> -	struct recv_frame *precvframe;
> -	struct list_head *plist, *ptmp;
> +	struct recv_frame *precvframe, *ptmp;
>  
>  	rtw_free_uc_swdec_pending_queue23a(padapter);
>  
> -	list_for_each_safe(plist, ptmp, &precvpriv->free_recv_queue.queue) {
> -		precvframe = container_of(plist, struct recv_frame, list);
> +	list_for_each_entry_safe(precvframe, ptmp,
> +				 &precvpriv->free_recv_queue.queue,
> +				 list) {
>  		list_del_init(&precvframe->list);
>  		kfree(precvframe);
>  	}
> @@ -195,19 +195,13 @@ using spinlock to protect
>  
>  static void rtw_free_recvframe23a_queue(struct rtw_queue *pframequeue)
>  {
> -	struct recv_frame *hdr;
> -	struct list_head *plist, *phead, *ptmp;
> +	struct recv_frame *hdr, *ptmp;
> +	struct list_head *phead;
>  
>  	spin_lock(&pframequeue->lock);
> -
>  	phead = get_list_head(pframequeue);
> -	plist = phead->next;
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		hdr = container_of(plist, struct recv_frame, list);
> +	list_for_each_entry_safe(hdr, ptmp, phead, list)
>  		rtw_free_recvframe23a(hdr);
> -	}
> -
>  	spin_unlock(&pframequeue->lock);
>  }
>  
> @@ -1567,16 +1561,14 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
>  struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
>  				    struct rtw_queue *defrag_q)
>  {
> -	struct list_head *plist, *phead, *ptmp;
> -	u8	*data, wlanhdr_offset;
> -	u8	curfragnum;
> -	struct recv_frame *pnfhdr;
> +	struct list_head *plist, *phead;
> +	u8 wlanhdr_offset;
> +	u8 curfragnum;
> +	struct recv_frame *pnfhdr, *ptmp;
>  	struct recv_frame *prframe, *pnextrframe;
> -	struct rtw_queue	*pfree_recv_queue;
> +	struct rtw_queue *pfree_recv_queue;
>  	struct sk_buff *skb;
>  
> -
> -
>  	curfragnum = 0;
>  	pfree_recv_queue = &adapter->recvpriv.free_recv_queue;
>  
> @@ -1597,12 +1589,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
>  
>  	curfragnum++;
>  
> -	phead = get_list_head(defrag_q);
> -
> -	data = prframe->pkt->data;
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		pnfhdr = container_of(plist, struct recv_frame, list);
> +	list_for_each_entry_safe(pnfhdr, ptmp, phead, list) {
>  		pnextrframe = (struct recv_frame *)pnfhdr;
>  		/* check the fragment sequence  (2nd ~n fragment frame) */
>  
> @@ -1644,8 +1631,6 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
>  	RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
>  		 "Performance defrag!!!!!\n");
>  
> -
> -
>  	return prframe;
>  }
>  
> diff --git a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
> index b06bff7..22d857b 100644
> --- a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
> +++ b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
> @@ -83,8 +83,8 @@ int _rtw_init_sta_priv23a(struct sta_priv *pstapriv)
>  
>  int _rtw_free_sta_priv23a(struct sta_priv *pstapriv)
>  {
> -	struct list_head *phead, *plist, *ptmp;
> -	struct sta_info *psta;
> +	struct list_head *phead;
> +	struct sta_info *psta, *ptmp;
>  	struct recv_reorder_ctrl *preorder_ctrl;
>  	int index;
>  
> @@ -93,12 +93,9 @@ int _rtw_free_sta_priv23a(struct sta_priv *pstapriv)
>  		spin_lock_bh(&pstapriv->sta_hash_lock);
>  		for (index = 0; index < NUM_STA; index++) {
>  			phead = &pstapriv->sta_hash[index];
> -
> -			list_for_each_safe(plist, ptmp, phead) {
> +			list_for_each_entry_safe(psta, ptmp, phead, hash_list) {
>  				int i;
>  
> -				psta = container_of(plist, struct sta_info,
> -						    hash_list);
>  				for (i = 0; i < 16 ; i++) {
>  					preorder_ctrl = &psta->recvreorder_ctrl[i];
>  					del_timer_sync(&preorder_ctrl->reordering_ctrl_timer);
> @@ -325,8 +322,8 @@ exit:
>  /*  free all stainfo which in sta_hash[all] */
>  void rtw_free_all_stainfo23a(struct rtw_adapter *padapter)
>  {
> -	struct list_head *plist, *phead, *ptmp;
> -	struct sta_info *psta;
> +	struct list_head *phead;
> +	struct sta_info *psta, *ptmp;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
>  	struct sta_info *pbcmc_stainfo = rtw_get_bcmc_stainfo23a(padapter);
>  	s32 index;
> @@ -335,13 +332,9 @@ void rtw_free_all_stainfo23a(struct rtw_adapter *padapter)
>  		return;
>  
>  	spin_lock_bh(&pstapriv->sta_hash_lock);
> -
>  	for (index = 0; index < NUM_STA; index++) {
>  		phead = &pstapriv->sta_hash[index];
> -
> -		list_for_each_safe(plist, ptmp, phead) {
> -			psta = container_of(plist, struct sta_info, hash_list);
> -
> +		list_for_each_entry_safe(psta, ptmp, phead, hash_list) {
>  			if (pbcmc_stainfo != psta)
>  				rtw_free_stainfo23a(padapter, psta);
>  		}
> @@ -352,9 +345,9 @@ void rtw_free_all_stainfo23a(struct rtw_adapter *padapter)
>  /* any station allocated can be searched by hash list */
>  struct sta_info *rtw_get_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr)
>  {
> -	struct list_head *plist, *phead;
> +	struct list_head *phead;
>  	struct sta_info *psta = NULL;
> -	u32	index;
> +	u32 index;
>  	const u8 *addr;
>  
>  	if (hwaddr == NULL)
> @@ -368,12 +361,8 @@ struct sta_info *rtw_get_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr)
>  	index = wifi_mac_hash(addr);
>  
>  	spin_lock_bh(&pstapriv->sta_hash_lock);
> -
>  	phead = &pstapriv->sta_hash[index];
> -
> -	list_for_each(plist, phead) {
> -		psta = container_of(plist, struct sta_info, hash_list);
> -
> +	list_for_each_entry(psta, phead, hash_list) {
>  		/*  if found the matched address */
>  		if (ether_addr_equal(psta->hwaddr, addr))
>  			break;
> @@ -418,7 +407,7 @@ bool rtw_access_ctrl23a(struct rtw_adapter *padapter, u8 *mac_addr)
>  {
>  	bool res = true;
>  #ifdef CONFIG_8723AU_AP_MODE
> -	struct list_head *plist, *phead;
> +	struct list_head *phead;
>  	struct rtw_wlan_acl_node *paclnode;
>  	bool match = false;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
> @@ -427,10 +416,7 @@ bool rtw_access_ctrl23a(struct rtw_adapter *padapter, u8 *mac_addr)
>  
>  	spin_lock_bh(&pacl_node_q->lock);
>  	phead = get_list_head(pacl_node_q);
> -
> -	list_for_each(plist, phead) {
> -		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
> -
> +	list_for_each_entry(paclnode, phead, list) {
>  		if (ether_addr_equal(paclnode->addr, mac_addr)) {
>  			if (paclnode->valid) {
>  				match = true;
> diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
> index a4b6bb6..b82b182 100644
> --- a/drivers/staging/rtl8723au/core/rtw_xmit.c
> +++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
> @@ -193,39 +193,38 @@ fail:
>  	goto exit;
>  }
>  
> -void _rtw_free_xmit_priv23a (struct xmit_priv *pxmitpriv)
> +void _rtw_free_xmit_priv23a(struct xmit_priv *pxmitpriv)
>  {
>  	struct rtw_adapter *padapter = pxmitpriv->adapter;
> -	struct xmit_frame *pxframe;
> -	struct xmit_buf *pxmitbuf;
> -	struct list_head *plist, *ptmp;
> +	struct xmit_frame *pxframe, *ptmp;
> +	struct xmit_buf *pxmitbuf, *ptmp2;
>  
> -	list_for_each_safe(plist, ptmp, &pxmitpriv->free_xmit_queue.queue) {
> -		pxframe = container_of(plist, struct xmit_frame, list);
> +	list_for_each_entry_safe(pxframe, ptmp,
> +				 &pxmitpriv->free_xmit_queue.queue, list) {
>  		list_del_init(&pxframe->list);
>  		rtw_os_xmit_complete23a(padapter, pxframe);
>  		kfree(pxframe);
>  	}
>  
> -	list_for_each_safe(plist, ptmp, &pxmitpriv->xmitbuf_list) {
> -		pxmitbuf = container_of(plist, struct xmit_buf, list2);
> +	list_for_each_entry_safe(pxmitbuf, ptmp2,
> +				 &pxmitpriv->xmitbuf_list, list2) {
>  		list_del_init(&pxmitbuf->list2);
>  		rtw_os_xmit_resource_free23a(padapter, pxmitbuf);
>  		kfree(pxmitbuf);
>  	}
>  
>  	/* free xframe_ext queue,  the same count as extbuf  */
> -	list_for_each_safe(plist, ptmp,
> -			   &pxmitpriv->free_xframe_ext_queue.queue) {
> -		pxframe = container_of(plist, struct xmit_frame, list);
> +	list_for_each_entry_safe(pxframe, ptmp,
> +				 &pxmitpriv->free_xframe_ext_queue.queue,
> +				 list) {
>  		list_del_init(&pxframe->list);
>  		rtw_os_xmit_complete23a(padapter, pxframe);
>  		kfree(pxframe);
>  	}
>  
>  	/*  free xmit extension buff */
> -	list_for_each_safe(plist, ptmp, &pxmitpriv->xmitextbuf_list) {
> -		pxmitbuf = container_of(plist, struct xmit_buf, list2);
> +	list_for_each_entry_safe(pxmitbuf, ptmp2,
> +				 &pxmitpriv->xmitextbuf_list, list2) {
>  		list_del_init(&pxmitbuf->list2);
>  		rtw_os_xmit_resource_free23a(padapter, pxmitbuf);
>  		kfree(pxmitbuf);
> @@ -1563,18 +1562,13 @@ exit:
>  void rtw_free_xmitframe_queue23a(struct xmit_priv *pxmitpriv,
>  				 struct rtw_queue *pframequeue)
>  {
> -	struct list_head *plist, *phead, *ptmp;
> -	struct	xmit_frame *pxmitframe;
> +	struct list_head *phead;
> +	struct xmit_frame *pxmitframe, *ptmp;
>  
>  	spin_lock_bh(&pframequeue->lock);
> -
>  	phead = get_list_head(pframequeue);
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		pxmitframe = container_of(plist, struct xmit_frame, list);
> -
> +	list_for_each_entry_safe(pxmitframe, ptmp, phead, list)
>  		rtw_free_xmitframe23a(pxmitpriv, pxmitframe);
> -	}
>  	spin_unlock_bh(&pframequeue->lock);
>  
>  }
> @@ -1612,9 +1606,9 @@ struct xmit_frame *
>  rtw_dequeue_xframe23a(struct xmit_priv *pxmitpriv, struct hw_xmit *phwxmit_i,
>  		   int entry)
>  {
> -	struct list_head *sta_plist, *sta_phead, *ptmp;
> +	struct list_head *sta_phead;
>  	struct hw_xmit *phwxmit;
> -	struct tx_servq *ptxservq = NULL;
> +	struct tx_servq *ptxservq = NULL, *ptmp;
>  	struct rtw_queue *pframe_queue = NULL;
>  	struct xmit_frame *pxmitframe = NULL;
>  	struct rtw_adapter *padapter = pxmitpriv->adapter;
> @@ -1638,11 +1632,8 @@ rtw_dequeue_xframe23a(struct xmit_priv *pxmitpriv, struct hw_xmit *phwxmit_i,
>  		phwxmit = phwxmit_i + inx[i];
>  
>  		sta_phead = get_list_head(phwxmit->sta_queue);
> -
> -		list_for_each_safe(sta_plist, ptmp, sta_phead) {
> -			ptxservq = container_of(sta_plist, struct tx_servq,
> -						tx_pending);
> -
> +		list_for_each_entry_safe(ptxservq, ptmp, sta_phead,
> +					 tx_pending) {
>  			pframe_queue = &ptxservq->sta_pending;
>  
>  			pxmitframe = dequeue_one_xmitframe(pxmitpriv, phwxmit, ptxservq, pframe_queue);
> @@ -2052,18 +2043,15 @@ dequeue_xmitframes_to_sleeping_queue(struct rtw_adapter *padapter,
>  				     struct rtw_queue *pframequeue)
>  {
>  	int ret;
> -	struct list_head *plist, *phead, *ptmp;
> -	u8	ac_index;
> +	struct list_head *phead;
> +	u8 ac_index;
>  	struct tx_servq	*ptxservq;
> -	struct pkt_attrib	*pattrib;
> -	struct xmit_frame	*pxmitframe;
> -	struct hw_xmit *phwxmits =  padapter->xmitpriv.hwxmits;
> +	struct pkt_attrib *pattrib;
> +	struct xmit_frame *pxmitframe, *ptmp;
> +	struct hw_xmit *phwxmits = padapter->xmitpriv.hwxmits;
>  
>  	phead = get_list_head(pframequeue);
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		pxmitframe = container_of(plist, struct xmit_frame, list);
> -
> +	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
>  		ret = xmitframe_enqueue_for_sleeping_sta23a(padapter, pxmitframe);
>  
>  		if (ret == true) {
> @@ -2124,17 +2112,14 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
>  {
>  	u8 update_mask = 0, wmmps_ac = 0;
>  	struct sta_info *psta_bmc;
> -	struct list_head *plist, *phead, *ptmp;
> -	struct xmit_frame *pxmitframe = NULL;
> +	struct list_head *phead;
> +	struct xmit_frame *pxmitframe = NULL, *ptmp;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
>  	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
>  
>  	spin_lock_bh(&pxmitpriv->lock);
> -
>  	phead = get_list_head(&psta->sleep_q);
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		pxmitframe = container_of(plist, struct xmit_frame, list);
> +	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
>  		list_del_init(&pxmitframe->list);
>  
>  		switch (pxmitframe->attrib.priority) {
> @@ -2194,7 +2179,6 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
>  
>  		pstapriv->sta_dz_bitmap &= ~CHKBIT(psta->aid);
>  	}
> -
>  	/* spin_unlock_bh(&psta->sleep_q.lock); */
>  	spin_unlock_bh(&pxmitpriv->lock);
>  
> @@ -2206,13 +2190,8 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
>  	if ((pstapriv->sta_dz_bitmap&0xfffe) == 0x0) {
>  		/* no any sta in ps mode */
>  		spin_lock_bh(&pxmitpriv->lock);
> -
>  		phead = get_list_head(&psta_bmc->sleep_q);
> -
> -		list_for_each_safe(plist, ptmp, phead) {
> -			pxmitframe = container_of(plist, struct xmit_frame,
> -						  list);
> -
> +		list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
>  			list_del_init(&pxmitframe->list);
>  
>  			psta_bmc->sleepq_len--;
> @@ -2232,7 +2211,6 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
>  			/* update_BCNTIM(padapter); */
>  			update_mask |= BIT(1);
>  		}
> -
>  		/* spin_unlock_bh(&psta_bmc->sleep_q.lock); */
>  		spin_unlock_bh(&pxmitpriv->lock);
>  	}
> @@ -2245,19 +2223,15 @@ void xmit_delivery_enabled_frames23a(struct rtw_adapter *padapter,
>  				  struct sta_info *psta)
>  {
>  	u8 wmmps_ac = 0;
> -	struct list_head *plist, *phead, *ptmp;
> -	struct xmit_frame *pxmitframe;
> +	struct list_head *phead;
> +	struct xmit_frame *pxmitframe, *ptmp;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
>  	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
>  
>  	/* spin_lock_bh(&psta->sleep_q.lock); */
>  	spin_lock_bh(&pxmitpriv->lock);
> -
>  	phead = get_list_head(&psta->sleep_q);
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		pxmitframe = container_of(plist, struct xmit_frame, list);
> -
> +	list_for_each_entry_safe(pxmitframe, ptmp, phead, list) {
>  		switch (pxmitframe->attrib.priority) {
>  		case 1:
>  		case 2:
> diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> index 0ae2180..908b84c 100644
> --- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> +++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> @@ -1270,18 +1270,14 @@ void rtw_cfg80211_indicate_scan_done(struct rtw_wdev_priv *pwdev_priv,
>  
>  void rtw_cfg80211_surveydone_event_callback(struct rtw_adapter *padapter)
>  {
> -	struct list_head *plist, *phead, *ptmp;
> +	struct list_head *phead;
>  	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
>  	struct rtw_queue *queue = &pmlmepriv->scanned_queue;
> -	struct wlan_network *pnetwork;
> +	struct wlan_network *pnetwork, *ptmp;
>  
>  	spin_lock_bh(&pmlmepriv->scanned_queue.lock);
> -
>  	phead = get_list_head(queue);
> -
> -	list_for_each_safe(plist, ptmp, phead) {
> -		pnetwork = container_of(plist, struct wlan_network, list);
> -
> +	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
>  		/* report network only if the current channel set
>  		   contains the channel to which this network belongs */
>  		if (rtw_ch_set_search_ch23a
> @@ -1289,7 +1285,6 @@ void rtw_cfg80211_surveydone_event_callback(struct rtw_adapter *padapter)
>  		     pnetwork->network.DSConfig) >= 0)
>  			rtw_cfg80211_inform_bss(padapter, pnetwork);
>  	}
> -
>  	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
>  
>  	/* call this after other things have been done */
> @@ -2850,9 +2845,9 @@ static int cfg80211_rtw_del_station(struct wiphy *wiphy,
>  {
>  	const u8 *mac = params->mac;
>  	int ret = 0;
> -	struct list_head *phead, *plist, *ptmp;
> +	struct list_head *phead;
>  	u8 updated = 0;
> -	struct sta_info *psta;
> +	struct sta_info *psta, *ptmp;
>  	struct rtw_adapter *padapter = netdev_priv(ndev);
>  	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
>  	struct sta_priv *pstapriv = &padapter->stapriv;
> @@ -2881,13 +2876,9 @@ static int cfg80211_rtw_del_station(struct wiphy *wiphy,
>  		return -EINVAL;
>  
>  	spin_lock_bh(&pstapriv->asoc_list_lock);
> -
>  	phead = &pstapriv->asoc_list;
> -
>  	/* check asoc_queue */
> -	list_for_each_safe(plist, ptmp, phead) {
> -		psta = container_of(plist, struct sta_info, asoc_list);
> -
> +	list_for_each_entry_safe(psta, ptmp, phead, asoc_list) {
>  		if (ether_addr_equal(mac, psta->hwaddr)) {
>  			if (psta->dot8021xalg == 1 &&
>  			    psta->bpairwise_key_installed == false) {
> @@ -2912,7 +2903,6 @@ static int cfg80211_rtw_del_station(struct wiphy *wiphy,
>  			}
>  		}
>  	}
> -
>  	spin_unlock_bh(&pstapriv->asoc_list_lock);
>  
>  	associated_clients_update23a(padapter, updated);
> diff --git a/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c b/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
> index 0cdaef0..cf4a506 100644
> --- a/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
> +++ b/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
> @@ -210,22 +210,21 @@ exit:
>  void rtl8723au_write_port_cancel(struct rtw_adapter *padapter)
>  {
>  	struct xmit_buf *pxmitbuf;
> -	struct list_head *plist;
>  	int j;
>  
>  	DBG_8723A("%s\n", __func__);
>  
>  	padapter->bWritePortCancel = true;
>  
> -	list_for_each(plist, &padapter->xmitpriv.xmitbuf_list) {
> -		pxmitbuf = container_of(plist, struct xmit_buf, list2);
> +	list_for_each_entry(pxmitbuf, &padapter->xmitpriv.xmitbuf_list,
> +			    list2) {
>  		for (j = 0; j < 8; j++) {
>  			if (pxmitbuf->pxmit_urb[j])
>  				usb_kill_urb(pxmitbuf->pxmit_urb[j]);
>  		}
>  	}
> -	list_for_each(plist, &padapter->xmitpriv.xmitextbuf_list) {
> -		pxmitbuf = container_of(plist, struct xmit_buf, list2);
> +	list_for_each_entry(pxmitbuf, &padapter->xmitpriv.xmitextbuf_list,
> +			    list2) {
>  		for (j = 0; j < 8; j++) {
>  			if (pxmitbuf->pxmit_urb[j])
>  				usb_kill_urb(pxmitbuf->pxmit_urb[j]);
