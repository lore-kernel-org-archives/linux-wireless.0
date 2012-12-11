Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61311 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2LKVX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 16:23:58 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so2736714wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 13:23:56 -0800 (PST)
References: <1355246854-12686-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1355246854-12686-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <066662FD-A0EF-41AE-98EF-9DA90FF4FE69@gmail.com> (sfid-20121211_222401_820343_6D19D7A4)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Gabor Juhos <juhosg@openwrt.org>,
	"<users@rt2x00.serialmonkey.com>" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2] rt2x00: zero-out rx_status
Date: Tue, 11 Dec 2012 22:23:54 +0100
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 11 dec. 2012, at 18:27, Gabor Juhos <juhosg@openwrt.org> wrote:

> In commit 'mac80211: support radiotap vendor namespace RX data'
> new fields were added to 'struct ieee80211_rx_status' and those
> fileds must be zeroed. However the rt2x00 driver stores driver
> specific data in the cb array of the rx skbs, so the fields
> might contain garbage and this can cause unexpected behaviour.
> 
> The rt2x00 driver from the compat-wireless-2012-12-01
> tarball caused the following warning:
> 
>  WARNING: at
>  /devel/ramips/build_dir/target-mipsel_r2_uClibc-0.9.33.2/linux-ramips_rt305x/
>  compat-wireless-2012-12-01/net/mac80211/rx.c:115 ieee80211_rx_irqsafe+0x274/0xbcc
>  [mac80211]()
>  Modules linked in: dwc_otg ledtrig_usbdev nf_nat_irc
>  nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE
>  iptable_nat nf_nat pppoe xt_conntrack xt_CT xt_NOTRACK iptable_raw
>  xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack pppox
>  ipt_REJECT xt_TCPMSS xt_comment xt_multiport xt_mac xt_limit
>  iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables ppp_async
>  ppp_generic slhc rt2800pci(O) rt2800lib(O) rt2x00soc(O) rt2x00pci(O)
>  rt2x00lib(O) mac80211(O) usbcore usb_common nls_base crc_itu_t
>  crc_ccitt eeprom_93cx6 cfg80211(O) compat(O) arc4 aes_generic
>  crypto_blkcipher cryptomgr aead crypto_hash crypto_algapi leds_gpio
>  button_hotplug(O) gpio_keys_polled input_polldev input_core
>  Call Trace:
>  [<801e96b4>] dump_stack+0x8/0x34
>  [<80010a9c>] warn_slowpath_common+0x78/0xa4
>  [<80010ae0>] warn_slowpath_null+0x18/0x24
>  [<80a9710c>] ieee80211_rx_irqsafe+0x274/0xbcc [mac80211]
> 
> The patch ensures that each field gets initialized with
> zeroes.
> 
> Cc: <users@rt2x00.serialmonkey.com>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> v2:
>  - update the commit message and add a comment to the code
>  - drop the ath5k and p54 patches
> ---
> drivers/net/wireless/rt2x00/rt2x00dev.c |    8 ++++++++
> 1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 3248b42..507c8c5 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -686,6 +686,14 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
>     * to mac80211.
>     */
>    rx_status = IEEE80211_SKB_RXCB(entry->skb);
> +
> +    /* Ensure that all fields of rx_status are initialized
> +     * properly. The skb->cb array was used for driver
> +     * specific informations, so rx_status might contain
> +     * garbage.
> +     */
> +    memset(rx_status, 0, sizeof(*rx_status));
> +
>    rx_status->mactime = rxdesc.timestamp;
>    rx_status->band = rt2x00dev->curr_band;
>    rx_status->freq = rt2x00dev->curr_freq;
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
