Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60086 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0EMJpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:45:35 -0400
Received: by fxm6 with SMTP id 6so110158fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 02:45:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273743418-28383-5-git-send-email-gwingerde@gmail.com>
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
	 <1273743418-28383-5-git-send-email-gwingerde@gmail.com>
Date: Thu, 13 May 2010 11:45:33 +0200
Message-ID: <AANLkTilbzQ1_16u2hjkh6pFSnUmjg8bNRHiJf_g1hPPb@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] rt2x00: Move rt2x00debug_dump_frame declaration
	to rt2x00.h.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 11:36 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> This allows rt2x00debug_dump_frame to be used from everywhere.
>
> This is preparation for beacon writing clean ups.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00.h      |   35 +++++++++++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2x00debug.c |    1 +
>  drivers/net/wireless/rt2x00/rt2x00dump.h  |   20 ----------------
>  drivers/net/wireless/rt2x00/rt2x00lib.h   |   10 --------
>  4 files changed, 36 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 6c1ff4c..1329f6c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -1015,6 +1015,41 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
>                                          enum queue_index index);
>
>  /*
> + * Debugfs handlers.
> + */
> +/**
> + * enum rt2x00_dump_type - Frame type
> + *
> + * These values are used for the indicate the type of frame that is being
> + * dumped:
> + * @DUMP_FRAME_RXDONE: This frame has been received by the hardware.
> + * @DUMP_FRAME_TX: This frame is queued for transmission to the hardware.
> + * @DUMP_FRAME_TXDONE: This frame indicates the device has handled
> + *     the tx event which has either succeeded or failed. A frame
> + *     with this type should also have been reported with as a
> + *     %DUMP_FRAME_TX frame.
> + * @DUMP_FRAME_BEACON: This beacon frame is queued for transmission to the
> + *     hardware.
> + */
> +enum rt2x00_dump_type {
> +       DUMP_FRAME_RXDONE = 1,
> +       DUMP_FRAME_TX = 2,
> +       DUMP_FRAME_TXDONE = 3,
> +       DUMP_FRAME_BEACON = 4,
> +};

Can't this stay in rt2x00dump.h? The rt2x00dump.h is part of the
public interface towards
userspace which can use these defined to determine the frame type.
We can safely include this header in rt2x00.h since it contains the
public interface anyway.

> +#ifdef CONFIG_RT2X00_LIB_DEBUGFS
> +void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
> +                           enum rt2x00_dump_type type, struct sk_buff *skb);
> +#else
> +static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
> +                                         enum rt2x00_dump_type type,
> +                                         struct sk_buff *skb)
> +{
> +}
> +#endif /* CONFIG_RT2X00_LIB_DEBUGFS */

Could you add some documentation to this function?

Thanks,

Ivo
