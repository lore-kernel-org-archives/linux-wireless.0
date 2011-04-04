Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59323 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1DDNM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 09:12:56 -0400
Received: by qwk3 with SMTP id 3so3331644qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 06:12:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110404115000.GA9707@redhat.com>
References: <20110404115000.GA9707@redhat.com>
Date: Mon, 4 Apr 2011 15:12:55 +0200
Message-ID: <BANLkTi=Vx9wo5_4mhUJdMKwKxR7A_i7yAw@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: fix cancelling uninitialized work
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 4, 2011 at 1:50 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> {rx,tx}done_work's are only initialized for usb devices.
>
> Cc: stable@kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 9de9dbe..84eb6ad 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1062,8 +1062,10 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>         * Stop all work.
>         */
>        cancel_work_sync(&rt2x00dev->intf_work);
> -       cancel_work_sync(&rt2x00dev->rxdone_work);
> -       cancel_work_sync(&rt2x00dev->txdone_work);
> +       if (rt2x00_is_usb(rt2x00dev)) {
> +               cancel_work_sync(&rt2x00dev->rxdone_work);
> +               cancel_work_sync(&rt2x00dev->txdone_work);
> +       }
>        destroy_workqueue(rt2x00dev->workqueue);
>
>        /*
> --
> 1.7.1
>
>
