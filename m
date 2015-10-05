Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33770 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbbJEClW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 22:41:22 -0400
Received: by iofh134 with SMTP id h134so171913962iof.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 19:41:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444010843-16796-3-git-send-email-chaehyun.lim@gmail.com>
References: <1444010843-16796-1-git-send-email-chaehyun.lim@gmail.com> <1444010843-16796-3-git-send-email-chaehyun.lim@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 5 Oct 2015 13:41:02 +1100
Message-ID: <CAGRGNgVkMaXtPA6nRY8-hcCYHdvX6pHoswtMFi1TPemHPMpJzA@mail.gmail.com> (sfid-20151005_044125_145215_7EB8BBEE)
Subject: Re: [PATCH 3/3] staging: wilc1000: return error code direclty in host_int_wait_msg_queue_idle
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, glen.lee@atmel.com,
	leo.kim@atmel.com, linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chaehyun,

On Mon, Oct 5, 2015 at 1:07 PM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> There is no need to pass the error code to the variable 'result'.
> Just return the error directly when error occurs.
> Return 0 at the end of this function when error is not happened.

We can't do this.

> Suggested-by: Julian Calaby <julian.calaby@gmail.com>
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index b1aa7dd..427fbaa 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -5343,7 +5343,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
>
>  int host_int_wait_msg_queue_idle(void)
>  {
> -       int result = 0;
> +       int result;
>
>         struct host_if_msg msg;
>
> @@ -5354,13 +5354,13 @@ int host_int_wait_msg_queue_idle(void)
>         result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
>         if (result) {
>                 PRINT_ER("wilc mq send fail\n");
> -               result = -EINVAL;
> +               return -EINVAL;

Returning here means that we don't call down:

>         }
>
>         /* wait untill MSG Q is empty */
>         down(&hWaitResponse);

here.

Sorry for the confusion.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
