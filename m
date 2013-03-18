Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34381 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3CRPMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 11:12:19 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20807.11884.89884.717497@gargle.gargle.HOWL> (sfid-20130318_161223_881427_7881242B)
Date: Mon, 18 Mar 2013 20:40:36 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/3] mac80211/minstrel_ht: improve rate selection stability
In-Reply-To: <1363449627-10884-1-git-send-email-nbd@openwrt.org>
References: <1363449627-10884-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Under load, otherwise stable rates can easily fluctuate because of
> collisions. In my tests on a clean channel, the success probability of
> the max throughput rate often stays somewhere between 90% and 100% under
> load. This can cause some unnecessary switching to lower rates.
> This patch improves stability by treating success probability values
> between 90% and 100% the same.
> In my tests on a 3x3 HT20 link with lots of TCP traffic, it improves the
> average throughput by a few mbit/s.

Some test results:

Sta: WB222 (2x2)
AP : DB120, AR9380 (3x3) (Channel 36, HT40+)
Distance: About a meter.

With ath9k RC:
[SUM]  0.0-60.0 sec  1.42 GBytes   203 Mbits/sec

With minstrel_ht, current HEAD:
[SUM]  0.0-60.0 sec  1.35 GBytes   193 Mbits/sec

with minstrel_ht, HEAD + these 3 patches:
[SUM]  0.0-60.1 sec  1.41 GBytes   202 Mbits/sec

Sujith
