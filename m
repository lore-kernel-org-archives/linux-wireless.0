Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13949 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2FRIiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 04:38:16 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20446.59554.904662.169816@gargle.gargle.HOWL> (sfid-20120618_103820_762993_C0F5DAD6)
Date: Mon, 18 Jun 2012 14:06:50 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 5/9] ath9k_hw: remove the old ANI implementation
In-Reply-To: <4FDDEB50.2040503@openwrt.org>
References: <1339766727-61926-1-git-send-email-nbd@openwrt.org>
	<1339766727-61926-2-git-send-email-nbd@openwrt.org>
	<1339766727-61926-3-git-send-email-nbd@openwrt.org>
	<1339766727-61926-4-git-send-email-nbd@openwrt.org>
	<1339766727-61926-5-git-send-email-nbd@openwrt.org>
	<20445.11677.349633.688444@gargle.gargle.HOWL>
	<4FDDEB50.2040503@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I did review pretty much all of the code, and the knobs that the ANI
> code tweaks really haven't changed much compared to the old
> implementation. It's split up into different functions, which makes it a
> bit harder to see the similarities.
> The main implementation differences that I can find is that the new
> implementation does not tweak the AGC parameters anymore (commit log
> mentions something about this messing up RIFS Rx) and that the old
> implementation tries to tune all available ANI control parameters
> individually, whereas the new implementation contains a table that
> describes how the parameters are raised/lowered at once (split into OFDM
> and CCK).
> This simplifies the state machine quite a bit and makes it easier to
> make sure that it does not get stuck somewhere.
> As for hw specific improvements, old hw does not tweak MRC
> enable/disable for CCK, this is dealt with properly in the code.

So I discussed this with a systems guy and the conclusion was that the
new ANI can be used - but it needs to be tested with older HW.
And this has not been tested by anyone - all our internal drivers
running on Windows/Linux/MacOS etc. use the older ANI with apparently
no problems. If ath9k's performance is sub-optimal then it's purely
a problem with ath9k - which is probably due to shitty code.

I am looking at numbers that have been arrived at after exhaustive
testing of the new ANI - quantifiable facts that verify all the various
levels/thresholds etc. with proper injection of interference.

The proposed migration has no supporting numbers at all.

Nuking the old algorithm completely would leave us in a position where
we can't even do a comparative analysis of old vs. new. And we can't approach
the systems/HW guys if any issue crops up - I really don't want us to be
stuck in an island.

> Having two similar implementations of the same thing in the code,
> partially overlapping, makes the code hard to follow and hard to fix.
> Also, as I pointed out, the issue of regressions creeping in because of
> complex code is not theoretical, it has already happened, and I believe
> it is likely to happen again unless the root cause (spaghetti code) is
> fixed.

Well, we did have two separate implementations which were merged at some point,
hence the overlapping code.

At this point, am not sure. So having said all that, my vote is to ACK this
patch and find some time to setup a testbed and validate this shit. :)

Sujith
