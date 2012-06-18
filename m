Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24308 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2FRKNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 06:13:41 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20446.65282.390682.126822@gargle.gargle.HOWL> (sfid-20120618_121346_260615_83CC4638)
Date: Mon, 18 Jun 2012 15:42:18 +0530
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
> Having two similar implementations of the same thing in the code,
> partially overlapping, makes the code hard to follow and hard to fix.
> Also, as I pointed out, the issue of regressions creeping in because of
> complex code is not theoretical, it has already happened, and I believe
> it is likely to happen again unless the root cause (spaghetti code) is
> fixed.
> The main state machine of the new implementation is much easier to
> understand and follow than the old one, and I'm confident that it'll be
> much easier for us to fix bugs there.

Speaking of bugs, ANI doesn't even get triggered on a system with HZ=1000
and PowerSave is enabled. The check for the power state causes it to exit
early, I think.

Sujith
