Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1CGJv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 04:51:29 -0500
Subject: Re: WARN_ON in ieee80211_scan_completed_finish triggered
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1299443142.1292.6.camel@marge>
References: <1299443142.1292.6.camel@marge>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 10:51:25 +0100
Message-ID: <1299491485.3790.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-03-06 at 21:25 +0100, Michael Buesch wrote:
> I just noticed the following warning on my p54spi device
> with compat-wireless-2011-02-25 (OpenWrt):
> 

> [ 1182.826599] WARNING: at net/mac80211/scan.c:310 ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]()

Unfortunately the backtrace gives no hint at all, is it possible that
there was an ifdown that canceled the scan?

Since I've never seen this before, I'm tempted to say Ben's changes
caused it to become possible, but I'm not certain. Still, Ben, can you
look at this please?

johannes


