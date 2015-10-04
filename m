Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35788 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbbJDXu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 19:50:27 -0400
Received: by igbkq10 with SMTP id kq10so49706021igb.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 16:50:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1443789896-7082-3-git-send-email-chaehyun.lim@gmail.com>
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com> <1443789896-7082-3-git-send-email-chaehyun.lim@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 5 Oct 2015 10:50:07 +1100
Message-ID: <CAGRGNgVbs1jBdLbGurCwcxZmV4-szfU5gs8fsmk9ZxAN_Z-EPA@mail.gmail.com> (sfid-20151005_015053_155067_A709657B)
Subject: Re: [PATCH 03/10] staging: wilc1000: rename s32Error in host_int_set_mac_chnl_num
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
> index 65bd325..566e618 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -5317,7 +5317,7 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
>   */
>  int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
>  {
> -       int s32Error = 0;
> +       int result = 0;
>         tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
>         struct host_if_msg msg;
>
> @@ -5332,13 +5332,13 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
>         msg.body.channel_info.u8SetChan = u8ChNum;
>         msg.drvHandler = hWFIDrv;
>
> -       s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
> -       if (s32Error) {
> +       result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
> +       if (result) {
>                 PRINT_ER("wilc mq send fail\n");
> -               s32Error = -EINVAL;
> +               result = -EINVAL;

Why not just have

return -EINVAL;

here?

>         }
>
> -       return s32Error;
> +       return result;

and

return 0;

here?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
