Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:42613 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0KKOU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:20:59 -0500
Message-ID: <3272.160.114.36.137.1289485257.squirrel@webmail.inf.u-szeged.hu>
In-Reply-To: <1289348811.3660.4.camel@jlt3.sipsolutions.net>
References: <32995.82.131.221.21.1289334684.squirrel@webmail.inf.u-szeged.hu>
    <1289348811.3660.4.camel@jlt3.sipsolutions.net>
Date: Thu, 11 Nov 2010 15:20:57 +0100 (CET)
Subject: Re: connecting ieee80211_hw and net_device
From: "Zoltan Herczeg" <zherczeg@inf.u-szeged.hu>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20101111152057_71141"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_20101111152057_71141
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi,

thanks for you reply. I was thinking and realized probably the
alloc_etherdev() calls have a different purpose and removed them (and
found an ieee80211_rx_irqsafe function, which pass the received messages
to 80211). My plan is to run the network in ad-hoc mode (passing 1 to
SIOCSIWMODE ioctl command). Unfortunately it is still not working, because
rx.sta = sta_info_get(local, hdr->addr2) in rx.c returns with NULL, and
the received messages are eventually dropped. I tried to understand the
code, and I think messages called "beacons" are needed to make
sta_info_get() work. These messages can be created by
ieee80211_beacon_get, but it also returns with NULL in my case, because
rcu_dereference(ifibss->presp) returns with NULL. Could you help me?

The code is attached to this mail.

Thanks in advance,
Zoltan

> On Tue, 2010-11-09 at 21:31 +0100, Zoltan Herczeg wrote:
>
>> I can allocate a "wlan0" and "wlan1" platform device with
>> ieee80211_alloc_hw, and can initialize it in Ad-Hoc mode. However, I
>> realized this is not enough to have a wireless interface, since it has
>> no
>> receive operation, only transfer. Looking at the other drivers, I found
>> that they allocate a net_device with the common alloc_etherdev.
>> Unfortunately the register_netdev registers a new eth interface in my
>> case, and this interface is not connected to the wlan interface. I set
>> wireless_handlers and ieee80211_ptr for this device, still it is totally
>> independent from the wlan interface.
>>
>> Am I missing something? (Sorry if this is a trivial question, I tried
>> google but no luck so far)
>
> Your question doesn't make any sense. You never need wlan0/1, you only
> need alloc_hw/register_hw and then the interfaces will be managed by
> mac80211. You should post the code so people can help you.
>
> johannes

------=_20101111152057_71141
Content-Type: text/x-csrc; name="xeemu_wireless.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="xeemu_wireless.c"

/*
 *  linux/drivers/net/wireless/xeemu_wireless.c
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <asm/io.h>

#include <linux/netdevice.h>
#include <linux/etherdevice.h>
#include <net/mac80211.h>

#define DRV_MODULE_NAME		"xeemu-wlan"
#define DRV_MODULE_VERSION	"1.0"
#define MAX_PACKET_SIZE		1518

struct xeemu_hw_priv {
	spinlock_t device_lock;
	unsigned long base_addr;
	int irq;
	struct ieee80211_vif *vif;
	struct ieee80211_channel *channel;
	struct cfg80211_scan_request *req;
	struct ieee80211_supported_band bands[2];
};

struct xeemu_vif_priv {
	u8 bssid[ETH_ALEN];
	bool assoc;
};

struct xeemu_sta_priv {
	u32 dummy;
};

#define CHAN2G(_freq)  { \
	.band = IEEE80211_BAND_2GHZ, \
	.center_freq = (_freq), \
	.hw_value = (_freq), \
	.max_power = 20, \
}

#define CHAN5G(_freq) { \
	.band = IEEE80211_BAND_5GHZ, \
	.center_freq = (_freq), \
	.hw_value = (_freq), \
	.max_power = 20, \
}

static struct ieee80211_channel xeemu_channels_2ghz[] = {
	CHAN2G(2412), /* Channel 1 */
	CHAN2G(2417), /* Channel 2 */
	CHAN2G(2422), /* Channel 3 */
	CHAN2G(2427), /* Channel 4 */
	CHAN2G(2432), /* Channel 5 */
	CHAN2G(2437), /* Channel 6 */
	CHAN2G(2442), /* Channel 7 */
	CHAN2G(2447), /* Channel 8 */
	CHAN2G(2452), /* Channel 9 */
	CHAN2G(2457), /* Channel 10 */
	CHAN2G(2462), /* Channel 11 */
	CHAN2G(2467), /* Channel 12 */
	CHAN2G(2472), /* Channel 13 */
	CHAN2G(2484), /* Channel 14 */
};

static struct ieee80211_channel xeemu_channels_5ghz[] = {
	CHAN5G(5180), /* Channel 36 */
	CHAN5G(5200), /* Channel 40 */
	CHAN5G(5220), /* Channel 44 */
	CHAN5G(5240), /* Channel 48 */

	CHAN5G(5260), /* Channel 52 */
	CHAN5G(5280), /* Channel 56 */
	CHAN5G(5300), /* Channel 60 */
	CHAN5G(5320), /* Channel 64 */

	CHAN5G(5500), /* Channel 100 */
	CHAN5G(5520), /* Channel 104 */
	CHAN5G(5540), /* Channel 108 */
	CHAN5G(5560), /* Channel 112 */
	CHAN5G(5580), /* Channel 116 */
	CHAN5G(5600), /* Channel 120 */
	CHAN5G(5620), /* Channel 124 */
	CHAN5G(5640), /* Channel 128 */
	CHAN5G(5660), /* Channel 132 */
	CHAN5G(5680), /* Channel 136 */
	CHAN5G(5700), /* Channel 140 */

	CHAN5G(5745), /* Channel 149 */
	CHAN5G(5765), /* Channel 153 */
	CHAN5G(5785), /* Channel 157 */
	CHAN5G(5805), /* Channel 161 */
	CHAN5G(5825), /* Channel 165 */
};

static struct ieee80211_rate xeemu_rates[] = {
	{ .bitrate = 10 },
	{ .bitrate = 20, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
	{ .bitrate = 55, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
	{ .bitrate = 110, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
	{ .bitrate = 60 },
	{ .bitrate = 90 },
	{ .bitrate = 120 },
	{ .bitrate = 180 },
	{ .bitrate = 240 },
	{ .bitrate = 360 },
	{ .bitrate = 480 },
	{ .bitrate = 540 }
};

// ----------------------------------------------------------------------

static void xeemu_rx(struct ieee80211_hw *hw, int packet_length)
{
	int i;
	unsigned long flags;
	struct sk_buff *skb;
	char buf[MAX_PACKET_SIZE];
	struct xeemu_hw_priv *hp = hw->priv;
	struct ieee80211_rx_status rx_status;

	spin_lock_irqsave(&hp->device_lock, flags);
	for (i = 0; i < packet_length; ++i) {
		outl(1, hp->base_addr + 4);
		buf[i] = inl(hp->base_addr + 4);
	}
	spin_unlock_irqrestore(&hp->device_lock, flags);

	memset(&rx_status, 0, sizeof(rx_status));
	rx_status.freq = hp->channel->center_freq;
	rx_status.band = hp->channel->band;
	rx_status.signal = -50;

	skb = dev_alloc_skb(packet_length + NET_IP_ALIGN);
	if (unlikely(!skb))
		return;

	skb_reserve(skb, NET_IP_ALIGN);
	memcpy(skb_put(skb, packet_length), buf, packet_length);
	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
	ieee80211_rx_irqsafe(hw, skb);
}

static int xeemu_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
{
	int i;
	unsigned long flags;
	struct xeemu_hw_priv *hp = hw->priv;
	struct ieee80211_tx_info *txi;

	if (unlikely(skb->len > MAX_PACKET_SIZE)) {
		dev_kfree_skb(skb);
		return NETDEV_TX_OK;
	}

	spin_lock_irqsave(&hp->device_lock, flags);
	outl(skb->len, hp->base_addr);
	for (i = 0; i < skb->len; ++i)
		outl(skb->data[i], hp->base_addr);
	spin_unlock_irqrestore(&hp->device_lock, flags);

	txi = IEEE80211_SKB_CB(skb);
	ieee80211_tx_info_clear_status(txi);
	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK))
		txi->flags |= IEEE80211_TX_STAT_ACK;
	printk(KERN_INFO "xeemu_tx: %d\n", skb->len);
	dev_kfree_skb(skb);
	return 0;
}

static int xeemu_tx_beacon(struct ieee80211_hw *hw)
{
	struct xeemu_hw_priv *hp = hw->priv;
	struct sk_buff *skb = ieee80211_beacon_get(hw, hp->vif);
	if (!skb)
		return -ENOMEM;
	return xeemu_tx(hw, skb);
}

static irqreturn_t xeemu_irq(int irq, void *dev_instance)
{
	struct ieee80211_hw *hw = (struct ieee80211_hw*)dev_instance;
	struct xeemu_hw_priv *hp = hw->priv;
	int packet_length;

	if (hp->req)
		ieee80211_scan_completed(hw, false);

	while (true) {
		// Check available packets
		outl(0, hp->base_addr + 4);
		packet_length = inl(hp->base_addr + 4);
		if (!packet_length)
			break;

		xeemu_rx(hw, packet_length);
	}

	return IRQ_HANDLED;
}

static int xeemu_start(struct ieee80211_hw *hw)
{
	int err;
	struct xeemu_hw_priv *hp = hw->priv;

	err = request_irq(hp->irq, xeemu_irq, IRQF_SHARED, "wlan", hw);
	if (err)
		return err;

	spin_lock_init(&hp->device_lock);
	return 0;
}

static void xeemu_stop(struct ieee80211_hw *hw)
{
	struct xeemu_hw_priv *hp = hw->priv;
	free_irq(hp->irq, hw);
}

static int xeemu_add_interface(struct ieee80211_hw *hw,
			     struct ieee80211_if_init_conf *conf)
{
	struct xeemu_hw_priv *hp = hw->priv;
	hp->vif = conf->vif;
	return 0;
}

static void xeemu_remove_interface(struct ieee80211_hw *hw,
				 struct ieee80211_if_init_conf *conf)
{
}

static int xeemu_config(struct ieee80211_hw *hw, u32 changed)
{
	struct xeemu_hw_priv *hp = hw->priv;

	hp->channel = hw->conf.channel;

	printk(KERN_INFO "xeemu_config 0x%x\n", changed);
	return 0;
}

static void xeemu_bss_info_changed(struct ieee80211_hw *hw,
				 struct ieee80211_vif *vif,
				 struct ieee80211_bss_conf *info,
				 u32 changed)
{
	struct xeemu_vif_priv *vp = (void *)vif->drv_priv;

	if (changed & BSS_CHANGED_BSSID)
		memcpy(vp->bssid, info->bssid, ETH_ALEN);
	if (changed & BSS_CHANGED_ASSOC)
		vp->assoc = info->assoc;
	printk(KERN_INFO "xeemu_bss_info_changed 0x%x\n", changed);
}

static void xeemu_configure_filter(struct ieee80211_hw *hw,
				 unsigned int changed_flags,
				 unsigned int *total_flags,
				 u64 multicast)
{
	*total_flags = *total_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI);
	printk(KERN_INFO "xeemu_configure_filter 0x%x 0x%x\n", changed_flags, *total_flags);
}

static int xeemu_hw_scan(struct ieee80211_hw *hw,
		       struct cfg80211_scan_request *req)
{
	struct xeemu_hw_priv *hp = hw->priv;
	if (hp->req)
		return -EINVAL;
	hp->req = req;
	// ieee80211_scan_completed must be called
	outl(5, hp->base_addr + 4);
	return 0;
}

static int xeemu_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
{
	return 0;
}

static void xeemu_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
			enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
{
}

static int xeemu_tx_last_beacon(struct ieee80211_hw *hw)
{
	return 0;
}

static void xeemu_rfkill_poll(struct ieee80211_hw *hw)
{
}

static const struct ieee80211_ops xeemu_wireless_ops = {
	.tx			= xeemu_tx,
	.start			= xeemu_start,
	.stop			= xeemu_stop,
	.add_interface		= xeemu_add_interface,
	.remove_interface	= xeemu_remove_interface,
	.config			= xeemu_config,
	.bss_info_changed	= xeemu_bss_info_changed,
	.configure_filter	= xeemu_configure_filter,
	.hw_scan		= xeemu_hw_scan,
	.set_rts_threshold	= xeemu_set_rts_threshold,
	.sta_notify		= xeemu_sta_notify,
	.tx_last_beacon		= xeemu_tx_last_beacon,
	.rfkill_poll		= xeemu_rfkill_poll
};

// ----------------------------------------------------------------------

static int xeemu_wlan_probe(struct platform_device *pdev)
{
	/* default mac address */
	static uint8_t mac_addrs[2][6] = {
		{ 0x00, 0xF5, 0x2A, 0x10, 0x71, 0x00 },
		{ 0x00, 0xF5, 0x2A, 0x15, 0xB2, 0x01 },
	};
	int i, band, err;
	struct resource* resource;
	struct ieee80211_hw *hw;
	struct xeemu_hw_priv *hp;
	unsigned long base_addr;
	int irq;

	resource = pdev->resource;
	for (i = 0; i < (pdev->num_resources >> 1); i++) {
		irq = resource->start;
		resource++;
		base_addr = resource->start;
		resource++;

		// Query the client_id based mac addr
		outl(2, base_addr + 4);
		mac_addrs[i][5] = inl(base_addr + 4);

		hw = ieee80211_alloc_hw(sizeof(struct xeemu_hw_priv), &xeemu_wireless_ops);
		if (hw == NULL) {
			dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
			return -ENOMEM;
		}

		SET_IEEE80211_DEV(hw, &pdev->dev);
		platform_set_drvdata(pdev, hw);

		hw->channel_change_time = 1;
		hw->queues = 4;
		hw->wiphy->interface_modes =
			BIT(NL80211_IFTYPE_ADHOC) |
			BIT(NL80211_IFTYPE_STATION) |
			BIT(NL80211_IFTYPE_AP) |
			BIT(NL80211_IFTYPE_MESH_POINT);

		hw->flags = IEEE80211_HW_MFP_CAPABLE |
			    IEEE80211_HW_SIGNAL_DBM;

		/* ask mac80211 to reserve space for magic */
		hw->vif_data_size = sizeof(struct xeemu_vif_priv);
		hw->sta_data_size = sizeof(struct xeemu_sta_priv);
		SET_IEEE80211_PERM_ADDR(hw, mac_addrs[i]);
		hp = hw->priv;
		hp->base_addr = base_addr;
		hp->irq = irq;
		hp->req = NULL;

		for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
			struct ieee80211_supported_band *sband = &hp->bands[band];
			switch (band) {
			case IEEE80211_BAND_2GHZ:
				sband->channels = xeemu_channels_2ghz;
				sband->n_channels = ARRAY_SIZE(xeemu_channels_2ghz);
				sband->bitrates = xeemu_rates;
				sband->n_bitrates = ARRAY_SIZE(xeemu_rates);
				break;
			case IEEE80211_BAND_5GHZ:
				sband->channels = xeemu_channels_5ghz;
				sband->n_channels = ARRAY_SIZE(xeemu_channels_5ghz);
				sband->bitrates = xeemu_rates + 4;
				sband->n_bitrates = ARRAY_SIZE(xeemu_rates) - 4;
			}
			sband->ht_cap.ht_supported = false;
			hw->wiphy->bands[band] = sband;
		}

		err = ieee80211_register_hw(hw);
		if (err < 0) {
			ieee80211_free_hw(hw);
			dev_err(&pdev->dev, "cannot register ieee80211_hw (%d)\n", err);
			return err;
		}

		printk(KERN_INFO "xeemu wlan%d (irq: %d base: 0x%lx mac[5]: %d) registered\n", i, irq, base_addr, mac_addrs[i][5]);
	}
	return 0;
}

static int __devexit xeemu_wlan_remove(struct platform_device *pdev)
{
	struct ieee80211_hw *hw;

	hw = platform_get_drvdata(pdev);
	if (hw == NULL)
		return 0;

	ieee80211_free_hw(hw);
	platform_set_drvdata(pdev, NULL);
	return 0;
}

static struct platform_driver xeemu_wlan_driver = {
	.probe		= xeemu_wlan_probe,
	.remove		= __devexit_p(xeemu_wlan_remove),
	.driver		= {
		.name	= "xeemu_wireless",
		.owner	= THIS_MODULE,
	},
};

static int __init xeemu_wlan_init_module(void)
{
	return platform_driver_register(&xeemu_wlan_driver);
}

static void __exit xeemu_wlan_cleanup_module(void)
{
	platform_driver_unregister(&xeemu_wlan_driver);
}

module_init(xeemu_wlan_init_module);
module_exit(xeemu_wlan_cleanup_module);

MODULE_LICENSE("GPL");
------=_20101111152057_71141--


