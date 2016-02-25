Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36661 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687AbcBYBHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 20:07:41 -0500
Received: by mail-io0-f174.google.com with SMTP id l127so72441718iof.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 17:07:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456358932-23114-6-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com> <1456358932-23114-6-git-send-email-afenkart@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 25 Feb 2016 12:07:20 +1100
Message-ID: <CAGRGNgVtYNfiJVCJcvM-+rduvSj4Uj59RgK6Uq81HA87J8MaKQ@mail.gmail.com> (sfid-20160225_020758_694923_BD5537B3)
Subject: Re: [PATCH 5/7] mwifiex: scan: replace pointer arithmetic with array access
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Feb 25, 2016 at 11:08 AM, Andreas Fenkart <afenkart@gmail.com> wrote:
> improves readability
>
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

Looks correct to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/net/wireless/marvell/mwifiex/scan.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index 5588750..6ddc98b 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -999,27 +999,24 @@ mwifiex_config_scan(struct mwifiex_private *priv,
>                      chan_idx++) {
>
>                         channel = user_scan_in->chan_list[chan_idx].chan_number;
> -                       (scan_chan_list + chan_idx)->chan_number = channel;
> +                       scan_chan_list[chan_idx].chan_number = channel;
>
>                         radio_type =
>                                 user_scan_in->chan_list[chan_idx].radio_type;
> -                       (scan_chan_list + chan_idx)->radio_type = radio_type;
> +                       scan_chan_list[chan_idx].radio_type = radio_type;
>
>                         scan_type = user_scan_in->chan_list[chan_idx].scan_type;
>
>                         if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
> -                               (scan_chan_list +
> -                                chan_idx)->chan_scan_mode_bitmap
> +                               scan_chan_list[chan_idx].chan_scan_mode_bitmap
>                                         |= (MWIFIEX_PASSIVE_SCAN |
>                                             MWIFIEX_HIDDEN_SSID_REPORT);
>                         else
> -                               (scan_chan_list +
> -                                chan_idx)->chan_scan_mode_bitmap
> +                               scan_chan_list[chan_idx].chan_scan_mode_bitmap
>                                         &= ~MWIFIEX_PASSIVE_SCAN;
>
>                         if (*filtered_scan)
> -                               (scan_chan_list +
> -                                chan_idx)->chan_scan_mode_bitmap
> +                               scan_chan_list[chan_idx].chan_scan_mode_bitmap
>                                         |= MWIFIEX_DISABLE_CHAN_FILT;
>
>                         if (user_scan_in->chan_list[chan_idx].scan_time) {
> @@ -1034,9 +1031,9 @@ mwifiex_config_scan(struct mwifiex_private *priv,
>                                         scan_dur = adapter->active_scan_time;
>                         }
>
> -                       (scan_chan_list + chan_idx)->min_scan_time =
> +                       scan_chan_list[chan_idx].min_scan_time =
>                                 cpu_to_le16(scan_dur);
> -                       (scan_chan_list + chan_idx)->max_scan_time =
> +                       scan_chan_list[chan_idx].max_scan_time =
>                                 cpu_to_le16(scan_dur);
>                 }
>
> --
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
