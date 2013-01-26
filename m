Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:63527 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3AZRQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 12:16:16 -0500
Received: by mail-yh0-f52.google.com with SMTP id q46so219221yhf.11
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2013 09:16:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130124210155.GC22800@localhost.localdomain>
References: <20130124205931.GB16252@localhost.localdomain>
	<20130124210028.GA22800@localhost.localdomain>
	<20130124210110.GB22800@localhost.localdomain>
	<20130124210155.GC22800@localhost.localdomain>
Date: Sat, 26 Jan 2013 18:16:15 +0100
Message-ID: <CAOZOX0UYTr-tfU4NdYnnDmu5+Mn6w3RFYRmRd2NHdPA+rjsmgg@mail.gmail.com> (sfid-20130126_181618_781214_2A41DB6B)
Subject: Re: [PATCH 4/4] rt2x00: print queue parameters at debug level
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
> Those messages do not provide interesting information for average user,
> print them at debug level.
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index ed7a1bb..20c6ecc 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -731,9 +731,9 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
>         queue->aifs = params->aifs;
>         queue->txop = params->txop;
>
> -       INFO(rt2x00dev,
> -            "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
> -            queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
> +       DEBUG(rt2x00dev,
> +             "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
> +             queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
>
>         return 0;
>  }
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
