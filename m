Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:39131 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2KKQPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 11:15:12 -0500
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [PATCH v5 1/2] wireless: Driver for 60GHz card wil6210
Date: Sun, 11 Nov 2012 18:15:05 +0200
Message-ID: <1647271.ZFHae4zFan@lx-vladimir> (sfid-20121111_171518_389765_6A5A4EEC)
In-Reply-To: <20121108193010.GC3354@lenteja.do-not-panic.com>
References: <20121108193010.GC3354@lenteja.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,

Thanks for review, I appreciate time you spent doing this!

On Thursday, November 08, 2012 08:29:43 PM Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> You asked... so I'll review... I'll start reviewing more functional
> aspects now.
> 
> On Wed, Oct 31, 2012 at 06:36:56PM +0200, Vladimir Kondratiev wrote:
> > diff --git a/drivers/net/wireless/ath/wil6210/Kconfig
> > b/drivers/net/wireless/ath/wil6210/Kconfig new file mode 100644
> > index 0000000..b927adc
> > --- /dev/null
> > +++ b/drivers/net/wireless/ath/wil6210/Kconfig
> > +	depends on EXPERIMENTAL
> 
> CONFIG_EXPERIMENTAL means nothing today and its usage should
> be avoided moving further. Please remove this line. And yes
> if you see other drivers using it please destroy that line
> too.

Will do

> 
> > +config WIL6210_DEBUG_TXRX
> 
> You add this here and then you kill it in the next patch.
> Don't add it then.
> 
> > +
> > +config WIL6210_DEBUG_IRQ
> 
> Same for this guy.

Sure, my mistake.

> 
> > diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c
> > b/drivers/net/wireless/ath/wil6210/cfg80211.c +static void
> > wil_print_channels(struct wil6210_priv *wil)
> > +{
> > +	struct wiphy *wiphy = wil_to_wiphy(wil);
> > +	int i;
> 
> Please use unsigned int for any loop variable. Please change all
> code to do this. For reasoning behind this see:

Will do

> But then again why the hell even have wil_print_channels() it seems
> like good debug code to have upon bringup but pretty useless for
> driver code. Please kill this useless routine.

Will do

> Is the hardware little endian or big endian?

Little endian

> Please see
> ath6kl's struct wmi_begin_scan_cmd on wmi.h for an example
> of how to specify endianess to ensure that you can use this
> driver on big or little endian. So although its great you
> managed to successfully use sparse with -D__CHECK_ENDIAN__
> endianess may be broken on this command and all over your
> wmi.h. I won't even review that file then.

I know about __le16 etc., but I have no big endian host to check it with. 
Thus, I'd prefer to mention that code is not ready for big endian platform 
rather then submit untested code. If there is a way to check endiannes without 
having big endian host, I'd be happy to know.
Also, is there a good way to check in Kconfig we are on Little endian?

> 
> > +	wil_info(wil, "%s(%pM)\n", __func__, mac);
> 
> Please kill all of these.

Will do

> 
> > +	if (memcmp(mac, wil->dst_addr[0], ETH_ALEN))
> > +		return -ENOENT;
> 
> Add empty new line.

Sure

> 
> > +	rc = wmi_call(wil, WMI_NOTIFY_REQ_CMDID, &cmd, sizeof(cmd),
> > +		      WMI_NOTIFY_REQ_DONE_EVENTID, NULL, 0, 20);
> > +	if (rc)
> > +		return rc;
> > +
> > +	sinfo->filled |= STATION_INFO_TX_BITRATE;
> > +	sinfo->txrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
> > +	sinfo->txrate.mcs = wil->stats.bf_mcs;
> > +	sinfo->filled |= STATION_INFO_RX_BITRATE;
> > +	sinfo->rxrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
> > +	sinfo->rxrate.mcs = wil->stats.last_mcs_rx;
> > +
> > +	if (test_bit(wil_status_fwconnected, &wil->status)) {
> > +		sinfo->filled |= STATION_INFO_SIGNAL;
> > +		sinfo->signal = 12; /* TODO: provide real value */
> > +	}
> > +
> > +	return 0;
> 
> So what did we do here exactlly? Poke firmware and not use anything?

Query current Tx MCS. Used to print "link speed". For debug, Tx/Rx sectors 
used to target peer printed to dmesg.

> 
> > +static int wil_cfg80211_change_iface(struct wiphy *wiphy,
> > +				     struct net_device *ndev,
> > +				     enum nl80211_iftype type, u32 *flags,
> > +				     struct vif_params *params)
> > +{
> > +	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
> > +	struct wireless_dev *wdev = wil->wdev;
> > +	wil_info(wil, "%s()\n", __func__);
> 
> Kill these single print lines.

Will do

> 
> > +
> > +	switch (type) {
> > +	case NL80211_IFTYPE_STATION:
> > +		wil_info(wil, "type: STATION\n");
> 
> These too. Just leave out the prints. We have better ways
> to be debugging what cfg80211 is telling us to do that
> should not require every single driver to add their own
> prints.

Will do. "better ways" is trace?

> 
> > +		break;
> > +	case NL80211_IFTYPE_AP:
> > +		wil_info(wil, "type: AP\n");
> > +		break;
> > +	case NL80211_IFTYPE_P2P_CLIENT:
> > +		wil_info(wil, "type: P2P_CLIENT\n");
> > +		break;
> > +	case NL80211_IFTYPE_P2P_GO:
> > +		wil_info(wil, "type: P2P_GO\n");
> > +		break;
> > +	case NL80211_IFTYPE_MONITOR:
> > +		wil_info(wil, "type: Monitor\n");
> > +		if (flags) {
> > +			wil_info(wil, "Monitor flags: 0x%08x\n", *flags);
> > +			wil->monitor_flags = *flags;
> > +		} else {
> > +			wil->monitor_flags = 0;
> 
> This else can just be without a brace.

No, it can't (unless 'if' branch reduced to one line). Quote 
Documentation/CodingStyle:

This does not apply if only one branch of a conditional statement is a single
statement; in the latter case use braces in both branches:

if (condition) {
	do_this();
	do_that();
} else {
	otherwise();
}

Sending patch v6...

Thanks, Vladimir
