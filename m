Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:32901 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752890AbdBIPAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Feb 2017 10:00:20 -0500
Received: by mail-qt0-f169.google.com with SMTP id v23so6106634qtb.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2017 07:00:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1486558291-1615-4-git-send-email-sgruszka@redhat.com>
References: <1486558291-1615-1-git-send-email-sgruszka@redhat.com> <1486558291-1615-4-git-send-email-sgruszka@redhat.com>
From: Jeroen Roovers <jer@airfi.aero>
Date: Thu, 9 Feb 2017 16:00:19 +0100
Message-ID: <CANCHnQq0111TX8psb4YizjSzOOUQSxj6Cf7OX8+L60J83wudsQ@mail.gmail.com> (sfid-20170209_160050_641503_343E89A7)
Subject: Re: [PATCH 3/3] rt2x00: remove queue_entry from skbdesc
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2017 at 13:51, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
> index 2233b91..22d1881 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
> @@ -116,8 +116,6 @@ struct skb_frame_desc {
>         __le32 iv[2];
>
>         dma_addr_t skb_dma;
> -
> -       struct queue_entry *entry;
>  };
>
>  /**

That change needs this line removed above:

 * @entry: The entry to which this sk buffer belongs.


Cheers.
     jer
