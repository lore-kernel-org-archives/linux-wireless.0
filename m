Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1CGLpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 06:45:01 -0500
Subject: Re: WARN_ON in ieee80211_scan_completed_finish triggered
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1299498147.5665.3.camel@marge>
References: <1299443142.1292.6.camel@marge>
	 <1299491485.3790.2.camel@jlt3.sipsolutions.net>
	 (sfid-20110307_105130_457515_FFFFFFFF997C7B78)  <1299498147.5665.3.camel@marge>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 12:44:57 +0100
Message-ID: <1299498297.3790.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 12:42 +0100, Michael Buesch wrote:
> On Mon, 2011-03-07 at 10:51 +0100, Johannes Berg wrote:
> > On Sun, 2011-03-06 at 21:25 +0100, Michael Buesch wrote:
> > > I just noticed the following warning on my p54spi device
> > > with compat-wireless-2011-02-25 (OpenWrt):
> > > 
> > 
> > > [ 1182.826599] WARNING: at net/mac80211/scan.c:310 ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]()
> > 
> > Unfortunately the backtrace gives no hint at all, is it possible that
> > there was an ifdown that canceled the scan?
> 
> I don't think there was an ifdown.

Ok

> It seems that it happened right after a regulatory
> update. See printk timestamps in the full kernel log:

> [ 1182.269927] cfg80211: Calling CRDA for country: DE
> [ 1182.369659] cfg80211: Regulatory domain changed to country: DE
> [ 1182.376586] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [ 1182.386138] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [ 1182.395385] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [ 1182.404449] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [ 1182.413146] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
> [ 1182.821472] ------------[ cut here ]------------
> [ 1182.826599] WARNING: at /home/mb/develop/svn/openwrt_n810/trunk/build_dir/linux-omap24xx/compat-wireless-2011-02-25/net/mac80211/scan.c:310 ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]()

It's still almost half a second, and the regulatory update was because
you connected to an AP that had a country IE. It could be related, but I
doubt it.

johannes

