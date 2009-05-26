Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43358 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbZEZSLw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 14:11:52 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 11:11:54 -0700
Subject: Re: [ath9k-devel] WMM settings and AP performance
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: Jeff Hansen <x@jeffhansen.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090526174640.GC9370@tesla>
References: <Pine.LNX.4.64.0905251926300.11772@ren>
	 <20090526174640.GC9370@tesla>
Content-Type: text/plain
Date: Tue, 26 May 2009 21:11:50 +0300
Message-ID: <1243361510.2923.10.camel@jm-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 10:46 -0700, Luis Rodriguez wrote:
> On Mon, May 25, 2009 at 06:52:41PM -0700, Jeff Hansen wrote:
> > I found that upgrading from compat-wireless-2009-04-28 to
> > compat-wireless-2009-05-11 caused a huge degradation in performance in AP
> > mode.  Before (with 04-28), I was able to get ~25 Mbps TCP iperf speeds up
> > and down (with a madwifi client), and after upgrading I still get ~30 Mbps
> > UDP download, but only ~2Mbps UDP upload (and TCP speeds about the same -
> > 2Mbps).
> >
> > After bisecting a bit, I found that the "mac80211: set default QoS values
> > according to spec" caused the performance degradation, so I'm guessing
> > that ath9k is not writing the correct values to the QoS timing registers
> > when it gets the configuration from mac80211.  For now, I'm just reverting
> > this patch in my builds.

That 25/30 Mbps to 2 Mbps is quite a huge difference and in order for
QoS parameters to cause something like this, they would need to be
seriously wrong..

I'm assuming that by "upload" you are referring to the case where a
station is transmitting data to the AP. One thing to note about that one
is that the QoS parameter change in the AP (i.e., the mac80211 change
mentioned here; I'm assuming you did not modify the client used in the
test) should actually have only a minor effect in the STA->AP
transmission.. As such, it is kind of surprising that this change would
cause such a difference.

> Hm, thanks for reporting this but did you try to configure changing the
> defaults first? The changes johannes did ensures we follow the IEEE spec
> for defaults. These can be tuned though, for example my hostapd.conf has:
> 
> wme_enabled=1
> wme_ac_bk_cwmin=4
..
> wme_ac_vo_acm=0
> 
> Through the nl80211 driver this is set when you call NL80211_CMD_SET_WIPHY,
> and pass NL80211_ATTR_WIPHY_TXQ_PARAMS, which I expect hostapd should be doing.

There are actually two sets of WMM/TX queue parameters in AP: one that
the AP uses itself and one that the AP requests the associated stations
to use. The wme_ac_* parameters are for the stations, not for the AP.
NL80211_ATTR_WIPHY_TXQ_PARAMS is used with the TX parameters for the AP,
i.e., tx_queue_data* parameters in hostapd.conf. I would recommend
explicitly specifying both of these sets to make sure both the AP and
stations end up using the expected values. Any change in mac80211 should
not affect the values the AP requests the client to use (wme_ac_*) which
are advertised in the WMM IE.

> If you're using wirelesss-extensions driver for hostapd I believe you get
> stuck with the defaults. Anyway in ath9k this is handled by ath9k_conf_tx()
> and we do respect the passed up values.

There is no wireless-extensions driver for hostapd, i.e., driver=nl80211
is the only available option with ath9k.

- Jouni


