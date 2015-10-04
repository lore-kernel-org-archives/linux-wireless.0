Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36523 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbbJDXvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 19:51:45 -0400
Received: by ioii196 with SMTP id i196so168795666ioi.3
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 16:51:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1443789896-7082-8-git-send-email-chaehyun.lim@gmail.com>
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com> <1443789896-7082-8-git-send-email-chaehyun.lim@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 5 Oct 2015 10:51:24 +1100
Message-ID: <CAGRGNgXZZupj_H1yc4QZXZVmXPTW6CmFcdaGFUVPsbUHZg9q8g@mail.gmail.com> (sfid-20151005_015147_469017_1D71581E)
Subject: Re: [PATCH 08/10] staging: wilc1000: rename s32Error in host_int_wait_msg_queue_idle
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

On Fri, Oct 2, 2015 at 10:44 PM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> This patch replaces s32Error with result to avoid camelcase.
>
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index e5b7689..69a4e79 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -5344,7 +5344,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
>
>  int host_int_wait_msg_queue_idle(void)
>  {
> -       int s32Error = 0;
> +       int result = 0;
>
>         struct host_if_msg msg;
>
> @@ -5352,16 +5352,16 @@ int host_int_wait_msg_queue_idle(void)
>
>         memset(&msg, 0, sizeof(struct host_if_msg));
>         msg.id = HOST_IF_MSG_Q_IDLE;
> -       s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
> -       if (s32Error) {
> +       result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
> +       if (result) {
>                 PRINT_ER("wilc mq send fail\n");
> -               s32Error = -EINVAL;
> +               result = -EINVAL;

Same comments here: Why not

return -EINVAL;

>         }
>
>         /* wait untill MSG Q is empty */
>         down(&hWaitResponse);
>
> -       return s32Error;
> +       return result;

and

return 0;

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
