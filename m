Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51877 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2BGMuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 07:50:17 -0500
Received: by vbjk17 with SMTP id k17so4571551vbj.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 04:50:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328568313-26267-2-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-2-git-send-email-gwingerde@gmail.com>
Date: Tue, 7 Feb 2012 13:50:16 +0100
Message-ID: <CAOZOX0WW8Mw8SKvG0itMUHLdJktaMimgYVTMkc=DJmPUHrb40w@mail.gmail.com> (sfid-20120207_135022_941534_4C6E28B8)
Subject: Re: [PATCH 1/8] rt2x00: Introduce concept of driver data in struct rt2x00_dev.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 11:45 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> We are getting more and more fields in struct rt2x00_dev that are
> specific to one or two of the low-level drivers. Instead of putting
> these fields inside the main structure and thus clobbering all low-level
> drivers with these fields, introduce the concept of driver data inside
> struct rt2x00_dev, whose size is indicated by the low-level driver and
> which can be populated by the low-level driver.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index b03b22c..b4260bfb6 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -647,6 +647,7 @@ struct rt2x00lib_ops {
>  */
>  struct rt2x00_ops {
>        const char *name;
> +       const unsigned int drv_data_size;
>        const unsigned int max_sta_intf;
>        const unsigned int max_ap_intf;
>        const unsigned int eeprom_size;
> @@ -742,6 +743,11 @@ struct rt2x00_dev {
>        const struct rt2x00_ops *ops;
>
>        /*
> +        * Driver data.
> +        */
> +       void *drv_data;
> +
> +       /*
>         * IEEE80211 control structure.
>         */
>        struct ieee80211_hw *hw;
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index c3e1aa7..bae5b01 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1121,6 +1121,18 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>  {
>        int retval = -ENOMEM;
>
> +       /*
> +        * Allocate the driver data memory, if necessary.
> +        */
> +       if (rt2x00dev->ops->drv_data_size > 0) {
> +               rt2x00dev->drv_data = kzalloc(rt2x00dev->ops->drv_data_size,
> +                                             GFP_KERNEL);
> +               if (!rt2x00dev->drv_data) {
> +                       retval = -ENOMEM;
> +                       goto exit;
> +               }
> +       }
> +
>        spin_lock_init(&rt2x00dev->irqmask_lock);
>        mutex_init(&rt2x00dev->csr_mutex);
>
> @@ -1261,6 +1273,12 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>         * Free queue structures.
>         */
>        rt2x00queue_free(rt2x00dev);
> +
> +       /*
> +        * Free the driver data.
> +        */
> +       if (rt2x00dev->drv_data)
> +               kfree(rt2x00dev->drv_data);
>  }
>  EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
>
> --
> 1.7.9
>
