Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45594 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab0IRIll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 04:41:41 -0400
Received: by vws3 with SMTP id 3so2080537vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Sep 2010 01:41:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284771979-13249-1-git-send-email-vmehta@atheros.com>
References: <1284771979-13249-1-git-send-email-vmehta@atheros.com>
Date: Sat, 18 Sep 2010 11:41:40 +0300
Message-ID: <AANLkTi=OsZGF=JxgwRCLCzBXqgYUW6xoOYHUN7Jb4MUv@mail.gmail.com>
Subject: Re: [PATCH] staging: ath6kl: Fixing a compile error
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: greg@kroah.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, randy.dunlap@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeah, but this is fixed in my correction series.
Whole store there:

http://lkml.org/lkml/2010/9/16/330
http://lkml.org/lkml/2010/9/17/54

On Sat, Sep 18, 2010 at 4:06 AM, Vipin Mehta <vmehta@atheros.com> wrote:
> Fixing a typo that came in as part of commit
> fa1ae16c97d25bb57ed9e1971b9e814da6a290bd.
>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Vipin Mehta <vmehta@atheros.com>
> ---
>  drivers/staging/ath6kl/wmi/wmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
> index 9811ce7..23ae5d2 100644
> --- a/drivers/staging/ath6kl/wmi/wmi.c
> +++ b/drivers/staging/ath6kl/wmi/wmi.c
> @@ -1458,7 +1458,7 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
>
>        A_DPRINTF(DBG_WMI2, (DBGFMT "bssInfo event - ch %u, rssi %02x, "
>                "bssid \"%pM\"\n", DBGARG, bih->channel,
> -               (unsigned char) bih->rssi, i&bih->bssid[0]));
> +               (unsigned char) bih->rssi, &bih->bssid[0]));
>
>     if(wps_enable && (bih->frameType == PROBERESP_FTYPE) ) {
>         wmi_node_return(wmip, bss);
> --
> 1.6.3.3
>
>



-- 
With Best Regards,
Andy Shevchenko
