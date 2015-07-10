Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33770 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbbGJG0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 02:26:54 -0400
Received: by ietj16 with SMTP id j16so17638412iet.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 23:26:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436507759-4546-4-git-send-email-johnny.kim@atmel.com>
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com> <1436507759-4546-4-git-send-email-johnny.kim@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Jul 2015 16:26:34 +1000
Message-ID: <CAGRGNgV6=vihfE3+p-nBm8sBKJ11tv9tzX472b=MSstOrUYMgg@mail.gmail.com> (sfid-20150710_082657_904057_0E891A3F)
Subject: Re: [PATCH 3/3] staging: wilc1000: wilc_wlan_cfg_set(): replace
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
> Last argument of wilc_wlan_cfg_set function is actually structure's address.
> This should be changed to be compatible with 64bit machine.
> Because wilc_wlan_cfg_set function is mapped by function pointer later,
> wilc_wlan_oup_t.wlan_cfg_set should be changed together.
>
> tstrWILC_WFIDrv structure is defined after wilc_wlan_oup_t.wlan_cfg_set
> is defined. So, this patch changes the argument to void type pointer.

Same question, why not move the structure definition before this op is defined?

> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 2 +-
>  drivers/staging/wilc1000/linux_wlan.c       | 2 +-
>  drivers/staging/wilc1000/wilc_wlan.c        | 2 +-
>  drivers/staging/wilc1000/wilc_wlan_if.h     | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 141d7b4..5c1096d 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -2117,7 +2117,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
>                         if (!gpstrWlanOps->wlan_cfg_set(!counter,
>                                                         pstrWIDs[counter].u16WIDid, pstrWIDs[counter].ps8WidVal,
>                                                         pstrWIDs[counter].s32ValueSize,
> -                                                       (counter == u32WIDsCount - 1), drvHandler)) {
> +                                                       (counter == u32WIDsCount - 1), (void *)drvHandler)) {

Again, you shouldn't need a void * cast.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
