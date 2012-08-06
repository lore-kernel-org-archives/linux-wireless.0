Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43653 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab2HFHRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 03:17:09 -0400
Received: by weyx8 with SMTP id x8so1701009wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 00:17:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344029551-17959-1-git-send-email-fercerpav@gmail.com>
References: <1344029551-17959-1-git-send-email-fercerpav@gmail.com>
Date: Mon, 6 Aug 2012 09:17:07 +0200
Message-ID: <CAL1gcdM4-mbdDTmopEhZhHysVioxP5+E=DuMRDU_nLxmebN8Nw@mail.gmail.com> (sfid-20120806_091714_075949_08FE6AA5)
Subject: Re: [RFC] rt2x00: specify iface_combinations to allow for multi-bss operation
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

On Fri, Aug 3, 2012 at 11:32 PM, Paul Fertser <fercerpav@gmail.com> wrote:
> This patch makes all rt2x00 drivers tell mac80211 about possible
> interface combinations they support. Only combinations allowed so far
> are 4 APs for rt61pci and rt73usb; 8 APs for rt2800{pci,usb}.
>
> The driver-specific code in add_interface is now redudant and thus
> removed.
>
> However, real-life testing on RT3052F SoC showed that neither WPA-PSK +
> Open nor 2 WPA-PSK APs work properly (though both APs beacon properly).
> No other tests were performed.
>
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>

I wonder if it is possible to find a less intrusive solution.that
doesn't require changes
to the lowlevel drivers and doesn't need the exporting of the
interface combination structures
outside of the base rt2x00 module.

I can imagine that you select the right structure to use based on the
current max_sta_intf
and max_ap_intf variables of the rt2x00dev structure inside
rt2x00mac.c and leave it with that.

> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c |    2 -
>  drivers/net/wireless/rt2x00/rt2500pci.c |    2 -
>  drivers/net/wireless/rt2x00/rt2500usb.c |    2 -
>  drivers/net/wireless/rt2x00/rt2800pci.c |    3 +-
>  drivers/net/wireless/rt2x00/rt2800usb.c |    3 +-
>  drivers/net/wireless/rt2x00/rt2x00.h    |    9 +++++-
>  drivers/net/wireless/rt2x00/rt2x00dev.c |   38 ++++++++++++++++++++++++++++-
>  drivers/net/wireless/rt2x00/rt2x00mac.c |   40 -------------------------------
>  drivers/net/wireless/rt2x00/rt61pci.c   |    3 +-
>  drivers/net/wireless/rt2x00/rt73usb.c   |    3 +-
>  10 files changed, 48 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index 8b9dbd7..d44c38a 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -1780,8 +1780,6 @@ static const struct data_queue_desc rt2400pci_queue_atim = {
>
>  static const struct rt2x00_ops rt2400pci_ops = {
>         .name                   = KBUILD_MODNAME,
> -       .max_sta_intf           = 1,
> -       .max_ap_intf            = 1,
>         .eeprom_size            = EEPROM_SIZE,
>         .rf_size                = RF_SIZE,
>         .tx_queues              = NUM_TX_QUEUES,
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index d2cf8a4..0543b27 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -2072,8 +2072,6 @@ static const struct data_queue_desc rt2500pci_queue_atim = {
>
>  static const struct rt2x00_ops rt2500pci_ops = {
>         .name                   = KBUILD_MODNAME,
> -       .max_sta_intf           = 1,
> -       .max_ap_intf            = 1,
>         .eeprom_size            = EEPROM_SIZE,
>         .rf_size                = RF_SIZE,
>         .tx_queues              = NUM_TX_QUEUES,
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 3aae36b..9f82f24 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1887,8 +1887,6 @@ static const struct data_queue_desc rt2500usb_queue_atim = {
>
>  static const struct rt2x00_ops rt2500usb_ops = {
>         .name                   = KBUILD_MODNAME,
> -       .max_sta_intf           = 1,
> -       .max_ap_intf            = 1,
>         .eeprom_size            = EEPROM_SIZE,
>         .rf_size                = RF_SIZE,
>         .tx_queues              = NUM_TX_QUEUES,
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 235376e..39a2bcd 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1214,8 +1214,7 @@ static const struct data_queue_desc rt2800pci_queue_bcn = {
>  static const struct rt2x00_ops rt2800pci_ops = {
>         .name                   = KBUILD_MODNAME,
>         .drv_data_size          = sizeof(struct rt2800_drv_data),
> -       .max_sta_intf           = 1,
> -       .max_ap_intf            = 8,
> +       .if_comb                = &if_comb_8,
>         .eeprom_size            = EEPROM_SIZE,
>         .rf_size                = RF_SIZE,
>         .tx_queues              = NUM_TX_QUEUES,
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 6cf3365..7f04532 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -892,8 +892,7 @@ static const struct data_queue_desc rt2800usb_queue_bcn = {
>  static const struct rt2x00_ops rt2800usb_ops = {
>         .name                   = KBUILD_MODNAME,
>         .drv_data_size          = sizeof(struct rt2800_drv_data),
> -       .max_sta_intf           = 1,
> -       .max_ap_intf            = 8,
> +       .if_comb                = &if_comb_8,
>         .eeprom_size            = EEPROM_SIZE,
>         .rf_size                = RF_SIZE,
>         .tx_queues              = NUM_TX_QUEUES,
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 8afb546..8cc2263 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -655,8 +655,7 @@ struct rt2x00lib_ops {
>  struct rt2x00_ops {
>         const char *name;
>         const unsigned int drv_data_size;
> -       const unsigned int max_sta_intf;
> -       const unsigned int max_ap_intf;
> +       const struct ieee80211_iface_combination *if_comb;
>         const unsigned int eeprom_size;
>         const unsigned int rf_size;
>         const unsigned int tx_queues;
> @@ -741,6 +740,12 @@ enum rt2x00_capability_flags {
>  };
>
>  /*
> + * Supported interface combinations: 4 or 8 APs
> + */
> +extern const struct ieee80211_iface_combination if_comb_4;
> +extern const struct ieee80211_iface_combination if_comb_8;
> +
> +/*
>   * rt2x00 device structure.
>   */
>  struct rt2x00_dev {
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index a6b88bd..c77fc3a 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -32,19 +32,52 @@
>  #include "rt2x00.h"
>  #include "rt2x00lib.h"
>
> +static const struct ieee80211_iface_limit if_limit_ap_4[] = {
> +       {
> +               .max = 4,
> +               .types = BIT(NL80211_IFTYPE_AP),
> +       },
> +};
> +
> +static const struct ieee80211_iface_limit if_limit_ap_8[] = {
> +       {
> +               .max = 8,
> +               .types = BIT(NL80211_IFTYPE_AP),
> +       },
> +};
> +
> +const struct ieee80211_iface_combination if_comb_4 = {
> +               .limits = if_limit_ap_4,
> +               .n_limits = ARRAY_SIZE(if_limit_ap_4),
> +               .max_interfaces = 4,
> +               .num_different_channels = 1,
> +};
> +EXPORT_SYMBOL_GPL(if_comb_4);
> +
> +const struct ieee80211_iface_combination if_comb_8 = {
> +               .limits = if_limit_ap_8,
> +               .n_limits = ARRAY_SIZE(if_limit_ap_8),
> +               .max_interfaces = 8,
> +               .num_different_channels = 1,
> +};
> +EXPORT_SYMBOL_GPL(if_comb_8);
> +
>  /*
>   * Utility functions.
>   */
>  u32 rt2x00lib_get_bssidx(struct rt2x00_dev *rt2x00dev,
>                          struct ieee80211_vif *vif)
>  {
> +       u16 max_interfaces = 1;
>         /*
>          * When in STA mode, bssidx is always 0 otherwise local_address[5]
>          * contains the bss number, see BSS_ID_MASK comments for details.
>          */
>         if (rt2x00dev->intf_sta_count)
>                 return 0;
> -       return vif->addr[5] & (rt2x00dev->ops->max_ap_intf - 1);
> +       if (rt2x00dev->ops->if_comb)
> +               max_interfaces = rt2x00dev->ops->if_comb->max_interfaces;
> +       return vif->addr[5] & (max_interfaces - 1);
>  }
>  EXPORT_SYMBOL_GPL(rt2x00lib_get_bssidx);
>
> @@ -1125,6 +1158,9 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>  {
>         int retval = -ENOMEM;
>
> +       rt2x00dev->hw->wiphy->iface_combinations = rt2x00dev->ops->if_comb;
> +       rt2x00dev->hw->wiphy->n_iface_combinations = 1;
> +
>         /*
>          * Allocate the driver data memory, if necessary.
>          */

Doestn't this introduce a bug for the rt2400 and rt2500 devices that
do not support
multiple AP interfaces? In that case you set the iface_combinations to
a NULL pointer
(as the if_comb field of the rt2x00dev structure is not initialized
for these drivers),
but you still indicate there is 1 combination.

> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index 4ff26c2..8391b6a 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -212,46 +212,6 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
>             !test_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags))
>                 return -ENODEV;
>
> -       switch (vif->type) {
> -       case NL80211_IFTYPE_AP:
> -               /*
> -                * We don't support mixed combinations of
> -                * sta and ap interfaces.
> -                */
> -               if (rt2x00dev->intf_sta_count)
> -                       return -ENOBUFS;
> -
> -               /*
> -                * Check if we exceeded the maximum amount
> -                * of supported interfaces.
> -                */
> -               if (rt2x00dev->intf_ap_count >= rt2x00dev->ops->max_ap_intf)
> -                       return -ENOBUFS;
> -
> -               break;
> -       case NL80211_IFTYPE_STATION:
> -       case NL80211_IFTYPE_ADHOC:
> -       case NL80211_IFTYPE_MESH_POINT:
> -       case NL80211_IFTYPE_WDS:
> -               /*
> -                * We don't support mixed combinations of
> -                * sta and ap interfaces.
> -                */
> -               if (rt2x00dev->intf_ap_count)
> -                       return -ENOBUFS;
> -
> -               /*
> -                * Check if we exceeded the maximum amount
> -                * of supported interfaces.
> -                */
> -               if (rt2x00dev->intf_sta_count >= rt2x00dev->ops->max_sta_intf)
> -                       return -ENOBUFS;
> -
> -               break;
> -       default:
> -               return -EINVAL;
> -       }
> -
>         /*
>          * Loop through all beacon queues to find a free
>          * entry. Since there are as much beacon entries
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index f322596..d4fb469 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -3037,8 +3037,7 @@ static const struct data_queue_desc rt61pci_queue_bcn = {
>
>  static const struct rt2x00_ops rt61pci_ops = {
>         .name                   = KBUILD_MODNAME,
> -       .max_sta_intf           = 1,
> -       .max_ap_intf            = 4,
> +       .if_comb                = &if_comb_4,
>         .eeprom_size            = EEPROM_SIZE,
>         .rf_size                = RF_SIZE,
>         .tx_queues              = NUM_TX_QUEUES,
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index ba6e434..3ecd3e4 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2373,8 +2373,7 @@ static const struct data_queue_desc rt73usb_queue_bcn = {
>
>  static const struct rt2x00_ops rt73usb_ops = {
>         .name                   = KBUILD_MODNAME,
> -       .max_sta_intf           = 1,
> -       .max_ap_intf            = 4,
> +       .if_comb                = &if_comb_4,
>         .eeprom_size            = EEPROM_SIZE,
>         .rf_size                = RF_SIZE,
>         .tx_queues              = NUM_TX_QUEUES,
.
---
Gertjan
