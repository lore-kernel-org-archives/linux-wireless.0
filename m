Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39106 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2KHT3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 14:29:49 -0500
Received: by mail-we0-f174.google.com with SMTP id t9so1405951wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 11:29:48 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R . Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: Re: [PATCH v5 1/2] wireless: Driver for 60GHz card wil6210
Date: Thu,  8 Nov 2012 20:29:43 +0100
Message-Id: <20121108193010.GC3354@lenteja.do-not-panic.com> (sfid-20121108_203002_320405_5E9A0854)
In-Reply-To: <1351701417-3140-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

You asked... so I'll review... I'll start reviewing more functional
aspects now.

On Wed, Oct 31, 2012 at 06:36:56PM +0200, Vladimir Kondratiev wrote:
> diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
> new file mode 100644
> index 0000000..b927adc
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wil6210/Kconfig
> @@ -0,0 +1,47 @@
> +config WIL6210
> +	tristate "Wilocity 60g WiFi card wil6210 support"
> +	depends on CFG80211
> +	depends on PCI
> +	depends on EXPERIMENTAL

CONFIG_EXPERIMENTAL means nothing today and its usage should
be avoided moving further. Please remove this line. And yes
if you see other drivers using it please destroy that line
too.

> +config WIL6210_DEBUG_TXRX
> +	bool "Debug Tx/Rx path for wil6210"
> +	depends on WIL6210
> +	default n
> +	---help---
> +	  Enables Tx/Rx path debug. It will emitt lots of messages.
> +	  Every Tx and Rx frame will be dumped, with some
> +	  auxiliary information.
> +	  Use with care.

You add this here and then you kill it in the next patch.
Don't add it then.


> +
> +config WIL6210_DEBUG_IRQ
> +	bool "Debug IRQ flows for wil6210"
> +	depends on WIL6210
> +	default n
> +	---help---
> +	  Enables IRQ debug. It will emitt lots of messages.
> +	  For every IRQ its ISR bits will be printed, with
> +	  some extra analysis.
> +	  Use with care.

Same for this guy.

> diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
> +static void wil_print_channels(struct wil6210_priv *wil)
> +{
> +	struct wiphy *wiphy = wil_to_wiphy(wil);
> +	int i;

Please use unsigned int for any loop variable. Please change all
code to do this. For reasoning behind this see:

http://lkml.indiana.edu/hypermail/linux/kernel/1008.0/00695.html

But then again why the hell even have wil_print_channels() it seems
like good debug code to have upon bringup but pretty useless for
driver code. Please kill this useless routine.

> +int wil_iftype_nl2wmi(enum nl80211_iftype type)
> +{
> +	static const struct {
> +		enum nl80211_iftype nl;
> +		enum wmi_network_type wmi;
> +	} __nl2wmi[] = {
> +		{NL80211_IFTYPE_ADHOC,		WMI_NETTYPE_ADHOC},
> +		{NL80211_IFTYPE_STATION,	WMI_NETTYPE_INFRA},
> +		{NL80211_IFTYPE_AP,		WMI_NETTYPE_AP},
> +		{NL80211_IFTYPE_P2P_CLIENT,	WMI_NETTYPE_P2P},
> +		{NL80211_IFTYPE_P2P_GO,		WMI_NETTYPE_P2P},
> +		{NL80211_IFTYPE_MONITOR,	WMI_NETTYPE_ADHOC}, /* FIXME */
> +	};
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(__nl2wmi); i++) {
> +		if (__nl2wmi[i].nl == type)
> +			return __nl2wmi[i].wmi;
> +	}
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static int wil_cfg80211_get_station(struct wiphy *wiphy,
> +				    struct net_device *ndev,
> +				    u8 *mac, struct station_info *sinfo)
> +{
> +	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
> +	int rc;
> +	struct wmi_notify_req_cmd cmd = {
> +		.cid = 0,
> +		.interval_usec = 0,
> +	};

Is the hardware little endian or big endian? Please see
ath6kl's struct wmi_begin_scan_cmd on wmi.h for an example
of how to specify endianess to ensure that you can use this
driver on big or little endian. So although its great you
managed to successfully use sparse with -D__CHECK_ENDIAN__
endianess may be broken on this command and all over your
wmi.h. I won't even review that file then.

> +	wil_info(wil, "%s(%pM)\n", __func__, mac);

Please kill all of these.

> +	if (memcmp(mac, wil->dst_addr[0], ETH_ALEN))
> +		return -ENOENT;

Add empty new line.

> +	rc = wmi_call(wil, WMI_NOTIFY_REQ_CMDID, &cmd, sizeof(cmd),
> +		      WMI_NOTIFY_REQ_DONE_EVENTID, NULL, 0, 20);
> +	if (rc)
> +		return rc;
> +
> +	sinfo->filled |= STATION_INFO_TX_BITRATE;
> +	sinfo->txrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
> +	sinfo->txrate.mcs = wil->stats.bf_mcs;
> +	sinfo->filled |= STATION_INFO_RX_BITRATE;
> +	sinfo->rxrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
> +	sinfo->rxrate.mcs = wil->stats.last_mcs_rx;
> +
> +	if (test_bit(wil_status_fwconnected, &wil->status)) {
> +		sinfo->filled |= STATION_INFO_SIGNAL;
> +		sinfo->signal = 12; /* TODO: provide real value */
> +	}
> +
> +	return 0;

So what did we do here exactlly? Poke firmware and not use anything?

> +static int wil_cfg80211_change_iface(struct wiphy *wiphy,
> +				     struct net_device *ndev,
> +				     enum nl80211_iftype type, u32 *flags,
> +				     struct vif_params *params)
> +{
> +	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
> +	struct wireless_dev *wdev = wil->wdev;
> +	wil_info(wil, "%s()\n", __func__);

Kill these single print lines.

> +
> +	switch (type) {
> +	case NL80211_IFTYPE_STATION:
> +		wil_info(wil, "type: STATION\n");

These too. Just leave out the prints. We have better ways
to be debugging what cfg80211 is telling us to do that
should not require every single driver to add their own
prints.

> +		break;
> +	case NL80211_IFTYPE_AP:
> +		wil_info(wil, "type: AP\n");
> +		break;
> +	case NL80211_IFTYPE_P2P_CLIENT:
> +		wil_info(wil, "type: P2P_CLIENT\n");
> +		break;
> +	case NL80211_IFTYPE_P2P_GO:
> +		wil_info(wil, "type: P2P_GO\n");
> +		break;
> +	case NL80211_IFTYPE_MONITOR:
> +		wil_info(wil, "type: Monitor\n");
> +		if (flags) {
> +			wil_info(wil, "Monitor flags: 0x%08x\n", *flags);
> +			wil->monitor_flags = *flags;
> +		} else {
> +			wil->monitor_flags = 0;

This else can just be without a brace.

> +		}
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	wdev->iftype = type;
> +
> +	return 0;
> +}
> +
> +static int wil_cfg80211_scan(struct wiphy *wiphy,
> +			     struct cfg80211_scan_request *request)
> +{
> +	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
> +	struct wireless_dev *wdev = wil->wdev;
> +	struct {
> +		struct wmi_start_scan_cmd cmd;
> +		u16 chnl[4];
> +	} __packed cmd;
> +	int i, n;
> +
> +	wil_info(wil, "%s(%d channels, %d SSIDs)\n", __func__,
> +		 request->n_channels, request->n_ssids);
> +
> +	for (i = 0; i < request->n_ssids; i++) {
> +		char prefix[20];
> +		struct cfg80211_ssid *ssid = &request->ssids[i];
> +		snprintf(prefix, sizeof(prefix), "SSID[%d] : ", i);
> +		print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE, 16, 1,
> +			       ssid->ssid, ssid->ssid_len, true);
> +	}
> +	if (request->ie && request->ie_len)
> +		print_hex_dump(KERN_INFO, "IE : ", DUMP_PREFIX_NONE, 16, 1,
> +			       request->ie, request->ie_len, true);
> +	wil_print_channels(wil);
> +
> +	if (wil->scan_request) {
> +		wil_err(wil, "Already scanning\n");
> +		return -EAGAIN;
> +	}
> +
> +	/* check we are client side */
> +	switch (wdev->iftype) {
> +	case NL80211_IFTYPE_STATION:
> +	case NL80211_IFTYPE_P2P_CLIENT:
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +
> +	}
> +
> +	/* FW don't support scan after connection attempt */
> +	if (test_bit(wil_status_dontscan, &wil->status)) {
> +		wil_err(wil, "Scan after connect attempt not supported\n");
> +		return -EBUSY;
> +	}
> +
> +	wil->scan_request = request;
> +	cmd.cmd.numChannels = 0;
> +	n = min(request->n_channels, 4U);
> +	for (i = 0; i < n; i++) {
> +		int ch = request->channels[i]->hw_value;
> +		if (ch == 0) {
> +			wil_err(wil,
> +				"Scan requested for unknown frequency %dMhz\n",
> +				request->channels[i]->center_freq);
> +			continue;
> +		}
> +		/* 0-based channel indexes */
> +		cmd.chnl[cmd.cmd.numChannels++] = ch - 1;
> +		wil_info(wil, "Scan for ch %d  : %d MHz\n", ch,
> +			 request->channels[i]->center_freq);
> +	}
> +
> +	return wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
> +			 cmd.cmd.numChannels * sizeof(cmd.chnl[0]));
> +}
> +

That's all I have time to review right now but that's a bit of changes.
Don't wait for me to review the other things, use this as a base of
what things to look for. If you don't need it, kill it.

  Luis
