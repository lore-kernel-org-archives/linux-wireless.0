Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbJDIk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 04:40:56 -0400
Date: Sun, 4 Oct 2015 09:40:53 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 04/10] staging: wilc1000: replace PRINT_ER with pr_err
Message-ID: <20151004084053.GA21313@kroah.com> (sfid-20151004_104104_498564_73BAB7AE)
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
 <1443789896-7082-4-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443789896-7082-4-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2015 at 09:44:50PM +0900, Chaehyun Lim wrote:
> This patch replaces PRINT_ER with pr_err.
> It would be better to use netdev_err, but it cannot use it in this
> function, so just use pr_err.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 566e618..802d87a 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -5322,7 +5322,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
>  	struct host_if_msg msg;
>  
>  	if (!pstrWFIDrv) {
> -		PRINT_ER("driver is null\n");
> +		pr_err("driver is null\n");
>  		return -EFAULT;
>  	}

I don't see how this check will ever trigger, do you?  If not, it should
just be removed.


>  
> @@ -5334,7 +5334,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
>  
>  	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
>  	if (result) {
> -		PRINT_ER("wilc mq send fail\n");
> +		pr_err("wilc mq send fail\n");

You should have a network device pointer somewhere here, dig around, it
should be possible to use netdev_err().

thanks,

greg k-h
