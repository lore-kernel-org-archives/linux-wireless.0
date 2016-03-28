Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35628 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbcC1EKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 00:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <1458973495-17403-1-git-send-email-bhumirks@gmail.com>
References: <1458973495-17403-1-git-send-email-bhumirks@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 28 Mar 2016 15:10:12 +1100
Message-ID: <CAGRGNgVFyhy3uCGjcB-EAL1Cewm_J4oNUz5=GOh98zLvFHUaoQ@mail.gmail.com> (sfid-20160328_061050_612968_BC923826)
Subject: Re: [PATCH] Staging: rtl8723au: Remove function rtw_enqueue_{recvbuf23a/recvbuf23a_to_head}
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Sat, Mar 26, 2016 at 5:24 PM, Bhumika Goyal <bhumirks@gmail.com> wrote:
> The functions rtw_enqueue_recvbuf23a and rtw_enqueue_recvbuf23a_to_head
> are never used anywhere in the kernel. So, remove their definition and
> prototype.
> Grepped to find occurences.
>
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/staging/rtl8723au/core/rtw_recv.c    | 25 -------------------------
>  drivers/staging/rtl8723au/include/rtw_recv.h |  2 --
>  2 files changed, 27 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
> index 989ed07..150dabc 100644
> --- a/drivers/staging/rtl8723au/core/rtw_recv.c
> +++ b/drivers/staging/rtl8723au/core/rtw_recv.c
> @@ -211,31 +211,6 @@ u32 rtw_free_uc_swdec_pending_queue23a(struct rtw_adapter *adapter)
>         return cnt;
>  }
>
> -int rtw_enqueue_recvbuf23a_to_head(struct recv_buf *precvbuf, struct rtw_queue *queue)
> -{
> -       spin_lock_bh(&queue->lock);
> -
> -       list_del_init(&precvbuf->list);
> -       list_add(&precvbuf->list, get_list_head(queue));
> -
> -       spin_unlock_bh(&queue->lock);
> -
> -       return _SUCCESS;
> -}
> -
> -int rtw_enqueue_recvbuf23a(struct recv_buf *precvbuf, struct rtw_queue *queue)
> -{
> -       unsigned long irqL;
> -
> -       spin_lock_irqsave(&queue->lock, irqL);
> -
> -       list_del_init(&precvbuf->list);
> -
> -       list_add_tail(&precvbuf->list, get_list_head(queue));
> -       spin_unlock_irqrestore(&queue->lock, irqL);
> -       return _SUCCESS;
> -}
> -
>  struct recv_buf *rtw_dequeue_recvbuf23a (struct rtw_queue *queue)
>  {
>         unsigned long irqL;
> diff --git a/drivers/staging/rtl8723au/include/rtw_recv.h b/drivers/staging/rtl8723au/include/rtw_recv.h
> index dc784be..85a5edb 100644
> --- a/drivers/staging/rtl8723au/include/rtw_recv.h
> +++ b/drivers/staging/rtl8723au/include/rtw_recv.h
> @@ -279,8 +279,6 @@ int rtw_enqueue_recvframe23a(struct recv_frame *precvframe, struct rtw_queue *qu
>
>  u32 rtw_free_uc_swdec_pending_queue23a(struct rtw_adapter *adapter);
>
> -int rtw_enqueue_recvbuf23a_to_head(struct recv_buf *precvbuf, struct rtw_queue *queue);
> -int rtw_enqueue_recvbuf23a(struct recv_buf *precvbuf, struct rtw_queue *queue);
>  struct recv_buf *rtw_dequeue_recvbuf23a(struct rtw_queue *queue);
>
>  void rtw_reordering_ctrl_timeout_handler23a(unsigned long pcontext);
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
