Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58933 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab0EDX1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 19:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <1273012850-8359-1-git-send-email-hauke@hauke-m.de>
References: <1273012850-8359-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 4 May 2010 16:26:53 -0700
Message-ID: <v2u43e72e891005041626n14deaca5z284f2472e909c923@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: updates for orinoco
To: Hauke Mehrtens <hauke@hauke-m.de>,
	Stephen Hemminger <shemminger@vyatta.com>,
	David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all, thanks a lot! Some comments below.

On Tue, May 4, 2010 at 3:40 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> * Make all the patches apply again.
> * rename read_pda to avoid conflicts with definitions in kernel <= 2.6.29

I'm going to apply these two changes, if you get time can you send a
patch to rename read_pda upstream as well, that way we don't have to
carry this?

> * add orinoco usb

Thanks for this but I've grown tired of updating these netdev ops and
I think we can do better. I'll add a netdev_attach_ops() which would
simply do all the backport stuff for us, this way for backporting
purposes all we have to do is replace the old lines with a
netdev_attach_ops() call. In fact if we *really* wanted to we could
add a dummy netdev_attach_ops() upstream and just backport that on
older kernels, this would mean 0 line changes to backport a newer
driver.

Something like this maybe on the generic compat module, it builds for
me, will commit soon.

/*
 * Expand this as drivers require more ops, for now this
 * only sets the ones we need.
 */
void netdev_attach_ops(struct net_device *dev,
                      const struct net_device_ops *ops)
{
#define SET_NETDEVOP(_op) (_op ? _op : NULL)
       dev->open = SET_NETDEVOP(ops->ndo_open);
       dev->stop = SET_NETDEVOP(ops->ndo_stop);
       dev->hard_start_xmit = SET_NETDEVOP(ops->ndo_start_xmit);
       dev->set_multicast_list = SET_NETDEVOP(ops->ndo_set_multicast_list);
       dev->change_mtu = SET_NETDEVOP(ops->ndo_change_mtu);
       dev->set_mac_address = SET_NETDEVOP(ops->ndo_set_mac_address);
       dev->tx_timeout = SET_NETDEVOP(ops->ndo_tx_timeout);
       dev->get_stats = SET_NETDEVOP(ops->ndo_get_stats);
#undef SET_NETDEVOP
}
EXPORT_SYMBOL(netdev_attach_ops);

For newer kernels then this would just be:

static inline void netdev_attach_ops(struct net_device *dev,
                      const struct net_device_ops *ops)
{
       dev->netdev_ops = ops;
}

Stephen, would the above be acceptable upstream on netdevice.h ? It
would eliminate all needs from having to #ifdef network drivers when
backporting. If so I can send a respective patch and spatch all the
setters I think. An example of the nasty ifdef crap we have to do for
the current backport of netdevop'able drivers is below.

  Luis

> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  config.mk                                 |    2 +
>  patches/01-netdev.patch                   |   51 +++++++++++++++++++++-----
>  patches/24-pcmcia.patch                   |   10 +++---
>  patches/27-hermes-read-pda-conflict.patch |   56 +++++++++++++++++++++++++++++
>  4 files changed, 104 insertions(+), 15 deletions(-)
>  create mode 100644 patches/27-hermes-read-pda-conflict.patch
>
> diff --git a/config.mk b/config.mk
> index 6a7c5c9..176c0af 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -388,6 +388,8 @@ CONFIG_LIBERTAS_USB=m
>  NEED_LIBERTAS=y
>  endif
>
> +CONFIG_ORINOCO_USB=m
> +
>  endif # end of USB driver list
>
>  ifneq ($(CONFIG_SPI_MASTER),)
> diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
> index 01dbbce..51d12c4 100644
> --- a/patches/01-netdev.patch
> +++ b/patches/01-netdev.patch
> @@ -575,7 +575,7 @@ without creating a headache on maintenance of the pathes.
>        dev->tx_queue_len = 0;
>  --- a/drivers/net/wireless/orinoco/main.c
>  +++ b/drivers/net/wireless/orinoco/main.c
> -@@ -2078,6 +2078,7 @@ int orinoco_init(struct orinoco_private
> +@@ -2087,6 +2087,7 @@ int orinoco_init(struct orinoco_private
>  }
>  EXPORT_SYMBOL(orinoco_init);
>
> @@ -583,7 +583,7 @@ without creating a headache on maintenance of the pathes.
>  static const struct net_device_ops orinoco_netdev_ops = {
>        .ndo_open               = orinoco_open,
>        .ndo_stop               = orinoco_stop,
> -@@ -2089,6 +2090,7 @@ static const struct net_device_ops orino
> +@@ -2098,6 +2099,7 @@ static const struct net_device_ops orino
>        .ndo_tx_timeout         = orinoco_tx_timeout,
>        .ndo_get_stats          = orinoco_get_stats,
>  };
> @@ -591,12 +591,15 @@ without creating a headache on maintenance of the pathes.
>
>  /* Allocate private data.
>   *
> -@@ -2211,7 +2213,18 @@ int orinoco_if_add(struct orinoco_privat
> -
> -       /* Setup / override net_device fields */
> -       dev->ieee80211_ptr = wdev;
> +@@ -2227,10 +2229,21 @@ int orinoco_if_add(struct orinoco_privat
> +       dev->wireless_data = &priv->wireless_data;
> + #endif
> +       /* Default to standard ops if not set */
>  +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
> -       dev->netdev_ops = &orinoco_netdev_ops;
> +       if (ops)
> +               dev->netdev_ops = ops;
> +       else
> +               dev->netdev_ops = &orinoco_netdev_ops;
>  +#else
>  +      dev->open = orinoco_open;
>  +      dev->stop = orinoco_stop;
> @@ -607,9 +610,37 @@ without creating a headache on maintenance of the pathes.
>  +      dev->tx_timeout = orinoco_tx_timeout;
>  +      dev->get_stats = orinoco_get_stats;
>  +#endif
> -       dev->watchdog_timeo = HZ; /* 1 second timeout */
> -       dev->wireless_handlers = &orinoco_handler_def;
> - #ifdef WIRELESS_SPY
> +
> +       /* we use the default eth_mac_addr for setting the MAC addr */
> +
> +--- a/drivers/net/wireless/orinoco/orinoco_usb.c
> ++++ b/drivers/net/wireless/orinoco/orinoco_usb.c
> +@@ -1566,6 +1566,7 @@ static const struct hermes_ops ezusb_ops
> +       .unlock_irq = ezusb_unlock_irq,
> + };
> +
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
> + static const struct net_device_ops ezusb_netdev_ops = {
> +       .ndo_open               = orinoco_open,
> +       .ndo_stop               = orinoco_stop,
> +@@ -1577,6 +1578,7 @@ static const struct net_device_ops ezusb
> +       .ndo_tx_timeout         = orinoco_tx_timeout,
> +       .ndo_get_stats          = orinoco_get_stats,
> + };
> ++#endif
> +
> + static int ezusb_probe(struct usb_interface *interface,
> +                      const struct usb_device_id *id)
> +@@ -1722,6 +1724,9 @@ static int ezusb_probe(struct usb_interf
> +               err("%s: orinoco_if_add() failed", __func__);
> +               goto error;
> +       }
> ++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
> ++      priv->ndev->hard_start_xmit = ezusb_xmit;
> ++#endif
> +       upriv->dev = priv->ndev;
> +
> +       goto exit;
>  --- a/net/bluetooth/bnep/netdev.c
>  +++ b/net/bluetooth/bnep/netdev.c
>  @@ -168,8 +168,12 @@ static inline int bnep_net_proto_filter(
> diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
> index 283b30d..3bc395d 100644
> --- a/patches/24-pcmcia.patch
> +++ b/patches/24-pcmcia.patch
> @@ -251,9 +251,9 @@
>        /* Register an interface with the stack */
>        if (orinoco_if_add(priv, link->io.BasePort1,
>  +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> -                          link->irq) != 0) {
> +                          link->irq, NULL) != 0) {
>  +#else
> -+                         link->irq.AssignedIRQ) != 0) {
> ++                         link->irq.AssignedIRQ, NULL) != 0) {
>  +#endif
>                printk(KERN_ERR PFX "orinoco_if_add() failed\n");
>                goto failed;
> @@ -285,14 +285,14 @@
>        if (ret)
>                goto failed;
>
> -@@ -359,7 +369,11 @@ spectrum_cs_config(struct pcmcia_device
> +@@ -360,7 +370,11 @@ spectrum_cs_config(struct pcmcia_device
>
>        /* Register an interface with the stack */
>        if (orinoco_if_add(priv, link->io.BasePort1,
>  +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> -                          link->irq) != 0) {
> +                          link->irq, NULL) != 0) {
>  +#else
> -+                         link->irq.AssignedIRQ) != 0) {
> ++                         link->irq.AssignedIRQ, NULL) != 0) {
>  +#endif
>                printk(KERN_ERR PFX "orinoco_if_add() failed\n");
>                goto failed;
> diff --git a/patches/27-hermes-read-pda-conflict.patch b/patches/27-hermes-read-pda-conflict.patch
> new file mode 100644
> index 0000000..fe6b181
> --- /dev/null
> +++ b/patches/27-hermes-read-pda-conflict.patch
> @@ -0,0 +1,56 @@
> +Rename read_pda to something else because this symbol is used in a
> +define for something else in arch/um/include/asm/pda.h on older kernels.
> +
> +--- a/drivers/net/wireless/orinoco/fw.c
> ++++ b/drivers/net/wireless/orinoco/fw.c
> +@@ -122,7 +122,7 @@ orinoco_dl_firmware(struct orinoco_priva
> +       dev_dbg(dev, "Attempting to download firmware %s\n", firmware);
> +
> +       /* Read current plug data */
> +-      err = hw->ops->read_pda(hw, pda, fw->pda_addr, fw->pda_size);
> ++      err = hw->ops->read_pda_h(hw, pda, fw->pda_addr, fw->pda_size);
> +       dev_dbg(dev, "Read PDA returned %d\n", err);
> +       if (err)
> +               goto free;
> +@@ -224,7 +224,7 @@ symbol_dl_image(struct orinoco_private *
> +               if (!pda)
> +                       return -ENOMEM;
> +
> +-              ret = hw->ops->read_pda(hw, pda, fw->pda_addr, fw->pda_size);
> ++              ret = hw->ops->read_pda_h(hw, pda, fw->pda_addr, fw->pda_size);
> +               if (ret)
> +                       goto free;
> +       }
> +--- a/drivers/net/wireless/orinoco/hermes.c
> ++++ b/drivers/net/wireless/orinoco/hermes.c
> +@@ -765,7 +765,7 @@ static const struct hermes_ops hermes_op
> +       .write_ltv = hermes_write_ltv,
> +       .bap_pread = hermes_bap_pread,
> +       .bap_pwrite = hermes_bap_pwrite,
> +-      .read_pda = hermes_read_pda,
> ++      .read_pda_h = hermes_read_pda,
> +       .program_init = hermesi_program_init,
> +       .program_end = hermesi_program_end,
> +       .program = hermes_program_bytes,
> +--- a/drivers/net/wireless/orinoco/hermes.h
> ++++ b/drivers/net/wireless/orinoco/hermes.h
> +@@ -393,7 +393,7 @@ struct hermes_ops {
> +                        u16 id, u16 offset);
> +       int (*bap_pwrite)(struct hermes *hw, int bap, const void *buf,
> +                         int len, u16 id, u16 offset);
> +-      int (*read_pda)(struct hermes *hw, __le16 *pda,
> ++      int (*read_pda_h)(struct hermes *hw, __le16 *pda,
> +                       u32 pda_addr, u16 pda_len);
> +       int (*program_init)(struct hermes *hw, u32 entry_point);
> +       int (*program_end)(struct hermes *hw);
> +--- a/drivers/net/wireless/orinoco/orinoco_usb.c
> ++++ b/drivers/net/wireless/orinoco/orinoco_usb.c
> +@@ -1556,7 +1556,7 @@ static const struct hermes_ops ezusb_ops
> +       .read_ltv = ezusb_read_ltv,
> +       .write_ltv = ezusb_write_ltv,
> +       .bap_pread = ezusb_bap_pread,
> +-      .read_pda = ezusb_read_pda,
> ++      .read_pda_h = ezusb_read_pda,
> +       .program_init = ezusb_program_init,
> +       .program_end = ezusb_program_end,
> +       .program = ezusb_program,
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
