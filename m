Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47600 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab0KDXWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 19:22:08 -0400
Received: by iwn41 with SMTP id 41so77228iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 16:22:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201011042041.06812.IvDoorn@gmail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042040.12419.IvDoorn@gmail.com>
 <201011042040.47235.IvDoorn@gmail.com> <201011042041.06812.IvDoorn@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 5 Nov 2010 10:21:46 +1100
Message-ID: <AANLkTinrhE9oOwYP8-ujeJ_YS97AP8=mwgmQ09gd1B6u@mail.gmail.com>
Subject: Re: [PATCH 11/13] rt2x00: Fix crash on USB unplug
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo,

A minor nit:

On Fri, Nov 5, 2010 at 06:41, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> By not scheduling the TX/RX completion worker threads
> when Radio is disabled, or hardware has been unplugged,
> the queues cannot be completely cleaned.
>
> This causes crashes when the hardware has been unplugged while
> the radio is still enabled.
>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index a5c7a4f..b6822cd 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -483,6 +483,10 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
>        unsigned int header_length;
>        int rate_idx;
>
> +       if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
> +           !test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
> +               goto submit_entry;
> +
>        if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
>                goto submit_entry;
>

Could these two if statements be combined?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
