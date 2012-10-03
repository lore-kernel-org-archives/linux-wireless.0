Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59677 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab2JCJd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 05:33:26 -0400
Received: by vbbff1 with SMTP id ff1so7581609vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2012 02:33:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349202079-14115-1-git-send-email-linville@tuxdriver.com>
References: <1349202079-14115-1-git-send-email-linville@tuxdriver.com>
Date: Wed, 3 Oct 2012 11:33:25 +0200
Message-ID: <CAOZOX0URb51i=6wko1MJVsi7du2kyYo9W=LLZSpH7Svh9BgAMw@mail.gmail.com> (sfid-20121003_113332_195497_FE0C4680)
Subject: Re: [RFC] rt2x00: check return from dma_map_single
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Oct 2, 2012 at 8:21 PM, John W. Linville <linville@tuxdriver.com> wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
>
> dma_map_single can fail, so it's return value needs to be checked and
> handled accordingly.  Failure to do so is akin to failing to check the
> return from a kmalloc.
>
> http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> Compile tested only...can the experts take a look at how the failures
> are handled?

<snip>

> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 0751b35..50ff18d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -605,8 +605,8 @@ struct rt2x00lib_ops {
>                                struct txentry_desc *txdesc);
>         void (*write_tx_data) (struct queue_entry *entry,
>                                struct txentry_desc *txdesc);
> -       void (*write_beacon) (struct queue_entry *entry,
> -                             struct txentry_desc *txdesc);
> +       int (*write_beacon) (struct queue_entry *entry,
> +                            struct txentry_desc *txdesc);
>         void (*clear_beacon) (struct queue_entry *entry);
>         int (*get_tx_data_len) (struct queue_entry *entry);

The only thing I am missing in the commit, is the check for
the return value when write_beacon is being called.

Ivo
