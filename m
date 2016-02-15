Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbcBOPcd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 10:32:33 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Geliang Tang <geliangtang@163.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] staging: rtl8723au: use list_for_each_entry*()
References: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com>
Date: Mon, 15 Feb 2016 10:32:31 -0500
In-Reply-To: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com>
	(Geliang Tang's message of "Sun, 7 Feb 2016 11:29:58 +0800")
Message-ID: <wrfj4mdaxa40.fsf@redhat.com> (sfid-20160215_184439_111227_92BEA312)
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
> Changes in v3:
>  - split it into three patches.
> Changes in v2:
>  - drop the coding style fixing in v1.
> ---
>  drivers/staging/rtl8723au/core/rtw_ap.c           | 55 ++++++++-----------
>  drivers/staging/rtl8723au/core/rtw_mlme.c         | 26 ++++-----
>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c     | 10 ++--
>  drivers/staging/rtl8723au/core/rtw_recv.c         | 22 ++++----
>  drivers/staging/rtl8723au/core/rtw_sta_mgt.c      | 25 ++++-----
>  drivers/staging/rtl8723au/core/rtw_xmit.c         | 64 ++++++++++-------------
>  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 14 +++--
>  drivers/staging/rtl8723au/os_dep/usb_ops_linux.c  |  9 ++--
>  8 files changed, 96 insertions(+), 129 deletions(-)

This one is mostly OK, however when you do multi patch sets, always
include a cover letter describing the overall changes of the set.

A few nit picks:

> diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
> index 404b618..18b7d03 100644
> --- a/drivers/staging/rtl8723au/core/rtw_recv.c
> +++ b/drivers/staging/rtl8723au/core/rtw_recv.c
> @@ -88,13 +88,13 @@ int _rtw_init_recv_priv23a(struct recv_priv *precvpriv,
>  void _rtw_free_recv_priv23a (struct recv_priv *precvpriv)
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

Too aggressive line breaking, the 'list' fits within 80 characters on
the line above.

> @@ -195,16 +195,15 @@ using spinlock to protect
>  
>  static void rtw_free_recvframe23a_queue(struct rtw_queue *pframequeue)
>  {
> -	struct recv_frame *hdr;
> -	struct list_head *plist, *phead, *ptmp;
> +	struct recv_frame *hdr, *ptmp;
> +	struct list_head *phead;
>  
>  	spin_lock(&pframequeue->lock);
>  
>  	phead = get_list_head(pframequeue);
>  	plist = phead->next;
>  
> -	list_for_each_safe(plist, ptmp, phead) {
> -		hdr = container_of(plist, struct recv_frame, list);
> +	list_for_each_entry_safe(hdr, ptmp, phead, list) {
>  		rtw_free_recvframe23a(hdr);
>  	}
>  

You could remove the brackets here, since you are fixing that specific
line. I am fine with this as is, some of the checkpatch police force
might bite over it.

On overall this patch is a lot better than the first version.

All set and done, I am thinking of removing this driver once Kalle pulls
in my currently posted set of changes for rtl8xxxu, plus the next one I
have lined up. I seems to me rtl8xxxu can replace rtl8723au at this
point.

I will probably mark rtl8723au deprecated after 4.6 comes out, and
remove the driver around 4.7.

Cheers,
Jes
