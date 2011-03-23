Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab1CWMr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 08:47:29 -0400
Subject: Re: [PATCH v3] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Ramesh Radhakrishnan <rramesh@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1300755650-21740-1-git-send-email-bzhao@marvell.com>
References: <1300755650-21740-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 13:47:26 +0100
Message-ID: <1300884446.3790.38.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> --- /dev/null
> +++ b/drivers/net/wireless/mwifiex/fw.h

Half of this file is a lie. things like

> +#define RESETHT_40MHZ_INTOLARANT(HTCapInfo) (HTCapInfo &= ~BIT(14))

are most certainly not firmware API, but part of 802.11n -- you should
be using the definitions from include/linux/ieee80211.h and not these
strange macros, I think?

> +	if (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
> +	    ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap))
> +		SETHT_SUPPCHANWIDTH(ht_cap_info);

Unless the adapter is not going to report 11n capabilities in the 11n
format... But from what I've seen, it does report them in the same
format, so these macros are just confusing IMHO.

> +void
> +mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap)
> +{
> +	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Max MSDU len = %s octets\n",
> +	       (ISSUPP_MAXAMSDU(cap) ? "7935" : "3839"));

You don't need this function at all, "iw list" is able to print most of
it, no?


> +	if (ISSUPP_RXANTENNAA(cap))
> +		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea A\n");

Presence?

> +mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support)
> +{
> +	dev_dbg(adapter->dev, "info: GET_HW_SPEC: MCSs for %dx%d MIMO\n",
> +	       GET_RXMCSSUPP(support), GET_TXMCSSUPP(support));

Again, ask yourself if all the debugging output is really necessary when
iw can display the information w/o any need for debug configuration.

> +	return;
> +}

That return seems pointless?

> +/*
> + * De-aggregate received packets.
> + *
> + * This function parses the received aggregate buffer, extracts each subframe,
> + * strips off the SNAP header from them and sends the data portion for further
> + * processing.
> + *
> + * Each subframe body is copied onto a separate buffer, which are freed by
> + * upper layer after processing. The function also performs sanity tests on
> + * the received buffer.
> + */
> +int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
> +				struct sk_buff *skb)

I /think/ this deaggregates aMSDUs, for which cfg80211 already has a
helper function that you should probably use.



> + * Marvell Wireless LAN device driver: 802.11n RX Re-ordering

I wonder if this could be some sort of shared code with mac80211? I
guess that won't be trivial though.

> +/*
> + * This function maps the given cipher type into driver specific type.
> + *
> + * It also sets a flag to indicate whether WPA is enabled or not.
> + *
> + * The mapping table is -
> + *      Input cipher                Driver cipher type              WPA enabled?
> + *      ------------                ------------------              ------------
> + *      IW_AUTH_CIPHER_NONE         MWIFIEX_ENCRYPTION_MODE_NONE    No
> + *      WLAN_CIPHER_SUITE_WEP40     MWIFIEX_ENCRYPTION_MODE_WEP40   No
> + *      WLAN_CIPHER_SUITE_WEP104    MWIFIEX_ENCRYPTION_MODE_WEP104  No
> + *      WLAN_CIPHER_SUITE_TKIP      MWIFIEX_ENCRYPTION_MODE_TKIP    Yes
> + *      WLAN_CIPHER_SUITE_CCMP      MWIFIEX_ENCRYPTION_MODE_CCMP    Yes
> + *      Others                      -1                              No

Why does the _driver_ even need a different "cipher type"? And did you
know that there's 802.1X WEP?

> +	case WLAN_CIPHER_SUITE_CCMP:
> +		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_CCMP;
> +		if (wpa_enabled)
> +			*wpa_enabled = 1;

All of this doesn't seem right. You can't necessarily deduce that WPA is
enabled from the cipher that's used, say SAE will be used in the future,
for example.

Btw, looking into this, I still see a lot of indirection:
mwifiex_set_auth() is used in some places. But that doesn't really do
anything, it calls mwifiex_set_encrypt_mode() with some sort of IOCTL
parameter, and if that fails returns -EFAULT which is a totally wrong
error code too.

The again mwifiex_set_encrypt_mode doesn't do anything but set a
variable, and then returns 0. So it can NEVER fail. It shouldn't have a
return value, heck, it probably shouldn't even _exist_ since it's used
*exactly once*.

Same for mwifiex_set_auth_mode.


Also, I'm looking through this, and I still see quite a bit of an ioctl
abstraction layer that isn't really useful.

Why does the driver have to do


> +       status = mwifiex_snmp_mib_ioctl(priv, wait, FRAG_THRESH_I,
> +                                       HostCmd_ACT_GEN_SET, &frag_thr);
> +
> +       if (mwifiex_request_ioctl(priv, wait, status, wait_option))   
> +               ret = -EFAULT;

rather than having a single function

mwifiex_set_frag_threshold(priv, frag_thr);

that will wait for the command to be processed. There are TONS of
pointless variables too, like here:


> +       u8 wait_option = MWIFIEX_IOCTL_WAIT;

which has exactly one use:

> +       wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
> +       if (!wait)
> +               return -ENOMEM;


what a mess!

Frankly, I think your abstraction is completely wrong. Why does the
caller have to be concerned about a wait queue, when all it wants is to
synchronously execute a command? That should be a low-level function. It
looks like you designed the entire driver around asynchronous commands,
and then half a year later realised that you have to execute them
synchronously, and instead of going back and changing the design you put
a wait queue around every single place...

And then some things like mwifiex_bss_ioctl_find_bss() don't even USE
the wait parameter!!

In iwlwifi, we just have iwl_send_cmd_sync(), which does all the wait.
That also has the added benefit that the wait queue doesn't need to be
dynamically allocated, it can just be on the stack. Also, your dynamic
allocations for that don't really seem to require GFP_ATOMIC in most
places, but that's probably the least of the worries here.

At this point, I give up. This driver still has close to 25k LOC, but
every time I look at a random place it's all just abstraction, not real
functionality.

johannes

