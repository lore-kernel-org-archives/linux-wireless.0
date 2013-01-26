Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:40955 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3AZRVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 12:21:49 -0500
Received: by mail-yh0-f46.google.com with SMTP id q15so219079yhf.33
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2013 09:21:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130124210110.GB22800@localhost.localdomain>
References: <20130124205931.GB16252@localhost.localdomain>
	<20130124210028.GA22800@localhost.localdomain>
	<20130124210110.GB22800@localhost.localdomain>
Date: Sat, 26 Jan 2013 18:15:47 +0100
Message-ID: <CAOZOX0WEWYZUfrOMVB-rTfkJaO+RYVv0SF9o_A_3kzQzDdcppw@mail.gmail.com> (sfid-20130126_182154_981787_1F49D244)
Subject: Re: [PATCH 3/4] rt2800usb: move "TX status missed" messages to debug level
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 24, 2013 at 10:01 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> Those messages can flood in dmesg, so do not print them by default.
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 011410f..047ead5 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -540,9 +540,9 @@ rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
>         tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
>
>         if (wcid != tx_wcid || ack != tx_ack || (!is_agg && pid != tx_pid)) {
> -               WARNING(entry->queue->rt2x00dev,
> -                       "TX status report missed for queue %d entry %d\n",
> -                       entry->queue->qid, entry->entry_idx);
> +               DEBUG(entry->queue->rt2x00dev,
> +                     "TX status report missed for queue %d entry %d\n",
> +                     entry->queue->qid, entry->entry_idx);
>                 return TXDONE_UNKNOWN;
>         }
>
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
