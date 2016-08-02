Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968212AbcHBSF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 14:05:27 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Shiva Kerdel <shiva@exdev.nl>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	geliangtang@163.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8723au: rtw_xmit: fixed coding style issues
References: <20160802175721.2453-1-shiva@exdev.nl>
Date: Tue, 02 Aug 2016 14:03:01 -0400
In-Reply-To: <20160802175721.2453-1-shiva@exdev.nl> (Shiva Kerdel's message of
	"Tue, 2 Aug 2016 19:57:21 +0200")
Message-ID: <wrfjeg67calm.fsf@redhat.com> (sfid-20160802_200630_570094_FAE284B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shiva Kerdel <shiva@exdev.nl> writes:
> Fixed some coding style issues that were detected as errors.
>
> Signed-off-by: Shiva Kerdel <shiva@exdev.nl>

You have already been told this once by Greg. Describe what you are
fixing in the commit message, and don't fix more than one type of bug
per commit.

Jes

> ---
>  drivers/staging/rtl8723au/core/rtw_xmit.c | 26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
> index 3de40cf..4ea7c5f 100644
> --- a/drivers/staging/rtl8723au/core/rtw_xmit.c
> +++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
> @@ -174,7 +174,7 @@ int _rtw_init_xmit_priv23a(struct xmit_priv *pxmitpriv,
>  	rtw_alloc_hwxmits23a(padapter);
>  	rtw_init_hwxmits23a(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);
>  
> -	for (i = 0; i < 4; i ++)
> +	for (i = 0; i < 4; i++)
>  		pxmitpriv->wmm_para_seq[i] = i;
>  
>  	sema_init(&pxmitpriv->tx_retevt, 0);
> @@ -640,7 +640,7 @@ static int xmitframe_addmic(struct rtw_adapter *padapter,
>  	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
>  	int curfragnum, length;
>  	u8 *pframe, *payload, mic[8];
> -	u8 priority[4]= {0x0, 0x0, 0x0, 0x0};
> +	u8 priority[4] = {0x0, 0x0, 0x0, 0x0};
>  	u8 hw_hdr_offset = 0;
>  	int bmcst = is_multicast_ether_addr(pattrib->ra);
>  
> @@ -667,10 +667,10 @@ static int xmitframe_addmic(struct rtw_adapter *padapter,
>  	if (pattrib->encrypt == WLAN_CIPHER_SUITE_TKIP) {
>  		/* encode mic code */
>  		if (stainfo) {
> -			u8 null_key[16]={0x0, 0x0, 0x0, 0x0,
> -					 0x0, 0x0, 0x0, 0x0,
> -					 0x0, 0x0, 0x0, 0x0,
> -					 0x0, 0x0, 0x0, 0x0};
> +			u8 null_key[16] = {0x0, 0x0, 0x0, 0x0,
> +					   0x0, 0x0, 0x0, 0x0,
> +					   0x0, 0x0, 0x0, 0x0,
> +					   0x0, 0x0, 0x0, 0x0};
>  
>  			pframe = pxmitframe->buf_addr + hw_hdr_offset;
>  
> @@ -902,8 +902,7 @@ static int rtw_make_wlanhdr(struct rtw_adapter *padapter, u8 *hdr,
>  
>  			if (psta->qos_option)
>  				qos_option = true;
> -		}
> -		else {
> +		} else {
>  			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
>  				 "fw_state:%x is not allowed to xmit frame\n",
>  				 get_fwstate(pmlmepriv));
> @@ -1190,7 +1189,7 @@ int rtw_xmitframe_coalesce23a(struct rtw_adapter *padapter, struct sk_buff *skb,
>  		pdata += mem_sz;
>  		data_len -= mem_sz;
>  
> -		if ((pattrib->icv_len >0) && (pattrib->bswenc)) {
> +		if ((pattrib->icv_len > 0) && (pattrib->bswenc)) {
>  			memcpy(pframe, pattrib->icv, pattrib->icv_len);
>  			pframe += pattrib->icv_len;
>  		}
> @@ -1766,7 +1765,6 @@ void rtw_alloc_hwxmits23a(struct rtw_adapter *padapter)
>  		hwxmits[4] .sta_queue = &pxmitpriv->be_pending;
>  
>  	} else if (pxmitpriv->hwxmit_entry == 4) {
> -
>  		/* pxmitpriv->vo_txqueue.head = 0; */
>  		/* hwxmits[0] .phwtxqueue = &pxmitpriv->vo_txqueue; */
>  		hwxmits[0] .sta_queue = &pxmitpriv->vo_pending;
> @@ -1952,18 +1950,16 @@ int xmitframe_enqueue_for_sleeping_sta23a(struct rtw_adapter *padapter, struct x
>  			/* spin_unlock_bh(&psta->sleep_q.lock); */
>  
>  			ret = true;
> -
>  		}
>  
>  		spin_unlock_bh(&psta->sleep_q.lock);
>  
>  		return ret;
> -
>  	}
>  
>  	spin_lock_bh(&psta->sleep_q.lock);
>  
> -	if (psta->state&WIFI_SLEEP_STATE) {
> +	if (psta->state & WIFI_SLEEP_STATE) {
>  		u8 wmmps_ac = 0;
>  
>  		if (pstapriv->sta_dz_bitmap & CHKBIT(psta->aid)) {
> @@ -2017,9 +2013,7 @@ int xmitframe_enqueue_for_sleeping_sta23a(struct rtw_adapter *padapter, struct x
>  			/*  */
>  
>  			ret = true;
> -
>  		}
> -
>  	}
>  
>  	spin_unlock_bh(&psta->sleep_q.lock);
> @@ -2159,7 +2153,7 @@ void wakeup_sta_to_xmit23a(struct rtw_adapter *padapter, struct sta_info *psta)
>  		/* update BCN for TIM IE */
>  		update_mask = BIT(0);
>  
> -		if (psta->state&WIFI_SLEEP_STATE)
> +		if (psta->state & WIFI_SLEEP_STATE)
>  			psta->state ^= WIFI_SLEEP_STATE;
>  
>  		if (psta->state & WIFI_STA_ALIVE_CHK_STATE) {
