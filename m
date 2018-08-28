Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53390 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbeH1Qha (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:37:30 -0400
Message-ID: <1535460343.5895.56.camel@sipsolutions.net> (sfid-20180828_144612_195273_EFB39F9F)
Subject: Re: [PATCH net-next] Implement a rtnetlink device which simulates
 wifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: Cody Schuffelen <schuffelen@google.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Date: Tue, 28 Aug 2018 14:45:43 +0200
In-Reply-To: <5b5b8e09.1c69fb81.c693c.0acd@mx.google.com> (sfid-20180727_232641_004306_EE08DF16)
References: <5b5b8e09.1c69fb81.c693c.0acd@mx.google.com>
         (sfid-20180727_232641_004306_EE08DF16)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cody,

Sorry for the delay in reviewing this.

I think in general there may be some value in this.

I think you'd have a far better experience (and some more real wifi
testing) by adding the ability to route the hwsim virtual air/medium of
the inside of the VM to the outside of the VM, and then you could run
APs there and bridge to ethernet etc. That way, you could have far more
realistic WiFi with multiple APs etc. with not all that much effort.


Regarding the patch itself:

On Tue, 2018-07-24 at 17:10 -0700, Cody Schuffelen wrote:
> The device added here is used through "ip link add ... type virt_wifi"

Can you have a more elaborate example that includes how to specify the
ethernet link to use?

> +static struct ieee80211_channel channel = {
> +	.band = NL80211_BAND_5GHZ,

You only have a single 5 GHz channel? That's pretty atypical - there are
no real devices that behave this way. I wouldn't be surprised if some
userspace assumes you have at least one 2.4 GHz channel, so I'd argue
you should have a more regular setup here.

> +static struct ieee80211_rate bitrate = {
> +	.flags = IEEE80211_RATE_SHORT_PREAMBLE, /* ieee80211_rate_flags */
> +	.bitrate = 1000,

err, well, you can't really have 10Mbps as a rate ... it doesn't exist.
Also, short preamble is irrelevant on 5 GHz.

Again, you should have a more regular setup here.

> +};
> +
> +static struct ieee80211_supported_band band_5ghz = {
> +	.channels = &channel,
> +	.bitrates = &bitrate,
> +	.band = NL80211_BAND_5GHZ,
> +	.n_channels = 1,
> +	.n_bitrates = 1,
> +};

And probably best to support the normal 8 bitrates supported on 5GHz at
least?

Or perhaps put the whole thing on 2.4GHz since chips actually exist that
only have 2.4 (vs. none that only have 5), and support some HT/VHT even
to make it look like it's not out of the last millenium? :)

> +static struct cfg80211_inform_bss mock_inform_bss = {
> +	/* ieee80211_channel* */ .chan = &channel,
> +	/* nl80211_bss_scan_width */ .scan_width = NL80211_BSS_CHAN_WIDTH_20,
> +	/* s32 */ .signal = 99,

That signal level is questionable ... better limit to something actually
used in practice like -60 dBm?

> +static u8 fake_router_bssid[] = {4, 4, 4, 4, 4, 4};

Well, use a locally assigned address at least if you're going to fake
something?

> +		for (i = 0; i < request->n_ssids; i++) {
> +			strncpy(request_ssid_copy, request->ssids[i].ssid,
> +				request->ssids[i].ssid_len);
> +			request_ssid_copy[request->ssids[i].ssid_len] = 0;
> +			wiphy_debug(wiphy, "scan: ssid: %s\n",
> +				    request_ssid_copy);

SSIDs can very well contain NUL bytes, so this is not a valid way to
print them.

Why would you even want to print the request anyway though, if your
stated goal is to make it look to userspace like a wifi link, vs.
debugging?

Plus you can always run "iw event" to see it.

> +		}
> +	}
> +
> +	priv->scan_request = request;
> +	schedule_delayed_work(&priv->scan_result, HZ / 100);

That's way too fast, so for any realism you should probably wait 2-3
seconds. Well, you only have one channel, so perhaps only 100-200ms? But
10ms is not realistic.

> +	return 0;
> +}
> +
> +static void virt_wifi_scan_result(struct work_struct *work)
> +{
> +	struct virt_wifi_priv *priv =
> +		container_of(work, struct virt_wifi_priv,
> +			     scan_result.work);
> +	struct wiphy *wiphy = priv_to_wiphy(priv);
> +	char ssid[] = "__VirtWifi";
> +	struct cfg80211_bss *informed_bss;
> +
> +	mock_inform_bss.boottime_ns = ktime_get_boot_ns();

Updating the static variable seems a bit weird, this could be concurrent
for different instances, afaict?

> +
> +static struct ieee80211_mgmt auth_mgmt_frame = {
> +	.frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT
> +				     | IEEE80211_STYPE_AUTH),

more idiomatic kernel coding style would put the | at the end of the
first line

> +	.duration = cpu_to_le16(1), /* ??? */

that's not quite a realistic duration, but I guess nobody cares

> +	.u = {
> +		.auth = {
> +			.auth_alg = WLAN_AUTH_OPEN,
> +			/* auth request has 1, auth response has 2 */
> +			.auth_transaction = cpu_to_le16(2),
> +		},
> +	},
> +};
> +
> +static int virt_wifi_auth(struct wiphy *wiphy,  struct net_device *dev,
> +			  struct cfg80211_auth_request *req)
> +{
> +	wiphy_debug(wiphy, "auth\n");
> +	memcpy(auth_mgmt_frame.da, dev->dev_addr, dev->addr_len);
> +	memcpy(auth_mgmt_frame.sa, fake_router_bssid,
> +	       sizeof(fake_router_bssid));
> +	memcpy(auth_mgmt_frame.bssid, fake_router_bssid,
> +	       sizeof(fake_router_bssid));

Well, I guess at the very least you should check you're connecting to
the right AP? Or maybe not, since you only fake one to exist in the
first place.

Same problem with globals being modified though.

> +	/* Must call cfg80211_rx_mlme_mgmt to notify about the response to this.
> +	 * This must hold the mutex for the wedev while calling the function.

typo - wdev

> +	 * Luckily the nl80211 code invoking this already holds that mutex.
> +	 */
> +	cfg80211_rx_mlme_mgmt(dev, (const u8 *)&auth_mgmt_frame,
> +			      sizeof(auth_mgmt_frame));

Some delay might be appropriate.

> +	return 0;
> +}
> +
> +static struct ieee80211_mgmt assoc_mgmt_frame = {
> +	.frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT
> +				     | IEEE80211_STYPE_ASSOC_RESP),
> +	.duration = cpu_to_le16(1), /* ??? */

see above

> +static int virt_wifi_assoc(struct wiphy *wiphy, struct net_device *dev,
> +			   struct cfg80211_assoc_request *req)
> +{
> +	wiphy_debug(wiphy, "assoc\n");
> +	memcpy(assoc_mgmt_frame.da, dev->dev_addr, dev->addr_len);

see above

> +	memcpy(assoc_mgmt_frame.sa, fake_router_bssid,
> +	       sizeof(fake_router_bssid));
> +	memcpy(assoc_mgmt_frame.bssid, fake_router_bssid,
> +	       sizeof(fake_router_bssid));
> +	/* Must call cfg80211_rx_assoc_resp to notify about the response to
> +	 * this. This must hold the mutex for the wedev while calling the

see above

> +	 * function. Luckily the nl80211 code invoking this already holds that
> +	 * mutex.
> +	 */
> +	cfg80211_rx_assoc_resp(dev, req->bss, (const u8 *)&assoc_mgmt_frame,
> +			       sizeof(assoc_mgmt_frame), -1);

see above

(and this repeats for deauth and disassoc too)

> +static int virt_wifi_get_station(struct wiphy *wiphy, struct net_device *dev,
> +				 const u8 *mac, struct station_info *sinfo)
> +{
> +	wiphy_debug(wiphy, "get_station\n");
> +	/* Only the values used by netlink_utils.cpp. */

What's netlink_utils.cpp? :-)

More seriously though, if you're proposing a general addition, the
hidden Android reference isn't all that helpful.

> +	sinfo->filled = BIT(NL80211_STA_INFO_TX_PACKETS) |
> +		BIT(NL80211_STA_INFO_TX_FAILED) | BIT(NL80211_STA_INFO_SIGNAL) |
> +		BIT(NL80211_STA_INFO_TX_BITRATE);
> +	sinfo->tx_packets = 1;
> +	sinfo->tx_failed = 0;
> +	sinfo->signal = -1; /* -1 is the maximum signal strength, somehow. */

Yeah, well, -1 is like taking a jet engine next to your ear ... not
going to happen. Go with something reasonable instead, maybe -60?

> +	sinfo->txrate = (struct rate_info) {
> +		.legacy = 10000, /* units are 100kbit/s */
> +	};

That's not realistic.

> +	return 0;
> +}
> +
> +static const struct cfg80211_ops virt_wifi_cfg80211_ops = {
> +	.scan = virt_wifi_scan,
> +
> +	.auth = virt_wifi_auth,
> +	.assoc = virt_wifi_assoc,
> +	.deauth = virt_wifi_deauth,
> +	.disassoc = virt_wifi_disassoc,
> +
> +	.get_station = virt_wifi_get_station,

That seems a little *too* minimal, and too much at the same time...

Practially no drivers, apart from mac80211 ones, implement auth/assoc -
in particular not most chips used in Android. So connect/disconnect
instead of auth/assoc/deauth/disassoc might be more realistic.

On the other hand, if you have get_station you should probably have
dump_station so people can use tools other than Android.

> +	/* 100 SSIDs should be enough for anyone! */
> +	wiphy->max_scan_ssids = 101;

Well, typical implementations limit this to 4, or 20, so this is
certainly excessive.

> +	/* Don't worry about frequency regulations. */
> +	wiphy->regulatory_flags = REGULATORY_WIPHY_SELF_MANAGED;
> +	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
> +				     BIT(NL80211_IFTYPE_AP) |
> +				     BIT(NL80211_IFTYPE_P2P_CLIENT) |
> +				     BIT(NL80211_IFTYPE_P2P_GO) |
> +				     BIT(NL80211_IFTYPE_ADHOC) |
> +				     BIT(NL80211_IFTYPE_MESH_POINT) |
> +				     BIT(NL80211_IFTYPE_MONITOR);

You obviously only support NL80211_IFTYPE_STATION - the other modes
require many more ops to be implemented.

> +	wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
> +			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
> +			    WIPHY_FLAG_AP_UAPSD |
> +			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;

Nope, has none of these.

> +	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR |
> +			       NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
> +			       NL80211_FEATURE_STATIC_SMPS |
> +			       NL80211_FEATURE_DYNAMIC_SMPS |
> +			       NL80211_FEATURE_AP_SCAN |
> +			       NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;

None of these either.

> +static netdev_tx_t virt_wifi_start_xmit(struct sk_buff *skb,
> +					struct net_device *dev)
> +{
> +	struct virt_wifi_netdev_priv *priv = netdev_priv(dev);
> +
> +	skb->dev = priv->lowerdev;
> +	return dev_queue_xmit(skb);

This really should only work while connected on "wifi".

> +static const struct net_device_ops wifi_vlan_ops = {

vlan?

> +/* Called under rcu_read_lock() from netif_receive_skb */
> +static rx_handler_result_t virt_wifi_rx_handler(struct sk_buff **pskb)
> +{
> +	struct sk_buff *skb = *pskb;
> +	struct virt_wifi_netdev_priv *priv =
> +		rcu_dereference(skb->dev->rx_handler_data);
> +
> +	/* macvlan uses GFP_ATOMIC here. */

so?

> +	skb = skb_share_check(skb, GFP_ATOMIC);
> +	if (!skb) {
> +		dev_err(&priv->upperdev->dev, "can't skb_share_check\n");
> +		return RX_HANDLER_CONSUMED;
> +	}
> +
> +	*pskb = skb;
> +	skb->dev = priv->upperdev;
> +	skb->pkt_type = PACKET_HOST;
> +	return RX_HANDLER_ANOTHER;
> +}

I guess this should also only do something while connected.

johannes
