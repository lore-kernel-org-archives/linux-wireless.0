Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43963 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbbFQI7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:59:50 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21889.14109.54454.563245@gargle.gargle.HOWL> (sfid-20150617_105957_427583_F0CFB59C)
Date: Wed, 17 Jun 2015 14:30:13 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFCv2] ath9k: make rxfilter per HW
In-Reply-To: <55812FB5.1070005@openwrt.org>
References: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>
	<21889.11726.101648.552280@gargle.gargle.HOWL>
	<55812FB5.1070005@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> mac80211 calculates the filter per hw, not per channel context or per
> vif. Setting it for the current channel context only would mean it might
> be applied to the wrong context. This patch fixes that issue.
> I agree that it might be a useful optimization to selectively apply
> filters per channel context, but mac80211 does not provide an API to do
> that right now.

But wpa_s already takes care of this requirement ? This is what I see
when running p2p_find:

wlan0: Starting radio work 'p2p-listen'@0x17c2500 after 0.000040 second wait
nl80211: Enable Probe Request reporting nl_preq=0x17c2560
nl80211: Register frame type=0x40 (WLAN_FC_STYPE_PROBE_REQ) nl_handle=0x17c2560 match=
nl80211: Remain-on-channel cookie 0x351 for freq=2437 MHz duration=204
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for wlan0
nl80211: Remain-on-channel event (cancel=0 freq=2437 channel_type=0 duration=204 cookie=0x351 (match))
wlan0: Event REMAIN_ON_CHANNEL (20) received

And in the driver:

ath: phy1: Starting RoC period
ath: phy1: Channel definition created: 2437 MHz
ath: phy1: Assigned next_chan to 2437 MHz
ath: phy1: Offchannel duration for chan 2437 MHz : 112825
ath: phy1: Set HW RX filter: 0x687
ath: phy1: ath_chanctx_set_next: current: 2412 MHz, next: 2437 MHz

So, the filter for probe requests appears to be set correctly ?

Sujith
