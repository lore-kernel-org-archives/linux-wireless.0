Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41185 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaIKO03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 10:26:29 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21521.45335.848659.125183@gargle.gargle.HOWL> (sfid-20140911_162634_077301_C4D42F82)
Date: Thu, 11 Sep 2014 19:56:31 +0530
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "ath9k: Calculate sleep duration"
In-Reply-To: <20140911141338.GA21543@qca.qualcomm.com>
References: <1410442548-15782-1-git-send-email-sujith@msujith.org>
	<20140911141338.GA21543@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> Some of the IOE customer using ath9k with power save enabled. IIRC the
> expectation is that when the station is idle, it should wakeup on DTIM
> beacon not for every beacons. Are you seeing frequest bmiss events on
> higher beacon interval?

I don't think ath9k has ever been tested with longer sleep durations
based on dtim period. We have always programmed the hardware to wake up
for every beacon interval, using the TIM_TIMER interrupt. And since the
TIM bit needs to be checked for every beacon, the sleep duration has
to be the beacon interval.

Also, the bmiss threshold needs to be adjusted based on the sleep
duration. We are hardcoding it currently in the driver using
ATH_DEFAULT_BMISS_LIMIT. This will break, too.

Using dtim for PS needs more testing before it can be used,
so we can have the original behavior for now.

Sujith

