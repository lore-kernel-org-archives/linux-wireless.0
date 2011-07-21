Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58812 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1GUOD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 10:03:26 -0400
Received: by vxh35 with SMTP id 35so896983vxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 07:03:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d9HgRvdJModc3hSA25+jLktZJ3i997oq7GfZz4dUJfuvw@mail.gmail.com>
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com>
	<201107201536.01392.helmut.schaa@googlemail.com>
	<CAN=pzdKLtB2yz4-OhKL5gzYF0Qm2weAmNAz-0MqdFuooFNYzwQ@mail.gmail.com>
	<201107201709.42141.helmut.schaa@googlemail.com>
	<CAN=pzdL7baXMVORm6CDh4Py773jbFBFkfRUKhjbL0ATZ_yvJmg@mail.gmail.com>
	<CAGXE3d9HgRvdJModc3hSA25+jLktZJ3i997oq7GfZz4dUJfuvw@mail.gmail.com>
Date: Thu, 21 Jul 2011 18:03:25 +0400
Message-ID: <CAN=pzdKHWNcvwAn3uDMzTdpvv3MkM9KNC89NuzZX=z6npBnUGg@mail.gmail.com> (sfid-20110721_160331_899093_ECAE30B3)
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
From: Stanislav Demakov <s.demakov@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch won't apply on current compat-wireless-2011-07-20.tar.bz2

(Stripping trailing CRs from patch.)
patching file b/drivers/net/wireless/rt2x00/rt2800lib.c
Hunk #1 FAILED at 4194.
1 out of 1 hunk FAILED -- saving rejects to file
b/drivers/net/wireless/rt2x00/rt2800lib.c.rej
(Stripping trailing CRs from patch.)
patching file b/drivers/net/wireless/rt2x00/rt2800usb.c
Hunk #1 FAILED at 527.
patch unexpectedly ends in middle of line
Hunk #2 FAILED at 820.
2 out of 2 hunks FAILED -- saving rejects to file
b/drivers/net/wireless/rt2x00/rt2800usb.c.rej

Should I use another version of compat wireless or edit files manually?
Also I have no stability issues, the connection is stable, but as I
said the TX speed from AP running rt2x00 (the driver is in Master
mode) to client is extremely slow in 802.11n+WMM mode.
And this is only WMM mode related, because wIthout it everything is fine.


2011/7/21 Helmut Schaa <helmut.schaa@googlemail.com>:
> On Thu, Jul 21, 2011 at 1:53 PM, Stanislav Demakov <s.demakov@gmail.com> wrote:
>> So eventually, are you going to fix or discover this bug yourself?
>
> Please try this on top of a current compat-wireless. It improved STA
> mode stability in
> rt2800usb for me quite a bit. But this is not a valid fix, it's just
> for tracking down the
> problem a bit further.
>
> Thanks,
> Helmut
>
> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
> b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 1ac1f39..3d9d152 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -4194,8 +4194,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>        /*
>         * Disable powersaving as default on PCI devices.
>         */
> -       if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
> -               rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +       rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
>
>        /*
>         * Initialize all hw fields.
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c
> b/drivers/net/wireless/rt2x00/rt2800usb.c
> index f9c58cd..602677c 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -527,7 +527,7 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>                entry = NULL;
>                while (!rt2x00queue_empty(queue)) {
>                        entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
> -                       if (rt2800usb_txdone_entry_check(entry, reg))
> +                       /*if (rt2800usb_txdone_entry_check(entry, reg))*/
>                                break;
>                }
>
> @@ -820,7 +820,7 @@ static const struct data_queue_desc rt2800usb_queue_rx = {
>  };
>
>  static const struct data_queue_desc rt2800usb_queue_tx = {
> -       .entry_num              = 64,
> +       .entry_num              = 8,
>        .data_size              = AGGREGATION_SIZE,
>        .desc_size              = TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
>        .priv_size              = sizeof(struct queue_entry_priv_usb),
>
