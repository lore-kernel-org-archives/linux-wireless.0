Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17845 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2JVUpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:45:14 -0400
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 22 Oct 2012 13:47:15 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH v1 1/2] wireless: Driver for 60GHz card wil6210
Message-ID: <20121022204715.GS3354@lenteja.do-not-panic.com> (sfid-20121022_224521_502335_9C96A021)
References: <1350824571-22554-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1350824571-22554-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1350824571-22554-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 21, 2012 at 03:02:50PM +0200, Vladimir Kondratiev wrote:
> Card wil6210 by Wilocity supports operation on the 60GHz band
> 
> This development snapshot supports:
> 
> - STA, PCP and monitor modes
> - security works for STA mode, not integrated yet for PCP mode
> - PCP limited to 1 connected STA
> 
> In the STA and PCP mode, one can assemble fully functional BSS.
> throughput of 1.2Gbps achieved with iperf
> 
> In the monitor mode, card is able to capture either control or non-control frames
> (due to hardware limitation).
> 
> Wil6210 card have on-board flash memory for the firmware, card comes pre-flushed
> and no firmware download required on the run time.

John, I'd prefer if these changes were addressed prior
to integration but if addressed I'd like to see this go
in via v3.7-rc series.

You should point to this page too:

http://wireless.kernel.org/en/users/Drivers/wil6210

and also refer to it on the Kconfig file. In fact
I see no reason for the second patch, please fold
the two together.

Since you are folding this into ath/ given that QCA is
maintaining the driver and not Wilocity please also require
the wil6210 Kconfig to be included only if ATH_COMMON is set
on drivers/net/wireless/ath/Kconfig. When I first enabled
this driver on my system I looked for it under the Atheros
list and it was not there and was a bit confused.

My review of actual code below.

> diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
> new file mode 100644
> index 0000000..7e20599
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wil6210/Kconfig
> @@ -0,0 +1,42 @@
> +config WIL6210
> +	tristate "Wilocity 60g WiFi card wil6210 support"
> +	depends on CFG80211
> +	depends on PCI
> +	depends on EXPERIMENTAL
> +	default n
> +	---help---
> +	  This module adds support for wireless adapter based on
> +	  wil6210 chip by Wilocity. It supports operation on the
> +	  60g band, covered by the IEEE802.11ad standard.
> +	  If you choose to build it as a module, it will be called
> +	  wil6210

Please refer to the wiki URL as well.

> +config WIL6210_ISR_COR
> +	bool "Use Clear-On-Read mode for ISR registers for wil6210"
> +	depends on WIL6210
> +	default y
> +	---help---
> +	  ISR registers on wil6210 chip may operate in either
> +	  COR (Clear-On-Read) or W1C (Write-1-to-Clear) mode.
> +	  COR is default since it saves extra target transaction;
> +	  W1C is more suitable for debug purposes.

In what conditions would one use WIL6210_ISR_COR not be used and
can we simply autodetect this preference?

> +config WIL6210_DEBUG_TXRX
> +	bool "Debug Tx/Rx path for wil6210"
> +	depends on WIL6210
> +	default n
> +	---help---
> +	  Enables Tx/Rx path debug. It will emitt lots of messages.
> +	  Every Tx and Rx frame will be dumped, with some
> +	  auxiliary information.
> +	  Use with care.

This is nice but you have a lot of #ifdef eye cancer causing code
lying around. I'll show a few examples, all this should be tidied up
when possible.

> diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
> new file mode 100644
> index 0000000..64c2447
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
> +static struct ieee80211_channel wil_60ghz_channels[] = {
> +	CHAN60G(1, 0),
> +	CHAN60G(2, 0),
> +	CHAN60G(3, 0),
> +#if 0 /* channel 4 not supported yet */
> +	CHAN60G(4, 0),
> +#endif

Please remove *all* code like this, that is #if 0
If you want to keep code add a Kconfig with a reasonable
excuse for it, otherwise it makes review harder and just
makes the code look like poo.

> +#define ADVANCED_SCAN 1

Kill the non advanced scan code then.

> +	if (rsn_eid) {
> +		print_hex_dump(KERN_INFO, "RSN IE : ", DUMP_PREFIX_NONE, 16, 1,
> +			       rsn_eid, rsn_eid[1] + 2, true);
> +		if (sme->ie_len > WMI_MAX_IE_LEN) {
> +			rc = -ERANGE;
> +			wil_err(wil, "IE too large (%td bytes)\n",
> +				sme->ie_len);
> +			goto out;
> +		}
> +		/*
> +		 * For secure assoc, send:
> +		 * (1) WMI_DELETE_CIPHER_KEY_CMD
> +		 * (2) WMI_SET_APPIE_CMD
> +		 */
> +		/* WMI_DELETE_CIPHER_KEY_CMD */
> +		{

This block style that you make just to define variables -- kill
all this usage and properly define variables at the top or use
static helper routines. This makes code review nasty, specially
when wrapped closely together to branching code. I see this type
of code all over the driver, please address all of these.


Next, I see a few style issues with the code both on general
declaration of the routines and also on the routines themselves
which would be good to get right from the start. I'll comment
below and show how to transform this to a routine in style that
would be consistent with what other newer drivers / other code.

> +static int wil_cfg80211_set_channel(struct wiphy *wiphy,
> +		struct ieee80211_channel *chan,
> +		enum nl80211_channel_type channel_type)

The second and third lines here should be tab separated as much
as possible and when you see that you still don't match to the top
line then uses spaces. For example:

static int wil_cfg80211_set_channel(struct wiphy *wiphy,
				    struct ieee80211_channel *chan,
				    enum nl80211_channel_type channel_type)

That looks much better. If you run > 80 chars then do something like:

static int
wil_cfg80211_set_channel(struct wiphy *wiphy,
			 struct ieee80211_channel *chan,
			 enum nl80211_channel_type channel_type)

> +{
> +	struct wil6210_priv *wil = wiphy_to_wil(wiphy);

Generally you want to put all variable declarations all together
tightly nit on the top and then after that please add an empty
line. Then dump your routine code.

> +	wil_info(wil, "%s()\n", __func__);
> +	wil_info(wil, "freq = %d\n", chan->center_freq);
> +	wil->channel = chan;
> +	return 0;
> +}

At the end of the code, right before the return put an empty line as well. For
example this routine would look much better as follows:

static int wil_cfg80211_set_channel(struct wiphy *wiphy,
				    struct ieee80211_channel *chan,
				    enum nl80211_channel_type channel_type)
{
	struct wil6210_priv *wil = wiphy_to_wil(wiphy);

	wil_info(wil, "%s()\n", __func__);
	wil_info(wil, "freq = %d\n", chan->center_freq);
	wil->channel = chan;

	return 0;
}

Please try to change routines to follow this style on your driver.
I won't make comments on all the cases where this happens, but please
do address them all.

> +static void print_ie(const char *name, const void *data, size_t len)
> +{
> +	print_hex_dump(KERN_INFO, name, DUMP_PREFIX_OFFSET, 16, 1,
> +		       data, len, true);
> +}

This name is very generic, please consider a driver specific
name to avoid name collisions in the future.

> +static void print_bcon_data(struct cfg80211_beacon_data *b)

Same here.

> diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> +static u32 dbg_txdesc_index; /* = 0; */

Please put static variables at the top of files.

> diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c

This file has huge amount of #ifdef'd code that can make people dizzy.
Please clean all that up.

For example one strategy you can use here is to have a static inline for the
clear write command. Below is your code and then below that how a possible
way for you to write this to avoid this #ifdef set of spider webs. Also consider
renaming the routines to be drivery specific to avoid name collisions in the
future.

> +static inline u32 ioread32_and_clear(void __iomem *addr)
> +{
> +	u32 x = ioread32(addr);
> +#if !defined(CONFIG_WIL6210_ISR_COR)
> +	iowrite32(x, addr);
> +#endif
> +	return x;
> +}

#if !defined(CONFIG_WIL6210_ISR_COR)
static inline void wil_read_clear(u32 val, void __iomem *addr)
{
	iowrite32(val, addr);
}
#else
static inline void wil_read_clear(u32 val, void __iomem *addr)
{
}
#endif

static inline u32 wil_ioread32_and_clear(void __iomem *addr)
{
	u32 x = ioread32(addr);

	wil_read_clear(x, addr);

	return x;
}

> +static void wil6210_mask_irq(struct wil6210_priv *wil)
> +{
> +#if defined(CONFIG_WIL6210_DEBUG_IRQ)
> +	wil_info(wil, "%s()\n", __func__);
> +#endif

Here's another example. The debug print for CONFIG_WIL6210_DEBUG_IRQ
is used in many places. How about instead you use a debug value which
lets us tell the wil_info() what type of debug printing it should do,
then wil_info() would simply figure out if to print or not therefore
avoiding the debug #ifdef print mess all together.

If you want to re-use debug print stuff from another driver you can
look at ath_dbg() and friends on ath.h. For an example cfg80211 driver
look at ath6kl/debug.h

> +void wil6210_enable_irq(struct wil6210_priv *wil)
> +{
> +#if defined(CONFIG_WIL6210_DEBUG_IRQ)
> +	wil_info(wil, "%s()\n", __func__);
> +#endif
> +#if defined(CONFIG_WIL6210_ISR_COR)
>
> +	/* configure to Clear-On-Read */
> +	iowrite32(0xFFFFFFFFUL, wil->csr +
> +			HOSTADDR(RGF_DMA_EP_RX_ICR) +
> +			offsetof(struct RGF_ICR, ICC));
> +	iowrite32(0xFFFFFFFFUL, wil->csr +
> +			HOSTADDR(RGF_DMA_EP_TX_ICR) +
> +			offsetof(struct RGF_ICR, ICC));
> +	iowrite32(0xFFFFFFFFUL, wil->csr +
> +			HOSTADDR(RGF_DMA_EP_MISC_ICR) +
> +			offsetof(struct RGF_ICR, ICC));
> +#else
> +	iowrite32(0, wil->csr +
> +			HOSTADDR(RGF_DMA_EP_RX_ICR) +
> +			offsetof(struct RGF_ICR, ICC));
> +	iowrite32(0, wil->csr +
> +			HOSTADDR(RGF_DMA_EP_TX_ICR) +
> +			offsetof(struct RGF_ICR, ICC));
> +	iowrite32(0, wil->csr +
> +			HOSTADDR(RGF_DMA_EP_MISC_ICR) +
> +			offsetof(struct RGF_ICR, ICC));
> +#endif
> +
> +	wil6210_unmask_irq(wil);
> +}

Same thing with the routines here, figure out a way
to separate these and avoid #ifdef hell on the routine
we read.

I won't comment more on this sort of stuff but you get the
point.

> diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
> + * Due to the hardware issue,
          a

> + * one have to read/write to/from NIC in 32-bit chunks;
          has
> + * regular memcpy_fromio and siblings will
> + * not work on 64-bit platform - it uses 64-bit transactions

May want to clarify this a bit more. Will the driver work on
64-bit CPUs with this work around though? If not just make this
driver then not be selectable or compilable on 64 bit CPUs.
You can do this on the Kconfig by depending on !64BIT
For example:

drivers/net/hamradio/Kconfig

config BAYCOM_EPP
        tristate "BAYCOM epp driver for AX.25"
        depends on PARPORT && AX25 && !64BIT
        select CRC_CCITT

Will this harware issue be fixed in the future ?

> + */
> +void memcpy_fromio_32(void *dst, const volatile void __iomem *src,
> +			 size_t count)
> +{
> +	u32 *d = dst;
> +	const volatile u32 __iomem *s = src;
> +	/* size_t is unsigned, if (count%4 != 0) it will wrap */
> +	for (count += 4; count > 4; count -= 4)
> +		*d++ = readl(s++);
> +}
> +
> +void memcpy_toio_32(volatile void __iomem *dst, const void *src,
> +		       size_t count)
> +{
> +	volatile u32 __iomem *d = dst;
> +	const u32 *s = src;
> +	for (count += 4; count > 4; count -= 4)
> +		writel(*s++, d++);
> +}

I wonder if these can eventually be added upstream for other
drivers that may need this as well, if so then later you can
try adding it upstream.

> +int wil_reset(struct wil6210_priv *wil)
> +{
> +	wil_info(wil, "%s()\n", __func__);
> +	cancel_work_sync(&wil->disconnect_worker);
> +	wil6210_disconnect(wil, NULL);
> +	wmi_event_flush(wil);
> +	flush_workqueue(wil->wmi_wq);
> +	flush_workqueue(wil->wmi_wq_conn);
> +	wil6210_disable_irq(wil);
> +	wil->status = 0;

In places like this you may want to add an empty line
after a few logical components for the reader to make it
easier to read and understand. For example this could be:

int wil_reset(struct wil6210_priv *wil)
{
	wil_info(wil, "%s()\n", __func__);

	cancel_work_sync(&wil->disconnect_worker);
	wil6210_disconnect(wil, NULL);

	wmi_event_flush(wil);

	flush_workqueue(wil->wmi_wq);
	flush_workqueue(wil->wmi_wq_conn);

	wil6210_disable_irq(wil);
	wil->status = 0;

We're not strict with this but this is just nicer to
read and follow.

> +	/* TODO: put MAC in reset */
> +	wil_target_reset(wil);
> +	/* init after reset */
> +	wil->pending_connect_cid = -1;
> +	INIT_COMPLETION(wil->wmi_ready);
> +	/* make shadow copy of registers that should not change on run time */
> +	memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
> +			 sizeof(struct wil6210_mbox_ctl));
> +	/* TODO: release MAC reset */
> +	wil6210_enable_irq(wil);
> +	/* we just started MAC, wait for FW ready */
> +	{

Again, an example where a block of code if just idented for no
reason other than variable declarations. Avoid this please.

> diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
> +/*out_profile:*/

Please remove.

> diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
> +#if 0 /* in case some more init code will be added */
> + debugfs_exit:
> +	wil6210_debugfs_remove(wil);
> + sysfs_fini:
> +	wil6210_sysfs_fini(wil);
> +#endif


Please kill all #if 0 code and leave in place all #if 1 code,
but remove the #if crap.

> +static DEFINE_PCI_DEVICE_TABLE(wil6210_pcie_ids) = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_WIL6210, PCI_DEVICE_ID_WIL6210),
> +			/*.driver_data  = (kernel_ulong_t)0,*/},

Kill the commented out code.

> diff --git a/drivers/net/wireless/ath/wil6210/sysfs.c b/drivers/net/wireless/ath/wil6210/sysfs.c

Whoa, you missed the copyright license on the top header.

> diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c

Remove all #if 0 code.

> +++ b/drivers/net/wireless/ath/wil6210/txrx.c
> +#ifdef CONFIG_WIL6210_DEBUG_TXRX
> +	wil_info(wil, "Rx[%3d] : %d bytes\n", vring->swhead, d->dma.length);
> +	print_hex_dump(KERN_INFO, "Rx ", DUMP_PREFIX_NONE, 32, 4, d
> +			, sizeof(*d), false);
> +#endif

See if you can write a debug print to do this so you don't have
to #ifdef code and make us go blind.

> diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
> +#define WIL6210_DRV_VERSION "0.4" /* Driver version */

Driver versions are the thing of 1980s and 1990. Kill them.
Try to go by the Linux kernel version or linux-next tag.

> +#define WIL_NAME "wil6210"

OK

> +#define PCI_VENDOR_ID_WIL6210 (0x1ae9)
> +#define PCI_DEVICE_ID_WIL6210 (0x0301)

Kill these two.

> diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
> +#ifndef __WMI_H__
> +#define __WMI_H__

Rename this to __WIL6210_WMI_H__ instead please. Try to always
avoid possible conflicts with generic names like these.

> +enum DOT11_AUTH_MODE {
> +	OPEN_AUTH	= 0x01,
> +	SHARED_AUTH	= 0x02,
> +	LEAP_AUTH	= 0x04, /* different from IEEE_AUTH_MODE definitions */
> +	WSC_AUTH	= 0x08,
> +};

Same with enums like this. There are others in this file,
please take care of them.

> +enum CRYPTO_TYPE {
> +	NONE_CRYPT	= 0x01,
> +	WEP_CRYPT	= 0x02,
> +	TKIP_CRYPT	= 0x04,
> +	AES_CRYPT	= 0x08,
> +	AES_GCMP_CRYPT	= 0x20,
> +};

Specially this one. WIL6210_CRYPTO_TYPE instead.

Other than that, great job at your first iteration!

  Luis
