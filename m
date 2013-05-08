Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44352 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3EHFfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 01:35:20 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20873.58246.410990.985421@gargle.gargle.HOWL> (sfid-20130508_073524_411875_9A99FE28)
Date: Wed, 8 May 2013 11:02:54 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH RFC] ath9k: collect statistics about Rx-Dup
 and Rx-STBC packets
In-Reply-To: <517D3B50.6070806@openwrt.org>
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de>
	<517D1B45.9020302@openwrt.org>
	<517D3840.2060000@candelatech.com>
	<517D3B50.6070806@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> The problem I have with the current stats is they're just an arbitrary
> collection of random stuff that is probably useless for 99% of all
> users. In many cases the way the stats are collected also makes the data
> completely meaningless (e.g. because the source/destination address is
> not taken into account).
> 
> Why care about the number of packets on the air that were sent with a
> specific rate flag? Why care about the number of beacons on the air
> (with no filter on a set of APs or anything)? Or what about the number
> of fragments received? To me it just looks like an incoherent set of
> useless facts.

Yes, having per-station statistics would be useful, mainly for RX and TX. Right
now, all the counters are global and there is no way to find out how a
particular station is performing, especially in AP mode. Since mac80211 gives us
proper debugfs hooks for station addition/deletion, relevant stuff can be moved
there.

The 'recv' file used to be just for HW errors (DESC, CRC etc.), now it has various
counters that should probably be node-specific.

The 'xmit' file can be trimmed and information can be maintained per-station.
This will be really useful in AP mode - especially for diagnosing aggregation, QoS, PS etc.

Other than these two files, the rest are simple.

Sujith
