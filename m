Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35050 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbFNX16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 19:27:58 -0400
Received: by iesa3 with SMTP id a3so52284722ies.2
        for <linux-wireless@vger.kernel.org>; Sun, 14 Jun 2015 16:27:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1434298342-1620-1-git-send-email-linux@rempel-privat.de>
References: <1434298342-1620-1-git-send-email-linux@rempel-privat.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 15 Jun 2015 09:27:37 +1000
Message-ID: <CAGRGNgUWJ-LDgdxe1TJw2YOroMKaYDj3ehUu7j_zoqX17BxbjQ@mail.gmail.com> (sfid-20150615_012804_356447_B2FE151D)
Subject: Re: [PATCH] ath9k_htc: introduce support for different fw versions
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oleksij,

On Mon, Jun 15, 2015 at 2:12 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Current kernel support only one fw name with theoretically only one
> fw version. By replacing fw with other version we will break compatibility
> with older kernels.
>
> To avoid this kind of regression this patch will reuse fw version model
> from iwlwifi driver.
>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c      | 102 ++++++++++++++++++++------
>  drivers/net/wireless/ath/ath9k/hif_usb.h      |  13 +++-
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |   4 +
>  3 files changed, 95 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 10c02f5..18407f2 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -17,10 +17,6 @@
>  #include <asm/unaligned.h>
>  #include "htc.h"
>
> -/* identify firmware images */
> -#define FIRMWARE_AR7010_1_1     "htc_7010.fw"
> -#define FIRMWARE_AR9271         "htc_9271.fw"
> -
>  MODULE_FIRMWARE(FIRMWARE_AR7010_1_1);
>  MODULE_FIRMWARE(FIRMWARE_AR9271);

Shouldn't you declare the versioned firmware names here too?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
