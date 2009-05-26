Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41793 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbZEZRqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 13:46:33 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 10:46:36 -0700
Date: Tue, 26 May 2009 10:46:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jeff Hansen <x@jeffhansen.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] WMM settings and AP performance
Message-ID: <20090526174640.GC9370@tesla>
References: <Pine.LNX.4.64.0905251926300.11772@ren>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <Pine.LNX.4.64.0905251926300.11772@ren>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2009 at 06:52:41PM -0700, Jeff Hansen wrote:
> Hello,
> 
> I found that upgrading from compat-wireless-2009-04-28 to
> compat-wireless-2009-05-11 caused a huge degradation in performance in AP
> mode.  Before (with 04-28), I was able to get ~25 Mbps TCP iperf speeds up
> and down (with a madwifi client), and after upgrading I still get ~30 Mbps
> UDP download, but only ~2Mbps UDP upload (and TCP speeds about the same -
> 2Mbps).
> 
> After bisecting a bit, I found that the "mac80211: set default QoS values
> according to spec" caused the performance degradation, so I'm guessing
> that ath9k is not writing the correct values to the QoS timing registers
> when it gets the configuration from mac80211.  For now, I'm just reverting
> this patch in my builds.

Hm, thanks for reporting this but did you try to configure changing the
defaults first? The changes johannes did ensures we follow the IEEE spec
for defaults. These can be tuned though, for example my hostapd.conf has:

wme_enabled=1
wme_ac_bk_cwmin=4
wme_ac_bk_cwmax=10
wme_ac_bk_aifs=7
wme_ac_bk_txop_limit=0
wme_ac_bk_acm=0
wme_ac_be_aifs=3
wme_ac_be_cwmin=4
wme_ac_be_cwmax=10
wme_ac_be_txop_limit=0
wme_ac_be_acm=0
wme_ac_vi_aifs=2
wme_ac_vi_cwmin=3
wme_ac_vi_cwmax=4
wme_ac_vi_txop_limit=94
wme_ac_vi_acm=0
wme_ac_vo_aifs=2
wme_ac_vo_cwmin=2
wme_ac_vo_cwmax=3
wme_ac_vo_txop_limit=47
wme_ac_vo_acm=0

Through the nl80211 driver this is set when you call NL80211_CMD_SET_WIPHY,
and pass NL80211_ATTR_WIPHY_TXQ_PARAMS, which I expect hostapd should be doing.

If you're using wirelesss-extensions driver for hostapd I believe you get
stuck with the defaults. Anyway in ath9k this is handled by ath9k_conf_tx()
and we do respect the passed up values.

Can you try with adding:

driver=nl80211

To your hostapd.conf and also tweek the queue parameters as you see fit?

  Luis
