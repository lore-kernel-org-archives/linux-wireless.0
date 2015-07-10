Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37477 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbbGJGU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 02:20:57 -0400
Received: by igpy18 with SMTP id y18so6310787igp.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 23:20:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436507759-4546-2-git-send-email-johnny.kim@atmel.com>
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com> <1436507759-4546-2-git-send-email-johnny.kim@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Jul 2015 16:20:37 +1000
Message-ID: <CAGRGNgX4xctq0XmEt-g3fnLG_PyUj6kHxEf1=hd41tjxcWEnCw@mail.gmail.com> (sfid-20150710_082113_295402_584CEFED)
Subject: Re: [PATCH 1/3] staging: wilc1000: wilc_wlan_cfg_commit(): replace
 integer with pointer
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chris Park <chris.park@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>, tony.cho@atmel.com,
	Nicolas.FERRE@atmel.com, Dean Lee <dean.lee@atmel.com>,
	austin.shin@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johnny,

On Fri, Jul 10, 2015 at 3:55 PM, Johnny Kim <johnny.kim@atmel.com> wrote:
> A argument of wilc_wlan_cfg_commit() is address of structure.
> But because the size is restricted to 32bit, it is not correct
> for 64bit machine.
>
> So, this changes the interger value to obvious structure pointer.
>
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index def72fd..d32e45e 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -1862,13 +1862,13 @@ static void wilc_wlan_cleanup(void)
>
>  }
>
> -static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
> +static int wilc_wlan_cfg_commit(int type, tstrWILC_WFIDrv *drvHandler)
>  {
>         wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
>         wilc_cfg_frame_t *cfg = &p->cfg_frame;
>         int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
>         int seq_no = p->cfg_seq_no % 256;
> -       int driver_handler = (u32)drvHandler;
> +       uintptr_t driver_handler = (uintptr_t)drvHandler;

Er, why not just remove this variable and use drvHandler directly?

> @@ -1923,7 +1923,7 @@ static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t
>                 p->cfg_frame_in_use = 1;
>
>                 /*Edited by Amr - BugID_4720*/
> -               if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
> +               if (wilc_wlan_cfg_commit(WILC_CFG_SET, (tstrWILC_WFIDrv *)drvHandler))

No need to cast it to it's own type.

>                         ret_size = 0;   /* BugID_5213 */
>
>                 if (p->os_func.os_wait(p->cfg_wait, CFG_PKTS_TIMEOUT)) {
> @@ -1960,7 +1960,7 @@ static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHa
>                 p->cfg_frame_in_use = 1;
>
>                 /*Edited by Amr - BugID_4720*/
> -               if (wilc_wlan_cfg_commit(WILC_CFG_QUERY, drvHandler))
> +               if (wilc_wlan_cfg_commit(WILC_CFG_QUERY, (tstrWILC_WFIDrv *)drvHandler))

Ditto.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
