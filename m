Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40838 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBYVHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 16:07:42 -0500
Received: by mail-wi0-f173.google.com with SMTP id bs8so5086768wib.6
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 13:07:41 -0800 (PST)
Message-ID: <530D0612.9080004@gmail.com> (sfid-20140225_220745_620827_6507854B)
Date: Tue, 25 Feb 2014 21:07:30 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 09/10] staging: vt6656: Remove pointer cast to urb->context.
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com> <1393361512-13805-9-git-send-email-tvboxspy@gmail.com>
In-Reply-To: <1393361512-13805-9-git-send-email-tvboxspy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

added Joe's cc

On 25/02/14 20:51, Malcolm Priestley wrote:
> Remove unnecessary cast to void * urb->context
>
> Reported-by: Joe Perches <joe@perches.com>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>   drivers/staging/vt6656/usbpipe.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
> index 1477def..54c68a5 100644
> --- a/drivers/staging/vt6656/usbpipe.c
> +++ b/drivers/staging/vt6656/usbpipe.c
> @@ -347,7 +347,7 @@ int PIPEnsInterruptRead(struct vnt_private *priv)
>
>   static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
>   {
> -	struct vnt_private *priv = (struct vnt_private *)urb->context;
> +	struct vnt_private *priv = urb->context;
>   	int status;
>
>   	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
> @@ -465,7 +465,7 @@ int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
>
>   static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
>   {
> -	struct vnt_rcb *rcb = (struct vnt_rcb *)urb->context;
> +	struct vnt_rcb *rcb = urb->context;
>   	struct vnt_private *priv = rcb->pDevice;
>   	int re_alloc_skb = false;
>
> @@ -592,8 +592,7 @@ int PIPEnsSendBulkOut(struct vnt_private *priv,
>
>   static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
>   {
> -	struct vnt_usb_send_context *context =
> -			(struct vnt_usb_send_context *)urb->context;
> +	struct vnt_usb_send_context *context = urb->context;
>   	struct vnt_private *priv = context->pDevice;
>   	u8 context_type = context->type;
>   	unsigned long buf_len = context->uBufLen;
>

