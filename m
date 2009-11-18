Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52126 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZKRCZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 21:25:06 -0500
Received: by bwz27 with SMTP id 27so646075bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 18:25:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258509054-10901-1-git-send-email-janakiram.sistla@gmail.com>
References: <1258509054-10901-1-git-send-email-janakiram.sistla@gmail.com>
Date: Wed, 18 Nov 2009 07:55:10 +0530
Message-ID: <4fb5db50911171825l2b1c1a3bk1169820d59c0989@mail.gmail.com>
Subject: Re:
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Janakiram Sistla <janakiram.sistla@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will be resending this patch ...sorry subjet line missing in this
sorry about that

Regards,
Ram.
On Wed, Nov 18, 2009 at 7:20 AM, Janakiram Sistla
<janakiram.sistla@gmail.com> wrote:
> From: Janakiram Sistla <janakiram.sistla@gmail.com>
>
> Adding radio type FM in RFKILL_TYPE_.FM belongs to
> same class of with both TX/RX capability
>
> Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
> ---
>  include/linux/rfkill.h |    2 ++
>  net/rfkill/core.c      |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 3392c59..7ae75ef 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -35,6 +35,7 @@
>  * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
>  * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
>  * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
> + * @RFKILL_TYPE_FM: switch is on a wireless FM device.
>  * @NUM_RFKILL_TYPES: number of defined rfkill types
>  */
>  enum rfkill_type {
> @@ -44,6 +45,7 @@ enum rfkill_type {
>        RFKILL_TYPE_UWB,
>        RFKILL_TYPE_WIMAX,
>        RFKILL_TYPE_WWAN,
> +       RFKILL_TYPE_FM,
>        RFKILL_TYPE_GPS,
>        NUM_RFKILL_TYPES,
>  };
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index ba2efb9..61b716e 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -590,6 +590,8 @@ static const char *rfkill_get_type_str(enum rfkill_type type)
>                return "wimax";
>        case RFKILL_TYPE_WWAN:
>                return "wwan";
> +       case RFKILL_TYPE_FM:
> +               return "fm";
>        case RFKILL_TYPE_GPS:
>                return "gps";
>        default:
> --
> 1.5.4.3
>
>
