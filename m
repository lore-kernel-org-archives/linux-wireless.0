Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:44387 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3FKSbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:31:25 -0400
Received: by mail-ea0-f176.google.com with SMTP id z15so3493926ead.35
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 11:31:24 -0700 (PDT)
References: <1370504180-10950-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1370504180-10950-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <48E3BAD1-B10D-4676-9809-F0C773DFD788@gmail.com> (sfid-20130611_203129_978383_B2234A32)
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2 1/2] rt2x00: move extra_tx_headroom field from rt2x00_ops to rt2x00_dev
Date: Tue, 11 Jun 2013 20:31:21 +0200
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 6 jun. 2013, at 09:36, Gabor Juhos <juhosg@openwrt.org> wrote:

> The extra_tx_headroom field of struct rt2x00_ops
> indicates the extra TX headroom size required for
> a given device. This data is redundant, the value
> can be computed from the desc_size and winfo_size
> fields of the TX queues.
> 
> Move the extra_tx_headroom field to struct rt2x00_dev,
> compute its value in the probe routine and use the
> cached value in the rest of the code.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> v2:
>  - remove the callbacks and compute the extra_tx_headroom
>    value from winfo_size and desc_size instead
>  - change subject
> 
> The patch depends on the 'rt2x00: get rid of static data queue descriptors'
> series.
> ---
> drivers/net/wireless/rt2x00/rt2400pci.c   |    1 -
> drivers/net/wireless/rt2x00/rt2500pci.c   |    1 -
> drivers/net/wireless/rt2x00/rt2500usb.c   |    1 -
> drivers/net/wireless/rt2x00/rt2800pci.c   |    1 -
> drivers/net/wireless/rt2x00/rt2800usb.c   |    2 --
> drivers/net/wireless/rt2x00/rt2x00.h      |    4 +++-
> drivers/net/wireless/rt2x00/rt2x00dev.c   |   18 ++++++++++++++++--
> drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +++---
> drivers/net/wireless/rt2x00/rt61pci.c     |    1 -
> drivers/net/wireless/rt2x00/rt73usb.c     |    1 -
> 10 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index e1ec9a4..3d53a09 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -1813,7 +1813,6 @@ static const struct rt2x00_ops rt2400pci_ops = {
>    .eeprom_size        = EEPROM_SIZE,
>    .rf_size        = RF_SIZE,
>    .tx_queues        = NUM_TX_QUEUES,
> -    .extra_tx_headroom    = 0,
>    .queue_init        = rt2400pci_queue_init,
>    .lib            = &rt2400pci_rt2x00_ops,
>    .hw            = &rt2400pci_mac80211_ops,
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index a1670e8..0ac5c58 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -2102,7 +2102,6 @@ static const struct rt2x00_ops rt2500pci_ops = {
>    .eeprom_size        = EEPROM_SIZE,
>    .rf_size        = RF_SIZE,
>    .tx_queues        = NUM_TX_QUEUES,
> -    .extra_tx_headroom    = 0,
>    .queue_init        = rt2500pci_queue_init,
>    .lib            = &rt2500pci_rt2x00_ops,
>    .hw            = &rt2500pci_mac80211_ops,
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index e5e5479..85acc79 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1913,7 +1913,6 @@ static const struct rt2x00_ops rt2500usb_ops = {
>    .eeprom_size        = EEPROM_SIZE,
>    .rf_size        = RF_SIZE,
>    .tx_queues        = NUM_TX_QUEUES,
> -    .extra_tx_headroom    = TXD_DESC_SIZE,
>    .queue_init        = rt2500usb_queue_init,
>    .lib            = &rt2500usb_rt2x00_ops,
>    .hw            = &rt2500usb_mac80211_ops,
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 260c8b4..7c74782 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1231,7 +1231,6 @@ static const struct rt2x00_ops rt2800pci_ops = {
>    .eeprom_size        = EEPROM_SIZE,
>    .rf_size        = RF_SIZE,
>    .tx_queues        = NUM_TX_QUEUES,
> -    .extra_tx_headroom    = TXWI_DESC_SIZE,
>    .queue_init        = rt2800pci_queue_init,
>    .lib            = &rt2800pci_rt2x00_ops,
>    .drv            = &rt2800pci_rt2800_ops,
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index b81d509..68ea00e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -905,7 +905,6 @@ static const struct rt2x00_ops rt2800usb_ops = {
>    .eeprom_size        = EEPROM_SIZE,
>    .rf_size        = RF_SIZE,
>    .tx_queues        = NUM_TX_QUEUES,
> -    .extra_tx_headroom    = TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
>    .queue_init        = rt2800usb_queue_init,
>    .lib            = &rt2800usb_rt2x00_ops,
>    .drv            = &rt2800usb_rt2800_ops,
> @@ -922,7 +921,6 @@ static const struct rt2x00_ops rt2800usb_ops_5592 = {
>    .eeprom_size        = EEPROM_SIZE,
>    .rf_size        = RF_SIZE,
>    .tx_queues        = NUM_TX_QUEUES,
> -    .extra_tx_headroom    = TXINFO_DESC_SIZE + TXWI_DESC_SIZE_5592,
>    .queue_init        = rt2800usb_queue_init,
>    .lib            = &rt2800usb_rt2x00_ops,
>    .drv            = &rt2800usb_rt2800_ops,
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 2a17f7e..ee3fc57 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -648,7 +648,6 @@ struct rt2x00_ops {
>    const unsigned int eeprom_size;
>    const unsigned int rf_size;
>    const unsigned int tx_queues;
> -    const unsigned int extra_tx_headroom;
>    void (*queue_init)(struct data_queue *queue);
>    const struct rt2x00lib_ops *lib;
>    const void *drv;
> @@ -1007,6 +1006,9 @@ struct rt2x00_dev {
>     */
>    struct list_head bar_list;
>    spinlock_t bar_list_lock;
> +
> +    /* Extra TX headroom required for alignment purposes. */
> +    unsigned int extra_tx_headroom;
> };
> 
> struct rt2x00_bar_list_entry {
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index dff5012..f03e3bb 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -334,7 +334,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>    /*
>     * Remove the extra tx headroom from the skb.
>     */
> -    skb_pull(entry->skb, rt2x00dev->ops->extra_tx_headroom);
> +    skb_pull(entry->skb, rt2x00dev->extra_tx_headroom);
> 
>    /*
>     * Signal that the TX descriptor is no longer in the skb.
> @@ -1049,7 +1049,7 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
>     */
>    rt2x00dev->hw->extra_tx_headroom =
>        max_t(unsigned int, IEEE80211_TX_STATUS_HEADROOM,
> -              rt2x00dev->ops->extra_tx_headroom);
> +              rt2x00dev->extra_tx_headroom);
> 
>    /*
>     * Take TX headroom required for alignment into account.
> @@ -1256,6 +1256,17 @@ static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
>    rt2x00dev->hw->wiphy->n_iface_combinations = 1;
> }
> 
> +static unsigned int rt2x00dev_extra_tx_headroom(struct rt2x00_dev *rt2x00dev)
> +{
> +    if (WARN_ON(!rt2x00dev->tx))
> +        return 0;
> +
> +    if (rt2x00_is_usb(rt2x00dev))
> +        return rt2x00dev->tx[0].winfo_size + rt2x00dev->tx[0].desc_size;
> +
> +    return rt2x00dev->tx[0].winfo_size;
> +}
> +
> /*
>  * driver allocation handlers.
>  */
> @@ -1330,6 +1341,9 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>    if (retval)
>        goto exit;
> 
> +    /* Cache TX headroom value */
> +    rt2x00dev->extra_tx_headroom = rt2x00dev_extra_tx_headroom(rt2x00dev);
> +
>    /*
>     * Determine which operating modes are supported, all modes
>     * which require beaconing, depend on the availability of
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index c4f1e2b..6c0a91f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -542,8 +542,8 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
>    /*
>     * Add the requested extra tx headroom in front of the skb.
>     */
> -    skb_push(entry->skb, rt2x00dev->ops->extra_tx_headroom);
> -    memset(entry->skb->data, 0, rt2x00dev->ops->extra_tx_headroom);
> +    skb_push(entry->skb, rt2x00dev->extra_tx_headroom);
> +    memset(entry->skb->data, 0, rt2x00dev->extra_tx_headroom);
> 
>    /*
>     * Call the driver's write_tx_data function, if it exists.
> @@ -596,7 +596,7 @@ static void rt2x00queue_bar_check(struct queue_entry *entry)
> {
>    struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>    struct ieee80211_bar *bar = (void *) (entry->skb->data +
> -                    rt2x00dev->ops->extra_tx_headroom);
> +                    rt2x00dev->extra_tx_headroom);
>    struct rt2x00_bar_list_entry *bar_entry;
> 
>    if (likely(!ieee80211_is_back_req(bar->frame_control)))
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 17507d1..53754bc6 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -3066,7 +3066,6 @@ static const struct rt2x00_ops rt61pci_ops = {
>    .eeprom_size        = EEPROM_SIZE,
>    .rf_size        = RF_SIZE,
>    .tx_queues        = NUM_TX_QUEUES,
> -    .extra_tx_headroom    = 0,
>    .queue_init        = rt61pci_queue_init,
>    .lib            = &rt61pci_rt2x00_ops,
>    .hw            = &rt61pci_mac80211_ops,
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index b2e346a..1616ed4 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2400,7 +2400,6 @@ static const struct rt2x00_ops rt73usb_ops = {
>    .eeprom_size        = EEPROM_SIZE,
>    .rf_size        = RF_SIZE,
>    .tx_queues        = NUM_TX_QUEUES,
> -    .extra_tx_headroom    = TXD_DESC_SIZE,
>    .queue_init        = rt73usb_queue_init,
>    .lib            = &rt73usb_rt2x00_ops,
>    .hw            = &rt73usb_mac80211_ops,
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
