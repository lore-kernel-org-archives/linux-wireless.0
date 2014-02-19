Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:44745 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754305AbaBSV4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 16:56:13 -0500
Message-ID: <1392846970.24844.14.camel@joe-AO722> (sfid-20140219_225620_318974_AB96C490)
Subject: Re: [PATCH 1/4] staging: vt6656: s_nsBulkOutIoCompleteWrite
 reorganise variable order.
From: Joe Perches <joe@perches.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 13:56:10 -0800
In-Reply-To: <1392846614.20211.10.camel@canaries64-MCP7A>
References: <1392846614.20211.10.camel@canaries64-MCP7A>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 21:50 +0000, Malcolm Priestley wrote:
> Declare in order of pointer use.
[]
> diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
[]
> @@ -607,21 +607,14 @@ int PIPEnsSendBulkOut(struct vnt_private *pDevice,
>  
>  static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
>  {
> -	struct vnt_private *pDevice;
> +	struct vnt_usb_send_context *pContext =
> +			(struct vnt_usb_send_context *)urb->context;

urb->context is a void * so this could be:

	struct vnt_usb_send_context *pContext = urb_context;


