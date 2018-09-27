Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D2DC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B08FB20833
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B08FB20833
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbeI0Q2Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:28:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53858 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbeI0Q2Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:28:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5TFv-0001Pm-7q; Thu, 27 Sep 2018 12:10:47 +0200
Message-ID: <1538043034.14416.42.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2] wireless-drivers: rtnetlink wifi simulation
 device
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Cody Schuffelen <schuffelen@google.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Date:   Thu, 27 Sep 2018 12:10:34 +0200
In-Reply-To: <20180926194324.71290-1-schuffelen@google.com> (sfid-20180926_214418_801913_9719889B)
References: <20180926194324.71290-1-schuffelen@google.com>
         (sfid-20180926_214418_801913_9719889B)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 12:43 -0700, Cody Schuffelen wrote:

> ip link set eth0 down
> ip link set eth0 name buried_eth0
> ip link set buried_eth0 up
> ip link add link buried_eth0 name wlan0 type virt_wifi
> 
> eth0 is renamed to buried_eth0 to avoid a network manager trying to
> manage it, 

I feel you should remove this "buried" thing at least from the plain
instructions - first of all, I'm not convinced it actually *works* in
general (network managers are able to find it anyway, right? perhaps
android's has some rules?), and it's not really necessary from a kernel
POV.

Perhaps add a note like "you may have to rename or otherwise hide the
eth0 from your connection manager" (also "NetworkManager" is a specific
software, so "network manager" is confusing - I actually first thought
you meant NM).

Anyway, just a thought.

> Thanks for the detailed review! I believe I've addressed all comments.

Thanks!

> The problem we've experienced with routing the hwsim virtual medium from the
> inside the VM to outside the VM is this required running hwsim on the host
> kernel as well. This is too intrusive for our use-case, whereas wifi that
> exists completely inside the VM kernel is much more palatable.

Fair enough. I still think it'd be worthwhile in the long run because
then you could start multiple APs to simulate roaming etc. without
having to implement all of this here.

IOW - I don't think we should extend this much. As is, I think it's
fine, but I wouldn't want to see extensions like "have two scan result",
"let userspace control the RSSI of the scan results to force 'roaming'"
etc.

> +static struct ieee80211_channel channel_2ghz = {
> +	.band = NL80211_BAND_2GHZ,
> +	.center_freq = 5500,
> +	.hw_value = 5500,

That doesn't seem right - a 2 GHz channel that's really 5.5 GHz?

> +	.max_power = 5500,

That seems more like a copy/paste bug rather than intentional?

> +static struct ieee80211_rate bitrates_2ghz[] = {
> +	{
> +		.bitrate = 10,
> +	}, {
> +		.bitrate = 20,
> +	}, {
> +		.bitrate = 55,
> +	}, {
> +		.bitrate = 60,
> +	}, {
> +		.bitrate = 110,
> +	}, {
> +		.bitrate = 120,
> +	}, {
> +		.bitrate = 240,
> +	},
> +};

That's ... strangely formatted? I guess we'd usually write

	{ .bitrate = 10 },
	{ .bitrate = 20 },
	...



> +static struct ieee80211_supported_band band_2ghz = {
> +	.channels = &channel_2ghz,
> +	.bitrates = bitrates_2ghz,
> +	.band = NL80211_BAND_2GHZ,
> +	.n_channels = 1,
> +	.n_bitrates = 7,

Please use ARRAY_SIZE()

> +	.ht_cap = {
> +		.ht_supported = true,
> +	},
> +	.vht_cap = {
> +		.vht_supported = true,
> +	},

That looks _really_ bare - you may want to copy something sane to here.

> +};
> +
> +static struct ieee80211_channel channel_5ghz = {

> +	.max_power = 5500,

same here - max_power 5500?

> +	.max_reg_power = 9999,
> +};
> +
> +static struct ieee80211_rate bitrates_5ghz[] = {
> +	{
> +		.bitrate = 60,
> +	}, {
> +		.bitrate = 120,
> +	}, {
> +		.bitrate = 240,
> +	},
> +};

Same comment here regarding formatting.

> +static struct ieee80211_supported_band band_5ghz = {
> +	.channels = &channel_5ghz,
> +	.bitrates = bitrates_5ghz,
> +	.band = NL80211_BAND_5GHZ,
> +	.n_channels = 1,
> +	.n_bitrates = 3,

and ARRAY_SIZE

> +	.ht_cap = {
> +		.ht_supported = true,
> +	},
> +	.vht_cap = {
> +		.vht_supported = true,
> +	},

and HT/VHT

> +/** Assigned at module init. Guaranteed locally-administered and unicast. */
> +static u8 fake_router_bssid[ETH_ALEN] = {};

Maybe make that __ro_after_init?

It doesn't matter that much, but is a good signal.

> +static void virt_wifi_scan_result(struct work_struct *work)
> +{
> +	char ssid[] = "__VirtWifi";
> +	struct cfg80211_bss *informed_bss;
> +	struct virt_wifi_priv *priv =
> +		container_of(work, struct virt_wifi_priv,
> +			     scan_result.work);
> +	struct wiphy *wiphy = priv_to_wiphy(priv);
> +	struct cfg80211_inform_bss mock_inform_bss = {
> +		.chan = &channel_5ghz,
> +		.scan_width = NL80211_BSS_CHAN_WIDTH_20,
> +		.signal = -60,
> +		.boottime_ns = ktime_get_boot_ns(),
> +	};
> +
> +	ssid[0] = WLAN_EID_SSID;
> +	/* size of the array minus null terminator, length byte, tag byte */
> +	ssid[1] = sizeof(ssid) - 3;

Seems like you could make that const?
	struct {
		u8 tag;
		u8 len;
		u8 ssid[8];
	} ssid = { .tag = 0, .len = 8, .ssid = "VirtWifi" };

or something like that?

Hmm, maybe that doesn't work.. whatever, not really important.

> +	informed_bss = cfg80211_inform_bss_data(wiphy, &mock_inform_bss,
> +						CFG80211_BSS_FTYPE_PRESP,
> +						fake_router_bssid,
> +						mock_inform_bss.boottime_ns,
> +						WLAN_CAPABILITY_ESS, 0, ssid,
> +						/* Truncate before the null. */
> +						sizeof(ssid) - 1, GFP_KERNEL);
> +	cfg80211_put_bss(wiphy, informed_bss);
> +
> +	informed_bss = cfg80211_inform_bss_data(wiphy, &mock_inform_bss,
> +						CFG80211_BSS_FTYPE_BEACON,
> +						fake_router_bssid,
> +						mock_inform_bss.boottime_ns,
> +						WLAN_CAPABILITY_ESS, 0, ssid,
> +						/* Truncate before the null. */
> +						sizeof(ssid) - 1, GFP_KERNEL);
> +	cfg80211_put_bss(wiphy, informed_bss);

Hmm, what's the point of doing it twice? You don't really need to
receive both PRESP/BEACON, just one is sufficient.

> +	schedule_delayed_work(&priv->scan_complete, HZ * 2);
> +}

I don't think you need to make that async again.

> +static int virt_wifi_connect(struct wiphy *wiphy, struct net_device *netdev,
> +			     struct cfg80211_connect_params *sme)
> +{
> +	struct virt_wifi_priv *priv = wiphy_priv(wiphy);
> +	bool could_schedule;
> +
> +	if (priv->being_deleted)
> +		return -EBUSY;
> +
> +	if (sme->bssid && !ether_addr_equal(sme->bssid, fake_router_bssid))
> +		return -EINVAL;

If you wanted to be more "real", you'd accept this and then check it in
the connect worker, rejecting it there if mismatched.

> +static int virt_wifi_get_station(struct wiphy *wiphy, struct net_device *dev,
> +				 const u8 *mac, struct station_info *sinfo)
> +{
> +	wiphy_debug(wiphy, "get_station\n");
> +	sinfo->filled = BIT(NL80211_STA_INFO_TX_PACKETS) |
> +		BIT(NL80211_STA_INFO_TX_FAILED) | BIT(NL80211_STA_INFO_SIGNAL) |
> +		BIT(NL80211_STA_INFO_TX_BITRATE);
> +	sinfo->tx_packets = 1;
> +	sinfo->tx_failed = 0;
> +	sinfo->signal = -60;
> +	sinfo->txrate = (struct rate_info) {
> +		.legacy = 10, /* units are 100kbit/s */
> +	};
> +	return 0;
> +}

You should check that mac is fake_router_bssid, and otherwise return not
found (-ENOENT), IIRC.

> +static netdev_tx_t virt_wifi_start_xmit(struct sk_buff *skb,
> +					struct net_device *dev)
> +{
> +	struct virt_wifi_netdev_priv *priv = netdev_priv(dev);
> +	struct virt_wifi_priv *w_priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
> +
> +	if (!w_priv->is_connected)
> +		return NETDEV_TX_BUSY;

I think you should just drop the frame.

> +/* Called under rcu_read_lock() from netif_receive_skb */
> +static rx_handler_result_t virt_wifi_rx_handler(struct sk_buff **pskb)

FWIW, the stuff beyond this point, especially the netlink, I'm less
familiar with.

> +/** Called with rtnl lock held. */

/** is usually used only for kernel-doc

johannes
