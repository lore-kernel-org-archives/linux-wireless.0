Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbHQTxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 15:53:13 -0400
Date: Mon, 17 Aug 2015 12:53:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 4/4] staging: wilc1000: return -EINVAL for invalid
 argument checking
Message-ID: <20150817195312.GA6468@kroah.com> (sfid-20150817_215320_361796_D73421D2)
References: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com>
 <1439819071-30000-4-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439819071-30000-4-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 10:44:31PM +0900, Chaehyun Lim wrote:
> This patch uses -EINVAL for invalid argument checking instead of using
> WILC_ERRORREPORT with WILC_INVALID_ARGUMENT.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_msgqueue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> index dd87448..561ff88 100644
> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> @@ -61,7 +61,7 @@ s32 WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
>  	Message *pstrMessage = NULL;
>  
>  	if ((pHandle == NULL) || (u32SendBufferSize == 0) || (pvSendBuffer == NULL)) {
> -		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
> +		return -EINVAL;

Watch out, WILC_ERRORREPORT has a goto in it, so I don't know if you can
always just do a "simple" return like this.

greg k-h
