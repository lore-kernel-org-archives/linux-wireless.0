Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34200 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3A3GK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 01:10:57 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20744.47404.184099.495423@gargle.gargle.HOWL> (sfid-20130130_071101_987787_DB4C8567)
Date: Wed, 30 Jan 2013 11:39:48 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at drivers/net/wireless/ath/ath9k/beacon.c:362 ath9k_beacon_tasklet+0xcc/0x5f0)
In-Reply-To: <5108B569.9090005@candelatech.com>
References: <5108AD09.9020308@candelatech.com>
	<20744.44999.48237.463434@gargle.gargle.HOWL>
	<5108B569.9090005@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> They were not.  I see the second was queued to stable, should the first one
> be a stable candidate as well?

Sorry, I meant this one:

commit 1adb2e2b5f85023d17eb4f95386a57029df27c88
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Wed Jan 9 16:16:53 2013 +0100

    ath9k: fix double-free bug on beacon generate failure
    
    When the next beacon is sent, the ath_buf from the previous run is reused.
    If getting a new beacon from mac80211 fails, bf->bf_mpdu is not reset, yet
    the skb is freed, leading to a double-free on the next beacon tx attempt,
    resulting in a system crash.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Sujith
