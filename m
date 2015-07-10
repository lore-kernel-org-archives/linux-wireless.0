Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36772 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbbGJGZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 02:25:53 -0400
Received: by igrv9 with SMTP id v9so6309590igr.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 23:25:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436507759-4546-3-git-send-email-johnny.kim@atmel.com>
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com> <1436507759-4546-3-git-send-email-johnny.kim@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Jul 2015 16:25:33 +1000
Message-ID: <CAGRGNgVwVKq2JQ5FypdAZvLUoYPEL+MQ=yPsMJo3onOfWin7vQ@mail.gmail.com> (sfid-20150710_082556_732493_DEC53EA7)
Subject: Re: [PATCH 2/3] staging: wilc1000: wilc_wlan_cfg_get(): replace
 integer with void pointer
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
> Last argument of wilc_wlan_cfg_get function is actually structure's address.
> This should be changed to be compatible with 64bit machine.
> Because wilc_wlan_cfg_get function is mapped by function pointer later,
> wilc_wlan_oup_t.wlan_cfg_get should be changed together.
>
> tstrWILC_WFIDrv structure is defined after wilc_wlan_oup_t.wlan_cfg_get
> is defined. So, this patch changes the argument to void type pointer.

Why not add a patch moving the structure definition before
wilc_wlan_oup_t.wlan_cfg_get is defined?

> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 2 +-
>  drivers/staging/wilc1000/wilc_wlan.c        | 2 +-
>  drivers/staging/wilc1000/wilc_wlan_if.h     | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index b069614..141d7b4 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -2094,7 +2094,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
>                                    (counter == u32WIDsCount - 1));
>                         if (!gpstrWlanOps->wlan_cfg_get(!counter,
>                                                         pstrWIDs[counter].u16WIDid,
> -                                                       (counter == u32WIDsCount - 1), drvHandler)) {
> +                                                       (counter == u32WIDsCount - 1), (void *)drvHandler)) {

If I recall correctly, you shouldn't need void * casts.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
