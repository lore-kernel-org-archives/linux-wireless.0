Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49976 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1E3SZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 14:25:38 -0400
Received: by qwk3 with SMTP id 3so1768224qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 11:25:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110529104529.GA2769@localhost.localdomain>
References: <20110529104529.GA2769@localhost.localdomain>
Date: Mon, 30 May 2011 20:25:37 +0200
Message-ID: <BANLkTinABm=J0eZnwAjkYPwA1e3AgoFW6Q@mail.gmail.com> (sfid-20110530_202542_315505_B59EFA7E)
Subject: Re: [PATCH wireless-2.6] rt2x00: fix rmmod crash
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, May 29, 2011 at 12:45 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> Do not destroy workqueue, which still can be used by autowakeup_work,
> before ieee80211_unregister_hw() is called.

Well isn't the bug then that autowakeup_work isn't cancelled using
cancel_work_sync
like the other workqueue tasks?

I rather add the call to cancel_work_sync then moving the killing of
the workqueue.
The position where the workqueue is destroyed should be the place
where we cancel
all scheduled work, that way we can assume no rt2x00-related threads ater this
position.

Ivo

> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index c018d67..2f2627b 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1165,7 +1165,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>                cancel_work_sync(&rt2x00dev->rxdone_work);
>                cancel_work_sync(&rt2x00dev->txdone_work);
>        }
> -       destroy_workqueue(rt2x00dev->workqueue);
>
>        /*
>         * Free the tx status fifo.
> @@ -1198,6 +1197,11 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>        rt2x00lib_remove_hw(rt2x00dev);
>
>        /*
> +        * Now nobody use workqueue anymore.
> +        */
> +       destroy_workqueue(rt2x00dev->workqueue);
> +
> +       /*
>         * Free firmware image.
>         */
>        rt2x00lib_free_firmware(rt2x00dev);
> --
> 1.7.4
>
>
