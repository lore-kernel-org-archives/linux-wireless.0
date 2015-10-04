Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbbJDImd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 04:42:33 -0400
Date: Sun, 4 Oct 2015 09:42:29 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 09/10] staging: wilc1000: use pr_err in
 host_int_wait_msg_queue_idle
Message-ID: <20151004084229.GC21313@kroah.com> (sfid-20151004_104237_960209_C597A473)
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
 <1443789896-7082-9-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443789896-7082-9-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2015 at 09:44:55PM +0900, Chaehyun Lim wrote:
> This patch changes PRINT_ER by pr_err.
> It would be better to use netdev_err, but it cannot use it in this
> function, so just use pr_err.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 69a4e79..79014ab 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -5354,7 +5354,7 @@ int host_int_wait_msg_queue_idle(void)
>  	msg.id = HOST_IF_MSG_Q_IDLE;
>  	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
>  	if (result) {
> -		PRINT_ER("wilc mq send fail\n");
> +		pr_err("wilc mq send fail\n");

Same as before, you should be able to get to a network device, please
use netdev_err().
