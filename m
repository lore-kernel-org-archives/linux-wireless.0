Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:18586 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbbJJHm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2015 03:42:27 -0400
Message-ID: <5618C15F.2030706@broadcom.com> (sfid-20151010_094307_561549_F1A45990)
Date: Sat, 10 Oct 2015 09:42:23 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Markus Elfring <elfring@users.sourceforge.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: fix waitqueue_active without memory barrier
 in brcmfmac driver
References: <17EC94B0A072C34B8DCF0D30AD16044A02874785@BPXM09GP.gisp.nec.co.jp>
In-Reply-To: <17EC94B0A072C34B8DCF0D30AD16044A02874785@BPXM09GP.gisp.nec.co.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/2015 02:35 AM, Kosuke Tatsukawa wrote:
> brcmf_msgbuf_ioctl_resp_wake() seems to be missing a memory barrier
> which might cause the waker to not notice the waiter and miss sending a
> wake_up as in the following figure.
> 
>    brcmf_msgbuf_ioctl_resp_wake		    brcmf_msgbuf_ioctl_resp_wait
> ------------------------------------------------------------------------
> if (waitqueue_active(&msgbuf->ioctl_resp_wait))
> /* The CPU might reorder the test for
>     the waitqueue up here, before
>     prior writes complete */
>     	   	     	 	       /* wait_event_timeout */
> 				        /* __wait_event_timeout */
> 					 /* ___wait_event */
> 					 prepare_to_wait_event(&wq, &__wait,
> 					   state);
> 					 if (msgbuf->ctl_completed)
> 					 ...
> msgbuf->ctl_completed = true;
> 					 schedule_timeout(__ret))
> ------------------------------------------------------------------------
> 
> There are three other place in drivers/net/wireless/brcm80211/brcmfmac/
> which have similar code.  The attached patch removes the call to
> waitqueue_active() leaving just wake_up() behind.  This fixes the
> problem because the call to spin_lock_irqsave() in wake_up() will be an
> ACQUIRE operation.
> 
> I found this issue when I was looking through the linux source code
> for places calling waitqueue_active() before wake_up*(), but without
> preceding memory barriers, after sending a patch to fix a similar
> issue in drivers/tty/n_tty.c  (Details about the original issue can be
> found here: https://lkml.org/lkml/2015/9/28/849).

I prefer to add proper barriers instead of removing waitqueue_active()
check. We will review your patch and submit it through our upstream process.

Regards,
Arend

> Signed-off-by: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c |    3 +--
>   drivers/net/wireless/brcm80211/brcmfmac/sdio.c   |    6 ++----
>   drivers/net/wireless/brcm80211/brcmfmac/usb.c    |    3 +--
>   3 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
> index 7b2136c..648151e 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
> @@ -473,8 +473,7 @@ static int brcmf_msgbuf_ioctl_resp_wait(struct brcmf_msgbuf *msgbuf)
>   static void brcmf_msgbuf_ioctl_resp_wake(struct brcmf_msgbuf *msgbuf)
>   {
>   	msgbuf->ctl_completed = true;
> -	if (waitqueue_active(&msgbuf->ioctl_resp_wait))
> -		wake_up(&msgbuf->ioctl_resp_wait);
> +	wake_up(&msgbuf->ioctl_resp_wait);
>   }
>   
>   
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> index f990e3d..332c4c8 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> @@ -1785,8 +1785,7 @@ static int brcmf_sdio_dcmd_resp_wait(struct brcmf_sdio *bus, uint *condition,
>   
>   static int brcmf_sdio_dcmd_resp_wake(struct brcmf_sdio *bus)
>   {
> -	if (waitqueue_active(&bus->dcmd_resp_wait))
> -		wake_up_interruptible(&bus->dcmd_resp_wait);
> +	wake_up_interruptible(&bus->dcmd_resp_wait);
>   
>   	return 0;
>   }
> @@ -2110,8 +2109,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
>   static void
>   brcmf_sdio_wait_event_wakeup(struct brcmf_sdio *bus)
>   {
> -	if (waitqueue_active(&bus->ctrl_wait))
> -		wake_up_interruptible(&bus->ctrl_wait);
> +	wake_up_interruptible(&bus->ctrl_wait);
>   	return;
>   }
>   
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> index daba86d..7f5889c 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> @@ -184,8 +184,7 @@ static int brcmf_usb_ioctl_resp_wait(struct brcmf_usbdev_info *devinfo)
>   
>   static void brcmf_usb_ioctl_resp_wake(struct brcmf_usbdev_info *devinfo)
>   {
> -	if (waitqueue_active(&devinfo->ioctl_resp_wait))
> -		wake_up(&devinfo->ioctl_resp_wait);
> +	wake_up(&devinfo->ioctl_resp_wait);
>   }
>   
>   static void
> 

